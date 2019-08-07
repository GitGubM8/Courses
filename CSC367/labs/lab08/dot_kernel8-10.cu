/* ------------
 * This code is provided solely for the personal and private use of 
 * students taking the CSC367 course at the University of Toronto.
 * Copying for purposes other than this use is expressly prohibited. 
 * All forms of distribution of this code, whether as given or with 
 * any changes, are expressly prohibited. 
 * 
 * Authors: Bogdan Simion, Maryam Dehnavi, Felipe de Azevedo Piovezan
 * 
 * All of the files in this directory and all subdirectories are:
 * Copyright (c) 2019 Bogdan Simion and Maryam Dehnavi
 * -------------
*/

__inline__ __device__
float warpReduceSum(float val)
{
    return val;
}

__inline__ __device__
float blockReduceSum(float val)
{
    return val;
}

__global__ void dot_kernel8(float *g_idata1, float *g_idata2, float *g_odata,
        int N)
{
}

__global__ void dot_kernel9(float *g_idata1, float *g_idata2, float *g_odata,
        int N)
{
}

__global__ void dot_kernel10(float *g_idata1, float *g_idata2, float *g_odata,
        int N)
{
}