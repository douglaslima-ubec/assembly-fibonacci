.data
promptFibo:      .asciiz "O 30° número de Fibonacci é: "
promptPhi:       .asciiz "A razão áurea usando F_41 e F_40 é: "
newline:         .asciiz "\n"

.text
.globl main

# Função principal
main:
    # Calcular o 30° número de Fibonacci
    li $a0, 30            # n = 30
    jal fibonacci
    move $s1, $v0         # Armazenar resultado de fibonacci(30) em $s1

    # Calcular o 41° número de Fibonacci
    li $a0, 41            # n = 41
    jal fibonacci
    move $s2, $v0         # Armazenar resultado de fibonacci(41) em $s2

    # Calcular o 40° número de Fibonacci
    li $a0, 40            # n = 40
    jal fibonacci
    move $s3, $v0         # Armazenar resultado de fibonacci(40) em $s3

    # Calcular a razão áurea F_41 / F_40
    move $a0, $s2         # Numerador
    move $a1, $s3         # Denominador
    jal div_float
    

    # Imprimir o 30° número de Fibonacci
    la $a0, promptFibo    # Carregar mensagem do prompt
    li $v0, 4
    syscall

    move $a0, $s1         # Colocar resultado em $a0
    li $v0, 1             # Código de serviço para impressão de inteiro
    syscall

    la $a0, newline       # Imprimir nova linha
    li $v0, 4
    syscall

    # Imprimir a razão áurea
    la $a0, promptPhi     # Carregar mensagem do prompt
    li $v0, 4
    syscall

    mov.s $f12, $f0       # Colocar resultado em $f12
    li $v0, 2             # Código de serviço para impressão de float
    syscall

    # Finalizar programa
    li $v0, 10            # Código de serviço para sair do programa
    syscall

# Função para calcular o n-ésimo termo da sequência de Fibonacci
fibonacci:
    addi $sp, $sp, -8     # Ajustar pilha
    sw $ra, 4($sp)        # Salvar endereço de retorno
    sw $a0, 0($sp)        # Salvar argumento n

    li $t0, 0             # F(0) = 0
    li $t1, 1             # F(1) = 1

    bgt $a0, 1, fib_loop  # Se n > 1, ir para o loop
    beq $a0, 0, fib_exit  # Se n == 0, retornar 0
    move $v0, $t1         # Se n == 1, retornar 1
    j fib_return

fib_loop:
    li $t2, 2             # Iniciar contador
fib_next:
    add $t3, $t0, $t1     # c = a + b
    move $t0, $t1         # a = b
    move $t1, $t3         # b = c
    addi $t2, $t2, 1      # contador++
    ble $t2, $a0, fib_next# Se contador <= n, repetir

    move $v0, $t3         # Colocar resultado em $v0
    j fib_return

fib_exit:
    move $v0, $t0         # Retornar F(0)

fib_return:
    lw $ra, 4($sp)        # Restaurar endereço de retorno
    lw $a0, 0($sp)        # Restaurar argumento n
    addi $sp, $sp, 8      # Ajustar pilha
    jr $ra                # Retornar

# Função para divisão de inteiros, retorna float
div_float:
    mtc1 $a0, $f12        # Mover numerador para $f12
    mtc1 $a1, $f14        # Mover denominador para $f14
    cvt.s.w $f12, $f12    # Converter numerador para float
    cvt.s.w $f14, $f14    # Converter denominador para float
    div.s $f0, $f12, $f14 # Dividir $f12 por $f14
    jr $ra                # Retornar