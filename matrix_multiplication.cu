#include <iostream>
#include <vector>
#include <iomanip>
#include <cmath>

__global__ void MatrixMulKernel(float *M, float *N, float *P, int width)
{
    int row = blockIdx.y * blockDim.y + threadIdx.y;
    int col = blockIdx.x * blockDim.x + threadIdx.x;
    if ((row < width) && (col < width))
    {
        float Pvalue = 0;
        for (int k = 0; k < width; ++k)
        {
            Pvalue += M[row * width + k] * N[k * width + col];
        }
        P[row * width + col] = Pvalue;
    }
}

int main()
{
    const int width = 4;
    size_t size = width * width * sizeof(float);
    std::vector<float> h_M(width * width);
    std::vector<float> h_N(width * width);
    std::vector<float> h_P(width * width, 0.0f);
    std::vector<float> h_ref(width * width, 0.0f);

    float *d_M, *d_N, *d_P;
    cudaMalloc()
}