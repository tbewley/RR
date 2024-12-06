# lab test program
# ME 396 Mechatronics
# Fall 2024
# 12/2/2024
# By Tao-Yi Wan (Roger Wan)
# Copyright USAFA 2024

import numpy as np
import cv2
import math
import time
from picamera2 import Picamera2

class CameraPoses():
    # Initial the data
    def __init__(self, intrinsic):
        
        self.K = intrinsic
        self.extrinsic = np.array(((1,0,0,0),(0,1,0,0),(0,0,1,0)))
        self.P = self.K @ self.extrinsic
        self.orb = cv2.ORB_create(500)
        FLANN_INDEX_LSH = 6
        index_params = dict(algorithm=FLANN_INDEX_LSH, table_number=6, key_size=12, multi_probe_level=1)
        search_params = dict(checks=50)
        self.flann = cv2.FlannBasedMatcher(indexParams=index_params, searchParams=search_params)
    
    @staticmethod
    # Rotation and translation matrix to transformation matrix
    def _form_transf(R, t):
        
        T = np.eye(4, dtype=np.float64)
        T[:3, :3] = R
        T[:3, 3] = t
        
        return T
    
    # Find the match points
    def get_matches(self, img1, img2):

        # Find the keypoints and descriptors with ORB
        kp1, des1 = self.orb.detectAndCompute(img1, None)
        kp2, des2 = self.orb.detectAndCompute(img2, None)
        print(f"Number of features detected: {len(kp1)}")
        
        # Find matches
        if len(kp1) > 6 and len(kp2) > 6:
            matches = self.flann.knnMatch(des1, des2, k=2)

            # Find the matches there do not have a to high distance
            good_matches = []
            try:
                for m, n in matches:
                    if m.distance < 0.5 * n.distance:
                        good_matches.append(m)
            except ValueError:
                pass
            
            # Get the image points from the good matches
            # q1 = [kp1[m.queryIdx] for m in good_matches]
            # q2 = [kp2[m.trainIdx] for m in good_matches]
            q1 = np.float32([kp1[m.queryIdx].pt for m in good_matches])
            q2 = np.float32([kp2[m.trainIdx].pt for m in good_matches])

            return q1, q2
        else:
            return None, None

    # With the match points to find the transformation matrix
    def get_pose(self, q1, q2):
    
        # Essential matrix
        E, _ = cv2.findEssentialMat(q1, q2, self.K)

        # Decompose the Essential matrix into R and t
        R, t = self.decomp_essential_mat(E, q1, q2)
    
        # Get transformation matrix
        transformation_matrix = self._form_transf(R, np.squeeze(t))
        
        return transformation_matrix

    # Decomposition the Essiential Matrix and return the R & t     
    def decomp_essential_mat(self, E, q1, q2):
        def sum_z_cal_relative_scale(R, t):
            
            # Get the transformation matrix
            T = self._form_transf(R, t)
            # Make the projection matrix
            P = np.matmul(np.concatenate((self.K, np.zeros((3, 1))), axis=1), T)

            # Triangulate the 3D points
            hom_Q1 = cv2.triangulatePoints(self.P, P, q1.T, q2.T)
            if hom_Q1 is None or hom_Q1.shape[0] != 4:
                raise ValueError("Triangulation failed or returned invalid points.")
            # Also seen from camera 2
            hom_Q2 = np.matmul(T, hom_Q1)

            # Un-homogenize
            Q1 = hom_Q1[:3, :] / hom_Q1[3, :]
            Q2 = hom_Q2[:3, :] / hom_Q2[3, :]
        
            # Find the number of points there has positive z coordinate in both cameras
            sum_of_pos_z_Q1 = sum(Q1[2, :] > 0)
            sum_of_pos_z_Q2 = sum(Q2[2, :] > 0)
            sum_of_pos_z_Q = sum_of_pos_z_Q1 + sum_of_pos_z_Q2

            # Prevent overflow by rescale the data
            Q1_scaled = Q1 / np.max(np.abs(Q1))
            Q2_scaled = Q2 / np.max(np.abs(Q2))

            relative_scale_scaled = np.mean(np.linalg.norm(Q1_scaled.T[:-1] - Q1_scaled.T[1:], axis=-1) /
                         np.linalg.norm(Q2_scaled.T[:-1] - Q2_scaled.T[1:], axis=-1))   
            relative_scale = relative_scale_scaled * (np.max(np.abs(Q1)) / np.max(np.abs(Q2)))
            
            return sum_of_pos_z_Q, relative_scale

        # Decompose the essential matrix
        R1, R2, t = cv2.decomposeEssentialMat(E)
        t = np.squeeze(t)

        # Make a list of the different possible pairs
        pairs = [[R1, t], [R1, -t], [R2, t], [R2, -t]]

            # Evaluate each pair by checking how many triangulated points have positive Z-coordinates
        z_sums = []
        relative_scales = []
    
        for R_, t_ in pairs:
            z_sum_, scale_ = sum_z_cal_relative_scale(R_, t_)
            z_sums.append(z_sum_)
            relative_scales.append(scale_)

        # Select the pair with the maximum number of points with positive Z-coordinates
        right_pair_idx = np.argmax(z_sums)
        right_pair = pairs[right_pair_idx]
    
        # Get the best rotation and translation pair
        R_r_, t_r_ = right_pair
    
        # Scale the translation by the relative scale factor
        relative_scale_ = relative_scales[right_pair_idx]
        t_r_ *= relative_scale_

        return [R_r_, t_r_]
    
    # Rotation matrix to Yaw, Pitch, Roll
    def rotation_matrix_to_ypr(self, R):
        sy = math.sqrt(R[0, 0] ** 2 + R[1, 0] ** 2)
        singular = sy < 1e-6

        if not singular:
            yaw = math.atan2(R[1, 0], R[0, 0])      # Yaw
            pitch = math.atan2(-R[2, 0], sy)        # Pitch
            roll = math.atan2(R[2, 1], R[2, 2])     # Roll
        else:
            yaw = math.atan2(-R[1, 2], R[1, 1])     # Yaw in singular case
            pitch = math.atan2(-R[2, 0], sy)        # Pitch
            roll = 0                                # Roll is set to zero

        return np.degrees(yaw), np.degrees(pitch), np.degrees(roll)
    
        # Rotation matrix to quaternion
    def rotation_matrix_to_quaternion(R):
        """
        Convert a 3x3 rotation matrix to a quaternion [q_w, q_x, q_y, q_z].
        """
        trace = np.trace(R)
        if trace > 0:
            S = 2.0 * np.sqrt(trace + 1.0)
            q_w = 0.25 * S
            q_x = (R[2, 1] - R[1, 2]) / S
            q_y = (R[0, 2] - R[2, 0]) / S
            q_z = (R[1, 0] - R[0, 1]) / S
        elif (R[0, 0] > R[1, 1]) and (R[0, 0] > R[2, 2]):
            S = 2.0 * np.sqrt(1.0 + R[0, 0] - R[1, 1] - R[2, 2])
            q_w = (R[2, 1] - R[1, 2]) / S
            q_x = 0.25 * S
            q_y = (R[0, 1] + R[1, 0]) / S
            q_z = (R[0, 2] + R[2, 0]) / S
        elif R[1, 1] > R[2, 2]:
            S = 2.0 * np.sqrt(1.0 + R[1, 1] - R[0, 0] - R[2, 2])
            q_w = (R[0, 2] - R[2, 0]) / S
            q_x = (R[0, 1] + R[1, 0]) / S
            q_y = 0.25 * S
            q_z = (R[1, 2] + R[2, 1]) / S
        else:
            S = 2.0 * np.sqrt(1.0 + R[2, 2] - R[0, 0] - R[1, 1])
            q_w = (R[1, 0] - R[0, 1]) / S
            q_x = (R[0, 2] + R[2, 0]) / S
            q_y = (R[1, 2] + R[2, 1]) / S
            q_z = 0.25 * S

        return np.array([q_w, q_x, q_y, q_z])

