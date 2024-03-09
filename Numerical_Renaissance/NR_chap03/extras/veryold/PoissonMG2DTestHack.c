#include <stdio.h>      /* A 2D Poisson solver on a uniform mesh using multigrid with   */
#include <stdlib.h>     /* red/black smoothing.  The RHS vector is assumed to be scaled */
#include <math.h>       /* such that the discretized Laplace operator has a 1 on the    */
#include <sys/types.h>  /* diagonal element.                                            */
#include <time.h>
#include <unistd.h>
#define max(A,B) ( (A) > (B) ? (A) : (B) )
void PoissonMG2DInit(); void PoissonMG2D(); void Multigrid(int l); void Smooth(int l);
void EnforceBCs(int l); double MaxDefect(int l);
/*-------------------------------------- USER INPUT ------------------------------------*/ 
/*XBC=1 for hom Dirichlet (0:NX), =2 for periodic (-1:NX), =3 for hom Neumann (-1:NX+1).*/
/*Same for YBC. NX,NY must be powers of 2 with NX>=NY. N1,N2,N3 set how much smoothing  */
int NX=16, NY=16, XBC=1, YBC=1, N1=2, N2=2, N3=2;   /* is applied at various steps.     */
/*----------------------------------- END OF USER INPUT --------------------------------*/
int xo, yo, nlev;                                                  /* global variables. */
typedef struct { int nx, ny, xm, ym; } grid;   
typedef struct { double **d; } arrays;        
arrays *v, *d; grid *g;
/****************************************************************************************/
int main() {
int i, j, s;  double z=0.0;  double **di;
printf("BCs: %d, %d.  Smoothing: %d, %d, %d.  Grids:\n",XBC,YBC,N1,N2,N3);
PoissonMG2DInit(); 

s = sizeof(double);
di=malloc((g[0].xm-3)*s); for (i=0; i<g[0].xm-4; ++i) di[i]=malloc((g[0].ym-4)*s);
z = 0.0; for(i=0; i<g[0].xm-4; ++i) for(j=0; j<g[0].ym-4;++j) {
      di[i][j] = (((double) rand())/((double) RAND_MAX)) ; z += di[i][j]; }
for(i=0; i<g[0].xm-4; ++i) free(di[i]); free(di);
for(i=2; i<g[0].xm-2; ++i) for(j=2; j<=g[0].ym-3; ++j) 
   d[0].d[i][j] = di[i-2][j-2]-z/((double)((g[0].xm-4)*(g[0].ym-4)));
   
PoissonMG2D();
} /**************************************************************************************/
void PoissonMG2DInit() {
/* This initialization routine defines several global variables to avoid the repeated   */
/* memory allocation/deallocation otherwise caused by recursion.  Note that d and v are */
/* arrays of arrays which are of different size at each level l.                        */
int i,l;
switch(XBC) {case 1: xo=1; break;  case 2: xo=2; break; case 3: xo=2; break; }
switch(YBC) {case 1: yo=1; break;  case 2: yo=2; break; case 3: yo=2; break; }
nlev = (int) log2(NY)-1; printf("nlev: %d\n",nlev);
g = (grid *) calloc(nlev+1, sizeof(grid));
v = (arrays *) calloc(nlev+1, sizeof(arrays));
d = (arrays *) calloc(nlev+1, sizeof(arrays));
for (l=0; l<=nlev; ++l) {
  g[l].nx = NX/pow(2.,l); g[l].ny = NY/pow(2.,l);
  printf("%d %d %d\n", l,g[l].nx,g[l].ny);
  g[l].xm = g[l].nx+XBC; g[l].ym = g[l].ny+YBC;
  v[l].d = (double **) calloc( g[l].xm,  sizeof(double *) );
  d[l].d = (double **) calloc( g[l].xm,  sizeof(double *) );
  for(i = 0; i < g[l].xm; ++i) {
	v[l].d[i] = (double *) calloc(g[l].ym, sizeof(double));
	d[l].d[i] = (double *) calloc(g[l].ym, sizeof(double)); }}
} /**************************************************************************************/
void PoissonMG2D() {
double e, o; int i, sm, iter;  time_t t0, t1;
e=MaxDefect(0);
printf("Iter = %d, max defect = %f\n", 0, e);  
for (sm=1; sm<=20; ++sm) Smooth1(0);           /* APPLY SMOOTHING BEFORE STARTING MULTIGRID */
e=MaxDefect(0);
printf("After initial smoothing, max defect = %f\n", e);  pause;
t0 = time(NULL); for (iter=1; iter<=10; ++iter) { /* PERFORM UP TO 10 MULTIGRID CYCLES. */
   o=e; Multigrid(0); e = MaxDefect(0);
   printf("Iter = %d, max defect = %f, factor = %f\n",iter,e,o/e);
   if (e<1E-13) { printf("\nConverged!\n"); break; } } t1 = time(NULL);
printf("\nTime: %ld; Time/iteration: %f sec\n", (t1-t0), ((double)(t1-t0)/(double)i));
} /**************************************************************************************/
void Multigrid(int l) {
int i, j, ic, jc, s;
/* printf("level %d\n",l); */
for (i=1; i<=N2; ++i) Smooth(l);                  /* APPLY SMOOTHING BEFORE COARSENING */
for(i=0; i<g[l+1].xm; ++i) for(j=0; j<g[l+1].ym; ++j) {v[l+1].d[i][j]=0; d[l+1].d[i][j]=0;}
for (ic=1; ic<=g[l+1].xm-2; ++ic) for (jc=1; jc<=g[l+1].ym-2; ++jc) {   
   i=2*(ic-xo)+xo+1; j=2*(jc-yo)+yo+1;        
   d[l+1].d[ic][jc]=d[l].d[i][j] - v[l].d[i][j] +
      (v[l].d[i][j+1]+v[l].d[i][j-1]+v[l].d[i+1][j]+v[l].d[i-1][j])*0.25;
   v[l+1].d[ic][jc]=d[l+1].d[ic][jc];  }
EnforceBCs(l+1);                                     
if (l<nlev-1) Multigrid(l+1); else for (i=1;i<=20;++i) Smooth(nlev);              
for (ic=1;ic<=g[l+1].xm-1;++ic) for (jc=1;jc<=g[l+1].ym-1;++jc) {     
   i=2*(ic-xo)+xo+1; j=2*(jc-yo)+yo+1;
   if (j<=g[l].ym-1) v[l].d[i-1][j]=v[l].d[i-1][j]+(v[l+1].d[ic-1][jc]+v[l+1].d[ic][jc]); 
   if (i<=g[l].xm-1) v[l].d[i][j-1]=v[l].d[i][j-1]+(v[l+1].d[ic][jc-1]+v[l+1].d[ic][jc]);}
EnforceBCs(l);
for (i=1;i<=N3;++i) Smooth(l);
} /**************************************************************************************/
void Smooth1(int l) {
int rb, i, j, m, n;                       /* update red points first, then black points */
for (rb=0; rb<=1; ++rb) { for (i=1; i<=g[l].xm-2; ++i) { 
   m = 1+(1+i+rb+xo+yo) % 2; n=g[l].ym-2;  /* In C, inner loop should be on LAST index */
   for (j=m; j<=n; j+=2) v[l].d[i][j]=(v[l].d[i][j+1]+v[l].d[i][j-1]+v[l].d[i+1][j]+v[l].d[i-1][j])*0.25+d[l].d[i][j]; 
   } EnforceBCs(l); }
} /*------------------------------------------------------------------------------------*/
void Smooth(int l) {
int irb, i, j, m, n;                      /* update red points first, then black points */
for (irb=0; irb<=1; ++irb) { for (i=1; i<=g[l].xm-2; ++i) { 
   m = 1+(1+i+irb+xo+yo) % 2; n=g[l].ym-2;  /* In C, inner loop should be on LAST index */
   for (j=m; j<=n; j+=2) v[l].d[i][j]=d[l].d[i][j] +
      (v[l].d[i][j+1]+v[l].d[i][j-1]+v[l].d[i+1][j]+v[l].d[i-1][j])*0.25;
   } EnforceBCs(l); }
} /**************************************************************************************/
void EnforceBCs(int l) {
/* Enforce the Neumann and periodic boundary conditions (nothing to do for Dirichlet)   */
int i, m, n; 
switch (XBC) { case 2: m=g[l].ym-2; for (i=1;i<=m;++i)
           {v[l].d[0][i]=v[l].d[2][i]; v[l].d[g[l].xm-1][i]=v[l].d[g[l].xm-3][i];} break;
               case 3: m=g[l].ym-2; for (i=1;i<=m;++i)
           {v[l].d[0][i]=v[l].d[g[l].xm-2][i]; v[l].d[g[l].xm-1][i]=v[l].d[1][i];} break;}
switch (YBC) { case 2: n=g[l].xm-2; for (i=1;i<=n;++i)
           {v[l].d[i][0]=v[l].d[i][2]; v[l].d[i][g[l].ym-1]=v[l].d[i][g[l].ym-3];} break;
  case 3: n=g[l].xm-2; for (i=1;i<=n;++i) {
            v[l].d[i][0]=v[l].d[i][g[l].ym-2]; v[l].d[i][g[l].ym-1]=v[l].d[i][1];} break;}
} /**************************************************************************************/
double MaxDefect(int l) {
double e = 0.0; int i,j;
for (i=1; i<=g[l].nx-1; ++i) for (j=1; j<=g[l].ny-1; ++j) 
   e = max(e, fabs( d[l].d[i][j] - v[l].d[i][j] + 
      ( v[l].d[i][j+1]+v[l].d[i][j-1]+v[l].d[i+1][j]+v[l].d[i-1][j] )*0.25));
return (e);
}
