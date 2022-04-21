#include "meuAlocador.h" 
#include <stdio.h>

int main(void){
  printf(" ");
  void *a, *b;
  iniciaAlocador();
  // imprimeMapa();
  a=alocaMem(240);
  // imprimeMapa();
  // b=alocaMem(50);
  // imprimeMapa();
  liberaMem(a);
  // imprimeMapa();
  a=alocaMem(50);
  // imprimeMapa();

  finalizaAlocador();

  return 0;

}