#============================== Main ==============================
# Load the Camera Matrix
with open('Arducam_intrinsic.npy', 'rb') as f:
    intrinsic = np.load(f)
vo = CameraPoses(intrinsic)

# Initial the transformation matrix
start_translation = np.zeros((3,1))
start_rotation = np.identity(3)
start_pose = np.concatenate((start_rotation, start_translation), axis=1)

# Initialize Picamera2 object
picam2 = Picamera2()

# Configure the camera for preview mode
picam2.preview_configuration.main.size = (640, 480)  # Set a valid resolution
picam2.preview_configuration.main.format = "RGB888"    # Set a valid format
picam2.preview_configuration.align()

# Start the camera
picam2.configure("preview")
try:
    picam2.start()
except Exception as e:
    print(f"Error starting camera: {e}")
    exit()

# Check if camera opened successfully
if not picam2:
    print("Error opening video stream")
    exit()

process_frames = False
old_frame = None
new_frame = None
frame_counter = 0
camera_pose = start_pose

# Main loop to capture frames
while True:
    # Capture frame-by-frame from Picamera as NumPy array
    new_frame = picam2.capture_array()

    frame_counter += 1
    start = time.perf_counter()

    if process_frames and old_frame is not None:
        q1, q2 = vo.get_matches(old_frame, new_frame)
        if q1 is not None and len(q1) > 20 and len(q2) > 20:
            transf = vo.get_pose(q1, q2)
            camera_pose = camera_pose @ transf

    old_frame = new_frame
    process_frames = True

    end = time.perf_counter()
    
    # Calculate FPS
    total_time = end - start
    fps = 1 / total_time if total_time > 0 else 0

    # Display FPS on the frame
    cv2.putText(new_frame, f'FPS: {int(fps)}', (20, 50), cv2.FONT_HERSHEY_SIMPLEX, 1, (0, 255, 0), 2)

    # Yaw, Pitch, Roll (rotation matrix to Euler angles)
    # yaw_angle, pitch_angle, roll_angle = vo.rotation_matrix_to_ypr(camera_pose)
    
    # Quaternion matrix
    Qw, Qx ,Qy, Qz = vo.rotation_matrix_to_quaternion(camera_pose)
    print(f"Qw: {Qw}, Qx: {Qx}, Qy: {Qy}, Qz: {Qz}")

    # Display Euler angles on the frame in degree
    # cv2.putText(new_frame, f"Yaw: {yaw_angle:.2f}", (400, 50), cv2.FONT_HERSHEY_SIMPLEX, 1, (0, 255, 0), 2)
    # cv2.putText(new_frame, f"Pitch: {pitch_angle:.2f}", (400, 90), cv2.FONT_HERSHEY_SIMPLEX, 1, (0, 255, 0), 2)
    # cv2.putText(new_frame, f"Roll: {roll_angle:.2f}", (400, 130), cv2.FONT_HERSHEY_SIMPLEX, 1, (0, 255, 0), 2)
    
    # Display the resulting frame using OpenCV with a custom window name
    cv2.imshow("Arducam OV5647", new_frame)

    # Press 'q' to exit the loop and close the window
    if cv2.waitKey(1) & 0xFF == ord('q'):
        break

# Release resources and close all OpenCV windows
cv2.destroyAllWindows()