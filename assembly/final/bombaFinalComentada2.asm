.data

# valores para ler cada linha
ler_linha1: .byte 1
ler_linha2: .byte 2
ler_linha3: .byte 4
ler_linha4: .byte 8
sem_led: .byte 0

# valores para acender os leds de cada numero
led_0: .byte 63
led_1: .byte 6
led_2: .byte 91
led_3: .byte 79
led_4: .byte 102
led_5: .byte 109
led_6: .byte 125
led_7: .byte 7
led_8: .byte 127
led_9: .byte 111
led_A: .byte 119
led_B: .byte 124
led_C: .byte 57
led_D: .byte 94
led_E: .byte 121
led_F: .byte 113

# Precos dos combustiveis
preco_comum:     .word 0
preco_aditivada: .word 0
preco_alcool:    .word 0
preco_padrao:    .word 5

# Buffers de entrada e conversao
buffer_input: .space 2
buffer_str:   .space 16

# Menus e mensagens gerais
principal:        .asciiz "\nMENU PRINCIPAL\n1 - Funcionario\n2 - Cliente\n0 - Sair\n"
funcionario:      .asciiz "\nMENU FUNCIONARIO\nALTERACAO DE PRECO\n1 - Gasolina comum\n2 - Gasolina aditivada\n3 - Alcool\n0 - Voltar\n"
cliente:          .asciiz "\nMENU CLIENTE\n1 - Gasolina comum\n2 - Gasolina aditivada\n3 - Alcool\n0 - Voltar\n"
msg_metodo:       .asciiz "\n1 - Abastecer por valor\n2 - Abastecer por litro\n"
prompt_escolha:   .asciiz "Escolha uma opcao: "
num_invalido:     .asciiz "Opcao invalida. Tente novamente.\n"
prompt_alteracao: .asciiz "\nEscolha o novo preco (em R$): "
preco_atual:      .asciiz "\nO preco atual e R$"

# Simulacao abastecimento
prompt_valor:          .asciiz "\nDigite o valor a ser abastecido (em R$ inteiros): "
prompt_litros:         .asciiz "\nDigite a quantidade em litros (inteiros): "
str_invalido:          .asciiz "\nOpcao invalida!"
str_iniciando:         .asciiz "\nIniciando abastecimento...\n"
str_total_abastecer:   .asciiz "Total a abastecer: "
str_L:                 .asciiz " L\n"
str_valor_total:       .asciiz "Valor total: R$ "
str_linha:             .asciiz "\n-----------------------------------------"
str_abastecendo:       .asciiz "\nAbastecido "
str_L_final:           .asciiz " L..."
str_concluido:         .asciiz "\n\n--- ABASTECIMENTO CONCLUIDO ---\n"

# Cupom fiscal (Strings corrigidas para formatação precisa)
cupom_nome:         .asciiz "meu_cupom_fiscal.txt"
cupom_cabecalho:    .asciiz "============== CUPOM FISCAL =============="
cupom_combustivel:  .asciiz "\nTipo de Combustivel:"
cupom_tipo_comum:   .asciiz " Gasolina Comum"
cupom_tipo_aditiv:  .asciiz " Gasolina Aditivada"
cupom_tipo_alcool:  .asciiz " Alcool"
cupom_litros:       .asciiz "\nLitros Abastecidos (L): "
cupom_valor:        .asciiz "Total: R$"
cupom_rodape:       .asciiz "========= OBRIGADO! VOLTE SEMPRE ========="
newline:            .asciiz "\n" # Essencial para controlar as quebras de linha

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
    jal ler_menu_labsim
    move $t0, $v0
    beq $t0, 1, menu_funcionario
    beq $t0, 2, menu_cliente
    beq $t0, 0, fim
    j invalido

menu_funcionario:
    li $v0, 4
    la $a0, funcionario
    syscall
    jal ler_menu_labsim
    move $t0, $v0
    beq $t0, 1, alterar_comum
    beq $t0, 2, alterar_aditivada
    beq $t0, 3, alterar_alcool
    beq $t0, 0, menu_principal
    j invalido

menu_cliente:
	li $v0, 4                  
	la $a0, cliente            
	syscall
	jal ler_menu_labsim
	move $t0, $v0
	beq $t0, 0, menu_principal 
	beq $t0, 1, cliente_comum     
	beq $t0, 2, cliente_aditivada 
	beq $t0, 3, cliente_alcool    
	j invalido                 

