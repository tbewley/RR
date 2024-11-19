// This is a test code that fits the smooth nonlinear 3-parameter function 
//     newton_func(x)=par[0] + (par[1] - par[0]) * exp( -par[2]*x)
// to 395 measured (noisy) temperature values in t_data, where the sample number x is time:
//   t_data[0]=21.6 is the measured temperature at time x=0,
//   t_data[1]=22   is the measured temperature at time x=1, etc.
// After the 3 parameters are optimized to fit the data, it then
// calculates the time x that corresponds to a particular value of temperature
// in the fitted 3-parameter model; it should be pretty close (but not quite equal)
// to the corresponding sample number in the data.  
// Original code, copyright Ron Babich under the MIT license, copied from
//    https://github.com/leechwort/levenberg-maquardt-example
// VERY minor tweaks (solely to improve readability) by Thomas Bewley 2024

#include <stdio.h>
#include "levmarq.h"
#include <math.h>
#include <time.h>

#define N_MEASUREMENTS 395
#define N_PARAMS 3

double t_data[N_MEASUREMENTS] = { 21.6,  22. ,  22.4,  22.4,  22.5,  22.4,  22.2,  22.3,  22.4,\
                                  22.1,  21.8,  21.6,  22.1,  22. ,  21.7,  21.7,  21.5,  21.5,\
                                  21.4,  21.6,  21.7,  21.8,  21.9,  22. ,  21.9,  22.2,  22.3,\
                                  22.3,  22.4,  22.4,  22.4,  23. ,  23.6,  24.6,  24.3,  24.3,\
                                  24.2,  25. ,  25. ,  25.2,  25.4,  26. ,  26.3,  26.3,  26. ,\
                                  26.1,  25.9,  25.7,  26.1,  26. ,  26.3,  26.4,  26.4,  26.4,\
                                  26.5,  26.8,  26.8,  26.9,  27.2,  27.8,  27.9,  28.2,  28.1,\
                                  28.1,  28. ,  28. ,  28.3,  28.4,  28.8,  29.7,  30. ,  30.1,\
                                  29.8,  30.4,  30.9,  30.6,  30.7,  30.6,  30.3,  30.4,  30.8,\
                                  31.3,  31.3,  31.4,  31.2,  31.4,  31.5,  31.6,  31.8,  32.3,\
                                  32.2,  32.7,  32.4,  32.3,  32.7,  33. ,  33. ,  33.1,  33.2,\
                                  33.3,  33.6,  34. ,  33.9,  34.1,  34.2,  34.4,  34.7,  35.1,\
                                  35.2,  34.9,  35.2,  35.3,  35.1,  35.3,  36. ,  35.9,  35.9,\
                                  36.4,  36.9,  36.5,  36.4,  36.9,  36.9,  36.9,  37.4,  37. ,\
                                  36.9,  36.4,  37. ,  37.1,  37. ,  37.1,  37.1,  37.6,  37.8,\
                                  38. ,  38.7,  39. ,  39.2,  39.5,  40.1,  40.4,  40.6,  40.2,\
                                  40.1,  40.3,  40.4,  40.7,  40.9,  40.5,  40.7,  41.5,  41.4,\
                                  41.3,  40.7,  40.5,  40.8,  41.2,  41.2,  41. ,  41.3,  41.5,\
                                  41.7,  42.1,  42.1,  42.3,  42.2,  41.8,  42. ,  42.4,  42.6,\
                                  42.6,  42.3,  42.4,  42.7,  43.1,  42.9,  42.8,  42.8,  43.1,\
                                  43.4,  44. ,  43.9,  43.9,  43.8,  43.9,  44.4,  44.6,  45.1,\
                                  45.2,  45.2,  45.2,  45.4,  45.7,  45.3,  45.1,  45.1,  45.6,\
                                  45.9,  45.9,  45.9,  46. ,  46.2,  46.2,  46.3,  46.6,  46.9,\
                                  46.9,  47.2,  47.6,  47.5,  47.7,  47.6,  47.7,  48. ,  47.8,\
                                  47.9,  48. ,  48.2,  48. ,  48. ,  48.1,  48.6,  48.6,  49.2,\
                                  48.9,  48.8,  49.2,  49.4,  49.2,  49. ,  49.3,  49.8,  50.3,\
                                  50.7,  50.9,  50.8,  50.6,  50.4,  50.7,  50.9,  51. ,  51.4,\
                                  51.4,  51.8,  51.8,  51.6,  52.3,  52.7,  53.3,  53.1,  54. ,\
                                  53.3,  53.3,  53.6,  53.2,  53. ,  53.1,  53.4,  53.5,  53.6,\
                                  53.9,  53.7,  53.9,  53.9,  52.8,  53.1,  53.1,  53.3,  53.4,\
                                  53.6,  54. ,  54.3,  54.2,  54.4,  54.7,  54.6,  56.5,  56.4,\
                                  55.7,  55.8,  55.9,  56.2,  56.2,  56.3,  56.3,  56.5,  56.9,\
                                  57. ,  57.4,  57.9,  58.2,  57.6,  57.5,  57.9,  58.4,  58.9,\
                                  59.1,  58.4,  59. ,  62.4,  57.6,  56.6,  58.6,  59. ,  59. ,\
                                  59. ,  59.3,  59.5,  59. ,  59.4,  59.2,  59.1,  60. ,  59.8,\
                                  60.3,  60.8,  60.5,  60.4,  61.5,  60.7,  60.7,  61. ,  60.9,\
                                  61. ,  61.3,  61.7,  61.5,  61.4,  61.8,  61.9,  62.6,  62.3,\
                                  62.1,  62. ,  62.3,  62.4,  62.4,  61.7,  62.7,  63.2,  62.8,\
                                  62.9,  63. ,  63.6,  63.9,  63.3,  63.7,  63.5,  63.3,  63.9,\
                                  64. ,  63.8,  63.9,  64.5,  64.3,  63.8,  63.5,  64. ,  64.3,\
                                  65.2,  65.7,  65.9,  65.6,  64.7,  65. ,  65.1,  65.8,  66.2,\
                                  66.6,  66.3,  66. ,  65.5,  66.2,  66.4,  66.8,  67.4,  67.3,\
                                  67. ,  66.8,  66.4,  67.3,  66.9,  67.6,  72.1,  66.6,  66.2,\
                                  67.1,  70. ,  68.8,  68.1,  67.8,  67.3,  67.4,  66.2 };

