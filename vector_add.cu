#include <cuda_runtime.h>
#include<stdio.h>

__global__ void vecAddKernel(float *A, float *B, float *C, int n)
{
    int i = blockIdx.x * blockDim.x + threadIdx.x;
    if (i < n)
    {
        C[i] = A[i] + B[i];
    }
}

int main()
{
    float *A_d, *B_d, *C_d;
    float size = 114514 * sizeof(float);
    float A[114514]={1,1,1,1};
    float B[114514]={1,1,1,1};
    float C[114514]={0,0,0,0};
    cudaMalloc((void **)&A_d, size);
    cudaMalloc((void **)&B_d, size);
    cudaMalloc((void **)&C_d, size);
    cudaMemcpy(A_d, A, size, cudaMemcpyHostToDevice);
    cudaMemcpy(B_d, B, size, cudaMemcpyHostToDevice);
    // 第一个配置参数给出了网格中的块数，第二个指定了每个块中的线程数。在这个例子中，每个块中有256个线程。
    vecAddKernel<<<ceil(114514 / 256.0), 256.0>>>(A_d, B_d, C_d, size);
    cudaMemcpy(C,C_d,size,cudaMemcpyDeviceToHost);
    cudaFree(A_d);
    cudaFree(B_d);
    cudaFree(C_d);
    printf("%f",C[1]);
}