escolher_modo:
	li $v0, 4                  # Define a syscall para imprimir string
	la $a0, msg_metodo         # Carrega o endereço da mensagem de método (valor ou litro)
	syscall                    # Imprime a mensagem
	jal ler_menu_labsim        # Lê a opção do usuário
	move $t6, $v0              # Move a opção para $t6
	beq $t6, 1, por_valor      # Se 1, vai para a função de abastecer por valor
	beq $t6, 2, por_litros     # Se 2, vai para a função de abastecer por litros
	j invalido                 # Se for outra opção, trata como inválida

# --- Funções de Leitura do Teclado e Controle de LED (LabSim) ---
ler_menu_labsim:
	# Carrega os endereços de hardware do LabSim em registradores
	li $t9, 0xFFFF0010         # Carrega o endereço do display de 7 segmentos
	li $s6, 0xFFFF0012         # Carrega o endereço para selecionar a linha do teclado
	li $s7, 0xFFFF0014         # Carrega o endereço para ler a coluna do teclado

esperar_tecla:
	# Varre a linha 1 do teclado
	li $t1, 1                  # Carrega 1 para ativar a linha 1
	sb $t1, 0($s6)             # Escreve 1 no hardware, ativando a linha 1
	lbu $t0, 0($s7)            # Lê o estado das colunas
	beq $t0, 0x11, tecla_0     # Compara com o valor esperado para cada tecla (linha+coluna)
	beq $t0, 0x21, tecla_1
	beq $t0, 0x41, tecla_2
	beq $t0, 0x81, tecla_3
	
	# Varre a linha 2 do teclado
	li $t1, 2                  # Carrega 2 para ativar a linha 2
	sb $t1, 0($s6)             # Ativa a linha 2
	lbu $t0, 0($s7)            # Lê as colunas
	beq $t0, 0x12, tecla_0
	beq $t0, 0x22, tecla_1
	beq $t0, 0x42, tecla_2
	beq $t0, 0x82, tecla_3
	
	# Varre a linha 3 do teclado
	li $t1, 4                  # Carrega 4 para ativar a linha 3
	sb $t1, 0($s6)             # Ativa a linha 3
	lbu $t0, 0($s7)            # Lê as colunas
	beq $t0, 0x14, tecla_0
	beq $t0, 0x24, tecla_1
	beq $t0, 0x44, tecla_2
	beq $t0, 0x84, tecla_3
	
	# Varre a linha 4 do teclado
	li $t1, 8                  # Carrega 8 para ativar a linha 4
	sb $t1, 0($s6)             # Ativa a linha 4
	lbu $t0, 0($s7)            # Lê as colunas
	beq $t0, 0x18, tecla_0
	beq $t0, 0x28, tecla_1
	beq $t0, 0x48, tecla_2
	beq $t0, 0x88, tecla_3
	
	j esperar_tecla            # Se nenhuma tecla foi pressionada, repete o loop de varredura

# Funções que acendem o LED correspondente e retornam o número da tecla
tecla_0:
	addi $sp, $sp, -4          # Abre espaço na pilha para salvar o endereço de retorno
	sw   $ra, 0($sp)           # Salva o registrador $ra na pilha
	lb   $t2, led_0            # Carrega o padrão de bits do LED '0' para $t2
	sb   $t2, 0($t9)           # Envia o padrão para o hardware, acendendo o LED '0'
	li   $v0, 0                # Define o valor de retorno da função como 0
	jal  aguardar_soltar       # Chama a função para esperar a tecla ser solta
	lw   $ra, 0($sp)           # Restaura o endereço de retorno da pilha
	addi $sp, $sp, 4           # Libera o espaço na pilha
	jr   $ra                   # Retorna para quem chamou a função
	
tecla_1:
	addi $sp, $sp, -4          # Abre espaço na pilha
	sw   $ra, 0($sp)           # Salva $ra
	lb   $t2, led_1            # Carrega o padrão do LED '1'
	sb   $t2, 0($t9)           # Acende o LED '1'
	li   $v0, 1                # Define o valor de retorno como 1
	jal  aguardar_soltar       # Espera a tecla ser solta
	lw   $ra, 0($sp)           # Restaura $ra
	addi $sp, $sp, 4           # Libera a pilha
	jr   $ra                   # Retorna
	
