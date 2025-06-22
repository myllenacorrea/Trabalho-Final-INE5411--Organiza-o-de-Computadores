.data
    # Preços dos combustíveis como INTEIROS 
    gasolina_aditivada: .word 5
    gasolina_comum:     .word 5
    alcool:             .word 4

    # Strings do menu
    # O menu foi quebrado em partes para permitir a inserção dos preços dinamicamente.
    prompt_titulo:      .asciiz "Escolha o combustivel:"
    prompt_op1:         .asciiz "\n1 - Gasolina Aditivada (R$ "
    prompt_op2:         .asciiz "\n2 - Gasolina Comum (R$ "
    prompt_op3:         .asciiz "\n3 - Alcool (R$ "
    prompt_fim_preco:   .asciiz "/L)"
    prompt_sua_escolha: .asciiz "\nSua escolha: "

    # --- Outras strings para interação com o usuário ---
    prompt_modo:        .asciiz "\nEscolha o modo de abastecimento:\n1 - Por valor (R$)\n2 - Por litros\nSua escolha: \n"
    prompt_valor:       .asciiz "\nDigite o valor a ser abastecido (em R$ inteiros): "
    prompt_litros:      .asciiz "\nDigite a quantidade em litros (inteiros): "
    str_invalido:       .asciiz "\nOpcao invalida!"

    # --- Strings para a simulação e resultados ---
    str_iniciando:      .asciiz "\nIniciando abastecimento...\n"
    str_total_abastecer:.asciiz "Total a abastecer: "
    str_L:              .asciiz " L\n"
    str_valor_total:    .asciiz "Valor total: R$ "
    str_linha:          .asciiz "\n-----------------------------------------"
    str_abastecendo:    .asciiz "\nAbastecido " # String usada dentro do loop de simulação.
    str_L_final:        .asciiz " L..."
    str_concluido:      .asciiz "\n\n--- ABASTECIMENTO CONCLUIDO ---\n"

    # --- Buffer para ler entradas do usuário ---
    # Aloca 2 bytes de espaço na memória para armazenar a entrada do usuário (ex: '1', '2', etc.).
    buffer_input:   .space 2

.text
.globl main # Declara 'main' como o ponto de entrada global do programa.

main:
    # $v0 = código do syscall, $a0 = argumento do syscall

    # Exibe o título do menu
    li $v0, 4                   # Syscall 4: print_string
    la $a0, prompt_titulo       # Carrega o endereço da string do título em $a0
    syscall

    #Opção 1: Gasolina Aditivada
    li $v0, 4
    la $a0, prompt_op1          # Imprime "1 - Gasolina Aditivada (R$ "
    syscall
    lw $t5, gasolina_aditivada  # Carrega o PREÇO da memória para o registrador temporário $t5
    li $v0, 1                   # Syscall 1: print_integer
    move $a0, $t5               # Move o preço de $t5 para $a0 para ser impresso
    syscall
    li $v0, 4
    la $a0, prompt_fim_preco    # Imprime "/L)" para completar a linha
    syscall

    #Opção 2: Gasolina Comum (mesma lógica da Opção 1)
    li $v0, 4
    la $a0, prompt_op2
    syscall
    lw $t5, gasolina_comum
    li $v0, 1
    move $a0, $t5
    syscall
    li $v0, 4
    la $a0, prompt_fim_preco
    syscall

    #Opção 3: Álcool (mesma lógica da Opção 1)
    li $v0, 4
    la $a0, prompt_op3
    syscall
    lw $t5, alcool
    li $v0, 1
    move $a0, $t5
    syscall
    li $v0, 4
    la $a0, prompt_fim_preco
    syscall
    
    # Exibe o prompt final para o usuário digitar sua escolha
    li $v0, 4
    la $a0, prompt_sua_escolha
    syscall
    
    # Lê a escolha do usuário (o caractere '1', '2' ou '3')
    li $v0, 8                   # Syscall 8: read_string
    la $a0, buffer_input        # Endereço do buffer para armazenar a entrada
    li $a1, 2                   # Tamanho máximo do buffer
    syscall
    lb $t0, buffer_input        # Carrega o primeiro byte (o caractere) da entrada para $t0

    # Verifica a escolha e desvia para a rotina correspondente
    li $t1, '1'
    beq $t0, $t1, carrega_aditivada # Se a escolha for '1', pula para carrega_aditivada
    li $t1, '2'
    beq $t0, $t1, carrega_comum     # Se a escolha for '2', pula para carrega_comum
    li $t1, '3'
    beq $t0, $t1, carrega_alcool    # Se a escolha for '3', pula para carrega_alcool
    j opcao_invalida                # Se não for nenhuma das opções, pula para opcao_invalida

