#include <iostream>
#include <vector>
#include <cmath>

__global__ void MatrixMulKernel(float *M, float *N, float *P, int width)
{
    int row = blockIdx.y * blockDim.y + threadIdx.y;
    int col = blockIdx.x * blockDim.x + threadIdx.x;
    if ((row < width) && (col < width)) // row col = 0,1
    {
        float Pvalue = 0;
        for (int k = 0; k < width; ++k) // k<=2
        {
            Pvalue += M[row * width + k] * N[k * width + col];
        }
        P[row * width + col] = Pvalue;
    }
}

int main()
{
    const int width = 2;
    float *M_d, *N_d, *P_d;

    size_t size = width * width * sizeof(float);

    std::vector<float> h_Matrix_one={4.0f,4.0f,2.0f,2.0f};
    std::vector<float> h_Matrix_two(width * width, 2.0f);
    std::vector<float> h_Res(width * width, 0.0f);

    cudaMalloc((void **)&M_d, size);
    cudaMalloc((void **)&N_d, size);
    cudaMalloc((void **)&P_d, size);

    cudaMemcpy(M_d, h_Matrix_one.data(), size, cudaMemcpyHostToDevice);
    cudaMemcpy(N_d, h_Matrix_two.data(), size, cudaMemcpyHostToDevice);

    dim3 dimGrid(1, 1, 1);
    dim3 dimBlock(2, 2, 1);
    // 这样写不行 MatrixMulKernel<<<1,2,2>>>(M_d,N_d,P_d,width);
    MatrixMulKernel<<<dimGrid, dimBlock>>>(M_d, N_d, P_d, width); // 这样可以，为什么

    cudaMemcpy(h_Res.data(), P_d, size, cudaMemcpyDeviceToHost);

    cudaFree(M_d);
    cudaFree(N_d);
    cudaFree(P_d);
    for (float elem : h_Res)
    {
        printf("%f\n", elem);
    }
}