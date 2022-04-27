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
	str13: .string "entrou no if 2\n"
	str14: .string "entrou em if(inicioHeap == topoHeap)\n"
	str15: .string "entrou em percorre = atual\n"
	str16: .string "entrou em else\n"
	str17: .string "entrou em percorre = (atual + *(atual + 8) + 16)\n"
	str18: .string "entrou em if(percorre == topoHeap)\n"
	str19: .string "entrou em percorre = inicioHeap\n"
	str20: .string "entrou em if(inicioHeap != topoHeap)\n"
	str21: .string "entrou em atual = NULL;\n"


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
	# -16(%rbp) ---> percorre
	#  -8(%rbp) ---> aux
	#  %rcx ---> numBytes
	#  %rax ---> aux
	#  %rbx ---> atual
	pushq %rbp
	movq %rsp, %rbp
	subq $16, %rsp            # 2 var. local

	movq %rdi, %r8            # rcx   <- numBytes
	movq %r8, %rsi            # printf
 	movq $str8, %rdi
 	call printf

	movq atual, %rbx          # rbx   <- atual
	movq %rbp, %rax            
	subq $8, %rax             # rax  <- -8(rbp) = aux
	movq %rbx, (%rax)         # *aux <- atual

 	# funcionando
	movq topoHeap, %rsi # printf
 	movq $str10, %rdi
	call printf

 	movq inicioHeap, %rdx
 	cmpq topoHeap, %rdx  #if(inicioHeap == topoHeap)

 	movq $str14, %rdi
	call printf

 	je atualizaPercorre
 	jmp elseComparaHeap

 	atualizaPercorre:
 		movq %rbx, -16(%rbp) # percorre <- atual

 		movq $str15, %rdi
		call printf

 		jmp ifComparaInicioETopo

 	elseComparaHeap:          # não testado	

 		movq $str16, %rdi
		call printf

		movq atual, %rbx
		movq 8(%rbx), %r13     # r13 <- atual + 8
		#movq (%rdx), %rcx  
 		#movq 16(%r13), %r13        # atual + 16
 		#movq 8(%rbx), %rdx    # rdx <- *(atual + 8)
 		#addq %r13, %rdx       # rdx <- *(atual + 8) + atual + 16
 		#movq %rdx, -16(%rbp)  # percorre <- rdx

 		movq $str17, %rdi
		call printf

 		movq topoHeap, %rdx
 		cmpq %rdx, -16(%rbp)  # if(percorre == topoHeap)
 		je atualizaPercorre2
 		jmp ifComparaInicioETopo

 		atualizaPercorre2:
 			movq inicioHeap, %rdx
 			movq %rdx, -16(%rbp)
 			jmp ifComparaInicioETopo

 	ifComparaInicioETopo:     # if(inicioHeap != topoHeap)
 		movq inicioHeap, %r8
 		movq topoHeap, %rdx
 		cmpq %rdx, %r8
 		#jne atualizaAtual
 		#jmp fim

 		#atualizaAtual:
 		#	movq $0, atual # atual <- NULL
 			#jmp whilePercorreHeap


 	movq $str3, %rdi
 	call printf

 	movq $0, %rbx
 	movq $1, %r12
 	whilePercorreHeap:
 		movq $str3, %rdi
 		call printf


 		cmpq %rbx, %r12    #while(percorre != atual)
 		jne verificaEspaco
 		#jmp whileAloca
 		verificaEspaco:
 			movq -16(%rbx), %r9 # r9 <- percorre
 			cmpq $livre, (%r9)  # if(*(percorre) == LIVRE
 			je verificaTamanhoBloco
 			#jmp verificaTopoHeap
 			verificaTamanhoBloco:
 				movq 8(%r9), %r10 # r10 <- percorre + 8
 				cmpq %rcx, (%r10) # *(percorre+8) >= numBytes
 				jge alocaBlocoLivre
 				#jmp verificaTopoHeap
 				alocaBlocoLivre:
 					movq $alocado, (%r9) # *(percorre) = OCUPADO;
 					
















 		
 	fim:
 		movq -8(%rbp), %rax
		#movq (%rax), %rax
 		addq $16, %rsp
		popq %rbp
		ret