# $s0 será usado para armazenar o preço por litro do combustível escolhido.
carrega_aditivada:
    lw $s0, gasolina_aditivada      # Carrega o preço da aditivada em $s0
    j escolher_modo_abastecimento   # Pula para a próxima etapa
carrega_comum:
    lw $s0, gasolina_comum          # Carrega o preço da comum em $s0
    j escolher_modo_abastecimento   # Pula para a próxima etapa
carrega_alcool:
    lw $s0, alcool                  # Carrega o preço do álcool em $s0
                                    # O código segue para a próxima instrução (escolher_modo_abastecimento)

#ESCOLHA DO MODO DE ABASTECIMENTO
escolher_modo_abastecimento:
    li $v0, 4
    la $a0, prompt_modo
    syscall
    li $v0, 8                   # Lê a escolha do modo ('1' ou '2')
    la $a0, buffer_input
    li $a1, 2
    syscall
    lb $t0, buffer_input        # Carrega o caractere da escolha em $t0
    li $t1, '1'
    bne $t0, $t1, modo_por_litros # Se NÃO for '1' (por valor), pula para modo_por_litros

#ABASTECER POR VALOR (R$)
    li $v0, 4
    la $a0, prompt_valor
    syscall
    li $v0, 5                   # Syscall 5: read_integer (lê um número inteiro)
    syscall
    move $s2, $v0               # Move o valor lido (total a pagar) para $s2
    div $s1, $s2, $s0           # Calcula: total_litros = total_pagar / preco_por_litro. Resultado em $s1.
    j imprimir_e_simular        # Pula para a simulação

# ABASTECER POR LITROS
modo_por_litros:
    li $t1, '2'
    bne $t0, $t1, opcao_invalida # Verifica se a opção é '2'. Se não, é inválida.
    li $v0, 4
    la $a0, prompt_litros
    syscall
    li $v0, 5                   # Lê um número inteiro (litros)
    syscall
    move $s1, $v0               # Move a quantidade de litros lida para $s1
    mul $s2, $s1, $s0           # Calcula: total_pagar = litros * preco_por_litro. Resultado em $s2.
    j imprimir_e_simular        # Pula para a simulação

# IMPRESSÃO DO RESUMO E SIMULAÇÃO DO ABASTECIMENTO
# os valores já foram calculados:
# $s1 = total de litros (inteiro)
# $s2 = total a pagar (inteiro)
imprimir_e_simular:
    # Imprime o resumo do abastecimento
    li $v0, 4
    la $a0, str_iniciando
    syscall
    li $v0, 4
    la $a0, str_total_abastecer
    syscall
    li $v0, 1
    move $a0, $s1               # Imprime o total de litros ($s1)
    syscall
    li $v0, 4
    la $a0, str_L
    syscall
    li $v0, 4
    la $a0, str_valor_total
    syscall
    li $v0, 1
    move $a0, $s2               # Imprime o valor total a pagar ($s2)
    syscall
    li $v0, 4
    la $a0, str_linha
    syscall

    # Inicia o loop de simulação
    li $t0, 1                   # Inicia um contador de loop 'i' em $t0 com valor 1
loop_simulacao:
    bgt $t0, $s1, fim_simulacao # CONDIÇÃO DO LOOP: se i ($t0) > total_litros ($s1), termina o loop.

    # Pausa por 1 segundo (1000 milissegundos)
    li $v0, 32                  # Syscall 32: sleep
    li $a0, 1000                # Argumento: tempo em milissegundos
    syscall

    # Imprime o progresso a cada litro
    li $v0, 4
    la $a0, str_abastecendo
    syscall
    li $v0, 1
    move $a0, $t0               # Imprime o litro atual (o valor do contador 'i')
    syscall
    li $v0, 4
    la $a0, str_L_final
    syscall

    addi $t0, $t0, 1            # Incrementa o contador do loop: i++
    j loop_simulacao            # Volta para o início do loop


fim_simulacao:
    # Imprime a mensagem de conclusão do abastecimento
    li $v0, 4
    la $a0, str_concluido
    syscall
    j fim_programa              # Pula para o final do programa

opcao_invalida:
    # Imprime mensagem de erro para o usuário
    li $v0, 4
    la $a0, str_invalido
    syscall
    # O programa continua para a próxima instrução, que é fim_programa

fim_programa:
    # Finaliza o programa de forma limpa
    li $v0, 10                  # Syscall 10: exit
    syscall