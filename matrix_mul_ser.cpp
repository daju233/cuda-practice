#include <iostream>
#include <vector>

const int SIZE = 32; // 矩阵大小

using namespace std;

int main() {
    // 初始化一维数组A和B作为矩阵，以及结果矩阵C初始化为0
    vector<float> A(SIZE * SIZE,4.0f);
    vector<float> B(SIZE * SIZE,2.0f);
    vector<float> C(SIZE * SIZE, 0); // 结果矩阵初始化为0

    // // 填充矩阵A和B，这里仅做示意，实际应用中应该根据需求填充
    // for (int i = 0; i < SIZE; ++i) {
    //     for (int j = 0; j < SIZE; ++j) {
    //         A[i * SIZE + j] = i + j; // 示例数据
    //         B[i * SIZE + j] = i - j; // 示例数据
    //     }
    // }

    // 执行矩阵乘法
    for (int i = 0; i < SIZE; ++i) {
        for (int j = 0; j < SIZE; ++j) {
            for (int k = 0; k < SIZE; ++k) {
                C[i * SIZE + j] += A[i * SIZE + k] * B[k * SIZE + j];
            }
        }
    }

    // 输出结果矩阵C
    // cout << "Matrix C (A * B):" << endl;
    // for (int i = 0; i < SIZE; ++i) {
    //     for (int j = 0; j < SIZE; ++j) {
    //         cout << C[i * SIZE + j] << "\t";
    //     }
    //     cout << endl;
    // }

    return 0;
}