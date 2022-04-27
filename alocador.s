.section .data
	topoHeap: .quad 0
	inicioHeap: .quad 0
	topoBrk: .quad 0
	atual: .quad 0
	livre: .quad 0
	percorreHeap: 	.quad 0
	tamHeader: 		.quad 8
	alocado: .quad 1
	quatrok: .quad 4096
	numBytes: .quad 0
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
	str14: .string "entrou em if(inicioHeap == topoHeap) - 14\n"
	str15: .string "entrou em percorre = atual - 15\n"
	str16: .string "entrou em else - 16\n"
	str17: .string "entrou em percorre = (atual + *(atual + 8) + 16) - 17\n"
	str18: .string "entrou em if(percorre == topoHeap) - 18\n"
	str19: .string "entrou em percorre = inicioHeap - 19\n"
	str20: .string "entrou em if(inicioHeap != topoHeap) - 20\n"
	str21: .string "entrou em atual = NULL - 21\n"
	str22: .string "entrou em while(percorre != atual) - 22\n"
	str23: .string "entrou em if(*(percorre) == LIVRE && *(percorre+8) >= numBytes) - 23\n"
	str24: .string "entrou em if(*(percorre+8) >= numBytes))- 24\n"
	str25: .string "entrou em *(percorre) = OCUPADO; - 25\n"
	str26: .string "entrou em if((percorre + *(percorre + 8) + 16) != topoHeap) - 26\n"
	str27: .string "entrou em percorre += *(percorre + 8) + 16; - 27\n"
	str28: .string "entrou em atual = aux; - 28\n"
	str29: .string "entrou em percorre = inicioHeap; - 29\n"
	str30: .string "entrou em while(topoBrk <= topoHeap + 16 + numBytes) - 30\n"
	str31: .string "entrou em topoBrk += 4096; - 31\n"
	str32: .string "entrou em *(topoHeap) = 1; - 32\n"



	inteiro:		.string "%ld \n"
	quebraLinha:	.string "\n"

