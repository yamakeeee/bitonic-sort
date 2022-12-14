#include <stdio.h>
#include <stdlib.h>
#include <iostream>
#include <algorithm>
#include <thrust/sort.h>

#include "time_measure.h"
#include "cuda_runtime.h"

static void bitonic_sort_GPU(int *in, int*out, const int n, const int m);
static void bitonic_sort_CPU(int *in, int*out, const int n, const int m);

time_measure::Timer timer;

bool solve()
{
    const int m = 15;
    const int n = (1 << m);

    int *a = new int[n];
    int *out_cpu = new int[n];
    int *out_gpu = new int[n];

    for (int i = 0; i < n; i++) a[i] = rand() % 10000;
    
    timer.start();
    bitonic_sort_GPU(a, out_gpu, n, m);
    timer.stop("bitonic sort GPU");

    timer.start();
    int *b = new int[n];
    for (int i = 0; i < n; ++i) b[i] = a[i];
    thrust::sort(b, b + n);
    timer.stop("thrust::sort");

    timer.start();
    bitonic_sort_CPU(a, out_cpu, n, m);
    timer.stop("bitonic sort CPU");

    timer.start();
    std::sort(a, a + n);
    timer.stop("std::sort");

    for(int i = 0; i < n; ++i){
        if(a[i] != out_cpu[i] || a[i] != out_gpu[i]){
            std::cout<<"NG"<<std::endl;
            printf("a[%d], out_cpu[%d], out_gpu[%d] = %d, %d, %d\n", i, i, i, a[i], out_cpu[i], out_gpu[i]);
            return false;
        }
    }

    delete[] a;
    delete[] out_cpu;
    delete[] out_gpu;
    return true;
}

__global__ void kernel_bitonic_sort(int *a, const int n, const int c, const int j)
{
    int i = blockIdx.x * blockDim.x +threadIdx.x;
    if (i < n / 2) {
        int idx = i + ((i >> j) << j);
        if (((i >> c) & 1) == 0 && a[idx] > a[idx + (1 << j)]){
            int tmp = a[idx];
            a[idx] = a[idx + (1 << j)];
            a[idx + (1 << j)] = tmp;
        }
        else if(((i >> c) & 1) && a[idx] < a[idx + (1 << j)]){
            int tmp = a[idx];
            a[idx] = a[idx + (1 << j)];
            a[idx + (1 << j)] = tmp;
        }
    }
}

__global__ void kernel_bitonic_sort_asink(int *a, const int n, const int c, const int jj)
{
    int i = blockIdx.x * blockDim.x +threadIdx.x;
    if (i < n / 2) {
        for(int j = jj; j >= 0; --j){
            int idx = i + ((i >> j) << j);
            if (((i >> c) & 1) == 0 && a[idx] > a[idx + (1 << j)]){
                int tmp = a[idx];
                a[idx] = a[idx + (1 << j)];
                a[idx + (1 << j)] = tmp;
            }
            else if(((i >> c) & 1) && a[idx] < a[idx + (1 << j)]){
                int tmp = a[idx];
                a[idx] = a[idx + (1 << j)];
                a[idx + (1 << j)] = tmp;
            }
        }
        __syncthreads();
    }
}

static void bitonic_sort_GPU(int *hIn, int *hOut, const int n, const int m)
{
    int *dArray;
    cudaMallocHost((void**)&dArray, n * sizeof(int));
    cudaMemcpy(dArray, hIn, n * sizeof(int), cudaMemcpyHostToDevice);
    int blockSize = 64;
    int gridSize = (n + blockSize - 1) / blockSize;
    for(int c = 0; c < m; ++c){
        for(int j = c; j >= 0; --j){
            if((1<<(j+1)) <= blockSize){
                kernel_bitonic_sort_asink<<<gridSize, blockSize>>>(dArray, n, c, j);
                break;
            }
            else kernel_bitonic_sort<<<gridSize, blockSize>>>(dArray, n, c, j);
        }
    }
    cudaDeviceSynchronize();
    cudaMemcpy(hOut, dArray, n * sizeof(int), cudaMemcpyDeviceToHost);
    cudaFree(dArray);
}

static void bitonic_sort_CPU(int *hIn, int *a, const int n, const int m){
    for(int i = 0; i < n; ++i)a[i] = hIn[i];
    for(int c = 0; c < m; ++c){
        for(int j = c; j >= 0; --j){
            for(int i = 0; i < (n >> 1); ++i){
                int idx = i + ((i >> j) << j);
                if (((i >> c) & 1) == 0 && a[idx] > a[idx + (1 << j)]){
                    std::swap(a[idx], a[idx + (1 << j)]);
                }
                else if(((i >> c) & 1) && a[idx] < a[idx + (1 << j)]){
                    std::swap(a[idx], a[idx + (1 << j)]);
                }
            }
        }
    }
    return;
}

int main(){
    int n = 1000;
    int ng = 0;
    for(int i = 0; i < n; ++i){
        if(!solve())++ng;
    }
    std::cout << ng << std::endl;
}
