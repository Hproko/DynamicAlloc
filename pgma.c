#include "meuAlocador.h" 
#include <stdio.h>

int main(void){
  printf(" ");
  void *a, *b, *c;
  iniciaAlocador();
  // imprimeMapa();
  a=alocaMem(240);
  printf("End. retornado: %p\n", a);
  imprimeMapa();
  //b=alocaMem(50);
  //imprimeMapa();
  /*liberaMem(a);
  liberaMem(b);
  imprimeMapa();
  b=alocaMem(100);
  c=alocaMem(200);
  imprimeMapa();
  liberaMem(b);
  liberaMem(c);
  imprimeMapa();*/

  finalizaAlocador();

  return 0;

}
