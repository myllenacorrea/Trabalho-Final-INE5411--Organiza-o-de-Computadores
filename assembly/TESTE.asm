# Versao unificada do programa MIPS: menu + alteracao de precos + simulacao abastecimento

.data
    # Precos dos combustiveis
    preco_comum:      .word 0
    preco_aditivada:  .word 0
    preco_alcool:     .word 0
    preco_padrao:     .word 5

    # Buffers de entrada
    buffer_input:     .space 2

    # Menus e mensagens gerais
    principal:        .asciiz "\nMENU PRINCIPAL\n1 - Funcion\303\241rio\n2 - Cliente\n0 - Sair\n"
    funcionario:      .asciiz "\nMENU FUNCION\303\201RIO\nALTERA\303\207\303\203O DE PRE\303\227O\n1 - Gasolina comum\n2 - Gasolina aditivada\n3 - \303\201lcool\n0 - Voltar\n"
    cliente:          .asciiz "\nMENU CLIENTE\n1 - Gasolina comum\n2 - Gasolina aditivada\n3 - \303\201lcool\n0 - Voltar\n"
    msg_metodo:       .asciiz "\n1 - Abastecer por valor\n2 - Abastecer por litro\n"
    prompt_escolha:   .asciiz "Escolha uma op\303\247\303\243o: "
    num_invalido:     .asciiz "Op\303\247\303\243o inv\303\241lida. Tente novamente.\n"
    prompt_alteracao: .asciiz "\nEscolha o novo pre\303\247o: "
    preco_atual:      .asciiz "\nO pre\303\247o atual \303\251 "

    # Simulacao abastecimento
    prompt_modo:        .asciiz "\nEscolha o modo de abastecimento:\n1 - Por valor (R$)\n2 - Por litros\nSua escolha: \n"
    prompt_valor:       .asciiz "\nDigite o valor a ser abastecido (em R$ inteiros): "
    prompt_litros:      .asciiz "\nDigite a quantidade em litros (inteiros): "
    str_invalido:       .asciiz "\nOpcao invalida!"
    str_iniciando:      .asciiz "\nIniciando abastecimento...\n"
    str_total_abastecer:.asciiz "Total a abastecer: "
    str_L:              .asciiz " L\n"
    str_valor_total:    .asciiz "Valor total: R$ "
    str_linha:          .asciiz "\n-----------------------------------------"
    str_abastecendo:    .asciiz "\nAbastecido "
    str_L_final:        .asciiz " L..."
    str_concluido:      .asciiz "\n\n--- ABASTECIMENTO CONCLUIDO ---\n"

.text
main:
    # Inicializa precos com preco_padrao
    la $t1, preco_comum
    la $t2, preco_aditivada
    la $t3, preco_alcool
    la $t4, preco_padrao
    lw $t5, 0($t4)
    sw $t5, 0($t1)
    sw $t5, 0($t2)
    sw $t5, 0($t3)

menu_principal:
    li $v0, 4
    la $a0, principal
    syscall
    li $v0, 4
    la $a0, prompt_escolha
    syscall
    li $v0, 5
    syscall
    move $t0, $v0

    beq $t0, 1, menu_funcionario
    beq $t0, 2, menu_cliente
    beq $t0, 0, fim
    j invalido

menu_funcionario:
    li $v0, 4
    la $a0, funcionario
    syscall
    li $v0, 4
    la $a0, prompt_escolha
    syscall
    li $v0, 5
    syscall
    move $t0, $v0

    beq $t0, 1, alterar_comum
    beq $t0, 2, alterar_aditivada
    beq $t0, 3, alterar_alcool
    beq $t0, 0, menu_principal
    j invalido

alterar_comum:
    li $v0, 4
    la $a0, preco_atual
    syscall
    lw $a0, preco_comum
    li $v0, 1
    syscall
    li $v0, 4
    la $a0, prompt_alteracao
    syscall
    li $v0, 5
    syscall
    sw $v0, preco_comum
    j menu_principal

alterar_aditivada:
    li $v0, 4
    la $a0, preco_atual
    syscall
    lw $a0, preco_aditivada
    li $v0, 1
    syscall
    li $v0, 4
    la $a0, prompt_alteracao
    syscall
    li $v0, 5
    syscall
    sw $v0, preco_aditivada
    j menu_principal

alterar_alcool:
    li $v0, 4
    la $a0, preco_atual
    syscall
    lw $a0, preco_alcool
    li $v0, 1
    syscall
    li $v0, 4
    la $a0, prompt_alteracao
    syscall
    li $v0, 5
    syscall
    sw $v0, preco_alcool
    j menu_principal

menu_cliente:
    li $v0, 4
    la $a0, cliente
    syscall
    li $v0, 4
    la $a0, prompt_escolha
    syscall
    li $v0, 5
    syscall
    move $t0, $v0
    beq $t0, 0, menu_principal
    beq $t0, 1, cliente_comum
    beq $t0, 2, cliente_aditivada
    beq $t0, 3, cliente_alcool
    j invalido

cliente_comum:
    lw $s0, preco_comum
    j escolher_modo
cliente_aditivada:
    lw $s0, preco_aditivada
    j escolher_modo
cliente_alcool:
    lw $s0, preco_alcool

escolher_modo:
    li $v0, 4
    la $a0, msg_metodo
    syscall
    li $v0, 4
    la $a0, prompt_escolha
    syscall
    li $v0, 5
    syscall
    move $t6, $v0
    beq $t6, 1, por_valor
    beq $t6, 2, por_litros
    j invalido

por_valor:
    li $v0, 4
    la $a0, prompt_valor
    syscall
    li $v0, 5
    syscall
    move $s2, $v0
    div $s1, $s2, $s0
    j simular

por_litros:
    li $v0, 4
    la $a0, prompt_litros
    syscall
    li $v0, 5
    syscall
    move $s1, $v0
    mul $s2, $s1, $s0

simular:
    li $v0, 4
    la $a0, str_iniciando
    syscall
    li $v0, 4
    la $a0, str_total_abastecer
    syscall
    li $v0, 1
    move $a0, $s1
    syscall
    li $v0, 4
    la $a0, str_L
    syscall
    li $v0, 4
    la $a0, str_valor_total
    syscall
    li $v0, 1
    move $a0, $s2
    syscall
    li $v0, 4
    la $a0, str_linha
    syscall

    li $t0, 1
loop:
    bgt $t0, $s1, fim_simulacao
    li $v0, 32
    li $a0, 1000
    syscall
    li $v0, 4
    la $a0, str_abastecendo
    syscall
    li $v0, 1
    move $a0, $t0
    syscall
    li $v0, 4
    la $a0, str_L_final
    syscall
    addi $t0, $t0, 1
    j loop

fim_simulacao:
    li $v0, 4
    la $a0, str_concluido
    syscall
    j menu_principal

invalido:
    li $v0, 4
    la $a0, num_invalido
    syscall
    j menu_principal

fim:
    li $v0, 10
    syscall