tecla_2:
	addi $sp, $sp, -4          # Abre espaço na pilha
	sw   $ra, 0($sp)           # Salva $ra
	lb   $t2, led_2            # Carrega o padrão do LED '2'
	sb   $t2, 0($t9)           # Acende o LED '2'
	li   $v0, 2                # Define o valor de retorno como 2
	jal  aguardar_soltar       # Espera a tecla ser solta
	lw   $ra, 0($sp)           # Restaura $ra
	addi $sp, $sp, 4           # Libera a pilha
	jr   $ra                   # Retorna
	
tecla_3:
	addi $sp, $sp, -4          # Abre espaço na pilha
	sw   $ra, 0($sp)           # Salva $ra
	lb   $t2, led_3            # Carrega o padrão do LED '3'
	sb   $t2, 0($t9)           # Acende o LED '3'
	li   $v0, 3                # Define o valor de retorno como 3
	jal  aguardar_soltar       # Espera a tecla ser solta
	lw   $ra, 0($sp)           # Restaura $ra
	addi $sp, $sp, 4           # Libera a pilha
	jr   $ra                   # Retorna

# Função que espera o usuário soltar a tecla para evitar leituras múltiplas (debouncing)
aguardar_soltar:
	li $t1, 1                  # Ativa a linha 1
	sb $t1, 0($s6)             # 
	lbu $t0, 0($s7)            # Lê as colunas
	andi $t3, $t0, 0xF0        # Verifica se alguma coluna está ativa (tecla pressionada)
	bnez $t3, aguardar_soltar  # Se estiver, a tecla ainda está pressionada, então espera
	# Repete para todas as linhas para garantir que nenhuma tecla esteja pressionada
	li $t1, 2
	sb $t1, 0($s6)
	lbu $t0, 0($s7)
	andi $t3, $t0, 0xF0
	bnez $t3, aguardar_soltar

	li $t1, 4
	sb $t1, 0($s6)
	lbu $t0, 0($s7)
	andi $t3, $t0, 0xF0
	bnez $t3, aguardar_soltar

	li $t1, 8
	sb $t1, 0($s6)
	lbu $t0, 0($s7)
	andi $t3, $t0, 0xF0
	bnez $t3, aguardar_soltar

	jr $ra                     # Retorna quando nenhuma tecla estiver mais pressionada

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

# Funções que preparam a simulação com base na escolha do cliente
cliente_comum:
	lw $s0, preco_comum        # Carrega o preço da gasolina comum no registrador salvo $s0
	li $s3, 1                  # Define o tipo de combustível como 1 em $s3
	j escolher_modo            # Pula para a função de escolher o método de abastecimento

cliente_aditivada:
	lw $s0, preco_aditivada    # Carrega o preço da aditivada em $s0
	li $s3, 2                  # Define o tipo como 2 em $s3
	j escolher_modo

cliente_alcool:
	lw $s0, preco_alcool       # Carrega o preço do álcool em $s0
	li $s3, 3                  # Define o tipo como 3 em $s3
	j escolher_modo

# Lógica para abastecer por valor em Reais
por_valor:
	li $v0, 4                  # Syscall para imprimir string
	la $a0, prompt_valor       # Pergunta o valor em R$
	syscall
	li $v0, 5                  # Syscall para ler um inteiro
	syscall
	move $s2, $v0              # Move o valor lido (total R$) para o registrador salvo $s2
	div $s1, $s2, $s0          # Divide o valor total ($s2) pelo preço ($s0) e guarda os litros em $s1
	j simular                  # Pula para a função de simulação

# Lógica para abastecer por quantidade de Litros
por_litros:
	li $v0, 4                  # Syscall para imprimir string
	la $a0, prompt_litros      # Pergunta a quantidade de litros
	syscall
	li $v0, 5                  # Syscall para ler um inteiro
	syscall
	move $s1, $v0              # Move a quantidade lida (litros) para o registrador salvo $s1
	mul $s2, $s1, $s0          # Multiplica os litros ($s1) pelo preço ($s0) e guarda o valor total em $s2
	j simular                  # Pula para a função de simulação

