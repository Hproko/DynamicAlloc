all:
	as alocador.s -o alocador.o
	gcc pgma.c alocador.o -o teste -no-pie -g
clean:
	rm *.o
	rm teste