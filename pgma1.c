#include "meuAlocador.h" 

int main() {
  void *a, *b, *c, *d;
  iniciaAlocador();
  imprimeMapa();
  a=alocaMem(240);
  imprimeMapa();
  b=alocaMem(50);
  imprimeMapa();
  liberaMem(a);
  imprimeMapa();
  a=alocaMem(50);
  imprimeMapa();
  c=alocaMem(50);
  imprimeMapa();
  liberaMem(b);
  d=alocaMem(100);
  imprimeMapa();
  liberaMem(d);
  b=alocaMem(50);
  imprimeMapa();
  liberaMem(c);
  imprimeMapa();
  liberaMem(b);
  liberaMem(a);
  imprimeMapa();
  alocaMem(100);
  imprimeMapa();

  finalizaAlocador();

}
