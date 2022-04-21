#include <stdio.h>
#include <unistd.h>


#define OCUPADO 1
#define LIVRE 0

long int *inicioHeap;
long int *topoHeap;
long int *topoBrk;
long int *atual;


void iniciaAlocador(){
    // printf("\n");
    inicioHeap = sbrk(0);
    // printf("Endereco inicioHeap: %p\n", inicioHeap);
    topoHeap = inicioHeap;
    topoBrk = inicioHeap;
    atual = inicioHeap;
    brk((void *) inicioHeap);
}


void *alocaMem(long int numBytes){
    
    long int *percorre;

    if( atual + *(atual + 8) + 16 > topoHeap)
        percorre = inicioHeap;
    
    else 
        if(topoBrk == inicioHeap)
            atual = NULL;
        else
            percorre = atual + *(atual + 8) + 16; 

    while(percorre != atual){
        if(*(percorre) == LIVRE && *(percorre+8) >= numBytes){
            *(percorre) = 1;
            atual = percorre;
            return (void *)percorre + 16;
        }
        
        if(percorre == topoHeap)
            percorre = inicioHeap;
        else
            percorre += *(percorre + 8) + 16;
    }

    atual = percorre;

    topoHeap = percorre + 16 + numBytes;

    int cont = 0;
    
    while(topoBrk <= topoHeap){
        cont++;
        printf("Alocou 4k %d vezes\n", cont);
        topoBrk += 4096;

        brk((void *) topoBrk);
    }

    *(percorre) = 1;
    *(percorre + 8) = numBytes;
    topoHeap = percorre + 16 + numBytes;
    printf("\nALOCADO:[%ld][%ld][DADOS]\n\n", *percorre, *(percorre + 8));
    return (void *) percorre + 16;
    

}


void finalizaAlocador(){
    // printf("Finalizando Heap: %p\n", inicioHeap);
    brk((void *) inicioHeap);
}



void liberaMem(void *bloco){
    long int *status = (long int *) (bloco - 16);
    printf("\nLIBERANDO:[%ld][%ld][DADOS]\n\n", *status, *(status + 8));
    *status = 0;
    printf("\nLIBERADO:[%ld][%ld][DADOS]\n\n", *status, *(status + 8));
    return;
}

void imprimeMapa() {
        if(topoHeap == inicioHeap) {
                printf("Não existe nada alocado\n");
                return;
    }
        long int tamHeader = sizeof(long int);
        long int*percorreHeap = inicioHeap;
        while(percorreHeap != topoHeap) {
                long int alocadoOuDesalocado = *percorreHeap;
                long int tamDataHeader  = *(percorreHeap+tamHeader);
                printf("%ld\n", tamDataHeader);

                printf("0-%p e %p\n", percorreHeap, percorreHeap);
                percorreHeap += tamHeader * 2;
                printf("1-%p e %p\n", percorreHeap, percorreHeap);

                for(long int i = 0; i < tamHeader * 2; i++) printf("#");

                if(alocadoOuDesalocado == 1)
                        for(long int i = 0; i < tamDataHeader; i++) printf("+");
                else
                        for(long int i = 0; i < tamDataHeader; i++) printf("-");
                printf("\n");

                percorreHeap += tamDataHeader;
        }
}
