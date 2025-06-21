.data
filename:     .asciiz "cupom_fiscal.txt"  # Define o nome do arquivo a ser criado e escrito

# Mensagens fixas que ser�o escritas no arquivo (strings)
msg1:         .asciiz " ------ CUPOM FISCAL ------\n"
msg2:         .asciiz "Combust�vel:\n"           # Aqui dever� ser escrito o tipo de combust�vel
msg3:         .asciiz " Quantidade:"            # Aqui dever� ser escrito a quantidade de litros
msg4:         .asciiz " litros\n"
msg5:         .asciiz " Pre�o por litro: R$ \n" # Aqui dever� ser escrito o pre�o por litro
msg6:         .asciiz "Total a pagar: R$ \n"    # Aqui dever� ser escrito o total a pagar
msg7:         .asciiz "------------------------\n        Volte Sempre!\n"

.text
.globl main

main:
    # Abrir arquivo para escrita
    li $v0, 13            # syscall 13 � usada para abrir/criar arquivo
    la $a0, filename      # endere�o da string com o nome do arquivo (argumento)
    li $a1, 1             # flag = 1 para abrir arquivo para escrita
    li $a2, 0             # modo padr�o (n�o � usado neste caso)
    syscall               # executa a chamada do sistema
    move $s0, $v0         # salva o descritor do arquivo retornado em $s0 para usar depois

    # Escrever o cabe�alho do cupom
    li $v0, 15            # syscall 15 escreve no arquivo
    move $a0, $s0         # primeiro argumento: descritor do arquivo (onde escrever)
    la $a1, msg1          # segundo argumento: endere�o da string a escrever
    li $a2, 29            # terceiro argumento: n�mero de caracteres a escrever
    syscall               # executa a escrita

    # Escrever "Combust�vel:\n"
    li $v0, 15
    move $a0, $s0
    la $a1, msg2
    li $a2, 13
    syscall

    # Escrever "Quantidade:"
    li $v0, 15
    move $a0, $s0
    la $a1, msg3
    li $a2, 12
    syscall

    # Escrever " litros\n"
    li $v0, 15
    move $a0, $s0
    la $a1, msg4
    li $a2, 8
    syscall

    # Escrever " Pre�o por litro: R$ \n"
    li $v0, 15
    move $a0, $s0
    la $a1, msg5
    li $a2, 23
    syscall

    # Escrever "Total a pagar: R$ \n"
    li $v0, 15
    move $a0, $s0
    la $a1, msg6
    li $a2, 22
    syscall

    # Escrever o rodap� do cupom 
    li $v0, 15
    move $a0, $s0
    la $a1, msg7
    li $a2, 50
    syscall

    # Deixar, importante para garantir que tudo foi salvo no arquivo corretamente
    # Fechar o arquivo aberto
    li $v0, 16            # syscall 16 fecha o arquivo
    move $a0, $s0         # descritor do arquivo a ser fechado
    syscall

    # Encerrar o programa 
    li $v0, 10            # syscall 10 termina a execu��o do programa
    syscall

