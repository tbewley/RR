#include <stdio.h> 
// Simple matrix/vector multiplication (calculate y=A*x) demo in C
// I am seriously not copyrighting this one.  - Tom Bewley, Nov 2024
// Compile with:
//   gcc matrix_vector_multiplication.c -o matrix_vector_multiplication

int main() { 
    int A[3][3] = {{1, 2, 3}, {4, 5, 6}, {7, 8, 9}}; 
    int x[3]    = {1, 2, 3}; 
    int y[3]    = {0, 0, 0}; 
    int i, j; 
    for (i=0; i<3; i++) {
        for (j=0; j<3; j++) { y[i] += A[i][j] * x[j]; } 
    } 
    printf("Result vector, y=A*x:\n"); 
    for (i = 0; i < 3; i++) { printf("%d \n", y[i]); } 
    return 0; 
}