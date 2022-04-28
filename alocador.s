.section .data
	topoHeap: .quad 0
	inicioHeap: .quad 0
	topoBrk: .quad 0
	aux: .quad 0
	atual: .quad 0
	livre: .quad 0
	percorre: .quad 0 
	percorreHeap: 	.quad 0
	tamHeader: 		.quad 8
	alocado: .quad 1
	quatrok: .quad 4096
	numBytes: .quad 0
	addrRecebido: .quad 0
	str: .string "Inicio Heap: %p\n"
	strFree: .string "End. liberado: %p\n"
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
	str33: .string "Iniciando a heap\n"


	inteiro:		.string "%ld \n"
	quebraLinha:	.string "\n"

.section .text
.globl iniciaAlocador, finalizaAlocador, alocaMem, imprimeMapa, liberaMem, blockMerge

iniciaAlocador:
	pushq %rbp
	movq %rsp, %rbp
	

	movq $0, %rax
	movq $str33, %rdi
	call printf

	movq $12, %rax            # Syscall para retornar o endereço de brk
	movq $0, %rdi
	syscall


	movq %rax, inicioHeap
	movq %rax, topoHeap
	movq %rax, topoBrk
	movq %rax, atual

	popq %rbp
	ret

finalizaAlocador:
	pushq %rbp
	movq %rsp, %rbp
	
	movq inicioHeap, %rax
	movq %rax, topoHeap
	movq %rax, topoBrk
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
	# 	16(%rbp) --> numBytes
	pushq %rbp
	movq %rsp, %rbp            

	movq %rdi, %rbx
	movq %rbx, numBytes # numBytes = %rax

	#movq topoHeap, %rsi
	#movq $str10, %rdi
	#call printf

	movq atual, %rax 
	movq %rax, aux # aux = atual

	movq inicioHeap, %r10 
	cmpq topoHeap, %r10 # if(inicioHeap == topoHeap)
	jne elseCompHeap

	movq atual, %rax
	movq %rax, percorre # percorre = atual
	jmp fimElseCompHeap


elseCompHeap:

	movq atual, %rax
	cmpq $0, (%rax) # if(*(atual) == livre)
	jne fim_1if

	addq $8, %rax
	movq numBytes, %rcx # if(*(atual+8) >= numBytes))
	cmpq %rcx, (%rax)
	jl fim_1if

	movq atual, %rax # retorna atual + 16
	movq $1, (%rax)
	addq $16, %rax
	popq %rbp
	ret

fim_1if:

	movq atual, %rax # %rax := atual 
	movq %rax, %rbx # %rbx := atual 
	addq $8, %rbx  # %rbx := atual + 8
	movq (%rbx), %rbx # %rbx := *(atual + 8)
	addq $16, %rax # %rax := atual + 16
	addq %rbx, %rax # %rax:= atual + *(atual + 8) + 16
	movq %rax, percorre

	cmpq topoHeap, %rax # if(percorre == topoHeap)
	jne fimElseCompHeap

	movq inicioHeap, %rax 
	movq %rax, percorre # percorre = inicioHeap


fimElseCompHeap:

	movq inicioHeap, %rax 
	cmpq topoHeap, %rax # if (inicioHeap != topoHeap)
	je fim_2if

	movq $0, atual # atual = NULL

fim_2if:
	#movq percorre, %rsi
	#movq $str2, %rdi
	#call printf
while:

	movq percorre, %r10 
	cmpq atual, %r10  # while(percorre != atual)
	je fim_while

	movq (%r10), %rcx
	#movq %rcx, %rsi
	#movq $str1, %rdi
	#call printf

	cmpq $0, %rcx # if(*(percorre) == LIVRE)
	jne fim_ifTestaEspaco

	movq percorre, %rbx
	addq $8, %rbx
	movq numBytes, %rdx
	cmpq %rdx, (%rbx) # if(*(percorre+8) >= numBytes)
	jl fim_ifTestaEspaco


	movq $1, (%r10) # *(percorre) = OCUPADO
	movq %r10, atual # atual = percorre
	addq $16, %r10 
	movq %r10, %rax # return pecorre + 16
	popq %rbp
	ret
	
fim_ifTestaEspaco:

	movq percorre , %r10 
	movq %r10, %r12 # r12 = percorre
	addq $8, %r12 # r12 = percorre + 8
	movq (%r12), %r12 # %r12 = *(percorre+8) 
	addq $16, %r12 # %r12 = *(percorre + 8) + 16
	movq %r10, %r13
	addq %r12, %r13
	cmpq topoHeap, %r13 # if((percorre + *(percorre + 8) + 16) != topoHeap)
	je else_nextPercorre

	addq %r12, percorre # percorre += *(percorre + 8) + 16
	jmp fim_else_nextPercorre

