#include<stdio.h>

/* An implementation of factorial in C using implicit
   references.  Please compare this with the function
   !/implicit-var written in Scheme.
*/

int f(int n) {
  
  int m = n;
  int a = 1;

 loop:

  if (m == 0)
    return a;
  
  a = a*m;
  m = m-1;
  goto loop;
}

int main() {
  printf("!(0) == %d\n", f(0));
  printf("!(1) == %d\n", f(1));
  printf("!(2) == %d\n", f(2));
  printf("!(3) == %d\n", f(3));
}





