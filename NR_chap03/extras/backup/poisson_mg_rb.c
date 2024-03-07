#include <stdio.h>             /* A 2D Poisson solver on uniform mesh using Multigrid   */
#include <stdlib.h>            /* and Red/Black RC_Gauss-Seidel (C syntax).                */
#include <math.h>              /* By Paolo Luchini, Thomas Bewley and Anish Karandikar. */
#include <sys/types.h>
#include <time.h>
#include <unistd.h>
#define max(A,B) ( (A) > (B) ? (A) : (B) )
typedef struct {int xbc, ybc, nx, ny, xo, yo, xm, ym; } grid;
void enforce_bcs(double **v, grid g);
void RC_poisson_mg(double **v, double **d, grid g, int n2, int n3);
void RC_poisson_rb(double **v, double **d, grid g);
double max_error(double **v, double **d, grid g);

int main() {
grid g;
int i, j, smooth, s;
double **v, **d, **di, di_sum=0.0, e, o = 0.0;
time_t t0, t1;
/*-------------------------------------- USER INPUT ------------------------------------*/   
/* Take XBC and YBC = 1 for homogeneous Dirichlet (grid:  0:NX   and  0:NY  ),          */
/*                  = 2 for homogeneous Neumann   (grid: -1:NX+1 and -1:NY+1), and      */
/*                  = 3 for periodic              (grid: -1:NX   and -1:NY  ).          */
   const int XBC = 1, YBC = 1, NX = 16, NY = 16, n1=2, n2=2, n3=2;
/*----------------------------------- END OF USER INPUT --------------------------------*/
g.xbc = XBC; g.ybc = YBC; g.nx = NX; g.ny = NY; s = sizeof(double);
printf("Grid: nx = %d, ny = %d \t BCs: (%d, %d)", g.nx, g.ny, g.xbc, g.ybc);
switch(g.xbc) {case 1: g.xm=g.nx+1; g.xo=1; break; 
               case 2: g.xm=g.nx+3; g.xo=2; break;
               case 3: g.xm=g.nx+2; g.xo=2; break; }
switch(g.ybc) {case 1: g.ym=g.ny+1; g.yo=1; break; 
               case 2: g.ym=g.ny+3; g.yo=2; break;
               case 3: g.ym=g.ny+2; g.yo=2; break; }
v =malloc((g.xm+1)*s); for (i=0; i<g.xm; ++i)   v[i] =malloc((g.ym)*s);
d =malloc((g.xm+1)*s); for (i=0; i<g.xm; ++i)   d[i] =malloc((g.ym)*s);
di=malloc((g.xm-3)*s); for (i=0; i<g.xm-4; ++i) di[i]=malloc((g.ym-4)*s);
di_sum = 0.0; for(i=0; i<g.xm-4; ++i) for(j=0; j<g.ym-4;++j) {
      di[i][j] = (((double) rand())/((double) RAND_MAX)) ; di_sum += di[i][j]; }
for(i=0; i<g.xm-4; ++i) free(di[i]); free(di);
for(i=2; i<g.xm-2; ++i) for(j=2; j<=g.ym-3; ++j) 
   d[i][j] = di[i-2][j-2]-di_sum/((double)((g.xm-4)*(g.ym-4)));  
e = max_error(v,d,g);  printf("\nIteration = %d, error = %f\n", 0, e);
for (smooth=1; smooth<=20; ++smooth) RC_poisson_rb(v,d,g);
e=max_error(v,d,g);
printf("After initial smoothing, max defect = %f\n", e);  pause;

t0 = time(NULL); for (i=1; i<=15; ++i) {
   o = e; RC_poisson_mg(v,d,g,n2,n3); e = max_error(v,d,g);
   printf("\nIteration = %d, error = %.10f, factor = %.10f",i,e,o/e);
   if (o/e==1.0) { printf("Converged\n"); break; } } t1 = time(NULL);
printf("Total wall time = %ld sec for %d iterations  -> time/iteration: %f sec\n",
   (t1-t0), i, ((double)(t1-t0)/(double)i));
for(i = 0; i < g.xm; ++i) { free(v[i]); free(d[i]); } free(v); free(d);
} /*------------------------------------------------------------------------------------*/
void enforce_bcs(double **v, grid g) {
int i, m, n; 
switch (g.xbc) {
  case 2: m=g.ym-2; for (i=1;i<=m;++i) {v[0][i]=v[2][i];v[g.xm-1][i]=v[g.xm-3][i];} break;
  case 3: m=g.ym-2; for (i=1;i<=m;++i) {v[0][i]=v[g.xm-2][i];v[g.xm-1][i]=v[1][i];} break;}
switch (g.ybc) {
  case 2: n=g.xm-2; for (i=1;i<=n;++i) {v[i][0]=v[i][2];v[i][g.ym-1]=v[i][g.ym-3];} break;
  case 3: n=g.xm-2; for (i=1;i<=n;++i) {v[i][0]=v[i][g.ym-2];v[i][g.ym-1]=v[i][1];} break;}
} /*------------------------------------------------------------------------------------*/
void RC_poisson_mg(double **vf, double **df, grid gf, int n2, int n3) {
int smooth, i, j, ic, jc, s;
grid gc;
double **vc, **dc;
gc.nx=gf.nx/2; gc.ny=gf.ny/2; gc.xbc=gf.xbc; gc.ybc=gf.ybc;  s=sizeof(double);
switch(gc.xbc) {case 1: gc.xm=gc.nx+1; gc.xo=1; break; 
                case 2: gc.xm=gc.nx+3; gc.xo=2; break;
                case 3: gc.xm=gc.nx+2; gc.xo=2; break; }
switch(gc.ybc) {case 1: gc.ym=gc.ny+1; gc.yo=1; break; 
                case 2: gc.ym=gc.ny+3; gc.yo=2; break;
                case 3: gc.ym=gc.ny+2; gc.yo=2; break; }
for (smooth=1;smooth<=n2;++smooth) RC_poisson_rb(vf,df,gf);
vc=malloc((gc.xm)*s); for (i=0; i<gc.xm; ++i) vc[i]=malloc((gc.ym)*s);
dc=malloc((gc.xm)*s); for (i=0; i<gc.xm; ++i) dc[i]=malloc((gc.ym)*s);
for(i=0; i<gc.xm; ++i) for(j=0; j<gc.ym;++j) { vc[i][j]=0.0; dc[i][j]=0.0; }
for (ic=1;ic<=gc.xm-2;++ic) for (jc=1;jc<=gc.ym-2;++jc) {   /* Compute residual and     */
   i=2*(ic-gc.xo)+gf.xo+1; j=2*(jc-gc.yo)+gf.yo+1;          /* restrict to coarser grid */
   dc[ic][jc]=(vf[i][j+1]+vf[i][j-1]+vf[i+1][j]+vf[i-1][j])*0.25-vf[i][j]+df[i][j];
   vc[ic][jc]=dc[ic][jc];  }
enforce_bcs(vc, gc);                                     
if (gc.nx>3 && gc.ny>3 && (gf.nx % 4)==0 && (gf.ny % 4)==0)    /* Continue to even      */
   RC_poisson_mg(vc,dc,gc,n2,n3);                                 /* coarser grid, or      */
else for (smooth=1;smooth<=20;++smooth) RC_poisson_rb(vc,dc,gc);  /* solve coarsest system */
for (ic=1;ic<=gc.xm-1;++ic) for (jc=1;jc<=gc.ym-1;++jc) {     
   i=2*(ic-gc.xo)+gf.xo+1; j=2*(jc-gc.yo)+gf.yo+1;
   if (j<=gf.ym-1) vf[i-1][j]=vf[i-1][j]+(vc[ic-1][jc]+vc[ic][jc]);     /* Prolongation */
   if (i<=gf.xm-1) vf[i][j-1]=vf[i][j-1]+(vc[ic][jc-1]+vc[ic][jc]); }   /* to fine grid */
enforce_bcs(vf,gf);
for (smooth=1;smooth<=n3;++smooth) RC_poisson_rb(vf,df,gf);
for (i=0; i<gc.xm; ++i) { free(vc[i]); free(dc[i]); }  free(vc); free(dc);
} /*------------------------------------------------------------------------------------*/
void RC_poisson_rb(double **v, double **d, grid g) {
int rb, i, j, m, n;                       /* update red points first, then black points */
for (rb=0; rb<=1; ++rb) { for (i=1; i<=g.xm-2; ++i) { 
   m = 1+(1+i+rb+g.xo+g.yo) % 2; n=g.ym-2;  /* In C, inner loop should be on LAST index */
   for (j=m; j<=n; j+=2) v[i][j]=(v[i][j+1]+v[i][j-1]+v[i+1][j]+v[i-1][j])*0.25+d[i][j]; 
   } enforce_bcs(v,g); }
} /*------------------------------------------------------------------------------------*/
double max_error(double **v, double **d, grid g) {
double e = 0.0;
int i,j;
for (i=1; i<=g.nx-1; ++i) for (j=1; j<=g.ny-1; ++j)  
    e = max(e, fabs((v[i][j+1]+v[i][j-1]+v[i+1][j]+v[i-1][j] )*0.25+d[i][j]-v[i][j] ));
return (e);
}
