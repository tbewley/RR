% script <a href="matlab:SVDTest">QuaternionTest</a>
% Test quaternion routines on a random complex matrix.
% Numerical Renaissance Codebase 1.0, Chapter 17; see text for copyleft info.

syms pr px py pz qr qx qy qz
p=[0; px; py; pz]; q=[qr; qx; qy; qz];
approach1=QuaternionRotate(p,q)
approach2=simplify(QuaternionMultiply(QuaternionMultiply(q,p),QuaternionConjugate(q)))
error=simplify(approach1-approach2(2:4))

% end script SVDTest
