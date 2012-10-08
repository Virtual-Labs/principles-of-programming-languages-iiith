#include<stdio.h>
#include<stdlib.h>

/* An implementation of factorial in C using explicit
   references.  Please compare this with the program
   !/explicit-var written in the Explicit References
   language whose interpreter was done in class.

   Note that m and a are identifiers of type REF.  They are
   not being assigned anywhere in the function f.  Rather,
   they are used only via the deref and setref primitives.
*/

typedef int *REF;

REF ref(int v) {
  REF a = (REF) malloc(sizeof(int));
  *a = v;
  return a;
};

/* could be a macro instead */
void setref(REF r, int v) {
  *r = v;
};

/* could be a macro instead */
int deref(REF r) {
  return *r;
};

int f(int n) {
  
  REF m = ref(n);   // this should be interpreted as a
  REF a = ref(1);   // binding, i.e., a LET, not assignment.

 loop:

  if (deref(m) == 0)
    return deref(a);

  setref(a,deref(a)*deref(m)); 
  setref(m,deref(m)-1); 

  goto loop;
}

int main() {
  printf("!(0) == %d\n", f(0));
  printf("!(1) == %d\n", f(1));
  printf("!(2) == %d\n", f(2));
  printf("!(3) == %d\n", f(3));
}





