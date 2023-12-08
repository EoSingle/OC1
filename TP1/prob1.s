.data
vetor: .word 2 5 7 4 # Valores de teste

##### START MODIFIQUE AQUI START #####
#
# Este espaço é para você definir as suas constantes e vetores auxiliares.
#

tamanho_vetor: .word 4 # Usado para teste do t3

##### END MODIFIQUE AQUI END #####

.text
jal ra, contador
addi x14, x0, 2          # utilizado para correção
beq x14, x10, FIM        # Verifica # de pares : x10 == a0
beq x14, x11, FIM        # Verifica # de ímpares x11 == a1

##### START MODIFIQUE AQUI START #####
contador:
	li a0, 0             # inicializa os contadores
    li a1, 0             # a0 == pares & a1 == impares
    la t2, vetor         # Inicialização do vetor
    lw t3, tamanho_vetor # Inicialização do tamanho do vetor
    
    loop:
    	lw t4, 0(t2)     # carrega item do vetor em t4
        andi t5, t4, 1   # verifica o bit menos significativo
        beqz t5, par     # 0 == par
        
        addi a1, a1, 1   # else impar, incrementa impar
        j next           # proximo
        
    par:
    	addi a0, a0, 1   # incrementa t0
        
    next:
    	addi t2, t2, 4   # proximo elemento do vetor
		addi t3, t3, -1  # tamanho_vetor -= 1
        bnez t3, loop    # se t3 != 0 continua o loop
		jalr zero, 0(ra) # break
        
##### END MODIFIQUE AQUI END #####

FIM: addi x0, x0, 1