.section .text
.globl iniciaAlocador, finalizaAlocador, alocaMem, imprimeMapa

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

	#movq atual, %rsi
	#movq $str, %rdi
	#call printf

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
	#  %rax ---> aux
	#  %rbx ---> atual
	pushq %rbp
	movq %rsp, %rbp
	subq $16, %rsp            # 2 var. local

	movq %rdi, numBytes            # rcx   <- numBytes
	#movq numBytes, %rsi            # printf
 	#movq $str8, %rdi
 	#call printf

	movq atual, %rbx          # rbx   <- atual
	movq %rbp, %rax            
	subq $8, %rax             # rax  <- -8(rbp) = aux
	movq %rbx, (%rax)         # *aux <- atual

 	# funcionando
	#movq topoHeap, %rsi # printf
 	#movq $str10, %rdi
	#call printf
	# printf
	#movq $str14, %rdi
	#call printf

 	movq inicioHeap, %rdx
 	cmpq topoHeap, %rdx  #if(inicioHeap == topoHeap)

 	je atualizaPercorre
 	jmp elseComparaHeap

 	atualizaPercorre:
	 	# printf
		#movq $str15, %rdi
		#call printf
 		movq %rbx, -16(%rbp) # percorre <- atual

 		jmp ifComparaInicioETopo

 	elseComparaHeap:          # não testado	
		# printf
 		#movq $str16, %rdi
		#call printf

		movq atual, %rbx  # rbx <- atual
		movq %rbx, %r13    
		addq $8, %r13     # r13 <- atual + 8
		movq %rbx, -16(%rbp)  # percorre <- atual
		addq $16, -16(%rbp)   # percorre <- atual + 16
		movq (%r13), %r14    
		movq %r14, -16(%rbp) # percorre <- atual + 16 + *(atual + 8)

 		# printf
 		#movq $str17, %rdi
		#call printf
		# printf
		#movq $str18, %rdi
		#call printf

 		movq topoHeap, %rdx
 		cmpq %rdx, -16(%rbp)  # if(percorre == topoHeap)
 		je atualizaPercorre2
 		jmp ifComparaInicioETopo

 		atualizaPercorre2:
		 	# printf
			#movq $str19, %rdi
			#call printf

 			movq inicioHeap, %rdx
 			movq %rdx, -16(%rbp)

 			jmp ifComparaInicioETopo

 	ifComparaInicioETopo:     # if(inicioHeap != topoHeap)
		# printf
		#movq $str20, %rdi
		#call printf

 		movq inicioHeap, %r8
 		movq topoHeap, %rdx

 		cmpq %rdx, %r8		
 		jne atualizaAtual
 		jmp whilePercorreHeap

 		atualizaAtual:
		 	# printf
			#movq $str21, %rdi
			#call printf

 			movq $0, atual # atual <- NULL
			jmp whilePercorreHeap

 	whilePercorreHeap:
 		# printf
 		#movq $str22, %rdi
 		#call printf

	 	movq atual, %rbx
		movq -16(%rbp), %r12
 		cmpq %rbx, %r12    # while(percorre != atual)
 		jne verificaEspaco
 		jmp whileAloca
 		verificaEspaco:
 			# printf
 			#movq $str23, %rdi
 			#call printf

 			movq -16(%rbx), %r9 # r9 <- percorre
 			cmpq $livre, (%r9)  # if(*(percorre) == LIVRE)
 			je verificaTamanhoBloco
 			jmp verificaTopoHeap
 			verificaTamanhoBloco: # *(percorre+8) >= numBytes
 				# printf
 				#movq $str24, %rdi
 				#call printf

 				movq 8(%r9), %r10 # r10 <- percorre + 8
 				movq numBytes, %r11
 				cmpq %r11, (%r10) # *(percorre+8) >= numBytes
 				jge alocaBlocoLivre
 				jmp verificaTopoHeap
 				alocaBlocoLivre:
 					# printf
 					#movq $str25, %rdi
 					#call printf

 					movq $alocado, (%r9) # *(percorre) = OCUPADO;
					movq %r9, %rbx
					movq %rbx, atual     # atual <- percorre
					addq $16, -16(%rbp)   # percorre + 16
					jmp fim
			verificaTopoHeap:
				# printf
 				#movq $str26, %rdi
 				#call printf

				movq -16(%rbp), %r11      # r11 <- percorre
				movq %r11, %r12
				addq $8, %r12            # percorre + 8
				movq (%r12), %r13        # *(percorre + 8)
				addq $16, %r11           # percorre + 16
				addq %r13, %r11          # r11 <- (percorre + *(percorre + 8) + 16)
				cmpq topoHeap, %r11      # if((percorre + *(percorre + 8) + 16) != topoHeap)
				jne atualizaPercorre3
				jmp elseVerificaTopoHeap
				atualizaPercorre3:
					# printf
 					#movq $str27, %rdi
 					#call printf

					movq -16(%rbp), %r11      # r11 <- percorre
					movq %r11, %r12
					addq $8, %r12            # percorre + 8
					addq $16, %r11           # percorre + 16
					movq (%r12), %r13       # *(percorre + 8)
					addq %r13, -16(%rbp)
					addq %r11, -16(%rbp)     # percorre += *(percorre + 8) + 16;
					jmp atualizaAtual2
				atualizaAtual2:              # atual = aux;
					# printf
 					#movq $str28, %rdi
 					#call printf

					movq -8(%rbp), %r14
					movq %r14, atual
					jmp whileAloca
				elseVerificaTopoHeap:       # percorre = inicioHeap;
					# printf
 					#movq $str29, %rdi
 					#call printf

					movq topoHeap, %r10
					movq %r10, -16(%rbp)
					jmp atualizaAtual
		
		whileAloca:
			# printf
 			#movq $str30, %rdi
 			#call printf

			movq topoHeap, %r15
			addq $16, %r15
 			addq numBytes, %r15                # topoHeap + 16 + numBytes
			cmpq %r15, topoBrk
			jle atualizaBrk
			jmp retornaPonteiro
			atualizaBrk:
				# printf
 				#movq $str31, %rdi
 				#call printf

				addq $quatrok, %r8
				movq %r8, topoBrk         # topoBrk += 4096;
				movq topoBrk, %rdi
				movq $12, %rax
				syscall                   # realiza syscall para aumentar o topo de brk

		retornaPonteiro:
			# printf
 			#movq $str32, %rdi
 			#call printf

			movq topoHeap, %r9
			movq $1, (%r9)                # *(topoHeap) = 1;
			addq $8, %r9                  # topoHeap + 8

			#movq $str9, %rdi
			#call printf

			#movq numBytes, %rsi
			#movq $str8, %rdi
			#call printf

			movq numBytes, %r13
			movq %r13, (%r9)              # *(topoHeap + 8) = numBytes;

			movq %rbp, %r10
			subq $24, %r10                # r10 <- -24(rbp) = ret
			movq topoHeap, %r11
			addq $16, %r11				  # topoHeap + 16
			movq %r11, (%r10)             # *ret = topoHeap + 16
			movq topoHeap, %r12           # r12 <- topoHeap
			addq $16, %r12                # topoHeap + 16
			addq numBytes, %r12				  # topoHeap + 16 + numBytes
			movq %r12, topoHeap           # topoHeap = topoHeap + 16 + numBytes;
			jmp fim
			
	
 	fim:
		# printf
		#movq topoHeap, %rsi
		#movq $str10, %rdi
		#call printf

 		movq %r10, %rax                   # *** r10 = ret ***
		movq (%rax), %rax
 		addq $16, %rsp
		popq %rbp
		ret

