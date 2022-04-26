.section .data
	topoHeap: .quad 0
	inicioHeap: .quad 0
	topoBrk: .quad 0
	atual: .quad 0
	livre: .quad 0
	alocado: .quad 1
	quatrok: .quad 4096
	str: .string "Inicio Heap: %p\n"
	str0: .string "Nao existe nada alocado\n"
	str1: .string "%ld\n"
	str2: .string "%p\n"
	str3: .string "#"
	str4: .string "+"
	str5: .string "-"
	str6: .string "\n"
	str7: .string "\n\n"
	str8: .string "Valor passado para a funcao: %ld\n"
	str9: .string "entrou no if\n"
	str10: .string "Topo heap: %p\n"
	str11: .string "-8rbp: %p\n"
	str12: .string "-16rbp: %p\n"

.section .text
.globl iniciaAlocador, finalizaAlocador, alocaMem

iniciaAlocador:
	pushq %rbp
	movq %rsp, %rbp

	movq $12, %rax            # Syscall para retornar o endereço de brk
	movq $0, %rdi
	syscall

	movq %rax, inicioHeap
	movq %rax, topoHeap
	movq %rax, topoBrk
	movq %rax, atual

	movq atual, %rsi
	movq $str, %rdi
	call printf

	popq %rbp
	ret

finalizaAlocador:
	pushq %rbp
	movq %rsp, %rbp

	movq inicioHeap, %rdi      # Restaura brk
	movq $12, %rax
	syscall

	popq %rbp
	ret

alocaMem:                     # no pgma.c colocar printf("Aloca: %p\n", a);
	pushq %rbp
	movq %rsp, %rbp

	movq %rdi, %rsi
 	movq $str8, %rdi
 	call printf	
 	movq %rsi, %rcx           # rcx   <- numBytes

	subq $16, %rsp            # 2 var. local

	movq atual, %rbx          # rbx   <- atual
	movq %rbp, %rax           # 
	subq $8, %rax             # rax  <- -8(rbp) = aux
	movq %rbx, (%rax)         # *aux <- atual

	cmpq $livre, (%rax)       # if(*(atual) == LIVRE)
	je ifLivre
	jmp ifComparaHeap
 	
 	ifLivre:                  # if nao testado
 		movq $str9, %rdi
		call printf

 		movq %rax, %rdx       
 		addq $8, %rdx         # rdx <- atual + 8
 		cmpq %rcx, (%rdx)     # if(*(atual+8) >= numBytes)
 		jge cabeNoBloco
 		jmp ifComparaHeap

 		cabeNoBloco:
 			movq $0, (%rax)
 			addq $16, %rax
 			jmp fim

 	ifComparaHeap:           # funcionando
		movq topoHeap, %rsi
 		movq $str10, %rdi
		call printf

 		movq inicioHeap, %rdx
 		cmpq topoHeap, %rdx  #if(inicioHeap == topoHeap)
 		je atualizaPercorre
 		jmp fim

 		atualizaPercorre:
 			movq $str9, %rdi
			call printf

 			movq atual, %rbx
 			movq %rbp, %rdx
 			subq $16, %rdx
 			movq %rbx, (%rdx) # percorre <- atual
 			#movq -8(%rbp), %rax
 			jmp fim

 		
 	fim:
 		movq -8(%rbp), %rax
		#movq (%rax), %rax
 		addq $16, %rsp
		popq %rbp
		ret

