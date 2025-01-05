#include <iostream>
#include <vector>
#include <cmath>
#define TILE_WIDTH 32 // 最简单的情况，瓦片的维度等于块的维度

__global__ void MatrixMulKernel(float *M, float *N, float *P, int width)
{
    __shared__ float Mds[TILE_WIDTH][TILE_WIDTH];
    __shared__ float Nds[TILE_WIDTH][TILE_WIDTH];

    int bx = blockIdx.x;
    int by = blockIdx.y;
    int tx = threadIdx.x;
    int ty = threadIdx.y;//共享内存数组和TILE_WIDTH显然不能超过32

    // 标记当前元素
    int Row = by * TILE_WIDTH + ty;
    int Col = bx * TILE_WIDTH + tx;

    // 遍历width/TILE_WIDTH次，这样可以将需要的元素都加载好到shared memory中
    if ((Row < width) && (Col < width))
    {
        float Pvalue = 0;
        // ph=tilecount
        for (int ph = 0; ph < width / TILE_WIDTH; ++ph)
        {

            // 加载到shared memory中
            Mds[ty][tx] = M[Row * width + ph * TILE_WIDTH + tx];
            Nds[ty][tx] = N[(ph * TILE_WIDTH + ty) * width + Col];
            __syncthreads();
            for (int k = 0; k < TILE_WIDTH; ++k)
            {
                Pvalue += Mds[ty][k] * Nds[k][tx];
            }
            __syncthreads();
        }
        P[Row * width + Col] = Pvalue;
    }
}

int main()
{
    const int width = TILE_WIDTH;
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

    dim3 dimBlock(32, 32, 1);      // 每个块1024个线程 //为什么要这么多？？？
    dim3 dimGrid(4, 4, 1); // 创建一个width*width个块的网格

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