# --- Simulação e Geração de Cupom ---
simular:
	# Mostra na tela o resumo do abastecimento que vai começar
	li $v0, 4
	la $a0, str_iniciando      # Imprime "Iniciando abastecimento..."
	syscall
	li $v0, 4
	la $a0, str_total_abastecer# Imprime "Total a abastecer: "
	syscall
	li $v0, 1
	move $a0, $s1              # Move os litros ($s1) para o argumento de impressão
	syscall                    # Imprime a quantidade de litros
	li $v0, 4
	la $a0, str_L              # Imprime " L\n"
	syscall
	li $v0, 4
	la $a0, str_valor_total    # Imprime "Valor total: R$ "
	syscall
	li $v0, 1
	move $a0, $s2              # Move o valor total ($s2) para o argumento de impressão
	syscall                    # Imprime o valor total
	li $v0, 4
	la $a0, str_linha          # Imprime a linha separadora
	syscall
	li $t7, 0                  # Zera o registrador $t7, que será o contador de litros abastecidos

# Loop que simula o abastecimento, 1 litro por segundo
loop_abastecimento:
	bge $t7, $s1, fim_simulacao # Se o contador ($t7) for maior ou igual ao total de litros ($s1), termina
	li $v0, 32                 # Syscall para "dormir" (pausar a execução)
	li $a0, 1000               # Define a pausa para 1000 milissegundos (1 segundo)
	syscall                    # Executa a pausa
	li $v0, 4
	la $a0, str_abastecendo    # Imprime "Abastecido "
	syscall
	li $v0, 1
	addi $a0, $t7, 1           # Adiciona 1 ao contador para mostrar o número do litro atual (1, 2, 3...)
	syscall                    # Imprime o número do litro
	li $v0, 4
	la $a0, str_L_final        # Imprime " L..."
	syscall
	addi $t7, $t7, 1           # Incrementa o contador de litros
	j loop_abastecimento       # Volta para o início do loop

fim_simulacao:
	jal gerar_cupom            # Ao final, chama a função para gerar o cupom fiscal

# ====================================================================
# pos_cupom: Exibe mensagem final de abastecimento e retorna ao menu.
# ====================================================================
pos_cupom:
    li $v0, 4                 # Syscall 4: imprime string na tela
    la $a0, str_concluido     # Carrega a mensagem "--- ABASTECIMENTO CONCLUIDO ---"
    syscall                   # Imprime a mensagem
    j menu_principal          # Retorna ao menu principal

# ====================================================================
# gerar_cupom: Cria um cupom fiscal com as informações do abastecimento.
#              Escreve tipo, litros, total pago e mensagem final no arquivo.
# ====================================================================
gerar_cupom:
    addi $sp, $sp, -4         # Reserva espaço na pilha
    sw $ra, 0($sp)            # Salva o registrador de retorno ($ra)

    li $v0, 13                # Syscall 13: abrir/criar arquivo
    la $a0, cupom_nome        # Nome do arquivo: "meu_cupom_fiscal.txt"
    li $a1, 1                 # Modo de escrita (write only)
    li $a2, 0                 # Sem permissões específicas
    syscall
    move $s7, $v0             # Armazena descritor do arquivo em $s7

    # Escreve cabeçalho do cupom
    li $v0, 15
    move $a0, $s7
    la $a1, cupom_cabecalho
    li $a2, 42
    syscall

    # Escreve rótulo do tipo de combustível
    li $v0, 15
    move $a0, $s7
    la $a1, cupom_combustivel
    li $a2, 22
    syscall

    # Decide qual string de combustível escrever
    beq $s3, 1, escrever_comum
    beq $s3, 2, escrever_aditivada
    beq $s3, 3, escrever_alcool

# ================================================================
# escrever_comum: Escreve "Gasolina Comum" no cupom
# ================================================================
escrever_comum:
    li $v0, 15
    move $a0, $s7
    la $a1, cupom_tipo_comum
    li $a2, 16
    syscall
    j continuar_cupom

# ================================================================
# escrever_aditivada: Escreve "Gasolina Aditivada" no cupom
# ================================================================
escrever_aditivada:
    li $v0, 15
    move $a0, $s7
    la $a1, cupom_tipo_aditiv
    li $a2, 19
    syscall
    j continuar_cupom

