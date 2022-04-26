objects = pgma.o meuAlocador.o


all: teste
	
teste: $(objects)
	gcc $(objects) -o teste
	
teste1: pgma1.o meuAlocador.o
	gcc pgma1.o meuAlocador.o -o teste1

pgma1.o: pgma1.c
	gcc -c pgma1.c

assembly: aloc.o pgma.o
	gcc aloc.o pgma.o -o testeassembly -no-pie -g

aloc.o: aloc.o meuAlocador.h
	as alocador.s -o aloc.o 

pgma.o: pgma.c
	gcc -c pgma.c

meuAlocador.o: meuAlocador.c meuAlocador.h
	gcc -c meuAlocador.c 
clean:
	rm teste teste1 testeassembly *.o
