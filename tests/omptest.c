# include <stdlib.h>
# include <stdio.h>
# include <string.h>
# include <omp.h>

int main ( int argc, char *argv[] );
void r8_test ( int r8_logn_max );
double r8_abs ( double r8 );
double r8_pi_est_omp ( int n );
double r8_pi_est_seq ( int n );
double r8_pi ( void );
 
/******************************************************************************/
 
int main ( int argc, char *argv[] ) {
  int r8_logn_max = 10;
 
  printf ( "\n" );
  printf ( "COMPUTE_PI\n" );
  printf ( "  C/OpenMP version\n" );
  printf ( "\n" );
  printf ( "  Estimate the value of PI by summing a series.\n" );
 
  printf ( "\n" );
  printf ( "  Number of processors available = %d\n", omp_get_num_procs ( ) );
  printf ( "  Number of threads =              %d\n", omp_get_max_threads ( ) );
 
  r8_test ( r8_logn_max );
 
  printf ( "\n" );
  printf ( "COMPUTE_PI\n" );
  printf ( "  Normal end of execution.\n" );
 
  return 0;
}
/******************************************************************************/
 
void r8_test ( int logn_max )
{
  double error;
  double estimate;
  int logn;
  char mode[4];
  int n;
  double r8_pi = 3.141592653589793;
  double wtime;
 
  printf ( "\n" );
  printf ( "R8_TEST:\n" );
  printf ( "  Estimate the value of PI,\n" );
  printf ( "  using double arithmetic.\n" );
  printf ( "\n" );
  printf ( "  N = number of terms computed and added;\n" );
  printf ( "\n" );
  printf ( "  MODE = SEQ for sequential code;\n" );
  printf ( "  MODE = OMP for Open MP enabled code;\n" );
  printf ( "  (performance depends on whether Open MP is used,\n" );
  printf ( "  and how many processes are available)\n" );
  printf ( "\n" );
  printf ( "  ESTIMATE = the computed estimate of PI;\n" );
  printf ( "\n" );
  printf ( "  ERROR = ( the computed estimate - PI );\n" );
  printf ( "\n" );
  printf ( "  TIME = elapsed wall clock time;\n" );
  printf ( "\n" );
  printf ( "  Note that you can''t increase N forever, because:\n" );
  printf ( "  A) ROUNDOFF starts to be a problem, and\n" );
  printf ( "  B) maximum integer size is a problem.\n" );
  printf ( "\n" );
  printf ( "             N Mode    Estimate        Error           Time\n" );
  printf ( "\n" );
 
  n = 1;
 
  for ( logn = 1; logn <= logn_max; logn++ )
  {
 
  strcpy ( mode, "SEQ" );
 
    wtime = omp_get_wtime ( );
 
    estimate = r8_pi_est_seq ( n );
 
    wtime = omp_get_wtime ( ) - wtime;
 
    error = r8_abs ( estimate - r8_pi );
 
    printf ( "%14d  %s  %14f  %14g  %14f\n", n, mode, estimate, error, wtime );
/*
 Open MP enabled calculation.
*/
    strcpy ( mode, "OMP" );
 
    wtime = omp_get_wtime ( );
 
    estimate = r8_pi_est_omp ( n );
 
    wtime = omp_get_wtime ( ) - wtime;
 
    error = r8_abs ( estimate - r8_pi );
 
    printf ( "%14d  %s  %14f  %14g  %14f\n", n, mode, estimate, error, wtime );
 
    n = n * 10;
  }
 
  return;
}
/******************************************************************************/
 
double r8_abs ( double r8 )
{
  double value;
 
  if ( 0.0 <= r8 )
  {
    value = r8;
  }
  else
  {
    value = - r8;
  }
  return value;
}
/******************************************************************************/
 
double r8_pi_est_omp ( int n )
{
  double h;
  double estimate;
  int i;
  double sum2;
  double x;
 
  h = 1.0 / ( double ) ( 2 * n );
 
  sum2 = 0.0;
# pragma omp parallel \
  shared ( h, n ) \
  private ( i, x ) \
  reduction ( +: sum2 )
# pragma omp for
  for ( i = 1; i <= n; i++ )
  {
    x = h * ( double ) ( 2 * i - 1 );
    sum2 = sum2 + 1.0 / ( 1.0 + x * x );
  }
 
  estimate = 4.0 * sum2 / ( double ) ( n );
 
  return estimate;
}
/******************************************************************************/
 
double r8_pi_est_seq ( int n )
{
  double h;
  double estimate;
  int i;
  double sum2;
  double x;
 
  h = 1.0 / ( double ) ( 2 * n );
 
  sum2 = 0.0;
 
  for ( i = 1; i <= n; i++ )
  {
    x = h * ( double ) ( 2 * i - 1 );
    sum2 = sum2 + 1.0 / ( 1.0 + x * x );
  }
 
  estimate = 4.0 * sum2 / ( double ) ( n );
 
  return estimate;
}
