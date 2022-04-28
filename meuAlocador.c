#include <stdio.h>
#include <unistd.h>


#define OCUPADO 1
#define LIVRE 0

long int *inicioHeap;
long int *topoHeap;
long int *topoBrk;
long int *atual;


void iniciaAlocador(){
    printf("Iniciando Heap!\n");
    inicioHeap = sbrk(0);
    // printf("Endereco inicioHeap: %p\n", inicioHeap);
    topoHeap = inicioHeap;
    topoBrk = inicioHeap;
    atual = inicioHeap;
    brk((void *) inicioHeap);
}


void *alocaMem(long int numBytes){
    
    long int *percorre, *aux = atual;

    // printf("atual %p\n", atual);


    if(inicioHeap == topoHeap) //Se a heap estiver vazia percorre = atual e nao entre no loop
        percorre = atual;
    else{

        if(*(atual) == LIVRE && *(atual+8) >= numBytes){
            *(atual) = OCUPADO;
            return (void *)(atual + 16);
        }

        percorre = (atual + *(atual + 8) + 16); //percorre aponta para o proximo nodo de atual
        
        if(percorre == topoHeap)
            percorre = inicioHeap;
        }
    
    if(inicioHeap != topoHeap)
        atual = NULL;
    
    while(percorre != atual){
        
            // printf("percorre %p\n", percorre);
        if(*(percorre) == LIVRE && *(percorre+8) >= numBytes){
            *(percorre) = OCUPADO;
            atual = percorre;
            return (void *)(percorre + 16);
        }
        
        if((percorre + *(percorre + 8) + 16) != topoHeap)
            percorre += *(percorre + 8) + 16;
        else
            percorre = inicioHeap;
        
        atual = aux; //restaura o valor de atual
    
    }
    
    while(topoBrk <= topoHeap + 16 + numBytes){
        topoBrk += 4096;
        brk((void *) topoBrk);
    }


    *(topoHeap) = 1;
    *(topoHeap + 8) = numBytes;
    long int *ret = topoHeap + 16;
    topoHeap = topoHeap + 16 + numBytes;
    // printf("\nALOCADO:[%ld][%ld][DADOS]\n\n", *percorre, *(percorre + 8));
    return (void *) ret;
    

}

void blockMerge(){

    long int *percorre = inicioHeap;
    long int *aux = percorre;
    
    //Testa se tem 0 ou 1 nodo na heap
    if(percorre == topoHeap || percorre + *(percorre + 8) + 16 == topoHeap)
        return;


    while(percorre != topoHeap){

        if(*(percorre) == LIVRE && aux + *(aux + 8) + 16 == percorre && *(aux) == LIVRE){
            *(aux + 8) += *(percorre + 8) + 16;
            atual = aux;
        }

        aux = percorre;
        percorre += *(percorre + 8) + 16;
    } 
}


void finalizaAlocador(){
    // printf("Finalizando Heap: %p\n", inicioHeap);
    brk((void *) inicioHeap);
}



void liberaMem(void *bloco){
    long int *status = (long int *)bloco - 16;
    // printf("\nLIBERANDO:[%ld][%ld][DADOS]\n\n", *status, *(status + 8));
    *status = 0;
    blockMerge();
    // printf("\nLIBERADO:[%ld][%ld][DADOS]\n\n", *status, *(status + 8));
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
                // printf("%ld\n", tamDataHeader);

                printf("%p\n", percorreHeap);
                percorreHeap += tamHeader * 2;
                // printf("1-%p e %p\n", percorreHeap, percorreHeap);

                for(long int i = 0; i < tamHeader * 2; i++) printf("#");

                if(alocadoOuDesalocado == 1)
                        for(long int i = 0; i < tamDataHeader; i++) printf("+");
                else
                        for(long int i = 0; i < tamDataHeader; i++) printf("-");
                printf("\n");

                percorreHeap += tamDataHeader;
        }

        printf("\n\n");
}