# ================================================================
# escrever_alcool: Escreve "Álcool" no cupom
# ================================================================
escrever_alcool:
    li $v0, 15
    move $a0, $s7
    la $a1, cupom_tipo_alcool
    li $a2, 7
    syscall

# ================================================================
# continuar_cupom: Escreve litros abastecidos e valor total no cupom.
# ================================================================
continuar_cupom:
    # Escreve rótulo dos litros
    li $v0, 15
    move $a0, $s7
    la $a1, cupom_litros
    li $a2, 26
    syscall

    # Converte quantidade de litros (inteiro ? string)
    move $a0, $s1              # Quantidade de litros
    la $a1, buffer_str
    jal int_to_string          # Converte em string

    # Escreve string de litros no cupom
    li $v0, 15
    move $a0, $s7
    la $a1, buffer_str
    move $a2, $v1              # Tamanho da string
    syscall

    # Quebra de linha
    li $v0, 15
    move $a0, $s7
    la $a1, newline
    li $a2, 1
    syscall

    # Escreve rótulo do valor total
    li $v0, 15
    move $a0, $s7
    la $a1, cupom_valor
    li $a2, 9
    syscall

    # Converte valor total (inteiro ? string)
    move $a0, $s2              # Valor total
    la $a1, buffer_str
    jal int_to_string

    # Escreve string do valor total
    li $v0, 15
    move $a0, $s7
    la $a1, buffer_str
    move $a2, $v1
    syscall

    # Quebra de linha
    li $v0, 15
    move $a0, $s7
    la $a1, newline
    li $a2, 1
    syscall

    # Escreve rodapé do cupom
    li $v0, 15
    move $a0, $s7
    la $a1, cupom_rodape
    li $a2, 46
    syscall

    # Fecha o arquivo
    li $v0, 16
    move $a0, $s7
    syscall

    # Restaura registrador de retorno e retorna da função
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra

# ====================================================================
# int_to_string: Converte um número inteiro positivo em string decimal.
# Entrada: $a0 = número, $a1 = ponteiro para buffer
# Saída: buffer preenchido, $v1 = tamanho da string gerada
# ====================================================================
int_to_string:
    move $t8, $a0              # Número a converter
    move $t9, $a1              # Ponteiro para buffer
    li $t0, 10                 # Base 10
    li $t1, 0                  # Contador de dígitos

    bnez $t8, itos_loop        # Se número ? 0, vai para o loop
    li $t2, '0'                # Caso especial: escreve '0'
    sb $t2, 0($t9)
    li $v1, 1
    jr $ra

itos_loop:
    beqz $t8, itos_reverse     # Se número for 0, termina loop
    divu $t8, $t0              # Divide por 10
    mflo $t8                   # Novo valor de t8 (quociente)
    mfhi $t2                   # Resto = dígito atual
    addi $t2, $t2, '0'         # Converte para caractere ASCII
    sb $t2, 0($t9)             # Armazena no buffer
    addi $t9, $t9, 1           # Avança ponteiro do buffer
    addi $t1, $t1, 1           # Incrementa contador
    j itos_loop

itos_reverse:
    move $v1, $t1              # Salva o tamanho da string
    sub $t9, $t9, 1            # Corrige posição final do ponteiro
    move $t3, $a1              # Início do buffer

reverse_loop:
    bge $t3, $t9, itos_done    # Se ponteiros se encontraram, fim
    lb $t4, 0($t3)             # Caractere da esquerda
    lb $t5, 0($t9)             # Caractere da direita
    sb $t5, 0($t3)             # Troca os valores
    sb $t4, 0($t9)
    addi $t3, $t3, 1           # Avança para o meio (esquerda)
    subi $t9, $t9, 1           # Avança para o meio (direita)
    j reverse_loop

itos_done:
    jr $ra

# ====================================================================
# invalido: Exibe mensagem de erro para entradas inválidas e volta ao menu.
# ====================================================================
invalido:
    li $v0, 4
    la $a0, num_invalido
    syscall
    j menu_principal

# ====================================================================
# fim: Encerra o programa.
# ====================================================================
fim:
    li $v0, 10                 # Syscall 10: encerra execução
    syscall

