# t0 = escolha dos menus
# t1 = preco comum
# t2 = preco aditivada
# t3 = preco alcool
# t4 = preco padrao

# t0 - a0 = tipo de combustivel (cliente)
# t6 - a1 = metodo de abastecimetno

.data
	preco_comum:      .word 0
	preco_aditivada:  .word 0
	preco_alcool:     .word 0
	preco_padrao:     .word 5

	principal:        .asciiz "\nMENU PRINCIPAL\n1 - Funcionário\n2 - Cliente\n0 - Sair\n"
	funcionario:      .asciiz "\nMENU FUNCIONÁRIO\nALTERAÇÃO DE PREÇO\n1 - Gasolina comum\n2 - Gasolina aditivada\n3 - Álcool\n0 - Voltar\n"
	cliente:          .asciiz "\nMENU CLIENTE\n1 - Gasolina comum\n2 - Gasolina aditivada\n3 - Álcool\n0 - Voltar\n"
	msg_metodo:       .asciiz "\n1 - Abastecer por valor\n2 - Abastecer por litro\n"
	
	prompt_escolha:   .asciiz "Escolha uma opção: "
	num_invalido:     .asciiz "Opção inválida. Tente novamente.\n"
	prompt_alteracao: .asciiz "\nEscolha o novo preço: "
	preco_atual:      .asciiz "\nO preço atual é "
	
.text
		la $t1, preco_comum           # preços padrão da gasolina
		la $t2, preco_aditivada
		la $t3, preco_alcool
		la $t4, preco_padrao
		
		lw $t5, 0($t4)                # t5 = valor de preco padrao
		sw $t5, 0($t1)
		sw $t5, 0($t2)
		sw $t5, 0($t3)

		
	menu_principal:
		
		li $v0, 4
		la $a0, principal
    		syscall                       # imprimir menu principal
    		
    		li $v0, 4
		la $a0, prompt_escolha
    		syscall                       # imprimir prompt p/ escolha
    		
    		li $v0, 5                     # ler inteiro 
    		syscall
    		move $t0, $v0                 # t0 = inteiro escolhido
    		
		beq $t0, 1, menu_funcionario  # pular p/ menus ou encerrar sistema
		beq $t0, 2, menu_cliente
		beq $t0, 0, fim
		bge $t0, 3, invalido          # exceções
		blt $t0, 0, invalido
		
	menu_funcionario:
		li $v0, 4
		la $a0, funcionario
    		syscall                       # imprimir menu funcionario
    		
    		li $v0, 4
		la $a0, prompt_escolha
    		syscall                       # imprimir prompt p/ escolha
    		
    		li $v0, 5                     # ler inteiro 
    		syscall
    		move $t0, $v0                 # t0 = inteiro escolhido
    		
    		beq $t0, 1, alterar_comum     # pular p/ mudar preços ou voltar p/ menu principal
		beq $t0, 2, alterar_aditivada
		beq $t0, 3, alterar_alcool
		beq $t0, 0, menu_principal
		bge $t0, 4, invalido          # exceções
		blt $t0, 0, invalido
    		
    	menu_cliente:
    		li $v0, 4
		la $a0, cliente
    		syscall                       # imprimir menu cliente
    		
    		li $v0, 4
		la $a0, prompt_escolha
    		syscall                       # imprimir prompt p/ escolha
    		
    		li $v0, 5                     # ler inteiro 
    		syscall
    		move $t0, $v0                 # t5 = tipo de combusivel
    		
    		beq $t0, 0, menu_principal    # pular p/ voltar p/ menu principal e exceções
		bge $t0, 4, invalido     
		blt $t0, 0, invalido
    		
    		li $v0, 4                     # imprimir qual o preço atual
		la $a0, preco_atual
    		syscall 
    		beq $t0, 1, mostrar_preco_comum    
		beq $t0, 2, mostrar_preco_aditivada
		beq $t0, 3, mostrar_preco_alcool
    		
    	alterar_comum:
    		li $v0, 4                     # imprimir qual o preço atual
		la $a0, preco_atual
    		syscall                       
    		lw $a0, 0($t1)
    		li $v0, 1
    		syscall
    		
    		li $v0, 4
		la $a0, prompt_alteracao
    		syscall                       # imprimir mensagem alteração
    		
		li $v0, 5                     # ler inteiro 
    		syscall
    		sw $v0, 0($t1)                # t1 recebe movo preco gasolina comum
    		
    		j menu_principal
    	
    	alterar_aditivada:
    		li $v0, 4                     # imprimir qual o preço atual
		la $a0, preco_atual
    		syscall 
    		lw $a0, 0($t2)                      
    		li $v0, 1     
		syscall
	
    		li $v0, 4
		la $a0, prompt_alteracao
    		syscall                       # imprimir mensagem alteração
    		
    		li $v0, 5                     # ler inteiro 
    		syscall
    		sw $v0, 0($t2)                # t2 recebe movo preco gasolina aditivada
    		
    		j menu_principal
    	
    	alterar_alcool:
    		li $v0, 4                     # imprimir qual o preço atual
		la $a0, preco_atual
    		syscall     
    		lw $a0, 0($t3)                      
    		li $v0, 1
		syscall
    		
    		li $v0, 4
		la $a0, prompt_alteracao
    		syscall                       # imprimir mensagem alteração
    		
    		li $v0, 5                     # ler inteiro 
    		syscall
    		sw $v0, 0($t3)                # t3 recebe movo preco alcool
    		
    		j menu_principal
    		
    	mostrar_preco_comum:
    		lw $a0, 0($t1)
    		li $v0, 1
    		syscall
    		j metodo
    	
    	mostrar_preco_aditivada:
    		lw $a0, 0($t2)
    		li $v0, 1
    		syscall
    		j metodo
    		
    	mostrar_preco_alcool:
    		lw $a0, 0($t3)
    		li $v0, 1
    		syscall
    		j metodo
    	
    	metodo:
    		li $v0, 4
    		la $a0, msg_metodo
    		syscall
    		
    		li $v0, 4
		la $a0, prompt_escolha
    		syscall                       # imprimir prompt p/ escolha
    		
    		li $v0, 5
    		syscall
    		move $t6, $v0                 # t6 = metodo escolhido
    		
    		blt $t1, 1, invalido
    		bge $t1, 3, invalido
    		
    		#################################################################
    		# move $a0, $t0      # tipo                                     #
    		# move $a1, $t6     # metodo                                    #
    		# j abastecer                                                   #
    		#################################################################
    		
    		
    	invalido: 
    		li $v0, 4
		la $a0, num_invalido
    		syscall                       # imprimir mensagem invalida
    		
    		j menu_principal              # voltar p/ menu principsl
    		
    	fim: 
    		li $v0, 10
    		syscall                       # encerra programa
