#include <stdio.h> 
// Simple matrix/vector multiplication demo in C
// I am seriously not copyrighting this one.  - Tom Bewley, Nov 2024
// Compile with:
//   gcc matrix_vector_multiplication.c -o matrix_vector_multiplication

int main() { 
    int matrix[3][3] = {{1, 2, 3}, {4, 5, 6}, {7, 8, 9}}; 
    int vector[3]     = {9, 8, 7}; 
    int result[3]     = {0, 0, 0}; 
    int i, k; 
 
    for (i = 0; i < 3; i++) {
        for (k = 0; k < 3; k++) { result[i] += matrix[i][k] * vector[k]; } 
    } 
 
    printf("Resulting Matrix:\n"); 
    for (i = 0; i < 3; i++) { printf("%d \n", result[i]); } 
 
    return 0; 
}