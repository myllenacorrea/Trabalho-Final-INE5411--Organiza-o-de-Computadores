.data
    # Precos dos combustiveis
    preco_comum:      .word 0
    preco_aditivada:  .word 0
    preco_alcool:     .word 0
    preco_padrao:     .word 5

    # Buffers de entrada e conversão
    buffer_input:     .space 2
    buffer_str:       .space 16

    # Menus e mensagens gerais
    principal:        .asciiz "\nMENU PRINCIPAL\n1 - Funcionario\n2 - Cliente\n0 - Sair\n"
    funcionario:      .asciiz "\nMENU FUNCIONARIO\nALTERACAO DE PRECO\n1 - Gasolina comum\n2 - Gasolina aditivada\n3 - Alcool\n0 - Voltar\n"
    cliente:          .asciiz "\nMENU CLIENTE\n1 - Gasolina comum\n2 - Gasolina aditivada\n3 - Alcool\n0 - Voltar\n"
    msg_metodo:       .asciiz "\n1 - Abastecer por valor\n2 - Abastecer por litro\n"
    prompt_escolha:   .asciiz "Escolha uma opcao: "
    num_invalido:     .asciiz "Opcao invalida. Tente novamente.\n"
    prompt_alteracao: .asciiz "\nEscolha o novo preco (em R$): "
    preco_atual:      .asciiz "\nO preço atual e R$"

    # Simulacao abastecimento
    prompt_modo:        .asciiz "\nEscolha o modo de abastecimento:\n1 - Por valor (R$)\n2 - Por litros\nSua escolha: "
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

    # Cupom fiscal
    cupom_nome:         .asciiz "meu_cupom_fiscal.txt"
    cupom_cabecalho:    .asciiz "============== CUPOM FISCAL ==============\n"
    cupom_combustivel:  .asciiz "\nTipo de Combustivel:"
    cupom_tipo_comum:   .asciiz " Gasolina Comum\n"
    cupom_tipo_aditiv:  .asciiz " Gasolina Aditivada\n"
    cupom_tipo_alcool:  .asciiz " Alcool\n"
    cupom_litros:       .asciiz "\nLitros Abastecidos (L): "
    cupom_valor:        .asciiz "Total: R$"
    cupom_rodape:       .asciiz "\n========= OBRIGADO! VOLTE SEMPRE =========\n"
    newline:            .asciiz "\n"

.text
main:
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
    li $s3, 1
    j escolher_modo

cliente_aditivada:
    lw $s0, preco_aditivada
    li $s3, 2
    j escolher_modo

cliente_alcool:
    lw $s0, preco_alcool
    li $s3, 3
    j escolher_modo

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

    li $t7, 0

loop_abastecimento:
    bge $t7, $s1, fim_simulacao
    li $v0, 32
    li $a0, 1000
    syscall
    li $v0, 4
    la $a0, str_abastecendo
    syscall
    li $v0, 1
    addi $a0, $t7, 1
    syscall
    li $v0, 4
    la $a0, str_L_final
    syscall
    addi $t7, $t7, 1
    j loop_abastecimento

fim_simulacao:
    jal gerar_cupom
    j pos_cupom

pos_cupom:
    li $v0, 4
    la $a0, str_concluido
    syscall
    j menu_principal

gerar_cupom:
    addi $sp, $sp, -4
    sw $ra, 0($sp)

    li $v0, 13
    la $a0, cupom_nome
    li $a1, 1
    li $a2, 0
    syscall
    move $s7, $v0

    li $v0, 15
    move $a0, $s7
    la $a1, cupom_cabecalho
    li $a2, 44
    syscall

    li $v0, 15
    move $a0, $s7
    la $a1, cupom_combustivel
    li $a2, 21
    syscall

    beq $s3, 1, escrever_comum
    beq $s3, 2, escrever_aditivada
    beq $s3, 3, escrever_alcool

escrever_comum:
    li $v0, 15
    move $a0, $s7
    la $a1, cupom_tipo_comum
    li $a2, 16
    syscall
    j continuar_cupom

escrever_aditivada:
    li $v0, 15
    move $a0, $s7
    la $a1, cupom_tipo_aditiv
    li $a2, 19
    syscall
    j continuar_cupom

escrever_alcool:
    li $v0, 15
    move $a0, $s7
    la $a1, cupom_tipo_alcool
    li $a2, 7
    syscall

continuar_cupom:
    li $v0, 15
    move $a0, $s7
    la $a1, cupom_litros
    li $a2, 25
    syscall

    move $a0, $s1
    la $a1, buffer_str
    jal int_to_string

    li $v0, 15
    move $a0, $s7
    la $a1, buffer_str
    move $a2, $v1
    syscall

    li $v0, 15
    move $a0, $s7
    la $a1, newline
    li $a2, 1
    syscall

    li $v0, 15
    move $a0, $s7
    la $a1, cupom_valor
    li $a2, 9
    syscall

    move $a0, $s2
    la $a1, buffer_str
    jal int_to_string

    li $v0, 15
    move $a0, $s7
    la $a1, buffer_str
    move $a2, $v1
    syscall

    li $v0, 15
    move $a0, $s7
    la $a1, newline
    li $a2, 1
    syscall

    li $v0, 15
    move $a0, $s7
    la $a1, cupom_rodape
    li $a2, 46
    syscall

    li $v0, 16
    move $a0, $s7
    syscall

    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra

int_to_string:
    move $t8, $a0
    move $t9, $a1
    li $t0, 10
    li $t1, 0

    bnez $t8, itos_loop
    li $t2, '0'
    sb $t2, 0($t9)
    li $v1, 1
    jr $ra

itos_loop:
    beqz $t8, itos_reverse
    divu $t8, $t0
    mflo $t8
    mfhi $t2
    addi $t2, $t2, '0'
    sb $t2, 0($t9)
    addi $t9, $t9, 1
    addi $t1, $t1, 1
    j itos_loop

itos_reverse:
    move $v1, $t1
    sub $t9, $t9, 1
    move $t3, $a1

reverse_loop:
    bge $t3, $t9, itos_done
    lb $t4, 0($t3)
    lb $t5, 0($t9)
    sb $t5, 0($t3)
    sb $t4, 0($t9)
    addi $t3, $t3, 1
    subi $t9, $t9, 1
    j reverse_loop

itos_done:
    jr $ra

invalido:
    li $v0, 4
    la $a0, num_invalido
    syscall
    j menu_principal

fim:
    li $v0, 10
    syscall