else_nextPercorre:
	movq inicioHeap, %rbx
	movq %rbx, percorre # percorre = inicioHeap

fim_else_nextPercorre:

	movq aux, %rcx
	movq %rcx, atual

	jmp while

fim_while:

	movq topoHeap, %rax
	addq $16, %rax # %rax = topoHeap + 16
	movq numBytes, %rbx
	addq %rbx, %r10 # %rax = topoHeap + 16 + numBytes
	

	#movq %rcx, %rsi
	#movq $str2, %rdi
	#call printf
whileAloca:


	cmpq %r10, topoBrk # while(topoBrk < topoHeap + 16 + numBytes)
	jge fim_whileAloca

	#movq topoBrk, %rsi
	#movq $str2, %rdi
	#call printf
	addq $4096, topoBrk # topoBrk += 4096
	movq topoBrk, %rdi
	movq $12, %rax
	syscall
	jmp whileAloca

fim_whileAloca:

	movq topoHeap, %rax
	movq $1, (%rax) # *(topoHeap) = 1
	movq %rax, %rbx
	addq $8, %rbx 
	movq numBytes, %rcx
	movq %rcx, (%rbx) # *(topoHeap + 8) = numBytes
	mov %rax, %rdx
	addq $16, %rdx
	addq $16, %rcx
	addq %rax, %rcx
	movq %rcx, topoHeap
	movq %rdx, %rax

	#movq topoHeap, %rsi
	#movq $str10, %rdi
	#call printf

	popq %rbp
	ret



liberaMem:
	pushq %rbp
	movq %rsp, %rbp

	movq %rdi, addrRecebido

	movq addrRecebido, %rax


	#movq (%rax), %rsi
	#movq $str1, %rdi
	#call printf

	subq $16, %rax                     # addr - 16
	movq %rax, atual  					# atual <- endereco
	movq $0, (%rax)                    # (addr - 16) <- 0

	call blockMerge

	popq %rbp
	ret

blockMerge:
	pushq %rbp
	movq %rsp, %rbp
	subq $16, %rsp

	movq inicioHeap, %r8
	movq %r8, percorre
	movq percorre, %r9 # aux = percorre

	movq percorre, %r8
	cmpq topoHeap, %r8 # if(percorre == topoHeap)
	je fimBlockMerge

	movq percorre, %r10 # r10 = percorre
	movq %r10, %r12
	addq $8, %r12       # r10 = percorre + 8
	movq (%r12), %r12   # r10 = *(percorre + 8)
	addq $16, %r12      # r10 = *(percorre + 8) + 16
	movq %r10, %r13
	addq %r12, %r13
	cmpq topoHeap, %r13 # if(percorre + *(percorre + 8) + 16 == topoHeap)
	je fimBlockMerge
	jne whileBlockMerge

	whileBlockMerge:        # while(percorre != topoHeap)
		movq percorre, %r8
		cmpq topoHeap, %r8
		je fimBlockMerge

		movq (%r8), %r8 # *(percorre)
		cmpq $0, %r8    #  if(*(percorre) == LIVRE)
		jne atualizaPercorre

		movq %r9, %rax  # rax = aux
		movq %rax, %rbx
		addq $8, %rbx   # rbx = aux + 8
		movq (%rbx), %rbx # *(aux + 8)
		addq $16, %rbx    # *(aux + 8) + 16
		movq %rax, %rcx
		addq %rbx, %rcx
		cmpq percorre, %rcx # if(aux + *(aux + 8) + 16 == percorre)
		jne atualizaPercorre

		movq %r9, %rdx
		movq (%rdx), %rdx # *(aux)
		cmpq $0, %rdx       # if(*(aux) == LIVRE)
		jne atualizaPercorre

		movq percorre, %r10 # r10 = percorre
		movq %r10, %r12
		addq $8, %r12       # r12 = percorre + 8
		movq (%r12), %r12   # r12 = *(percorre + 8)
		addq $16, %r12      # r12 = *(percorre + 8) + 16
		movq %r9, %r13
		addq $8, %r13       # aux + 8
		addq %r12, (%r13)   # *(aux + 8) += *(percorre + 8) + 16;
		movq %r9, atual     # atual = aux;

		atualizaPercorre:
			movq percorre, %r9 # aux = percorre;
			movq percorre, %r10 # r10 = percorre
			movq %r10, %r12
			addq $8, %r12       # r12 = percorre + 8
			movq (%r12), %r12   # r12 = *(percorre + 8)
			addq $16, %r12      # r12 = *(percorre + 8) + 16
			addq %r12, percorre
			jmp whileBlockMerge


	fimBlockMerge:
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
		movq $str0, %rdi
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
		movq $quebraLinha, %rdi
		call printf

		movq $quebraLinha, %rdi
		call printf

		popq %rbp
		ret