imprimeMapa:
	pushq %rbp
	movq %rsp, %rbp

	movq inicioHeap, %rax
	movq topoHeap, %rcx

	cmpq %rax, %rcx				# Verifica se existe algo alocado
	je if						# Caso não tenha nada alocado, finaliza o código com o if
	jmp endif 					# Caso tenha algo alocado vai para o endif imprimir as coisas

	if:
		movq $str1, %rdi
		call printf

		popq %rbp
		ret

	endif:
		movq inicioHeap, %rax
		movq tamHeader, %rbx
		movq %rax, percorreHeap		# percorreHeap = inicioHeap;

#		# Pular o while por enquanto, e fazer para apenas um caso
		inicioMapaHeap:
			movq percorreHeap, %rax
			movq topoHeap, %rcx
			cmpq %rax, %rcx
			jle fimImprimeMapa


			movq percorreHeap, %r13		# alocadoOuDesalocado = *percorreHeap

            movq $inteiro, %rdi
            movq (%r13), %rsi
            call printf

			addq %rbx, percorreHeap
			movq percorreHeap, %r14		# tamDataHeader = (percorreHeap + tamDataHeader)

            movq $inteiro, %rdi
            movq (%r14), %rsi
            call printf

			addq %rbx, percorreHeap
	
			movq $0, %r12				# i = 0;
			inicioForCabecalho: 		# Imprime os #
				cmpq $16, %r12
				jge fimForCabecalho
	
				movq $str3, %rdi
				call printf
	
				addq $1, %r12
				jmp inicioForCabecalho
	
			fimForCabecalho:
			movq $0, %r12
			cmpq $1, (%r13)
			je inicioImprimeAlocado
			jmp inicioImprimeDesalocado
	
			inicioImprimeAlocado: 		# Imprime os +
				cmpq (%r14), %r12
				jge fimImprimes
	
				movq $str4, %rdi
				call printf
	
				addq $1, %r12
				jmp inicioImprimeAlocado
	
			inicioImprimeDesalocado: 		# imprime os -
				cmpq (%r14), %r12
				jge fimImprimes
	
				movq $str5, %rdi
				call printf
	
				addq $1, %r12
				jmp inicioImprimeDesalocado
	
			fimImprimes:
			movq $quebraLinha, %rdi
			call printf
	
			movq (%r14), %rax
			addq %rax, percorreHeap
	
			jmp inicioMapaHeap
		
		fimImprimeMapa:
		popq %rbp
		ret
