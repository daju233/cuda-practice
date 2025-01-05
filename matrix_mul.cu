#include <iostream>
#include <vector>
#include <cmath>

__global__ void MatrixMulKernel(float *M, float *N, float *P, int width)
{
    // 每个线程负责一个输出元素
    int row = blockIdx.y * blockDim.y + threadIdx.y;
    int col = blockIdx.x * blockDim.x + threadIdx.x;
    if ((row < width) && (col < width)) // row col < width
    {
        float Pvalue = 0;
        for (int k = 0; k < width; ++k) // k < width
        {
            Pvalue += M[row * width + k] * N[k * width + col]; // 一整行和一整列
        }
        P[row * width + col] = Pvalue;
    }
}

int main()
{
    const int width = 32;
    float *M_d, *N_d, *P_d;

    size_t size = width * width * sizeof(float);

    std::vector<float> h_Matrix_one(width * width, 4.0f);
    std::vector<float> h_Matrix_two(width * width, 2.0f);
    std::vector<float> h_Res(width * width, 0.0f);

    cudaMalloc((void **)&M_d, size);
    cudaMalloc((void **)&N_d, size);
    cudaMalloc((void **)&P_d, size);

    cudaMemcpy(M_d, h_Matrix_one.data(), size, cudaMemcpyHostToDevice);
    cudaMemcpy(N_d, h_Matrix_two.data(), size, cudaMemcpyHostToDevice);

    dim3 dimBlock(16,16,1);//每个块256个线程
    dim3 dimGrid(width,width,1);//创建一个width*width个块的网格

    MatrixMulKernel<<<dimGrid, dimBlock>>>(M_d, N_d, P_d, width);

    cudaMemcpy(h_Res.data(), P_d, size, cudaMemcpyDeviceToHost);

    cudaFree(M_d);
    cudaFree(N_d);
    cudaFree(P_d);
    // std::cout << "Matrix C (A * B):" << std::endl;
    // for (int i = 0; i < width; ++i) {
    //     for (int j = 0; j < width; ++j) {
    //         std::cout << h_Res[i * width + j] << "\t";
    //     }
    //     std::cout << std::endl;
    // }
}