objects = pgma.o meuAlocador.o


all: teste
	
teste: $(objects)
	gcc $(objects) -o teste

pgma.o: pgma.c
	gcc -c pgma.c

meuAlocador.o: meuAlocador.c meuAlocador.h
	gcc -c meuAlocador.c 
clean:
	rm teste *.o
