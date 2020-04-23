	.data
	
	.align 0

#Menu
menu_inicio: .asciiz "Bem-vindo a calculadora!"
menu_borda: .asciiz "\n-------------------------\n"
menu_selecao: .asciiz "Selecione a operação desejada\n"
menu_operacoes: .asciiz "1 - Soma\n2 - Subtracao\n3 - Multiplicação\n4 - Divisão\n5 - Potencia\n6 - Raiz quadrada\n7 - Tabuada\n8 - IMC\n9 - Fatorial\n10 - Fibonacci\n0 - Encerrrar"

#Entrada
entrada_primeiro: .asciiz "Digite o primeiro valor: "
entrada_segundo: .asciiz "Digite o segundo valor: "
entrada_unica: .asciiz "Digite o valor: "

#Saida
saida_resultado: .asciiz "Resultado: "

#Tabuada
operador_mult_tab: .asciiz " * "
operador_igual: .asciiz " = "

#Outros
pula_linha: .asciiz "\n"
espaco: .asciiz " "

	.text
	.globl main
	
main:
	#Imprimindo mensagem de boas-vindas
	li $v0, 4 
	la $a0, menu_inicio
	syscall
	
principal:
	#Imprimindo menu
	li $v0, 4 
	la $a0, menu_borda
	syscall
	
	li $v0, 4
	la $a0, menu_selecao
	syscall
	
	li $v0, 4
	la $a0, menu_operacoes
	syscall
	
	li $v0, 4
	la $a0, menu_borda
	syscall
	
	#Recebendo a operação
	li $v0, 5
	syscall
	
	#Chamando a operação
	beq $v0, 1, soma
	
	beq $v0, 2, subtracao
	
	beq $v0, 3, multiplicacao
	
	beq $v0, 4, divisao
	
	beq $v0, 5, potencia
	
	beq $v0, 6, raiz_quadrada
	
	beq $v0, 7, tabuada
	
	beq $v0, 8, imc
	
	beq $v0, 9, fatorial

	beq $v0, 10, fibonacci
	
#Se $v0 não for igual a nenhum dos valores, a aplicação será encerrada	
encerrar:
	li $v0, 10
	syscall
	
#-------------------------------------Soma-------------------------------------	
soma:
	# salvando registradores na pilha
	addi $sp, $sp, -4 
	sw $a0, 0($sp)
	
	jal ler_entrada_dupla
	move $t1, $v0
	move $t2, $v1
	
	add $t3, $t1, $t2
	
	li $v0, 4 # codigo para imprimir string
	la $a0, saida_resultado # imprime saida_resultado
	syscall 
	
	li $v0, 1 # codigo para imprimir inteiro
	move $a0, $t3 # inteiro a ser impresso
	syscall
	
	# desempilha registradores

	lw $a0, 0($sp)
	addi $sp, $sp, 4
	
	j principal

#-------------------------------------Subtração-------------------------------------	
subtracao:
	j principal

#-------------------------------------Multiplicação-------------------------------------	
multiplicacao:
	#Armazenando $v0 na pilha
	addi $sp, $sp, -4
	sw $v0, 0($sp)	
	
	jal ler_entrada_dupla
	move $t1, $v0
	move $t2, $v1

	#Multiplicando
	mul $t0, $t1, $t2
	
	#Imprimindo texto auxiliar
	li $v0, 4
	la $a0, saida_resultado
	syscall 
	
	#Imprimindo resultado
	li $v0, 1
	move $a0, $t0
	syscall 
	
	#Retornando o valor de $v0
	lw $v0, 0($sp)
	addi $sp, $sp, 4
			
	j principal

#-------------------------------------Divisão-------------------------------------
divisao:
	# salvando registradores na pilha
	addi $sp, $sp, -4 
	sw $a0, 0($sp)
	
	li $v0, 4 # codigo para imprimir string
	la $a0, entrada_primeiro # imprime entrada_primeiro
	syscall 
	
	li $v0, 5 # le um inteiro fornecido pelo usuario em $v0
	syscall
	
	move $t1, $v0 # transfere o valor de $v0 para $t1
	
	li $v0, 4 # codigo para imprimir string
	la $a0, entrada_segundo # imprime entrada_segundo
	syscall 
	
	li $v0, 5 # le um inteiro fornecido pelo usuario em $v0 
	syscall
	
	move $t2, $v0 # transfere o valor de $v0 para $t2
	
	div $t3, $t1, $t2
	
	li $v0, 4 # codigo para imprimir string
	la $a0, saida_resultado # imprime saida_resultado
	syscall 
	
	li $v0, 1 # codigo para imprimir inteiro
	move $a0, $t3 # inteiro a ser impresso
	syscall
	
	# desempilha registradores

	lw $a0, 0($sp)
	addi $sp, $sp, 4
	
	j principal
	
potencia:
	j principal

#-------------------------------------Raiz quadrada-------------------------------------
raiz_quadrada:
	#Armazenando $v0 na pilha
	addi $sp, $sp, -4
	sw $v0, 0($sp)	
	
	jal ler_entrada_unica
	move $t1, $v0
		
	#Calculo da raiz quadrada
	li $t2, 1 #Armazenara o resultado
	li $t0, 1 #Contador
	
loop_raiz_quadrada:
	#Se $t2 (armazenador do resultado) for igual ao valor de entrada, finaliza
	beq $t1, $t2, endloop_raiz_quadrada
	#Se $t2 (armazenador do resultado) for maior que o valor de entrada, o resultado deve ser o $t3 anterior
	bgt $t2, $t1, endloop_raiz_quadrada_ultrapassou

	#Incrementando o contador	
	addi $t0, $t0, 1
	
	#Atualizando resultado para pegar a $t3^2 
	mul $t2, $t0, $t0
	
	j loop_raiz_quadrada
	