double params[N_PARAMS] = {200, 20, 0.001}; // Initial values of parameters

LMstat lmstat;

/* @brief   Function describing Newtons law of heating/cooling
 *
 * @usage   par[0] - temperature of heater,
 *          par[1] - initial temperature of water,
 *          par[2] - heat transmission coefficient
 *
 * @par     parameters defining Newtons Law:
 * @x       samplenumber
 * @fdata   additional data, not used
 *
 * @return  temperature at the time x
 */
double newton_func(double *par, int x, void *fdata)
{
    return par[0] + (par[1] - par[0]) * exp( -par[2]*x);
}

/*
 * @brief   Gradient function for Newton law of heating
 */
void gradient(double *g, double *par, int x, void *fdata)
{
    g[0] = 1.0 - exp(-par[2] * x);
    g[1] = exp(-par[2] * x);
    g[2] = -x * (par[1] - par[0]) * exp(-par[2] * x);
}

/*
 * @brief  Function for prediction of time, when target temperature will be reached
 * 
 * @par    Parameters from Newton equation
 * @temp   Target temperature
 * @return Number of sample
 * TB: Note that this function simply inverts newton_func
 */
double temp_to_time(double *par, double temp)
{
    return -(1/par[2]) * log((temp - par[0])/(par[1] - par[0]));
}

int main(int argc, char *argv[])
{
    int n_iterations;
    levmarq_init(&lmstat);
    n_iterations = levmarq(N_PARAMS, params, N_MEASUREMENTS, t_data, NULL,
            &newton_func, &gradient, NULL, &lmstat);
    printf("**************** End of calculation ***********************\n");
    printf("N iterations: %d\n", n_iterations);
    printf("T_heater: %f, T_0: %f, k: %f\n",
           params[0], params[1], params[2]);
    printf("**************** Interpolation test ***********************\n");
    printf("Search for temp 23.0 degrees\n");
    printf("Result: time = %f\n", temp_to_time(params, 23.0));
    return 0;
}
