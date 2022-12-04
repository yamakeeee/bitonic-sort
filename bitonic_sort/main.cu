#include <stdio.h>
#include <stdlib.h>
#include <algorithm>

#include "cuda_runtime.h"

static void bitonic_sort_GPU(int *in, int*out, const int n);
// static void bitonic_sort_CPU(int *in, int*out, const int n);

int main()
{
    printf("Hello from CPU\n");

    const int n = 1024;
    int *in = new int[n];
    int *out_cpu = new int[n];
    int *out_gpu = new int[n];

    for (int i = 0; i < n; i++) in[i] = rand() % 10000;

    bitonic_sort_GPU(in, out_gpu, n);
    // bitonic_sort_CPU(in, out_cpu, n);

    delete[] in;
    delete[] out_cpu;
    delete[] out_gpu;

    return 0;
}

__global__ void kernel_bitonic_sort(int *in, int *out, const int n)
{
    int i = blockIdx.x * blockDim.x +threadIdx.x;
    if (i < n) {
        out[i] = in[i] * 2;
    }
}

static void bitonic_sort_GPU(int *hIn, int *hOut, const int n)
{
    int *dIn;
    int *dOut;
    cudaMallocHost((void**)&dIn, n * sizeof(int));
    cudaMallocHost((void**)&dOut, n * sizeof(int));
    cudaMemcpy(dIn, hIn, n * sizeof(int), cudaMemcpyHostToDevice);
    int m=(n+31)/32;
    kernel_vecDouble<<<32, m>>>(dIn, dOut, n);
    cudaDeviceSynchronize();

    cudaMemcpy(hOut, dOut, n * sizeof(int), cudaMemcpyDeviceToHost);
    cudaFree(dIn);
    cudaFree(dOut);
}

// static void bitonic_sort_CPU(int *hIn, int *hOut, const int n){
//     return;
// }
