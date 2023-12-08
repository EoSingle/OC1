.data
vetor: .word 200, 190, 340, 100 # exemplo

##### START MODIFIQUE AQUI START #####
#
# Este espaço é para você definir as suas constantes e vetores auxiliares.
#

tamanho_vetor: .word 4   # Altere para o tamanho do vetor
limiar: .word 200        # define o limiar considerado

##### END MODIFIQUE AQUI END #####

.text
jal ra, main
# utilizado para correção (considerando um limiar de 200 para o vetor
# de exemplo após a aplicação do reajuste.
addi a4, x0, 3          # Alterar o int p/ n. de valores acima do limiar

beq a4, t0, FIM # Verifica a quantidade de salários acima do limiar.

main:
##### START MODIFIQUE AQUI START #####
    li t0, 0                # contador de salarios acima do limiar
    li t1, 50               # porcentagem de aumento
    li t2, 100              # auxiliar para calcular porcentagem
    la a0, vetor            # carrega o vetor
    lw a1, tamanho_vetor    # carrega o tamanho do vetor
    lw a2, limiar           # carrega o limiar
    
    addi sp, sp, -4         # subtrai 4 da pilha
    sw ra, 0(sp)            # guarda o endereço de retorno na pilha
    jal ra, aplica_reajuste
    lw ra, 0(sp)            # carrega o endereço de retorno da pilha
    addi sp, sp, 4          # libera memoria da pilha
    jalr zero, 0(ra)
##### END MODIFIQUE AQUI END #####

aplica_reajuste:
##### START MODIFIQUE AQUI START #####
    lw t4, 0(a0)            # carrega o elemento do vetor
	mul t6, t4, t1          # multiplica por 100
    div t6, t6, t2          # divide pelo limiar
    add t4, t4, t6          # incrementa o valor

    bge t4, a2, incrementa  # se o novo valor >= limiar
    j loop

incrementa:
    addi t0, t0, 1          # t0 += 1

loop:
    addi a0, a0, 4           # prox elemento do vetor
    addi a1, a1 -1           # tamanho_vetor -= 1
    bnez a1, aplica_reajuste # se a1 != 0 continua o loop
    jalr zero, 0(ra)         # break

##### END MODIFIQUE AQUI END #####

FIM: addi x0, x0, 1