endloop_raiz_quadrada_ultrapassou:
	addi $t0, $t0, -1
	
endloop_raiz_quadrada:
	#Imprimindo texto auxiliar
	li $v0, 4
	la $a0, saida_resultado
	syscall 
	
	#Imprimindo resultado
	li $v0, 1
	move $a0, $t0
	syscall
	 
	#Retornando o valor de $v0
	lw $v0, 0($sp)
	addi $sp, $sp, 4
		
	j principal

#-------------------------------------Tabuada-------------------------------------
tabuada:
	addi $sp, $sp, -4 
	sw $a0, 0($sp)
	
	li $v0, 4 # codigo para imprimir string
	la $a0, entrada_unica # imprime entrada_unica
	syscall 
	
	li $v0, 5 # le um inteiro fornecido pelo usuario em $v0
	syscall
	
	move $t1, $v0 # transfere o valor de $v0 para $t1
	
	li $t2, 0 # carrega valor 0 para $t2
	li $t4, 11 # carrega valor 11 para $t4	
	
loop_tabuada:
	beq $t2, $t4, fim_tabuada
	
	mul $t3, $t1, $t2
	
	# imprime valor contido em $t1 
	li $v0, 1 
	move $a0, $t1 
	syscall
	
	# imprime " * "
	li $v0, 4 
	la $a0, operador_mult_tab 
	syscall
	
	# imprime valor contido em $t2
	li $v0, 1 
	move $a0, $t2 
	syscall
	
	# imprime " = "
	li $v0, 4 
	la $a0, operador_igual 
	syscall
	
	# imprime resultado contido em $t3
	li $v0, 1
	move $a0, $t3
	syscall
	
	# pula uma linha
	li $v0, 4 
	la $a0, pula_linha 
	syscall
	
	# incrementa t2
	addi $t2, $t2, 1
	jal loop_tabuada
	
fim_tabuada:
	lw $a0, 0($sp)
	addi $sp, $sp, 4
	
	j principal

#-------------------------------------IMC-------------------------------------
imc:
	j principal
	
#-------------------------------------Fatorial-------------------------------------
fatorial:
	#Armazenando $v0 na pilha
	addi $sp, $sp, -4
	sw $v0, 0($sp)	
	
	jal ler_entrada_unica
	move $t1, $v0
	
	#Será o acumulador do resultado
	addi $t0, $zero, 1
	#Usado como caso de parada
	addi $t2, $zero, 1

loop_fatorial:			
	#Se a quantidade de multiplicacoes (numero do fatorial) for menor ou igual a 1, encerra
	ble $t1, $t2, endloop_fatorial

	#Calculando o novo fatorial
	mul $t0, $t0, $t1	
	#Decrementando o contador
        addi $t1, $t1, -1	
   	j loop_fatorial
	
endloop_fatorial:
	#Imprimindo texto auxiliar
	li $v0, 4
	la $a0, saida_resultado
	syscall 
	
	#Imprimindo resultado
	li $v0, 1
	move $a0, $t0
	syscall
	
	#Retornando o valor de $v0
	lw $v0, 0($sp)
	addi $sp, $sp, 4
	
	j principal

#-------------------------------------Fibonacci-------------------------------------
fibonacci:
	# salva registradores na pilha
	addi $sp, $sp, -4 
	sw $a0, 0($sp)
	
	li $v0, 4 # codigo para imprimir string
	la $a0, entrada_unica # imprime entrada_unica
	syscall
	
	li $v0, 5 # le um inteiro fornecido pelo usuario em $v0
	syscall
	
	move $t0, $v0 # transfere o valor de $v0 para $t0
	
	li $t1, -1 # carrega -1 para $t1
	li $t2, 0 # carrega 0 para $t2
	li $t3, 1 # carrega 1 para $t3
	
	li $v0, 1
	move $a0, $t2
	syscall
	
	li $v0, 4
	la $a0, espaco
	syscall
	
	li $v0, 1
	move $a0, $t3
	syscall
	
	jal loop_fibonacci
	
	# desempilha registradores
	lw $a0, 0($sp)
	addi $sp, $sp, 4
	j principal
	
loop_fibonacci:
	beq $t0, $t1, fim_fibonacci
	
	add $t2, $t2, $t3
	
	li $v0, 1
	move $a0, $t2
	syscall
	
	li $v0, 4
	la $a0, espaco
	syscall
	
	lw $t3, 0($t2)
	addi $t0, $t0, 1
	jal loop_fibonacci
	
fim_fibonacci:
	jr $ra

#-------------------------------------Funções de leitura-------------------------------------	

#Retorno do primeiro valor: $v0
#Retorno do segundo valor: $v1
ler_entrada_dupla:
	#Imprimindo texto da primeira entrada
	li $v0, 4
	la $a0, entrada_primeiro
	syscall 
	
	#Recebendo primeiro valor e armazenando em $t1
	li $v0, 5
	syscall
	move $t1, $v0
	
	#Imprimindo texto da segunda entrada
	li $v0, 4
	la $a0, entrada_segundo
	syscall 
	
	#Recebendo segundo valor e armazenando em $t2
	li $v0, 5
	syscall
	move $t2, $v0
	
	#Enviando como retorno do procedimento
	move $v0, $t1
	move $v1, $t2
	
	jr $ra
	
#Retorno do valor: $v0
ler_entrada_unica:
	#Imprimindo texto da primeira entrada
	li $v0, 4
	la $a0, entrada_unica
	syscall 
	
	#Recebendo o valor e armazenando em $t1
	li $v0, 5
	syscall
	move $t1, $v0
	
	#Enviando como retorno do procedimento
	move $v0, $t1
	
	jr $ra