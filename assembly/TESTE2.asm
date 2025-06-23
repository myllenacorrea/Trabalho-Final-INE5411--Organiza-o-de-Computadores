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
    cupom_nome:       .asciiz "cupom_fiscalNOVO.txt"
    cupom_cabecalho:   .asciiz "=== CUPOM FISCAL ===\n"
    cupom_combustivel: .asciiz "\nCombustivel: "
    cupom_tipo_comum:  .asciiz "Gasolina Comum\n"
    cupom_tipo_aditiv: .asciiz "Gasolina Aditivada\n"
    cupom_tipo_alcool: .asciiz "Alcool\n"
    cupom_litros:      .asciiz "Litros abastecidos: "
    cupom_valor:       .asciiz "Valor total: R$"
    cupom_rodape:      .asciiz "\n=== OBRIGADO VOLTE SEMPRE ===\n"
    newline:           .asciiz "\n"

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
    li $s3, 1       # Salvar tipo de combust�vel (1 = comum)
    j escolher_modo
    
cliente_aditivada:
    lw $s0, preco_aditivada
    li $s3, 2       # Salvar tipo de combust�vel (2 = aditivada)
    j escolher_modo
    
cliente_alcool:
    lw $s0, preco_alcool
    li $s3, 3       # Salvar tipo de combust�vel (3 = �lcool)
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

    li $t7, 0          # Contador iniciado em 0
    
loop_abastecimento:
    bge $t7, $s1, fim_simulacao
    
    # Pausa de 1 segundo
    li $v0, 32
    li $a0, 1000
    syscall
    
    # Mostrar progresso
    li $v0, 4
    la $a0, str_abastecendo
    syscall
    
    li $v0, 1
    addi $a0, $t7, 1    # Mostrar litro atual (contador+1)
    syscall
    
    li $v0, 4
    la $a0, str_L_final
    syscall
    
    addi $t7, $t7, 1    # Incrementar contador
    j loop_abastecimento

fim_simulacao:
    jal gerar_cupom
    
    li $v0, 4
    la $a0, str_concluido
    syscall
    j menu_principal

gerar_cupom:
    # Abrir arquivo para escrita
    li $v0, 13
    la $a0, cupom_nome
    li $a1, 1
    li $a2, 0
    syscall
    move $s7, $v0
    
    # Escrever cabe�alho
    li $v0, 15
    move $a0, $s7
    la $a1, cupom_cabecalho
    li $a2, 18
    syscall
    
    # Escrever tipo de combust�vel
    li $v0, 15
    move $a0, $s7
    la $a1, cupom_combustivel
    li $a2, 13
    syscall
    
    # Determinar qual tipo de combust�vel foi usado
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
    # Escrever litros
    li $v0, 15
    move $a0, $s7
    la $a1, cupom_litros
    li $a2, 19
    syscall
    
    # Converter litros para string e escrever
    addi $sp, $sp, -16
    move $a0, $s1
    move $a1, $sp
    jal int_to_string
    
    li $v0, 15
    move $a0, $s7
    move $a1, $sp
    move $a2, $v1
    syscall
    
    # Nova linha
    li $v0, 15
    move $a0, $s7
    la $a1, newline
    li $a2, 1
    syscall
    
    # Escrever valor
    li $v0, 15
    move $a0, $s7
    la $a1, cupom_valor
    li $a2, 14
    syscall
    
    # Converter valor para string e escrever
    move $a0, $s2
    move $a1, $sp
    jal int_to_string
    
    li $v0, 15
    move $a0, $s7
    move $a1, $sp
    move $a2, $v1
    syscall
    
    # Nova linha
    li $v0, 15
    move $a0, $s7
    la $a1, newline
    li $a2, 1
    syscall
    
    # Escrever rodap�
    li $v0, 15
    move $a0, $s7
    la $a1, cupom_rodape
    li $a2, 29
    syscall
    
    # Fechar arquivo
    li $v0, 16
    move $a0, $s7
    syscall
    
    addi $sp, $sp, 16
    jr $ra

int_to_string:
    move $t8, $a0
    move $t9, $a1
    li $t0, 10
    li $t1, 0
    
    # Caso especial para zero
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