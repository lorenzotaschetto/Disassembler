.data
	buffer: .space 11 # buffer que armazena a string de digitos hexadecimais
	#Posição 0: Armazena o caractere '0' para indicar que o número está representado em hexadecimal.
	#Posição 1: Armazena o caractere 'x' para indicar que o número é uma representação hexadecimal.
	#Posições 2 a 9: São utilizadas para armazenar os 8 dígitos hexadecimais do valor de entrada.
	#Posição 10: Armazena o caractere nulo ('\0') para indicar o final da string.
	
	tabela_hexadecimal: .ascii "0123456789ABCDEF" # tabela de caracteres hexadecimais

	input_file: .asciiz "INPUT.bin" # Nome do arquivo de leitura
	output_file: .asciiz "OUTPUT.txt"    # Nome do arquivo de escrita
	erro_input: .asciiz "Erro ao abrir o arquivo de entrada" # Mensagem de erro 
	erro_output: .asciiz "Erro ao abrir o arquivo de saida"  # Mensagem de erro

	virgula: .asciiz ","
	espaco: .asciiz " "
	parentese_L: .asciiz "("
	parentese_R: .asciiz ")"
	
	nova_linha: .asciiz "\r\n" # Move o cursor para o inicio da linha e faz a quebra de linha
	
	indefinida_instrucao: .asciiz "instrucao nao identificada" # Caso a instruçao não seja reconhecida
	indefinido_registrador: .asciiz "registrador nao identificado" # Caso o registrador não seja reconhecido
	
	# Registradores
	r_zero: .asciiz "$zero"
	r_at: .asciiz "$at"
	r_v0: .asciiz "$v0"
	r_v1: .asciiz "$v1"
	r_a0: .asciiz "$a0"
	r_a1: .asciiz "$a1"
	r_a2: .asciiz "$a2"
	r_a3: .asciiz "$a3"
	r_t0: .asciiz "$t0"
	r_t1: .asciiz "$t1"
	r_t2: .asciiz "$t2"
	r_t3: .asciiz "$t3"
	r_t4: .asciiz "$t4"
	r_t5: .asciiz "$t5"
	r_t6: .asciiz "$t6"
	r_t7: .asciiz "$t7"
	r_s0: .asciiz "$s0"
	r_s1: .asciiz "$s1"
	r_s2: .asciiz "$s2"
	r_s3: .asciiz "$s3"
	r_s4: .asciiz "$s4"
	r_s5: .asciiz "$s5"
	r_s6: .asciiz "$s6"
	r_s7: .asciiz "$s7"
	r_sp: .asciiz "$sp"
	r_ra: .asciiz "$ra"

	# J
	op_j: .asciiz "j"
	op_jal: .asciiz "jal"

	# R
	op_jr: .asciiz "jr"
	op_add: .asciiz "add"
	op_addu: .asciiz "addu"
	op_sub: .asciiz "sub"
	op_subu: .asciiz "subu"
	op_and: .asciiz "and"
	op_or: .asciiz "or"
	op_xor: .asciiz "xor"
	op_nor: .asciiz "nor"
	op_sll: .asciiz "sll"
	op_srl: .asciiz "srl"
	op_slt: .asciiz "slt"
	op_sltu: .asciiz "sltu"
	op_syscall: .asciiz "syscall"
	op_mul: .asciiz "mul"

	# I
	op_addi: .ascii "addi"
	op_addiu: .asciiz "addiu"
	op_andi: .asciiz "andi"
	op_ori: .asciiz "ori"
	op_xori: .asciiz "xori"
	op_slti: .asciiz "slti"
	op_sltiu: .asciiz "sltiu"
	op_lui: .asciiz "lui"
	op_beq: .asciiz "beq"
	op_bne: .asciiz "bne"
	op_lb: .asciiz "lb"
	op_lbu: .asciiz "lbu"
	op_lh: .asciiz "lh"
	op_lhu: .asciiz "lhu"
	op_lw: .asciiz "lw"
	op_ll: .asciiz "ll"
	op_sb: .asciiz "sb"
	op_sh: .asciiz "sh"
	op_sw: .asciiz "sw"
	op_sc: .asciiz "sc"
	
.text

.globl main

main:
	addiu $sp, $sp, -12  # Reserva 12 bytes na pilha, decrementando o valor do registrador $sp

abre_arquivo_leitura:
	# Abertura do arquivo de leitura
	li     $v0, 13  # Carrega o valor 13 em $v0 (código da chamada do sistema para abrir arquivo)
	la     $a0, input_file  # Carrega o endereço da string "input_file" em $a0 (nome do arquivo de entrada)
	li     $a1, 0  # Carrega o valor 0 em $a1 (modo de leitura para o arquivo)
	li     $a2, 0  # Carrega o valor 0 em $a2 (permissões padrão para o arquivo)
	syscall  # Chama o sistema operacional para abrir o arquivo de entrada
	sw     $v0, 0($sp)  # Armazena o valor de retorno em 0($sp) (na pilha)
	li     $t0, 0x0040000  # Carrega o valor hexadecimal 0x0040000 em $t0
	sw     $t0, 8($sp)  # Armazena o valor de $t0 em 8($sp) (na pilha)

	slt    $t0, $v0, $zero  # Define $t0 como 1 se $v0 < 0 (verifica se ocorreu um erro ao abrir o arquivo)
	bne    $t0, $zero, label_erro_input  # Pula para o label 'erro_input' se $t0 != 0 (ocorreu um erro ao abrir o arquivo)


###################################################################################################################################################################	
	
abre_arquivo_escrita:
	# Abertura do arquivo de escrita
	li    $v0, 13  # Carrega o valor 13 em $v0 (código da chamada do sistema para abrir arquivo)
	la    $a0, output_file  # Carrega o endereço da string "output_file" em $a0 (nome do arquivo de saída)
	li    $a1, 1  # Carrega o valor 1 em $a1 (modo de escrita para o arquivo)
	li    $a2, 0  # Carrega o valor 0 em $a2 (permissões padrão para o arquivo)
	syscall  # Chama o sistema operacional para abrir o arquivo de saída
	sw    $v0, -4($sp)  # Armazena o valor de retorno em -4($sp) (na pilha)

	slt   $t0, $v0, $zero  # Define $t0 como 1 se $v0 < 0 (verifica se ocorreu um erro ao abrir o arquivo)
	bne   $t0, $zero, label_erro_output  # Pula para o label 'erro_output' se $t0 != 0 (ocorreu um erro ao abrir o arquivo)
        
###################################################################################################################################################################
               
le_arquivo:
        # Leitura de 4 bytes do arquivo (uma linha)
        lw    $a0, 0($sp)   # Carrega o valor localizado em 0($sp) (descritor do arquivo)
        addiu $a1, $sp, 4   # Adiciona 4 bytes ao endereço do registrador $sp e armazena o resultado em $a1
        li    $a2, 4        # Carrega o valor 4 em $a2 (tamanho máximo de leitura)
        li    $v0, 14       # Carrega o valor 14 em $v0 (código da chamada do sistema para ler do arquivo)
        syscall             # Faz a chamada do sistema para ler do arquivo

	# Vai para o label 'verifica_fim_arquivo'
        
###################################################################################################################################################################
        
verifica_fim_arquivo:
	# Verifica se o resultado da chamada do sistema indica fim do arquivo
        slti  $t0, $v0, 4   # Define $t0 como 1 se $v0 < 4 (indica que chegou ao fim do arquivo)
        bne   $t0, $zero, fim_programa  # Pula para o label 'fim_programa' se $t0 != 0 (chegou ao fim do arquivo)
        
        # Vai para o label 'endereco'

###################################################################################################################################################################

endereco:
	endereço:
        lw    $a0, 8($sp)   # Carrega o valor localizado em 8($sp) 
        la    $a1, buffer   # Carrega o endereço da variável 'buffer' em $a1
	
	jal hex_string # Chama a função 'hex_para_string' para converter o código em hexadecimal para string
	
        # Imprime o conteúdo convertido em hexadecimal
        lw    $a0, -4($sp) # Armazena o valor de $a0 em -4($sp) (na pilha)
        la    $a1, buffer  # Carrega o endereço da variável 'buffer' em $a1
        li    $a2, 10      # Carrega o valor 10 em $a2 (tamanho máximo de impressão)
        li    $v0, 15      # Carrega o valor 15 em $v0 (código da chamada do sistema para imprimir)
        syscall            # Faz a chamada do sistema para imprimir o conteúdo convertido

        # Imprime espaço
        lw    $a0, -4($sp) # Carrega o valor localizado em -4($sp) 
        la    $a1, espaco  # Carrega o endereço da variável 'espaco' em $a1
        li    $a2, 1       # Carrega o valor 1 em $a2 (tamanho máximo de impressão)
        li    $v0, 15      # Carrega o valor 15 em $v0 (código da chamada do sistema para imprimir)
        syscall            # Faz a chamada do sistema para imprimir o espaço

        # Incrementa o valor do endereço em 4 bytes
        lw    $t0, 8($sp)  # Carrega o valor localizado em 8($sp) 
        addiu $t0, $t0, 4  # Incrementa o valor em $t0 em 4
        sw    $t0, 8($sp)  # Armazena o valor incrementado em 8($sp)
	
	# vai para o label codigo_maquina
	
###################################################################################################################################################################

codigo_maquina:
	# converte o codigo de maquina que esta em hexa para string
	lw    $a0, 4($sp)     # Carrega o valor da pilha (endereço do código em hexadecimal) em $a0
	la    $a1, buffer     # Carrega o endereço da string de destino (buffer) em $a1
	
	jal hex_string   # Chama a função 'hex_para_string' para converter o código em hexadecimal para string
	
	# Imprime o conteúdo convertido em hexadecimal
	lw    $a0, -4($sp)    # Carrega o valor da pilha (endereço do código em hexadecimal) em $a0
	la    $a1, buffer     # Carrega o endereço da string a ser impressa (buffer) em $a1
	li    $a2, 10         # Carrega o valor 10 em $a2 (tamanho da string a ser impressa)
	li    $v0, 15         # Carrega o valor 15 em $v0 (código da chamada do sistema para imprimir string)
	syscall               # Faz a chamada do sistema para imprimir a string
	
	# Imprime espaço
	lw    $a0, -4($sp)    # Carrega o valor da pilha (endereço do código em hexadecimal) em $a0
	la    $a1, espaco     # Carrega o endereço da string a ser impressa (espaco) em $a1
	li    $a2, 1          # Carrega o valor 1 em $a2 (tamanho da string a ser impressa)
	li    $v0, 15         # Carrega o valor 15 em $v0 (código da chamada do sistema para imprimir string)
	syscall               # Faz a chamada do sistema para imprimir a string
	
	# vai para o label 'codigo_assembly'
	
###################################################################################################################################################################
	
codigo_assembly:
	lw    $t4, 4($sp)    # $t4 contem a linha que está na pilha
        
	# Identificação instrução	
	# Extrair campos da instrução
	#PARA O OPCODE FORMATO R                  #PARA O OPCODE FORMATO I                #PARA O OPCODE FORMATO J
	# $s0 = opcode       6 bits               # $s0 = opcode       6 bits             # $s0 = opcode                     6 bits 
	# $s1 = rs           5 bits               # $s1 = rs           5 bits---------
	# $s2 = rt           5 bits               # $s2 = rt           5 bits         |
	# $s3 = rd           5 bits----------                                         |-> # $s1 or $s2 or $s3 or $s4 or $s5  26 bits
	# $s4 = shamt        5 bits         |->   # $s3 or $s4 or $s5  16 bits        |
	# $s5 = funct        6 bits----------                                ----------

	srl $s0, $t4, 26     # Desloca a instrução 26 bits para a direita para extrair o campo OPCODE
	and $s0, $s0, 0x3F   # Aplica uma máscara de bits para manter apenas os 6 bits do campo OPCODE
	
	srl $s1, $t4, 21     # Desloca a instrução 21 bits para a direita para extrair o campo RS (registrador de origem 1)
	and $s1, $s1, 0x1F   # Aplica uma máscara de bits para manter apenas os 5 bits do campo RS
	
	srl $s2, $t4, 16     # Desloca a instrução 16 bits para a direita para extrair o campo Rt (registrador de origem 2)
	and $s2, $s2, 0x1F   # Aplica uma máscara de bits para manter apenas os 5 bits do campo Rt
	
	srl $s3, $t4, 11     # Desloca a instrução 11 bits para a direita para extrair o campo RD (registrador de destino)
	and $s3, $s3, 0x1F   # Aplica uma máscara de bits para manter apenas os 5 bits do campo RD

	srl $s4, $t4, 6      # Desloca a instrução 6 bits para a direita para extrair o campo shamt
	and $s4, $s4, 0x1F   # Aplica uma máscara de bits para manter apenas os 5 bits do campo shamt
	
	and $s5, $t4, 0x3F   # Aplica uma máscara de bits para manter apenas os 6 bits do campo funct

	# Os campos estão agora armazenados em $s0, $s1, $s2, $s3, $s4 e $s5

###################################################################################################################################################################

	# Verificar o valor do opcode
	beq $s0, 0x02, opcode_J  # Se opcode for 0x2 (store), ir para o rótulo 'opcode_J'
	beq $s0, 0x03, opcode_J  # Se opcode for 0x3 (store), ir para o rótulo 'opcode_J'
	
	beq $s0, 0x00, opcode_R  # Se opcode for 0x00 (load), ir para o rótulo 'opcode_R'
	beq $s0, 0x1c, local_mul # Se opcode for 0x1c (load), ir para o rótulo 'local_mul'
			
	j opcode_I              # Se opcode não for o nem 2, ir para o rótulo 'opcode_I'
	
###################################################################################################################################################################

opcode_J:
 	# Concatena os registradores $s1,$s2,$s3,$s4,$s5
    	sll $s1, $s1, 21       # Desloca o registrador $s1 para a posição correta (26-6+5 = 25)
    	sll $s2, $s2, 16       # Desloca o registrador $s2 para a posição correta (26-6+5+5 = 21)
	sll $s3, $s3, 11       # Desloca o registrador $s3 para a posição correta (26-6+5+5+5 = 16)
	sll $s4, $s4, 6        # Desloca o registrador $s4 para a posição correta (26-6+5+5+5+5 = 11)
    	or $s1, $s1, $s2       # Concatena $s1 e $s2
    	or $s1, $s1, $s3       # Concatena $s1, $s2 e $s3
    	or $s1, $s1, $s4       # Concatena $s1, $s2, $s3 e $s4
    	or $s1, $s1, $s5  	# Concatena $s1, $s2, $s3, $s4 e $s5

    	# Código para instruções J
    	beq $s0, 0x02, local_jump           # Se opcode for 0x2 (store), ir para o rótulo 'local_jump'
	beq $s0, 0x03, local_jump_and_link  # Se opcode for 0x3 (store), ir para o rótulo 'local_jump_and_link'
    	
local_jump:    	
	# Escreve a instrução no arquivo
    	lw    $a0, -4($sp)    # Carrega o valor da pilha (stack) no registrador $a0
    	la    $a1, op_j       # Carrega o endereço da string "op_j" no registrador $a1
    	li    $a2, 2          # Carrega o valor 2 no registrador $a2
    	li    $v0, 15         # Carrega o valor 15 (código de serviço para escrever string) no registrador $v0
    	syscall               # Chama a syscall para escrever a string com a instrução, o endereço e o valor

	# Escreve um espaço
	jal escreve_espaco     # Chama a função 'escreve_espaco' para escrever um espaço

    	# Escreve o endereço (IMM) no arquivo
   	move  $a0, $s1        # Move o valor do registrador $s1 para o registrador $a0
    	la    $a1, buffer     # Carrega o endereço da string "buffer" no registrador $a1
    	jal   hex_string      # Chama a função hex_string, passando $a0 e $a1 como argumentos
    	lw    $a0, -4($sp)    # Carrega o valor da pilha (stack) no registrador $a0
    	la    $a1, buffer     # Carrega o endereço da string "buffer" no registrador $a1
    	li    $a2, 10         # Carrega o valor 10 no registrador $a2
    	li    $v0, 15         # Carrega o valor 15 (código de serviço para escrever string) no registrador $v0
    	syscall               # Chama a syscall para escrever a string com o endereço e o valor

    	# Ajuste para próxima linha
	jal ajuste_proxima_linha

	j le_arquivo            # Pula para o label 'le_arquivo'
    	
local_jump_and_link:    	
	# Escreve a instrução no arquivo
    	lw    $a0, -4($sp)    # Carrega o valor da pilha (stack) no registrador $a0
    	la    $a1, op_jal     # Carrega o endereço da string "op_jal" no registrador $a1
    	li    $a2, 3          # Carrega o valor 3 no registrador $a2
    	li    $v0, 15         # Carrega o valor 15 (código de serviço para escrever string) no registrador $v0
    	syscall               # Chama a syscall para escrever a string com a instrução, o endereço e o valor

	# Escreve um espaço
	jal escreve_espaco     # Chama a função 'escreve_espaco' para escrever um espaço

    	# Escreve o endereço (IMM) no arquivo
   	move  $a0, $s1        # Move o valor do registrador $s1 para o registrador $a0
    	la    $a1, buffer     # Carrega o endereço da string "buffer" no registrador $a1
    	jal   hex_string      # Chama a função hex_string, passando $a0 e $a1 como argumentos
    	lw    $a0, -4($sp)    # Carrega o valor da pilha (stack) no registrador $a0
    	la    $a1, buffer     # Carrega o endereço da string "buffer" no registrador $a1
    	li    $a2, 10         # Carrega o valor 10 no registrador $a2
    	li    $v0, 15         # Carrega o valor 15 (código de serviço para escrever string) no registrador $v0
    	syscall               # Chama a syscall para escrever a string com o endereço e o valor

    	# Ajuste para próxima linha
	jal ajuste_proxima_linha

	j le_arquivo           # Pula para o label 'le_arquivo'

###################################################################################################################################################################

opcode_R:
    	# Código para instruções R
    	beq  $s5, 0x00, local_sll 
	beq  $s5, 0x02, local_srl 
	beq  $s5, 0x08, local_jr
	beq  $s5, 0x0c, local_syscall
	beq  $s5, 0x20, local_add
	beq  $s5, 0x21, local_addu 
	beq  $s5, 0x22, local_sub
	beq  $s5, 0x23, local_subu
	beq  $s5, 0x24, local_and  
	beq  $s5, 0x25, local_or
	beq  $s5, 0x26, local_xor    
	beq  $s5, 0x27, local_nor
    	beq  $s5, 0x2a, local_slt
    	beq  $s5, 0x2b, local_sltu

local_sll: 
	# Escreve a instrução no arquivo
    	lw    $a0, -4($sp)     # Carrega o valor da pilha (stack) no registrador $a0
    	la    $a1, op_sll      # Carrega o endereço da string "op_sll" no registrador $a1
    	li    $a2, 3           # Carrega o valor 3 no registrador $a2
    	li    $v0, 15          # Carrega o valor 15 (código de serviço para escrever string) no registrador $v0
    	syscall                # Chama a syscall para escrever a string com a instrução, o endereço e o valor
	
	# Escreve um espaço
	jal escreve_espaco     # Chama a função 'escreve_espaco' para escrever um espaço

	# Escreve primeiro registrador
	move $t0, $s1		# Move o valor de $s1 para $t0 (cópia)
	move $s1, $s3          # Move o valor de $s3 para $s1 (argumento para a função "registrador")
	jal   registrador      # Chama a função "registrador" para escrever o primeiro registrador

	lw    $a0, -4($sp)     # Carrega o valor de -4($sp) em $a0 (argumento para a função syscall)
	# Escreve uma vírgula
	jal escreve_virgula	# Chama a função 'escreve_virgula' para escrever uma vírgula

	# Escreve um espaço
	jal escreve_espaco     # Chama a função 'escreve_espaco' para escrever um espaço

	# Escreve segundo registrador
	move $s1, $s2          # Move o valor de $s2 para $s1 (Restaura valor)
	jal   registrador      # Chama a função "registrador" para escrever o segundo registrador

	lw    $a0, -4($sp)     # Carrega o valor de -4($sp) em $a0 (argumento para a função syscall)
	# Escreve uma vírgula
	jal escreve_virgula	# Chama a função 'escreve_virgula' para escrever uma vírgula

	# Escreve um espaço
	jal escreve_espaco     # Chama a função 'escreve_espaco' para escrever um espaço

	# Escreve o shamt no arquivo
   	move  $a0, $s4        # Move o valor do registrador $s4 para o registrador $a0
    	la    $a1, buffer     # Carrega o endereço da string "buffer" no registrador $a1
    	jal   hex_string      # Chama a função hex_string, passando $a0 e $a1 como argumentos
    	lw    $a0, -4($sp)    # Carrega o valor da pilha (stack) no registrador $a0
    	la    $a1, buffer     # Carrega o endereço da string "buffer" no registrador $a1
    	li    $a2, 10         # Carrega o valor 10 no registrador $a2
    	li    $v0, 15         # Carrega o valor 15 (código de serviço para escrever string) no registrador $v0
    	syscall               # Chama a syscall para escrever a string com o endereço e o valor

	# Ajuste para próxima linha
	jal ajuste_proxima_linha

	j le_arquivo           # Pula para o label 'le_arquivo'

local_srl: 
	# Escreve a instrução no arquivo
    	lw    $a0, -4($sp)     # Carrega o valor da pilha (stack) no registrador $a0
    	la    $a1, op_srl      # Carrega o endereço da string "op_srl" no registrador $a1
    	li    $a2, 3           # Carrega o valor 3 no registrador $a2
    	li    $v0, 15          # Carrega o valor 15 (código de serviço para escrever string) no registrador $v0
    	syscall                # Chama a syscall para escrever a string com a instrução, o endereço e o valor
	
	# Escreve um espaço
	jal escreve_espaco     # Chama a função 'escreve_espaco' para escrever um espaço

	# Escreve primeiro registrador
	move $t0, $s1		# Move o valor de $s1 para $t0 (cópia)
	move $s1, $s3          # Move o valor de $s3 para $s1 (argumento para a função "registrador")
	jal   registrador      # Chama a função "registrador" para escrever o primeiro registrador

	lw    $a0, -4($sp)     # Carrega o valor de -4($sp) em $a0 (argumento para a função syscall)
	# Escreve uma vírgula
	jal escreve_virgula	# Chama a função 'escreve_virgula' para escrever uma vírgula

	# Escreve um espaço
	jal escreve_espaco     # Chama a função 'escreve_espaco' para escrever um espaço

	# Escreve segundo registrador
	move $s1, $s2          # Move o valor de $s2 para $s1 (Restaura valor)
	jal   registrador      # Chama a função "registrador" para escrever o segundo registrador

	lw    $a0, -4($sp)     # Carrega o valor de -4($sp) em $a0 (argumento para a função syscall)
	# Escreve uma vírgula
	jal escreve_virgula	# Chama a função 'escreve_virgula' para escrever uma vírgula

	# Escreve um espaço
	jal escreve_espaco     # Chama a função 'escreve_espaco' para escrever um espaço

	# Escreve o shamt no arquivo
   	move  $a0, $s4        # Move o valor do registrador $s4 para o registrador $a0
    	la    $a1, buffer     # Carrega o endereço da string "buffer" no registrador $a1
    	jal   hex_string      # Chama a função hex_string, passando $a0 e $a1 como argumentos
    	lw    $a0, -4($sp)    # Carrega o valor da pilha (stack) no registrador $a0
    	la    $a1, buffer     # Carrega o endereço da string "buffer" no registrador $a1
    	li    $a2, 10         # Carrega o valor 10 no registrador $a2
    	li    $v0, 15         # Carrega o valor 15 (código de serviço para escrever string) no registrador $v0
    	syscall               # Chama a syscall para escrever a string com o endereço e o valor

	# Ajuste para próxima linha
	jal ajuste_proxima_linha

	j le_arquivo           # Pula para o label 'le_arquivo'

local_jr:
	# Escreve a instrução no arquivo
    	lw    $a0, -4($sp)     # Carrega o valor da pilha (stack) no registrador $a0
    	la    $a1, op_jr       # Carrega o endereço da string "op_jr" no registrador $a1
    	li    $a2, 2           # Carrega o valor 2 no registrador $a2
    	li    $v0, 15          # Carrega o valor 15 (código de serviço para escrever string) no registrador $v0
    	syscall                # Chama a syscall para escrever a string com a instrução, o endereço e o valor
	
	# Escreve um espaço
	jal escreve_espaco     # Chama a função 'escreve_espaco' para escrever um espaço

	# Escreve primeiro registrador
	jal   registrador      # Chama a função "registrador" para escrever o primeiro registrador

	# Ajuste para próxima linha
	jal ajuste_proxima_linha

	j le_arquivo           # Pula para o label 'le_arquivo'
		
local_syscall:
	# Escreve a instrução no arquivo
    	lw    $a0, -4($sp)    # Carrega o valor da pilha (stack) no registrador $a0
    	la    $a1, op_syscall # Carrega o endereço da string "op_syscall" no registrador $a1
    	li    $a2, 7          # Carrega o valor 3 no registrador $a2
    	li    $v0, 15         # Carrega o valor 15 (código de serviço para escrever string) no registrador $v0
    	syscall               # Chama a syscall para escrever a string com a instrução, o endereço e o valor
	
	# Ajuste para próxima linha
	jal ajuste_proxima_linha
	
	j le_arquivo           # Pula para o label 'le_arquivo'

local_add:
	# Escreve a instrução no arquivo
    	lw    $a0, -4($sp)     # Carrega o valor da pilha (stack) no registrador $a0
    	la    $a1, op_add      # Carrega o endereço da string "op_add" no registrador $a1
    	li    $a2, 3           # Carrega o valor 3 no registrador $a2
    	li    $v0, 15          # Carrega o valor 15 (código de serviço para escrever string) no registrador $v0
    	syscall                # Chama a syscall para escrever a string com a instrução, o endereço e o valor
	
	# Escreve um espaço
	jal escreve_espaco     # Chama a função 'escreve_espaco' para escrever um espaço

	# Escreve primeiro registrador
	move $t0, $s1		# Move o valor de $s1 para $t0 (cópia)
	move $s1, $s3          # Move o valor de $s3 para $s1 (argumento para a função "registrador")
	jal   registrador      # Chama a função "registrador" para escrever o primeiro registrador

	lw    $a0, -4($sp)     # Carrega o valor de -4($sp) em $a0 (argumento para a função syscall)
	# Escreve uma vírgula
	jal escreve_virgula	# Chama a função 'escreve_virgula' para escrever uma vírgula

	# Escreve um espaço
	jal escreve_espaco     # Chama a função 'escreve_espaco' para escrever um espaço

	# Escreve segundo registrador
	move $s1, $t0          # Move o valor de $t0 para $s1 (Restaura valor)
	jal   registrador      # Chama a função "registrador" para escrever o segundo registrador

	lw    $a0, -4($sp)     # Carrega o valor de -4($sp) em $a0 (argumento para a função syscall)
	# Escreve uma vírgula
	jal escreve_virgula	# Chama a função 'escreve_virgula' para escrever uma vírgula

	# Escreve um espaço
	jal escreve_espaco     # Chama a função 'escreve_espaco' para escrever um espaço

	# Escreve terceiro registrador
	move $s1, $s2          # Move o valor de $s2 para $s1 (argumento para a função "registrador")
	jal   registrador      # Chama a função "registrador" para escrever o terceiro registrador
 
	# Ajuste para próxima linha
	jal ajuste_proxima_linha

	j le_arquivo           # Pula para o label 'le_arquivo'

local_addu:
	# Escreve a instrução no arquivo
    	lw    $a0, -4($sp)     # Carrega o valor da pilha (stack) no registrador $a0
    	la    $a1, op_addu      # Carrega o endereço da string "op_addu" no registrador $a1
    	li    $a2, 4           # Carrega o valor 4 no registrador $a2
    	li    $v0, 15          # Carrega o valor 15 (código de serviço para escrever string) no registrador $v0
    	syscall                # Chama a syscall para escrever a string com a instrução, o endereço e o valor
	
	# Escreve um espaço
	jal escreve_espaco     # Chama a função 'escreve_espaco' para escrever um espaço

	# Escreve primeiro registrador
	move $t0, $s1		# Move o valor de $s1 para $t0 (cópia)
	move $s1, $s3          # Move o valor de $s3 para $s1 (argumento para a função "registrador")
	jal   registrador      # Chama a função "registrador" para escrever o primeiro registrador

	lw    $a0, -4($sp)     # Carrega o valor de -4($sp) em $a0 (argumento para a função syscall)
	# Escreve uma vírgula
	jal escreve_virgula	# Chama a função 'escreve_virgula' para escrever uma vírgula

	# Escreve um espaço
	jal escreve_espaco     # Chama a função 'escreve_espaco' para escrever um espaço

	# Escreve segundo registrador
	move $s1, $t0          # Move o valor de $t0 para $s1 (Restaura valor)
	jal   registrador      # Chama a função "registrador" para escrever o segundo registrador

	lw    $a0, -4($sp)     # Carrega o valor de -4($sp) em $a0 (argumento para a função syscall)
	# Escreve uma vírgula
	jal escreve_virgula	# Chama a função 'escreve_virgula' para escrever uma vírgula

	# Escreve um espaço
	jal escreve_espaco     # Chama a função 'escreve_espaco' para escrever um espaço

	# Escreve terceiro registrador
	move $s1, $s2          # Move o valor de $s2 para $s1 (argumento para a função "registrador")
	jal   registrador      # Chama a função "registrador" para escrever o terceiro registrador
 
	# Ajuste para próxima linha
	jal ajuste_proxima_linha

	j le_arquivo           # Pula para o label 'le_arquivo'

local_sub:
	# Escreve a instrução no arquivo
    	lw    $a0, -4($sp)     # Carrega o valor da pilha (stack) no registrador $a0
    	la    $a1, op_sub      # Carrega o endereço da string "op_sub" no registrador $a1
    	li    $a2, 3           # Carrega o valor 3 no registrador $a2
    	li    $v0, 15          # Carrega o valor 15 (código de serviço para escrever string) no registrador $v0
    	syscall                # Chama a syscall para escrever a string com a instrução, o endereço e o valor
	
	# Escreve um espaço
	jal escreve_espaco     # Chama a função 'escreve_espaco' para escrever um espaço

	# Escreve primeiro registrador
	move $t0, $s1		# Move o valor de $s1 para $t0 (cópia)
	move $s1, $s3          # Move o valor de $s3 para $s1 (argumento para a função "registrador")
	jal   registrador      # Chama a função "registrador" para escrever o primeiro registrador

	lw    $a0, -4($sp)     # Carrega o valor de -4($sp) em $a0 (argumento para a função syscall)
	# Escreve uma vírgula
	jal escreve_virgula	# Chama a função 'escreve_virgula' para escrever uma vírgula

	# Escreve um espaço
	jal escreve_espaco     # Chama a função 'escreve_espaco' para escrever um espaço

	# Escreve segundo registrador
	move $s1, $t0          # Move o valor de $t0 para $s1 (Restaura valor)
	jal   registrador      # Chama a função "registrador" para escrever o segundo registrador

	lw    $a0, -4($sp)     # Carrega o valor de -4($sp) em $a0 (argumento para a função syscall)
	# Escreve uma vírgula
	jal escreve_virgula	# Chama a função 'escreve_virgula' para escrever uma vírgula

	# Escreve um espaço
	jal escreve_espaco     # Chama a função 'escreve_espaco' para escrever um espaço

	# Escreve terceiro registrador
	move $s1, $s2          # Move o valor de $s2 para $s1 (argumento para a função "registrador")
	jal   registrador      # Chama a função "registrador" para escrever o terceiro registrador
 
	# Ajuste para próxima linha
	jal ajuste_proxima_linha

	j le_arquivo           # Pula para o label 'le_arquivo'

local_subu:
	# Escreve a instrução no arquivo
    	lw    $a0, -4($sp)     # Carrega o valor da pilha (stack) no registrador $a0
    	la    $a1, op_subu     # Carrega o endereço da string "op_subu" no registrador $a1
    	li    $a2, 4           # Carrega o valor 4 no registrador $a2
    	li    $v0, 15          # Carrega o valor 15 (código de serviço para escrever string) no registrador $v0
    	syscall                # Chama a syscall para escrever a string com a instrução, o endereço e o valor
	
	# Escreve um espaço
	jal escreve_espaco     # Chama a função 'escreve_espaco' para escrever um espaço

	# Escreve primeiro registrador
	move $t0, $s1		# Move o valor de $s1 para $t0 (cópia)
	move $s1, $s3          # Move o valor de $s3 para $s1 (argumento para a função "registrador")
	jal   registrador      # Chama a função "registrador" para escrever o primeiro registrador

	lw    $a0, -4($sp)     # Carrega o valor de -4($sp) em $a0 (argumento para a função syscall)
	# Escreve uma vírgula
	jal escreve_virgula	# Chama a função 'escreve_virgula' para escrever uma vírgula

	# Escreve um espaço
	jal escreve_espaco     # Chama a função 'escreve_espaco' para escrever um espaço

	# Escreve segundo registrador
	move $s1, $t0          # Move o valor de $t0 para $s1 (Restaura valor)
	jal   registrador      # Chama a função "registrador" para escrever o segundo registrador

	lw    $a0, -4($sp)     # Carrega o valor de -4($sp) em $a0 (argumento para a função syscall)
	# Escreve uma vírgula
	jal escreve_virgula	# Chama a função 'escreve_virgula' para escrever uma vírgula

	# Escreve um espaço
	jal escreve_espaco     # Chama a função 'escreve_espaco' para escrever um espaço

	# Escreve terceiro registrador
	move $s1, $s2          # Move o valor de $s2 para $s1 (argumento para a função "registrador")
	jal   registrador      # Chama a função "registrador" para escrever o terceiro registrador
 
	# Ajuste para próxima linha
	jal ajuste_proxima_linha

	j le_arquivo           # Pula para o label 'le_arquivo'

local_and:
	# Escreve a instrução no arquivo
    	lw    $a0, -4($sp)     # Carrega o valor da pilha (stack) no registrador $a0
    	la    $a1, op_and      # Carrega o endereço da string "op_and" no registrador $a1
    	li    $a2, 3           # Carrega o valor 3 no registrador $a2
    	li    $v0, 15          # Carrega o valor 15 (código de serviço para escrever string) no registrador $v0
    	syscall                # Chama a syscall para escrever a string com a instrução, o endereço e o valor
	
	# Escreve um espaço
	jal escreve_espaco     # Chama a função 'escreve_espaco' para escrever um espaço

	# Escreve primeiro registrador
	move $t0, $s1		# Move o valor de $s1 para $t0 (cópia)
	move $s1, $s3          # Move o valor de $s3 para $s1 (argumento para a função "registrador")
	jal   registrador      # Chama a função "registrador" para escrever o primeiro registrador

	lw    $a0, -4($sp)     # Carrega o valor de -4($sp) em $a0 (argumento para a função syscall)
	# Escreve uma vírgula
	jal escreve_virgula	# Chama a função 'escreve_virgula' para escrever uma vírgula

	# Escreve um espaço
	jal escreve_espaco     # Chama a função 'escreve_espaco' para escrever um espaço

	# Escreve segundo registrador
	move $s1, $t0          # Move o valor de $t0 para $s1 (Restaura valor)
	jal   registrador      # Chama a função "registrador" para escrever o segundo registrador

	lw    $a0, -4($sp)     # Carrega o valor de -4($sp) em $a0 (argumento para a função syscall)
	# Escreve uma vírgula
	jal escreve_virgula	# Chama a função 'escreve_virgula' para escrever uma vírgula

	# Escreve um espaço
	jal escreve_espaco     # Chama a função 'escreve_espaco' para escrever um espaço

	# Escreve terceiro registrador
	move $s1, $s2          # Move o valor de $s2 para $s1 (argumento para a função "registrador")
	jal   registrador      # Chama a função "registrador" para escrever o terceiro registrador
 
	# Ajuste para próxima linha
	jal ajuste_proxima_linha

	j le_arquivo           # Pula para o label 'le_arquivo'


local_or:
	# Escreve a instrução no arquivo
    	lw    $a0, -4($sp)     # Carrega o valor da pilha (stack) no registrador $a0
    	la    $a1, op_or       # Carrega o endereço da string "op_or" no registrador $a1
    	li    $a2, 2           # Carrega o valor 2 no registrador $a2
    	li    $v0, 15          # Carrega o valor 15 (código de serviço para escrever string) no registrador $v0
    	syscall                # Chama a syscall para escrever a string com a instrução, o endereço e o valor
	
	# Escreve um espaço
	jal escreve_espaco     # Chama a função 'escreve_espaco' para escrever um espaço

	# Escreve primeiro registrador
	move $t0, $s1		# Move o valor de $s1 para $t0 (cópia)
	move $s1, $s3          # Move o valor de $s3 para $s1 (argumento para a função "registrador")
	jal   registrador      # Chama a função "registrador" para escrever o primeiro registrador

	lw    $a0, -4($sp)     # Carrega o valor de -4($sp) em $a0 (argumento para a função syscall)
	# Escreve uma vírgula
	jal escreve_virgula	# Chama a função 'escreve_virgula' para escrever uma vírgula

	# Escreve um espaço
	jal escreve_espaco     # Chama a função 'escreve_espaco' para escrever um espaço

	# Escreve segundo registrador
	move $s1, $t0          # Move o valor de $t0 para $s1 (Restaura valor)
	jal   registrador      # Chama a função "registrador" para escrever o segundo registrador

	lw    $a0, -4($sp)     # Carrega o valor de -4($sp) em $a0 (argumento para a função syscall)
	# Escreve uma vírgula
	jal escreve_virgula	# Chama a função 'escreve_virgula' para escrever uma vírgula

	# Escreve um espaço
	jal escreve_espaco     # Chama a função 'escreve_espaco' para escrever um espaço

	# Escreve terceiro registrador
	move $s1, $s2          # Move o valor de $s2 para $s1 (argumento para a função "registrador")
	jal   registrador      # Chama a função "registrador" para escrever o terceiro registrador
 
	# Ajuste para próxima linha
	jal ajuste_proxima_linha

	j le_arquivo           # Pula para o label 'le_arquivo'

local_xor:
	# Escreve a instrução no arquivo
    	lw    $a0, -4($sp)     # Carrega o valor da pilha (stack) no registrador $a0
    	la    $a1, op_xor      # Carrega o endereço da string "op_xor" no registrador $a1
    	li    $a2, 3           # Carrega o valor 3 no registrador $a2
    	li    $v0, 15          # Carrega o valor 15 (código de serviço para escrever string) no registrador $v0
    	syscall                # Chama a syscall para escrever a string com a instrução, o endereço e o valor
	
	# Escreve um espaço
	jal escreve_espaco     # Chama a função 'escreve_espaco' para escrever um espaço

	# Escreve primeiro registrador
	move $t0, $s1		# Move o valor de $s1 para $t0 (cópia)
	move $s1, $s3          # Move o valor de $s3 para $s1 (argumento para a função "registrador")
	jal   registrador      # Chama a função "registrador" para escrever o primeiro registrador

	lw    $a0, -4($sp)     # Carrega o valor de -4($sp) em $a0 (argumento para a função syscall)
	# Escreve uma vírgula
	jal escreve_virgula	# Chama a função 'escreve_virgula' para escrever uma vírgula

	# Escreve um espaço
	jal escreve_espaco     # Chama a função 'escreve_espaco' para escrever um espaço

	# Escreve segundo registrador
	move $s1, $t0          # Move o valor de $t0 para $s1 (Restaura valor)
	jal   registrador      # Chama a função "registrador" para escrever o segundo registrador

	lw    $a0, -4($sp)     # Carrega o valor de -4($sp) em $a0 (argumento para a função syscall)
	# Escreve uma vírgula
	jal escreve_virgula	# Chama a função 'escreve_virgula' para escrever uma vírgula

	# Escreve um espaço
	jal escreve_espaco     # Chama a função 'escreve_espaco' para escrever um espaço

	# Escreve terceiro registrador
	move $s1, $s2          # Move o valor de $s2 para $s1 (argumento para a função "registrador")
	jal   registrador      # Chama a função "registrador" para escrever o terceiro registrador
 
	# Ajuste para próxima linha
	jal ajuste_proxima_linha

	j le_arquivo           # Pula para o label 'le_arquivo'

local_nor: 
	# Escreve a instrução no arquivo
    	lw    $a0, -4($sp)     # Carrega o valor da pilha (stack) no registrador $a0
    	la    $a1, op_nor      # Carrega o endereço da string "op_nor" no registrador $a1
    	li    $a2, 3           # Carrega o valor 3 no registrador $a2
    	li    $v0, 15          # Carrega o valor 15 (código de serviço para escrever string) no registrador $v0
    	syscall                # Chama a syscall para escrever a string com a instrução, o endereço e o valor
	
	# Escreve um espaço
	jal escreve_espaco     # Chama a função 'escreve_espaco' para escrever um espaço

	# Escreve primeiro registrador
	move $t0, $s1		# Move o valor de $s1 para $t0 (cópia)
	move $s1, $s3          # Move o valor de $s3 para $s1 (argumento para a função "registrador")
	jal   registrador      # Chama a função "registrador" para escrever o primeiro registrador

	lw    $a0, -4($sp)     # Carrega o valor de -4($sp) em $a0 (argumento para a função syscall)
	# Escreve uma vírgula
	jal escreve_virgula	# Chama a função 'escreve_virgula' para escrever uma vírgula

	# Escreve um espaço
	jal escreve_espaco     # Chama a função 'escreve_espaco' para escrever um espaço

	# Escreve segundo registrador
	move $s1, $t0          # Move o valor de $t0 para $s1 (Restaura valor)
	jal   registrador      # Chama a função "registrador" para escrever o segundo registrador

	lw    $a0, -4($sp)     # Carrega o valor de -4($sp) em $a0 (argumento para a função syscall)
	# Escreve uma vírgula
	jal escreve_virgula	# Chama a função 'escreve_virgula' para escrever uma vírgula

	# Escreve um espaço
	jal escreve_espaco     # Chama a função 'escreve_espaco' para escrever um espaço

	# Escreve terceiro registrador
	move $s1, $s2          # Move o valor de $s2 para $s1 (argumento para a função "registrador")
	jal   registrador      # Chama a função "registrador" para escrever o terceiro registrador
 
	# Ajuste para próxima linha
	jal ajuste_proxima_linha

	j le_arquivo           # Pula para o label 'le_arquivo'

local_slt:
	# Escreve a instrução no arquivo
    	lw    $a0, -4($sp)     # Carrega o valor da pilha (stack) no registrador $a0
    	la    $a1, op_slt      # Carrega o endereço da string "op_slt" no registrador $a1
    	li    $a2, 3           # Carrega o valor 3 no registrador $a2
    	li    $v0, 15          # Carrega o valor 15 (código de serviço para escrever string) no registrador $v0
    	syscall                # Chama a syscall para escrever a string com a instrução, o endereço e o valor
	
	# Escreve um espaço
	jal escreve_espaco     # Chama a função 'escreve_espaco' para escrever um espaço

	# Escreve primeiro registrador
	move $t0, $s1		# Move o valor de $s1 para $t0 (cópia)
	move $s1, $s3          # Move o valor de $s3 para $s1 (argumento para a função "registrador")
	jal   registrador      # Chama a função "registrador" para escrever o primeiro registrador

	lw    $a0, -4($sp)     # Carrega o valor de -4($sp) em $a0 (argumento para a função syscall)
	# Escreve uma vírgula
	jal escreve_virgula	# Chama a função 'escreve_virgula' para escrever uma vírgula

	# Escreve um espaço
	jal escreve_espaco     # Chama a função 'escreve_espaco' para escrever um espaço

	# Escreve segundo registrador
	move $s1, $t0          # Move o valor de $t0 para $s1 (Restaura valor)
	jal   registrador      # Chama a função "registrador" para escrever o segundo registrador

	lw    $a0, -4($sp)     # Carrega o valor de -4($sp) em $a0 (argumento para a função syscall)
	# Escreve uma vírgula
	jal escreve_virgula	# Chama a função 'escreve_virgula' para escrever uma vírgula

	# Escreve um espaço
	jal escreve_espaco     # Chama a função 'escreve_espaco' para escrever um espaço

	# Escreve terceiro registrador
	move $s1, $s2          # Move o valor de $s2 para $s1 (argumento para a função "registrador")
	jal   registrador      # Chama a função "registrador" para escrever o terceiro registrador
 
	# Ajuste para próxima linha
	jal ajuste_proxima_linha

	j le_arquivo           # Pula para o label 'le_arquivo'

local_sltu:
	# Escreve a instrução no arquivo
    	lw    $a0, -4($sp)     # Carrega o valor da pilha (stack) no registrador $a0
    	la    $a1, op_sltu     # Carrega o endereço da string "op_sltu" no registrador $a1
    	li    $a2, 4           # Carrega o valor 4 no registrador $a2
    	li    $v0, 15          # Carrega o valor 15 (código de serviço para escrever string) no registrador $v0
    	syscall                # Chama a syscall para escrever a string com a instrução, o endereço e o valor
	
	# Escreve um espaço
	jal escreve_espaco     # Chama a função 'escreve_espaco' para escrever um espaço

	# Escreve primeiro registrador
	move $t0, $s1		# Move o valor de $s1 para $t0 (cópia)
	move $s1, $s3          # Move o valor de $s3 para $s1 (argumento para a função "registrador")
	jal   registrador      # Chama a função "registrador" para escrever o primeiro registrador

	lw    $a0, -4($sp)     # Carrega o valor de -4($sp) em $a0 (argumento para a função syscall)
	# Escreve uma vírgula
	jal escreve_virgula	# Chama a função 'escreve_virgula' para escrever uma vírgula

	# Escreve um espaço
	jal escreve_espaco     # Chama a função 'escreve_espaco' para escrever um espaço

	# Escreve segundo registrador
	move $s1, $t0          # Move o valor de $t0 para $s1 (Restaura valor)
	jal   registrador      # Chama a função "registrador" para escrever o segundo registrador

	lw    $a0, -4($sp)     # Carrega o valor de -4($sp) em $a0 (argumento para a função syscall)
	# Escreve uma vírgula
	jal escreve_virgula	# Chama a função 'escreve_virgula' para escrever uma vírgula

	# Escreve um espaço
	jal escreve_espaco     # Chama a função 'escreve_espaco' para escrever um espaço

	# Escreve terceiro registrador
	move $s1, $s2          # Move o valor de $s2 para $s1 (argumento para a função "registrador")
	jal   registrador      # Chama a função "registrador" para escrever o terceiro registrador
 
	# Ajuste para próxima linha
	jal ajuste_proxima_linha

	j le_arquivo           # Pula para o label 'le_arquivo'
	
local_mul:
	# Escreve a instrução no arquivo
    	lw    $a0, -4($sp)     # Carrega o valor da pilha (stack) no registrador $a0
    	la    $a1, op_mul      # Carrega o endereço da string "op_mul" no registrador $a1
    	li    $a2, 3           # Carrega o valor 3 no registrador $a2
    	li    $v0, 15          # Carrega o valor 15 (código de serviço para escrever string) no registrador $v0
    	syscall                # Chama a syscall para escrever a string com a instrução, o endereço e o valor
	
	# Escreve um espaço
	jal escreve_espaco     # Chama a função 'escreve_espaco' para escrever um espaço

	# Escreve primeiro registrador
	move $t0, $s1		# Move o valor de $s1 para $t0 (cópia)
	move $s1, $s3          # Move o valor de $s3 para $s1 (argumento para a função "registrador")
	jal   registrador      # Chama a função "registrador" para escrever o primeiro registrador

	lw    $a0, -4($sp)     # Carrega o valor de -4($sp) em $a0 (argumento para a função syscall)
	# Escreve uma vírgula
	jal escreve_virgula	# Chama a função 'escreve_virgula' para escrever uma vírgula

	# Escreve um espaço
	jal escreve_espaco     # Chama a função 'escreve_espaco' para escrever um espaço

	# Escreve segundo registrador
	move $s1, $t0          # Move o valor de $t0 para $s1 (Restaura valor)
	jal   registrador      # Chama a função "registrador" para escrever o segundo registrador

	lw    $a0, -4($sp)     # Carrega o valor de -4($sp) em $a0 (argumento para a função syscall)
	# Escreve uma vírgula
	jal escreve_virgula	# Chama a função 'escreve_virgula' para escrever uma vírgula

	# Escreve um espaço
	jal escreve_espaco     # Chama a função 'escreve_espaco' para escrever um espaço

	# Escreve terceiro registrador
	move $s1, $s2          # Move o valor de $s2 para $s1 (argumento para a função "registrador")
	jal   registrador      # Chama a função "registrador" para escrever o terceiro registrador
 
	# Ajuste para próxima linha
	jal ajuste_proxima_linha

	j le_arquivo           # Pula para o label 'le_arquivo'
   
###################################################################################################################################################################
	
opcode_I:
	# Concatena os registradores $s3,$s4,$s5
	sll $s3, $s3, 11       # Desloca o registrador $s3 para a posição correta (26-6+5+5+5 = 16)
	sll $s4, $s4, 6        # Desloca o registrador $s4 para a posição correta (26-6+5+5+5+5 = 11)
    	or $s3, $s3, $s4       # Concatena $s3 e $s4
    	or $s3, $s3, $s5       # Concatena $s3, $s4 e $s5

	# Código para instruções I
	beq   $s0, 0x04, local_beq
	beq   $s0, 0x05, local_bne
	beq   $s0, 0x08, local_addi
	beq   $s0, 0x09, local_addiu
	beq   $s0, 0x0a, local_slti
	beq   $s0, 0x0b, local_sltiu
	beq   $s0, 0x0c, local_andi
	beq   $s0, 0x0d, local_ori
	beq   $s0, 0x0e, local_xori
	beq   $s0, 0x0f, local_lui
	beq   $s0, 0x20, local_lb
	beq   $s0, 0x21, local_lh
	beq   $s0, 0x23, local_lw
	beq   $s0, 0x24, local_lbu
	beq   $s0, 0x25, local_lhu
	beq   $s0, 0x28, local_sb
	beq   $s0, 0x29, local_sh
	beq   $s0, 0x30, local_ll
	beq   $s0, 0x38, local_sc
	beq   $s0, 0x2b, local_sw

local_beq:
	# Escreve a instrução no arquivo
    	lw    $a0, -4($sp)     # Carrega o valor da pilha (stack) no registrador $a0
    	la    $a1, op_beq      # Carrega o endereço da string "op_beq" no registrador $a1
    	li    $a2, 3           # Carrega o valor 3 no registrador $a2
    	li    $v0, 15          # Carrega o valor 15 (código de serviço para escrever string) no registrador $v0
    	syscall                # Chama a syscall para escrever a string com a instrução, o endereço e o valor
	
	# Escreve um espaço
	jal escreve_espaco     # Chama a função 'escreve_espaco' para escrever um espaço

	# Escreve primeiro registrador
	jal   registrador      # Chama a função "registrador" para escrever o primeiro registrador

	lw    $a0, -4($sp)     # Carrega o valor de -4($sp) em $a0 (argumento para a função syscall)
	# Escreve uma vírgula
	jal escreve_virgula	# Chama a função 'escreve_virgula' para escrever uma vírgula

	# Escreve um espaço
	jal escreve_espaco     # Chama a função 'escreve_espaco' para escrever um espaço
	
	# Escreve segundo registrador
	move $s1, $s2          # Move o valor de $s2 para $s1 (argumento para a função "registrador")
	jal   registrador      # Chama a função "registrador" para escrever o segundo registrador
	
	lw    $a0, -4($sp)     # Carrega o valor de -4($sp) em $a0 (argumento para a função syscall)
	# Escreve uma vírgula
	jal escreve_virgula	# Chama a função 'escreve_virgula' para escrever uma vírgula

	# Escreve um espaço
	jal escreve_espaco     # Chama a função 'escreve_espaco' para escrever um espaço
	
	# Escreve o endereço (IMM) no arquivo
   	move  $a0, $s3        # Move o valor do registrador $s3 para o registrador $a0
    	la    $a1, buffer     # Carrega o endereço da string "buffer" no registrador $a1
    	jal   hex_string      # Chama a função hex_string, passando $a0 e $a1 como argumentos
    	lw    $a0, -4($sp)    # Carrega o valor da pilha (stack) no registrador $a0
    	la    $a1, buffer     # Carrega o endereço da string "buffer" no registrador $a1
    	li    $a2, 10         # Carrega o valor 10 no registrador $a2
    	li    $v0, 15         # Carrega o valor 15 (código de serviço para escrever string) no registrador $v0
    	syscall               # Chama a syscall para escrever a string com o endereço e o valor
	
	# Ajuste para próxima linha
	jal ajuste_proxima_linha

	j le_arquivo           # Pula para o label 'le_arquivo'

local_bne:
    	# Escreve a instrução no arquivo
    	lw    $a0, -4($sp)     # Carrega o valor da pilha (stack) no registrador $a0
    	la    $a1, op_bne      # Carrega o endereço da string "op_bne" no registrador $a1
    	li    $a2, 3           # Carrega o valor 3 no registrador $a2
    	li    $v0, 15          # Carrega o valor 15 (código de serviço para escrever string) no registrador $v0
    	syscall                # Chama a syscall para escrever a string com a instrução, o endereço e o valor
	
	# Escreve um espaço
	jal escreve_espaco     # Chama a função 'escreve_espaco' para escrever um espaço

	# Escreve primeiro registrador
	jal   registrador      # Chama a função "registrador" para escrever o primeiro registrador

	lw    $a0, -4($sp)     # Carrega o valor de -4($sp) em $a0 (argumento para a função syscall)
	# Escreve uma vírgula
	jal escreve_virgula	# Chama a função 'escreve_virgula' para escrever uma vírgula

	# Escreve um espaço
	jal escreve_espaco     # Chama a função 'escreve_espaco' para escrever um espaço
	
	# Escreve segundo registrador
	move $s1, $s2          # Move o valor de $s2 para $s1 (argumento para a função "registrador")
	jal   registrador      # Chama a função "registrador" para escrever o segundo registrador
	
	lw    $a0, -4($sp)     # Carrega o valor de -4($sp) em $a0 (argumento para a função syscall)
	# Escreve uma vírgula
	jal escreve_virgula	# Chama a função 'escreve_virgula' para escrever uma vírgula

	# Escreve um espaço
	jal escreve_espaco     # Chama a função 'escreve_espaco' para escrever um espaço
	
	# Escreve o endereço (IMM) no arquivo
   	move  $a0, $s3        # Move o valor do registrador $s3 para o registrador $a0
    	la    $a1, buffer     # Carrega o endereço da string "buffer" no registrador $a1
    	jal   hex_string      # Chama a função hex_string, passando $a0 e $a1 como argumentos
    	lw    $a0, -4($sp)    # Carrega o valor da pilha (stack) no registrador $a0
    	la    $a1, buffer     # Carrega o endereço da string "buffer" no registrador $a1
    	li    $a2, 10         # Carrega o valor 10 no registrador $a2
    	li    $v0, 15         # Carrega o valor 15 (código de serviço para escrever string) no registrador $v0
    	syscall               # Chama a syscall para escrever a string com o endereço e o valor
	
	# Ajuste para próxima linha
	jal ajuste_proxima_linha

	j le_arquivo           # Pula para o label 'le_arquivo'

local_addi:
	# Escreve a instrução no arquivo
    	lw    $a0, -4($sp)     # Carrega o valor da pilha (stack) no registrador $a0
    	la    $a1, op_addi     # Carrega o endereço da string "op_addi" no registrador $a1
    	li    $a2, 4           # Carrega o valor 4 no registrador $a2
    	li    $v0, 15          # Carrega o valor 15 (código de serviço para escrever string) no registrador $v0
    	syscall                # Chama a syscall para escrever a string com a instrução, o endereço e o valor
	
	# Escreve um espaço
	jal escreve_espaco     # Chama a função 'escreve_espaco' para escrever um espaço

	# Escreve primeiro registrador
	move $t0, $s1          # Move o valor de $s1 para $t0 (Cópia)
	move $s1, $s2		# Move o valor de $s2 para $s1 (argumento para a função "registrador")
	jal   registrador      # Chama a função "registrador" para escrever o primeiro registrador

	lw    $a0, -4($sp)     # Carrega o valor de -4($sp) em $a0 (argumento para a função syscall)
	# Escreve uma vírgula
	jal escreve_virgula	# Chama a função 'escreve_virgula' para escrever uma vírgula

	# Escreve um espaço
	jal escreve_espaco     # Chama a função 'escreve_espaco' para escrever um espaço
	
	# Escreve segundo registrador
	move $s1, $t0          # Move o valor de $t0 para $s1 (Restaura valor)
	jal   registrador      # Chama a função "registrador" para escrever o segundo registrador
	
	lw    $a0, -4($sp)     # Carrega o valor de -4($sp) em $a0 (argumento para a função syscall)
	# Escreve uma vírgula
	jal escreve_virgula	# Chama a função 'escreve_virgula' para escrever uma vírgula

	# Escreve um espaço
	jal escreve_espaco     # Chama a função 'escreve_espaco' para escrever um espaço
	
	# Escreve o endereço (IMM) no arquivo
   	move  $a0, $s3        # Move o valor do registrador $s3 para o registrador $a0
    	la    $a1, buffer     # Carrega o endereço da string "buffer" no registrador $a1
    	jal   hex_string      # Chama a função hex_string, passando $a0 e $a1 como argumentos
    	lw    $a0, -4($sp)    # Carrega o valor da pilha (stack) no registrador $a0
    	la    $a1, buffer     # Carrega o endereço da string "buffer" no registrador $a1
    	li    $a2, 10         # Carrega o valor 10 no registrador $a2
    	li    $v0, 15         # Carrega o valor 15 (código de serviço para escrever string) no registrador $v0
    	syscall               # Chama a syscall para escrever a string com o endereço e o valor
	
	# Ajuste para próxima linha
	jal ajuste_proxima_linha

	j le_arquivo           # Pula para o label 'le_arquivo'

local_addiu:
	# Escreve a instrução no arquivo
    	lw    $a0, -4($sp)     # Carrega o valor da pilha (stack) no registrador $a0
    	la    $a1, op_addiu    # Carrega o endereço da string "op_addiu" no registrador $a1
    	li    $a2, 5           # Carrega o valor 5 no registrador $a2
    	li    $v0, 15          # Carrega o valor 15 (código de serviço para escrever string) no registrador $v0
    	syscall                # Chama a syscall para escrever a string com a instrução, o endereço e o valor
		
	# Escreve um espaço
	jal escreve_espaco     # Chama a função 'escreve_espaco' para escrever um espaço

	# Escreve primeiro registrador
	move $t0, $s1          # Move o valor de $s1 para $t0 (Cópia)
	move $s1, $s2		# Move o valor de $s2 para $s1 (argumento para a função "registrador")
	jal   registrador      # Chama a função "registrador" para escrever o primeiro registrador

	lw    $a0, -4($sp)     # Carrega o valor de -4($sp) em $a0 (argumento para a função syscall)
	# Escreve uma vírgula
	jal escreve_virgula	# Chama a função 'escreve_virgula' para escrever uma vírgula

	# Escreve um espaço
	jal escreve_espaco     # Chama a função 'escreve_espaco' para escrever um espaço
	
	# Escreve segundo registrador
	move $s1, $t0          # Move o valor de $t0 para $s1 (Restaura valor)
	jal   registrador      # Chama a função "registrador" para escrever o segundo registrador
	
	lw    $a0, -4($sp)     # Carrega o valor de -4($sp) em $a0 (argumento para a função syscall)
	# Escreve uma vírgula
	jal escreve_virgula	# Chama a função 'escreve_virgula' para escrever uma vírgula

	# Escreve um espaço
	jal escreve_espaco     # Chama a função 'escreve_espaco' para escrever um espaço
	
	# Escreve o endereço (IMM) no arquivo
   	move  $a0, $s3        # Move o valor do registrador $s3 para o registrador $a0
    	la    $a1, buffer     # Carrega o endereço da string "buffer" no registrador $a1
    	jal   hex_string      # Chama a função hex_string, passando $a0 e $a1 como argumentos
    	lw    $a0, -4($sp)    # Carrega o valor da pilha (stack) no registrador $a0
    	la    $a1, buffer     # Carrega o endereço da string "buffer" no registrador $a1
    	li    $a2, 10         # Carrega o valor 10 no registrador $a2
    	li    $v0, 15         # Carrega o valor 15 (código de serviço para escrever string) no registrador $v0
    	syscall               # Chama a syscall para escrever a string com o endereço e o valor
	
	# Ajuste para próxima linha
	jal ajuste_proxima_linha

	j le_arquivo           # Pula para o label 'le_arquivo'

local_slti:
	# Escreve a instrução no arquivo
    	lw    $a0, -4($sp)     # Carrega o valor da pilha (stack) no registrador $a0
    	la    $a1, op_slti     # Carrega o endereço da string "op_slti" no registrador $a1
    	li    $a2, 4           # Carrega o valor 4 no registrador $a2
    	li    $v0, 15          # Carrega o valor 15 (código de serviço para escrever string) no registrador $v0
    	syscall                # Chama a syscall para escrever a string com a instrução, o endereço e o valor
	
	# Escreve um espaço
	jal escreve_espaco     # Chama a função 'escreve_espaco' para escrever um espaço

	# Escreve primeiro registrador
	move $t0, $s1          # Move o valor de $s1 para $t0 (Cópia)
	move $s1, $s2		# Move o valor de $s2 para $s1 (argumento para a função "registrador")
	jal   registrador      # Chama a função "registrador" para escrever o primeiro registrador

	lw    $a0, -4($sp)     # Carrega o valor de -4($sp) em $a0 (argumento para a função syscall)
	# Escreve uma vírgula
	jal escreve_virgula	# Chama a função 'escreve_virgula' para escrever uma vírgula

	# Escreve um espaço
	jal escreve_espaco     # Chama a função 'escreve_espaco' para escrever um espaço
	
	# Escreve segundo registrador
	move $s1, $t0          # Move o valor de $t0 para $s1 (Restaura valor)
	jal   registrador      # Chama a função "registrador" para escrever o segundo registrador
	
	lw    $a0, -4($sp)     # Carrega o valor de -4($sp) em $a0 (argumento para a função syscall)
	# Escreve uma vírgula
	jal escreve_virgula	# Chama a função 'escreve_virgula' para escrever uma vírgula

	# Escreve um espaço
	jal escreve_espaco     # Chama a função 'escreve_espaco' para escrever um espaço
	
	# Escreve o endereço (IMM) no arquivo
   	move  $a0, $s3        # Move o valor do registrador $s3 para o registrador $a0
    	la    $a1, buffer     # Carrega o endereço da string "buffer" no registrador $a1
    	jal   hex_string      # Chama a função hex_string, passando $a0 e $a1 como argumentos
    	lw    $a0, -4($sp)    # Carrega o valor da pilha (stack) no registrador $a0
    	la    $a1, buffer     # Carrega o endereço da string "buffer" no registrador $a1
    	li    $a2, 10         # Carrega o valor 10 no registrador $a2
    	li    $v0, 15         # Carrega o valor 15 (código de serviço para escrever string) no registrador $v0
    	syscall               # Chama a syscall para escrever a string com o endereço e o valor
	
	# Ajuste para próxima linha
	jal ajuste_proxima_linha

	j le_arquivo           # Pula para o label 'le_arquivo'

local_sltiu:
	# Escreve a instrução no arquivo
    	lw    $a0, -4($sp)     # Carrega o valor da pilha (stack) no registrador $a0
    	la    $a1, op_sltiu    # Carrega o endereço da string "op_sltiu" no registrador $a1
    	li    $a2, 5           # Carrega o valor 5 no registrador $a2
    	li    $v0, 15          # Carrega o valor 15 (código de serviço para escrever string) no registrador $v0
    	syscall                # Chama a syscall para escrever a string com a instrução, o endereço e o valor
	
	# Escreve um espaço
	jal escreve_espaco     # Chama a função 'escreve_espaco' para escrever um espaço

	# Escreve primeiro registrador
	move $t0, $s1          # Move o valor de $s1 para $t0 (Cópia)
	move $s1, $s2		# Move o valor de $s2 para $s1 (argumento para a função "registrador")
	jal   registrador      # Chama a função "registrador" para escrever o primeiro registrador

	lw    $a0, -4($sp)     # Carrega o valor de -4($sp) em $a0 (argumento para a função syscall)
	# Escreve uma vírgula
	jal escreve_virgula	# Chama a função 'escreve_virgula' para escrever uma vírgula

	# Escreve um espaço
	jal escreve_espaco     # Chama a função 'escreve_espaco' para escrever um espaço
	
	# Escreve segundo registrador
	move $s1, $t0          # Move o valor de $t0 para $s1 (Restaura valor)
	jal   registrador      # Chama a função "registrador" para escrever o segundo registrador
	
	lw    $a0, -4($sp)     # Carrega o valor de -4($sp) em $a0 (argumento para a função syscall)
	# Escreve uma vírgula
	jal escreve_virgula	# Chama a função 'escreve_virgula' para escrever uma vírgula

	# Escreve um espaço
	jal escreve_espaco     # Chama a função 'escreve_espaco' para escrever um espaço
	
	# Escreve o endereço (IMM) no arquivo
   	move  $a0, $s3        # Move o valor do registrador $s3 para o registrador $a0
    	la    $a1, buffer     # Carrega o endereço da string "buffer" no registrador $a1
    	jal   hex_string      # Chama a função hex_string, passando $a0 e $a1 como argumentos
    	lw    $a0, -4($sp)    # Carrega o valor da pilha (stack) no registrador $a0
    	la    $a1, buffer     # Carrega o endereço da string "buffer" no registrador $a1
    	li    $a2, 10         # Carrega o valor 10 no registrador $a2
    	li    $v0, 15         # Carrega o valor 15 (código de serviço para escrever string) no registrador $v0
    	syscall               # Chama a syscall para escrever a string com o endereço e o valor
	
	# Ajuste para próxima linha
	jal ajuste_proxima_linha

	j le_arquivo           # Pula para o label 'le_arquivo'

local_andi:
	# Escreve a instrução no arquivo
    	lw    $a0, -4($sp)     # Carrega o valor da pilha (stack) no registrador $a0
    	la    $a1, op_andi     # Carrega o endereço da string "op_andi" no registrador $a1
    	li    $a2, 4           # Carrega o valor 4 no registrador $a2
    	li    $v0, 15          # Carrega o valor 15 (código de serviço para escrever string) no registrador $v0
    	syscall                # Chama a syscall para escrever a string com a instrução, o endereço e o valor
	
	# Escreve um espaço
	jal escreve_espaco     # Chama a função 'escreve_espaco' para escrever um espaço

	# Escreve primeiro registrador
	move $t0, $s1          # Move o valor de $s1 para $t0 (Cópia)
	move $s1, $s2		# Move o valor de $s2 para $s1 (argumento para a função "registrador")
	jal   registrador      # Chama a função "registrador" para escrever o primeiro registrador

	lw    $a0, -4($sp)     # Carrega o valor de -4($sp) em $a0 (argumento para a função syscall)
	# Escreve uma vírgula
	jal escreve_virgula	# Chama a função 'escreve_virgula' para escrever uma vírgula

	# Escreve um espaço
	jal escreve_espaco     # Chama a função 'escreve_espaco' para escrever um espaço
	
	# Escreve segundo registrador
	move $s1, $t0          # Move o valor de $t0 para $s1 (Restaura valor)
	jal   registrador      # Chama a função "registrador" para escrever o segundo registrador
	
	lw    $a0, -4($sp)     # Carrega o valor de -4($sp) em $a0 (argumento para a função syscall)
	# Escreve uma vírgula
	jal escreve_virgula	# Chama a função 'escreve_virgula' para escrever uma vírgula

	# Escreve um espaço
	jal escreve_espaco     # Chama a função 'escreve_espaco' para escrever um espaço
	
	# Escreve o endereço (IMM) no arquivo
   	move  $a0, $s3        # Move o valor do registrador $s3 para o registrador $a0
    	la    $a1, buffer     # Carrega o endereço da string "buffer" no registrador $a1
    	jal   hex_string      # Chama a função hex_string, passando $a0 e $a1 como argumentos
    	lw    $a0, -4($sp)    # Carrega o valor da pilha (stack) no registrador $a0
    	la    $a1, buffer     # Carrega o endereço da string "buffer" no registrador $a1
    	li    $a2, 10         # Carrega o valor 10 no registrador $a2
    	li    $v0, 15         # Carrega o valor 15 (código de serviço para escrever string) no registrador $v0
    	syscall               # Chama a syscall para escrever a string com o endereço e o valor
	
	# Ajuste para próxima linha
	jal ajuste_proxima_linha

	j le_arquivo           # Pula para o label 'le_arquivo'

local_ori:
	# Escreve a instrução no arquivo
    	lw    $a0, -4($sp)     # Carrega o valor da pilha (stack) no registrador $a0
    	la    $a1, op_ori      # Carrega o endereço da string "op_ori" no registrador $a1
    	li    $a2, 3           # Carrega o valor 3 no registrador $a2
    	li    $v0, 15          # Carrega o valor 15 (código de serviço para escrever string) no registrador $v0
    	syscall                # Chama a syscall para escrever a string com a instrução, o endereço e o valor
	
	# Escreve um espaço
	jal escreve_espaco     # Chama a função 'escreve_espaco' para escrever um espaço

	# Escreve primeiro registrador
	move $t0, $s1          # Move o valor de $s1 para $t0 (Cópia)
	move $s1, $s2		# Move o valor de $s2 para $s1 (argumento para a função "registrador")
	jal   registrador      # Chama a função "registrador" para escrever o primeiro registrador

	lw    $a0, -4($sp)     # Carrega o valor de -4($sp) em $a0 (argumento para a função syscall)
	# Escreve uma vírgula
	jal escreve_virgula	# Chama a função 'escreve_virgula' para escrever uma vírgula

	# Escreve um espaço
	jal escreve_espaco     # Chama a função 'escreve_espaco' para escrever um espaço
	
	# Escreve segundo registrador
	move $s1, $t0          # Move o valor de $t0 para $s1 (Restaura valor)
	jal   registrador      # Chama a função "registrador" para escrever o segundo registrador
	
	lw    $a0, -4($sp)     # Carrega o valor de -4($sp) em $a0 (argumento para a função syscall)
	# Escreve uma vírgula
	jal escreve_virgula	# Chama a função 'escreve_virgula' para escrever uma vírgula

	# Escreve um espaço
	jal escreve_espaco     # Chama a função 'escreve_espaco' para escrever um espaço
	
	# Escreve o endereço (IMM) no arquivo
   	move  $a0, $s3        # Move o valor do registrador $s3 para o registrador $a0
    	la    $a1, buffer     # Carrega o endereço da string "buffer" no registrador $a1
    	jal   hex_string      # Chama a função hex_string, passando $a0 e $a1 como argumentos
    	lw    $a0, -4($sp)    # Carrega o valor da pilha (stack) no registrador $a0
    	la    $a1, buffer     # Carrega o endereço da string "buffer" no registrador $a1
    	li    $a2, 10         # Carrega o valor 10 no registrador $a2
    	li    $v0, 15         # Carrega o valor 15 (código de serviço para escrever string) no registrador $v0
    	syscall               # Chama a syscall para escrever a string com o endereço e o valor
	
	# Ajuste para próxima linha
	jal ajuste_proxima_linha

	j le_arquivo           # Pula para o label 'le_arquivo'

local_xori:
	# Escreve a instrução no arquivo
    	lw    $a0, -4($sp)     # Carrega o valor da pilha (stack) no registrador $a0
    	la    $a1, op_xori     # Carrega o endereço da string "op_xori" no registrador $a1
    	li    $a2, 4           # Carrega o valor 4 no registrador $a2
    	li    $v0, 15          # Carrega o valor 15 (código de serviço para escrever string) no registrador $v0
    	syscall                # Chama a syscall para escrever a string com a instrução, o endereço e o valor
	
	# Escreve um espaço
	jal escreve_espaco     # Chama a função 'escreve_espaco' para escrever um espaço

	# Escreve primeiro registrador
	move $t0, $s1          # Move o valor de $s1 para $t0 (Cópia)
	move $s1, $s2		# Move o valor de $s2 para $s1 (argumento para a função "registrador")
	jal   registrador      # Chama a função "registrador" para escrever o primeiro registrador

	lw    $a0, -4($sp)     # Carrega o valor de -4($sp) em $a0 (argumento para a função syscall)
	# Escreve uma vírgula
	jal escreve_virgula	# Chama a função 'escreve_virgula' para escrever uma vírgula

	# Escreve um espaço
	jal escreve_espaco     # Chama a função 'escreve_espaco' para escrever um espaço
	
	# Escreve segundo registrador
	move $s1, $t0          # Move o valor de $t0 para $s1 (Restaura valor)
	jal   registrador      # Chama a função "registrador" para escrever o segundo registrador
	
	lw    $a0, -4($sp)     # Carrega o valor de -4($sp) em $a0 (argumento para a função syscall)
	# Escreve uma vírgula
	jal escreve_virgula	# Chama a função 'escreve_virgula' para escrever uma vírgula

	# Escreve um espaço
	jal escreve_espaco     # Chama a função 'escreve_espaco' para escrever um espaço
	
	# Escreve o endereço (IMM) no arquivo
   	move  $a0, $s3        # Move o valor do registrador $s3 para o registrador $a0
    	la    $a1, buffer     # Carrega o endereço da string "buffer" no registrador $a1
    	jal   hex_string      # Chama a função hex_string, passando $a0 e $a1 como argumentos
    	lw    $a0, -4($sp)    # Carrega o valor da pilha (stack) no registrador $a0
    	la    $a1, buffer     # Carrega o endereço da string "buffer" no registrador $a1
    	li    $a2, 10         # Carrega o valor 10 no registrador $a2
    	li    $v0, 15         # Carrega o valor 15 (código de serviço para escrever string) no registrador $v0
    	syscall               # Chama a syscall para escrever a string com o endereço e o valor
	
	# Ajuste para próxima linha
	jal ajuste_proxima_linha

	j le_arquivo           # Pula para o label 'le_arquivo'

local_lui:
	# Escreve a instrução no arquivo
    	lw    $a0, -4($sp)     # Carrega o valor da pilha (stack) no registrador $a0
    	la    $a1, op_lui      # Carrega o endereço da string "op_lui" no registrador $a1
    	li    $a2, 3           # Carrega o valor 3 no registrador $a2
    	li    $v0, 15          # Carrega o valor 15 (código de serviço para escrever string) no registrador $v0
    	syscall                # Chama a syscall para escrever a string com a instrução, o endereço e o valor
	
	# Escreve um espaço
	jal escreve_espaco     # Chama a função 'escreve_espaco' para escrever um espaço

	# Escreve primeiro registrador
	move $s1, $s2          # Move o valor de $s2 para $s1 (argumento para a função "registrador")
	jal   registrador      # Chama a função "registrador" para escrever o segundo registrador
	
	lw    $a0, -4($sp)     # Carrega o valor de -4($sp) em $a0 (argumento para a função syscall)
	# Escreve uma vírgula
	jal escreve_virgula	# Chama a função 'escreve_virgula' para escrever uma vírgula

	# Escreve um espaço
	jal escreve_espaco     # Chama a função 'escreve_espaco' para escrever um espaço
	
	# Escreve o endereço (IMM) no arquivo
   	move  $a0, $s3        # Move o valor do registrador $s3 para o registrador $a0
    	la    $a1, buffer     # Carrega o endereço da string "buffer" no registrador $a1
    	jal   hex_string      # Chama a função hex_string, passando $a0 e $a1 como argumentos
    	lw    $a0, -4($sp)    # Carrega o valor da pilha (stack) no registrador $a0
    	la    $a1, buffer     # Carrega o endereço da string "buffer" no registrador $a1
    	li    $a2, 10         # Carrega o valor 10 no registrador $a2
    	li    $v0, 15         # Carrega o valor 15 (código de serviço para escrever string) no registrador $v0
    	syscall               # Chama a syscall para escrever a string com o endereço e o valor
	
	# Ajuste para próxima linha
	jal ajuste_proxima_linha

	j le_arquivo           # Pula para o label 'le_arquivo'

local_lb:
	# Escreve a instrução no arquivo
    	lw    $a0, -4($sp)     # Carrega o valor da pilha (stack) no registrador $a0
    	la    $a1, op_lb	# Carrega o endereço da string "op_lb" no registrador $a1
    	li    $a2, 2           # Carrega o valor 2 no registrador $a2
    	li    $v0, 15          # Carrega o valor 15 (código de serviço para escrever string) no registrador $v0
    	syscall                # Chama a syscall para escrever a string com a instrução, o endereço e o valor
	
	# Escreve um espaço
	jal escreve_espaco     # Chama a função 'escreve_espaco' para escrever um espaço

	# Escreve primeiro registrador
	move $t7, $s1          # Move o valor de $s1 para $t7 (Cópia)
	move $s1, $s2          # Move o valor de $s2 para $s1 (argumento para a função "registrador")
	jal   registrador      # Chama a função "registrador" para escrever o segundo registrador
	
	lw    $a0, -4($sp)     # Carrega o valor de -4($sp) em $a0 (argumento para a função syscall)
	# Escreve uma vírgula
	jal escreve_virgula	# Chama a função 'escreve_virgula' para escrever uma vírgula

	# Escreve um espaço
	jal escreve_espaco     # Chama a função 'escreve_espaco' para escrever um espaço
	
	# Escreve o endereço (IMM) no arquivo
   	move  $a0, $s3        # Move o valor do registrador $s3 para o registrador $a0
    	la    $a1, buffer     # Carrega o endereço da string "buffer" no registrador $a1
    	jal   hex_string      # Chama a função hex_string, passando $a0 e $a1 como argumentos
    	lw    $a0, -4($sp)    # Carrega o valor da pilha (stack) no registrador $a0
    	la    $a1, buffer     # Carrega o endereço da string "buffer" no registrador $a1
    	li    $a2, 10         # Carrega o valor 10 no registrador $a2
    	li    $v0, 15         # Carrega o valor 15 (código de serviço para escrever string) no registrador $v0
    	syscall               # Chama a syscall para escrever a string com o endereço e o valor
	
	# Escreve primeiro parêntese
	la    $a1, parentese_L  # Carrega o endereço da variável "parente_L" em $a1
	li    $a2, 1            # Carrega o valor 1 em $a2 (tamanho do parêntese a ser escrito) 
	li    $v0, 15           # Carrega o valor 15 em $v0 (código do syscall para escrever)
	syscall                 # Faz uma chamada de sistema para escrever a vírgula
	
	# Escreve segundo registrador
	move $s1, $t7          # Move o valor de $t7 para $s1 (Restaura valor) 
	jal   registrador      # Chama a função "registrador" para escrever o segundo registrador
	
	lw    $a0, -4($sp)     # Carrega o valor de -4($sp) em $a0 (argumento para a função syscall)
	# Escreve segundo parêntese
	la    $a1, parentese_R  # Carrega o endereço da variável "parente_R" em $a1
	li    $a2, 1            # Carrega o valor 1 em $a2 (tamanho do parêntese a ser escrito)
	li    $v0, 15           # Carrega o valor 15 em $v0 (código do syscall para escrever)
	syscall                 # Faz uma chamada de sistema para escrever a vírgula
	
	# Ajuste para próxima linha
	jal ajuste_proxima_linha

	j le_arquivo           # Pula para o label 'le_arquivo'

local_lh:
	# Escreve a instrução no arquivo
    	lw    $a0, -4($sp)     # Carrega o valor da pilha (stack) no registrador $a0
    	la    $a1, op_lh       # Carrega o endereço da string "op_lh" no registrador $a1
    	li    $a2, 2           # Carrega o valor 2 no registrador $a2
    	li    $v0, 15          # Carrega o valor 15 (código de serviço para escrever string) no registrador $v0
    	syscall                # Chama a syscall para escrever a string com a instrução, o endereço e o valor
	
	# Escreve um espaço
	jal escreve_espaco     # Chama a função 'escreve_espaco' para escrever um espaço

	# Escreve primeiro registrador
	move $t7, $s1          # Move o valor de $s1 para $t7 (Cópia)
	move $s1, $s2          # Move o valor de $s2 para $s1 (argumento para a função "registrador")
	jal   registrador      # Chama a função "registrador" para escrever o segundo registrador
	
	lw    $a0, -4($sp)     # Carrega o valor de -4($sp) em $a0 (argumento para a função syscall)
	# Escreve uma vírgula
	jal escreve_virgula	# Chama a função 'escreve_virgula' para escrever uma vírgula

	# Escreve um espaço
	jal escreve_espaco     # Chama a função 'escreve_espaco' para escrever um espaço
	
	# Escreve o endereço (IMM) no arquivo
   	move  $a0, $s3        # Move o valor do registrador $s3 para o registrador $a0
    	la    $a1, buffer     # Carrega o endereço da string "buffer" no registrador $a1
    	jal   hex_string      # Chama a função hex_string, passando $a0 e $a1 como argumentos
    	lw    $a0, -4($sp)    # Carrega o valor da pilha (stack) no registrador $a0
    	la    $a1, buffer     # Carrega o endereço da string "buffer" no registrador $a1
    	li    $a2, 10         # Carrega o valor 10 no registrador $a2
    	li    $v0, 15         # Carrega o valor 15 (código de serviço para escrever string) no registrador $v0
    	syscall               # Chama a syscall para escrever a string com o endereço e o valor
	
	# Escreve primeiro parêntese
	la    $a1, parentese_L  # Carrega o endereço da variável "parente_L" em $a1
	li    $a2, 1            # Carrega o valor 1 em $a2 (tamanho do parêntese a ser escrito)
	li    $v0, 15           # Carrega o valor 15 em $v0 (código do syscall para escrever)
	syscall                 # Faz uma chamada de sistema para escrever a vírgula
	
	# Escreve segundo registrador
	move $s1, $t7          # Move o valor de $t7 para $s1 (Restaura valor) 
	jal   registrador      # Chama a função "registrador" para escrever o segundo registrador
	
	lw    $a0, -4($sp)     # Carrega o valor de -4($sp) em $a0 (argumento para a função syscall)
	# Escreve segundo parêntese
	la    $a1, parentese_R  # Carrega o endereço da variável "parente_R" em $a1
	li    $a2, 1            # Carrega o valor 1 em $a2 (tamanho do parêntese a ser escrito)
	li    $v0, 15           # Carrega o valor 15 em $v0 (código do syscall para escrever)
	syscall                 # Faz uma chamada de sistema para escrever a vírgula
	
	# Ajuste para próxima linha
	jal ajuste_proxima_linha

	j le_arquivo           # Pula para o label 'le_arquivo'

local_lw:
	# Escreve a instrução no arquivo
    	lw    $a0, -4($sp)     # Carrega o valor da pilha (stack) no registrador $a0
    	la    $a1, op_lw       # Carrega o endereço da string "op_lw" no registrador $a1
    	li    $a2, 2           # Carrega o valor 2 no registrador $a2
    	li    $v0, 15          # Carrega o valor 15 (código de serviço para escrever string) no registrador $v0
    	syscall                # Chama a syscall para escrever a string com a instrução, o endereço e o valor
	
	# Escreve um espaço
	jal escreve_espaco     # Chama a função 'escreve_espaco' para escrever um espaço

	# Escreve primeiro registrador
	move $t7, $s1          # Move o valor de $s1 para $t7 (Cópia)
	move $s1, $s2          # Move o valor de $s2 para $s1 (argumento para a função "registrador")
	jal   registrador      # Chama a função "registrador" para escrever o segundo registrador
	
	lw    $a0, -4($sp)     # Carrega o valor de -4($sp) em $a0 (argumento para a função syscall)
	# Escreve uma vírgula
	jal escreve_virgula	# Chama a função 'escreve_virgula' para escrever uma vírgula

	# Escreve um espaço
	jal escreve_espaco     # Chama a função 'escreve_espaco' para escrever um espaço
	
	# Escreve o endereço (IMM) no arquivo
   	move  $a0, $s3        # Move o valor do registrador $s3 para o registrador $a0
    	la    $a1, buffer     # Carrega o endereço da string "buffer" no registrador $a1
    	jal   hex_string      # Chama a função hex_string, passando $a0 e $a1 como argumentos
    	lw    $a0, -4($sp)    # Carrega o valor da pilha (stack) no registrador $a0
    	la    $a1, buffer     # Carrega o endereço da string "buffer" no registrador $a1
    	li    $a2, 10         # Carrega o valor 10 no registrador $a2
    	li    $v0, 15         # Carrega o valor 15 (código de serviço para escrever string) no registrador $v0
    	syscall               # Chama a syscall para escrever a string com o endereço e o valor
	
	# Escreve primeiro parêntese
	la    $a1, parentese_L  # Carrega o endereço da variável "parente_L" em $a1
	li    $a2, 1            # Carrega o valor 1 em $a2 (tamanho do parêntese a ser escrito)
	li    $v0, 15           # Carrega o valor 15 em $v0 (código do syscall para escrever)
	syscall                 # Faz uma chamada de sistema para escrever a vírgula
	
	# Escreve segundo registrador
	move $s1, $t7          # Move o valor de $t7 para $s1 (Restaura valor) 
	jal   registrador      # Chama a função "registrador" para escrever o segundo registrador
	
	lw    $a0, -4($sp)     # Carrega o valor de -4($sp) em $a0 (argumento para a função syscall)
	# Escreve segundo parêntese
	la    $a1, parentese_R  # Carrega o endereço da variável "parente_R" em $a1
	li    $a2, 1            # Carrega o valor 1 em $a2 (tamanho do parêntese a ser escrito)
	li    $v0, 15           # Carrega o valor 15 em $v0 (código do syscall para escrever)
	syscall                 # Faz uma chamada de sistema para escrever a vírgula
	
	# Ajuste para próxima linha
	jal ajuste_proxima_linha

	j le_arquivo           # Pula para o label 'le_arquivo'

local_lbu:
	# Escreve a instrução no arquivo
    	lw    $a0, -4($sp)     # Carrega o valor da pilha (stack) no registrador $a0
    	la    $a1, op_lbu      # Carrega o endereço da string "op_lbu" no registrador $a1
    	li    $a2, 3           # Carrega o valor 3 no registrador $a2
    	li    $v0, 15          # Carrega o valor 15 (código de serviço para escrever string) no registrador $v0
    	syscall                # Chama a syscall para escrever a string com a instrução, o endereço e o valor
	
	# Escreve um espaço
	jal escreve_espaco     # Chama a função 'escreve_espaco' para escrever um espaço

	# Escreve primeiro registrador
	move $t7, $s1          # Move o valor de $s1 para $t7 (Cópia)
	move $s1, $s2          # Move o valor de $s2 para $s1 (argumento para a função "registrador")
	jal   registrador      # Chama a função "registrador" para escrever o segundo registrador
	
	lw    $a0, -4($sp)     # Carrega o valor de -4($sp) em $a0 (argumento para a função syscall)
	# Escreve uma vírgula
	jal escreve_virgula	# Chama a função 'escreve_virgula' para escrever uma vírgula

	# Escreve um espaço
	jal escreve_espaco     # Chama a função 'escreve_espaco' para escrever um espaço
	
	# Escreve o endereço (IMM) no arquivo
   	move  $a0, $s3        # Move o valor do registrador $s3 para o registrador $a0
    	la    $a1, buffer     # Carrega o endereço da string "buffer" no registrador $a1
    	jal   hex_string      # Chama a função hex_string, passando $a0 e $a1 como argumentos
    	lw    $a0, -4($sp)    # Carrega o valor da pilha (stack) no registrador $a0
    	la    $a1, buffer     # Carrega o endereço da string "buffer" no registrador $a1
    	li    $a2, 10         # Carrega o valor 10 no registrador $a2
    	li    $v0, 15         # Carrega o valor 15 (código de serviço para escrever string) no registrador $v0
    	syscall               # Chama a syscall para escrever a string com o endereço e o valor
	
	# Escreve primeiro parêntese
	la    $a1, parentese_L  # Carrega o endereço da variável "parente_L" em $a1
	li    $a2, 1            # Carrega o valor 1 em $a2 (tamanho do parêntese a ser escrito)
	li    $v0, 15           # Carrega o valor 15 em $v0 (código do syscall para escrever)
	syscall                 # Faz uma chamada de sistema para escrever a vírgula
	
	# Escreve segundo registrador
	move $s1, $t7          # Move o valor de $t7 para $s1 (Restaura valor) 
	jal   registrador      # Chama a função "registrador" para escrever o segundo registrador
	
	lw    $a0, -4($sp)     # Carrega o valor de -4($sp) em $a0 (argumento para a função syscall)
	# Escreve segundo parêntese
	la    $a1, parentese_R  # Carrega o endereço da variável "parente_R" em $a1
	li    $a2, 1            # Carrega o valor 1 em $a2 (tamanho do parêntese a ser escrito)
	li    $v0, 15           # Carrega o valor 15 em $v0 (código do syscall para escrever)
	syscall                 # Faz uma chamada de sistema para escrever a vírgula
	
	# Ajuste para próxima linha
	jal ajuste_proxima_linha

	j le_arquivo           # Pula para o label 'le_arquivo'

local_lhu:
	# Escreve a instrução no arquivo
    	lw    $a0, -4($sp)     # Carrega o valor da pilha (stack) no registrador $a0
    	la    $a1, op_lhu      # Carrega o endereço da string "op_lhu" no registrador $a1
    	li    $a2, 3           # Carrega o valor 3 no registrador $a2
    	li    $v0, 15          # Carrega o valor 15 (código de serviço para escrever string) no registrador $v0
    	syscall                # Chama a syscall para escrever a string com a instrução, o endereço e o valor
	
	# Escreve um espaço
	jal escreve_espaco     # Chama a função 'escreve_espaco' para escrever um espaço

	# Escreve primeiro registrador
	move $t7, $s1          # Move o valor de $s1 para $t7 (Cópia)
	move $s1, $s2          # Move o valor de $s2 para $s1 (argumento para a função "registrador")
	jal   registrador      # Chama a função "registrador" para escrever o segundo registrador
	
	lw    $a0, -4($sp)     # Carrega o valor de -4($sp) em $a0 (argumento para a função syscall)
	# Escreve uma vírgula
	jal escreve_virgula	# Chama a função 'escreve_virgula' para escrever uma vírgula

	# Escreve um espaço
	jal escreve_espaco     # Chama a função 'escreve_espaco' para escrever um espaço
	
	# Escreve o endereço (IMM) no arquivo
   	move  $a0, $s3        # Move o valor do registrador $s3 para o registrador $a0
    	la    $a1, buffer     # Carrega o endereço da string "buffer" no registrador $a1
    	jal   hex_string      # Chama a função hex_string, passando $a0 e $a1 como argumentos
    	lw    $a0, -4($sp)    # Carrega o valor da pilha (stack) no registrador $a0
    	la    $a1, buffer     # Carrega o endereço da string "buffer" no registrador $a1
    	li    $a2, 10         # Carrega o valor 10 no registrador $a2
    	li    $v0, 15         # Carrega o valor 15 (código de serviço para escrever string) no registrador $v0
    	syscall               # Chama a syscall para escrever a string com o endereço e o valor
	
	# Escreve primeiro parêntese
	la    $a1, parentese_L  # Carrega o endereço da variável "parente_L" em $a1
	li    $a2, 1            # Carrega o valor 1 em $a2 (tamanho do parêntese a ser escrito)
	li    $v0, 15           # Carrega o valor 15 em $v0 (código do syscall para escrever)
	syscall                 # Faz uma chamada de sistema para escrever a vírgula
	
	# Escreve segundo registrador
	move $s1, $t7          # Move o valor de $t7 para $s1 (Restaura valor) 
	jal   registrador      # Chama a função "registrador" para escrever o segundo registrador
	
	lw    $a0, -4($sp)     # Carrega o valor de -4($sp) em $a0 (argumento para a função syscall)
	# Escreve segundo parêntese
	la    $a1, parentese_R  # Carrega o endereço da variável "parente_R" em $a1
	li    $a2, 1            # Carrega o valor 1 em $a2 (tamanho do parêntese a ser escrito)
	li    $v0, 15           # Carrega o valor 15 em $v0 (código do syscall para escrever)
	syscall                 # Faz uma chamada de sistema para escrever a vírgula
	
	# Ajuste para próxima linha
	jal ajuste_proxima_linha

	j le_arquivo           # Pula para o label 'le_arquivo'

local_sb:
	# Escreve a instrução no arquivo
    	lw    $a0, -4($sp)     # Carrega o valor da pilha (stack) no registrador $a0
    	la    $a1, op_sb       # Carrega o endereço da string "op_sb" no registrador $a1
    	li    $a2, 2           # Carrega o valor 2 no registrador $a2
    	li    $v0, 15          # Carrega o valor 15 (código de serviço para escrever string) no registrador $v0
    	syscall                # Chama a syscall para escrever a string com a instrução, o endereço e o valor
	
	# Escreve um espaço
	jal escreve_espaco     # Chama a função 'escreve_espaco' para escrever um espaço

	# Escreve primeiro registrador
	move $t7, $s1          # Move o valor de $s1 para $t7 (Cópia)
	move $s1, $s2          # Move o valor de $s2 para $s1 (argumento para a função "registrador")
	jal   registrador      # Chama a função "registrador" para escrever o segundo registrador
	
	lw    $a0, -4($sp)     # Carrega o valor de -4($sp) em $a0 (argumento para a função syscall)
	# Escreve uma vírgula
	jal escreve_virgula	# Chama a função 'escreve_virgula' para escrever uma vírgula

	# Escreve um espaço
	jal escreve_espaco     # Chama a função 'escreve_espaco' para escrever um espaço
	
	# Escreve o endereço (IMM) no arquivo
   	move  $a0, $s3        # Move o valor do registrador $s3 para o registrador $a0
    	la    $a1, buffer     # Carrega o endereço da string "buffer" no registrador $a1
    	jal   hex_string      # Chama a função hex_string, passando $a0 e $a1 como argumentos
    	lw    $a0, -4($sp)    # Carrega o valor da pilha (stack) no registrador $a0
    	la    $a1, buffer     # Carrega o endereço da string "buffer" no registrador $a1
    	li    $a2, 10         # Carrega o valor 10 no registrador $a2
    	li    $v0, 15         # Carrega o valor 15 (código de serviço para escrever string) no registrador $v0
    	syscall               # Chama a syscall para escrever a string com o endereço e o valor
	
	# Escreve primeiro parêntese
	la    $a1, parentese_L  # Carrega o endereço da variável "parente_L" em $a1
	li    $a2, 1            # Carrega o valor 1 em $a2 (tamanho do parêntese a ser escrito)
	li    $v0, 15           # Carrega o valor 15 em $v0 (código do syscall para escrever)
	syscall                 # Faz uma chamada de sistema para escrever a vírgula
	
	# Escreve segundo registrador
	move $s1, $t7          # Move o valor de $t7 para $s1 (Restaura valor) 
	jal   registrador      # Chama a função "registrador" para escrever o segundo registrador
	
	lw    $a0, -4($sp)     # Carrega o valor de -4($sp) em $a0 (argumento para a função syscall)
	# Escreve segundo parêntese
	la    $a1, parentese_R  # Carrega o endereço da variável "parente_R" em $a1
	li    $a2, 1            # Carrega o valor 1 em $a2 (tamanho do parêntese a ser escrito)
	li    $v0, 15           # Carrega o valor 15 em $v0 (código do syscall para escrever)
	syscall                 # Faz uma chamada de sistema para escrever a vírgula
	
	# Ajuste para próxima linha
	jal ajuste_proxima_linha

	j le_arquivo           # Pula para o label 'le_arquivo'

local_sh:
	# Escreve a instrução no arquivo
    	lw    $a0, -4($sp)     # Carrega o valor da pilha (stack) no registrador $a0
    	la    $a1, op_sh       # Carrega o endereço da string "op_sh" no registrador $a1
    	li    $a2, 2           # Carrega o valor 2 no registrador $a2
    	li    $v0, 15          # Carrega o valor 15 (código de serviço para escrever string) no registrador $v0
    	syscall                # Chama a syscall para escrever a string com a instrução, o endereço e o valor
	
	# Escreve um espaço
	jal escreve_espaco     # Chama a função 'escreve_espaco' para escrever um espaço

	# Escreve primeiro registrador
	move $t7, $s1          # Move o valor de $s1 para $t7 (Cópia)
	move $s1, $s2          # Move o valor de $s2 para $s1 (argumento para a função "registrador")
	jal   registrador      # Chama a função "registrador" para escrever o segundo registrador
	
	lw    $a0, -4($sp)     # Carrega o valor de -4($sp) em $a0 (argumento para a função syscall)
	# Escreve uma vírgula
	jal escreve_virgula	# Chama a função 'escreve_virgula' para escrever uma vírgula

	# Escreve um espaço
	jal escreve_espaco     # Chama a função 'escreve_espaco' para escrever um espaço
	
	# Escreve o endereço (IMM) no arquivo
   	move  $a0, $s3        # Move o valor do registrador $s3 para o registrador $a0
    	la    $a1, buffer     # Carrega o endereço da string "buffer" no registrador $a1
    	jal   hex_string      # Chama a função hex_string, passando $a0 e $a1 como argumentos
    	lw    $a0, -4($sp)    # Carrega o valor da pilha (stack) no registrador $a0
    	la    $a1, buffer     # Carrega o endereço da string "buffer" no registrador $a1
    	li    $a2, 10         # Carrega o valor 10 no registrador $a2
    	li    $v0, 15         # Carrega o valor 15 (código de serviço para escrever string) no registrador $v0
    	syscall               # Chama a syscall para escrever a string com o endereço e o valor
	
	# Escreve primeiro parêntese
	la    $a1, parentese_L  # Carrega o endereço da variável "parente_L" em $a1
	li    $a2, 1            # Carrega o valor 1 em $a2 (tamanho do parêntese a ser escrito)
	li    $v0, 15           # Carrega o valor 15 em $v0 (código do syscall para escrever)
	syscall                 # Faz uma chamada de sistema para escrever a vírgula
	
	# Escreve segundo registrador
	move $s1, $t7          # Move o valor de $t7 para $s1 (Restaura valor) 
	jal   registrador      # Chama a função "registrador" para escrever o segundo registrador
	
	lw    $a0, -4($sp)     # Carrega o valor de -4($sp) em $a0 (argumento para a função syscall)
	# Escreve segundo parêntese
	la    $a1, parentese_R  # Carrega o endereço da variável "parente_R" em $a1
	li    $a2, 1            # Carrega o valor 1 em $a2 (tamanho do parêntese a ser escrito)
	li    $v0, 15           # Carrega o valor 15 em $v0 (código do syscall para escrever)
	syscall                 # Faz uma chamada de sistema para escrever a vírgula
	
	# Ajuste para próxima linha
	jal ajuste_proxima_linha

	j le_arquivo           # Pula para o label 'le_arquivo'

local_ll:
	# Escreve a instrução no arquivo
    	lw    $a0, -4($sp)     # Carrega o valor da pilha (stack) no registrador $a0
    	la    $a1, op_ll       # Carrega o endereço da string "op_ll" no registrador $a1
    	li    $a2, 2           # Carrega o valor 2 no registrador $a2
    	li    $v0, 15          # Carrega o valor 15 (código de serviço para escrever string) no registrador $v0
    	syscall                # Chama a syscall para escrever a string com a instrução, o endereço e o valor
	
	# Escreve um espaço
	jal escreve_espaco     # Chama a função 'escreve_espaco' para escrever um espaço

	# Escreve primeiro registrador
	move $t7, $s1          # Move o valor de $s1 para $t7 (Cópia)
	move $s1, $s2          # Move o valor de $s2 para $s1 (argumento para a função "registrador")
	jal   registrador      # Chama a função "registrador" para escrever o segundo registrador
	
	lw    $a0, -4($sp)     # Carrega o valor de -4($sp) em $a0 (argumento para a função syscall)
	# Escreve uma vírgula
	jal escreve_virgula	# Chama a função 'escreve_virgula' para escrever uma vírgula

	# Escreve um espaço
	jal escreve_espaco     # Chama a função 'escreve_espaco' para escrever um espaço
	
	# Escreve o endereço (IMM) no arquivo
   	move  $a0, $s3        # Move o valor do registrador $s3 para o registrador $a0
    	la    $a1, buffer     # Carrega o endereço da string "buffer" no registrador $a1
    	jal   hex_string      # Chama a função hex_string, passando $a0 e $a1 como argumentos
    	lw    $a0, -4($sp)    # Carrega o valor da pilha (stack) no registrador $a0
    	la    $a1, buffer     # Carrega o endereço da string "buffer" no registrador $a1
    	li    $a2, 10         # Carrega o valor 10 no registrador $a2
    	li    $v0, 15         # Carrega o valor 15 (código de serviço para escrever string) no registrador $v0
    	syscall               # Chama a syscall para escrever a string com o endereço e o valor
	
	# Escreve primeiro parêntese
	la    $a1, parentese_L  # Carrega o endereço da variável "parente_L" em $a1
	li    $a2, 1            # Carrega o valor 1 em $a2 (tamanho do parêntese a ser escrito)
	li    $v0, 15           # Carrega o valor 15 em $v0 (código do syscall para escrever)
	syscall                 # Faz uma chamada de sistema para escrever a vírgula
	
	# Escreve segundo registrador
	move $s1, $t7          # Move o valor de $t7 para $s1 (Restaura valor) 
	jal   registrador      # Chama a função "registrador" para escrever o segundo registrador
	
	lw    $a0, -4($sp)     # Carrega o valor de -4($sp) em $a0 (argumento para a função syscall)
	# Escreve segundo parêntese
	la    $a1, parentese_R  # Carrega o endereço da variável "parente_R" em $a1
	li    $a2, 1            # Carrega o valor 1 em $a2 (tamanho do parêntese a ser escrito)
	li    $v0, 15           # Carrega o valor 15 em $v0 (código do syscall para escrever)
	syscall                 # Faz uma chamada de sistema para escrever a vírgula
	
	# Ajuste para próxima linha
	jal ajuste_proxima_linha

	j le_arquivo           # Pula para o label 'le_arquivo'

local_sc:
	# Escreve a instrução no arquivo
    	lw    $a0, -4($sp)     # Carrega o valor da pilha (stack) no registrador $a0
    	la    $a1, op_sc       # Carrega o endereço da string "op_sc" no registrador $a1
    	li    $a2, 2           # Carrega o valor 2 no registrador $a2
    	li    $v0, 15          # Carrega o valor 15 (código de serviço para escrever string) no registrador $v0
    	syscall                # Chama a syscall para escrever a string com a instrução, o endereço e o valor
	
	# Escreve um espaço
	jal escreve_espaco     # Chama a função 'escreve_espaco' para escrever um espaço

	# Escreve primeiro registrador
	move $t7, $s1          # Move o valor de $s1 para $t7 (Cópia)
	move $s1, $s2          # Move o valor de $s2 para $s1 (argumento para a função "registrador")
	jal   registrador      # Chama a função "registrador" para escrever o segundo registrador
	
	lw    $a0, -4($sp)     # Carrega o valor de -4($sp) em $a0 (argumento para a função syscall)
	# Escreve uma vírgula
	jal escreve_virgula	# Chama a função 'escreve_virgula' para escrever uma vírgula

	# Escreve um espaço
	jal escreve_espaco     # Chama a função 'escreve_espaco' para escrever um espaço
	
	# Escreve o endereço (IMM) no arquivo
   	move  $a0, $s3        # Move o valor do registrador $s3 para o registrador $a0
    	la    $a1, buffer     # Carrega o endereço da string "buffer" no registrador $a1
    	jal   hex_string      # Chama a função hex_string, passando $a0 e $a1 como argumentos
    	lw    $a0, -4($sp)    # Carrega o valor da pilha (stack) no registrador $a0
    	la    $a1, buffer     # Carrega o endereço da string "buffer" no registrador $a1
    	li    $a2, 10         # Carrega o valor 10 no registrador $a2
    	li    $v0, 15         # Carrega o valor 15 (código de serviço para escrever string) no registrador $v0
    	syscall               # Chama a syscall para escrever a string com o endereço e o valor
	
	# Escreve primeiro parêntese
	la    $a1, parentese_L  # Carrega o endereço da variável "parente_L" em $a1
	li    $a2, 1            # Carrega o valor 1 em $a2 (tamanho do parêntese a ser escrito)
	li    $v0, 15           # Carrega o valor 15 em $v0 (código do syscall para escrever)
	syscall                 # Faz uma chamada de sistema para escrever a vírgula
	
	# Escreve segundo registrador
	move $s1, $t7          # Move o valor de $t7 para $s1 (Restaura valor) 
	jal   registrador      # Chama a função "registrador" para escrever o segundo registrador
	
	lw    $a0, -4($sp)     # Carrega o valor de -4($sp) em $a0 (argumento para a função syscall)
	# Escreve segundo parêntese
	la    $a1, parentese_R  # Carrega o endereço da variável "parente_R" em $a1
	li    $a2, 1            # Carrega o valor 1 em $a2 (tamanho do parêntese a ser escrito)
	li    $v0, 15           # Carrega o valor 15 em $v0 (código do syscall para escrever)
	syscall                 # Faz uma chamada de sistema para escrever a vírgula
	
	# Ajuste para próxima linha
	jal ajuste_proxima_linha

	j le_arquivo           # Pula para o label 'le_arquivo'

local_sw:
	# Escreve a instrução no arquivo
    	lw    $a0, -4($sp)     # Carrega o valor da pilha (stack) no registrador $a0
    	la    $a1, op_sw       # Carrega o endereço da string "op_sw" no registrador $a1
    	li    $a2, 2           # Carrega o valor 2 no registrador $a2
    	li    $v0, 15          # Carrega o valor 15 (código de serviço para escrever string) no registrador $v0
    	syscall                # Chama a syscall para escrever a string com a instrução, o endereço e o valor
	
	# Escreve um espaço
	jal escreve_espaco     # Chama a função 'escreve_espaco' para escrever um espaço

	# Escreve primeiro registrador
	move $t7, $s1          # Move o valor de $s1 para $t7 (Cópia)
	move $s1, $s2          # Move o valor de $s2 para $s1 (argumento para a função "registrador")
	jal   registrador      # Chama a função "registrador" para escrever o segundo registrador
	
	lw    $a0, -4($sp)     # Carrega o valor de -4($sp) em $a0 (argumento para a função syscall)
	# Escreve uma vírgula
	jal escreve_virgula	# Chama a função 'escreve_virgula' para escrever uma vírgula

	# Escreve um espaço
	jal escreve_espaco     # Chama a função 'escreve_espaco' para escrever um espaço
	
	# Escreve o endereço (IMM) no arquivo
   	move  $a0, $s3        # Move o valor do registrador $s3 para o registrador $a0
    	la    $a1, buffer     # Carrega o endereço da string "buffer" no registrador $a1
    	jal   hex_string      # Chama a função hex_string, passando $a0 e $a1 como argumentos
    	lw    $a0, -4($sp)    # Carrega o valor da pilha (stack) no registrador $a0
    	la    $a1, buffer     # Carrega o endereço da string "buffer" no registrador $a1
    	li    $a2, 10         # Carrega o valor 10 no registrador $a2
    	li    $v0, 15         # Carrega o valor 15 (código de serviço para escrever string) no registrador $v0
    	syscall               # Chama a syscall para escrever a string com o endereço e o valor
	
	# Escreve primeiro parêntese
	la    $a1, parentese_L  # Carrega o endereço da variável "parente_L" em $a1
	li    $a2, 1            # Carrega o valor 1 em $a2 (tamanho do parêntese a ser escrito)
	li    $v0, 15           # Carrega o valor 15 em $v0 (código do syscall para escrever)
	syscall                 # Faz uma chamada de sistema para escrever a vírgula
	
	# Escreve segundo registrador
	move $s1, $t7          # Move o valor de $t7 para $s1 (Restaura valor) 
	jal   registrador      # Chama a função "registrador" para escrever o segundo registrador
	
	lw    $a0, -4($sp)     # Carrega o valor de -4($sp) em $a0 (argumento para a função syscall)
	# Escreve segundo parêntese
	la    $a1, parentese_R  # Carrega o endereço da variável "parente_R" em $a1
	li    $a2, 1            # Carrega o valor 1 em $a2 (tamanho do parêntese a ser escrito)
	li    $v0, 15           # Carrega o valor 15 em $v0 (código do syscall para escrever)
	syscall                 # Faz uma chamada de sistema para escrever a vírgula
	
	# Ajuste para próxima linha
	jal ajuste_proxima_linha

	j le_arquivo           # Pula para o label 'le_arquivo'
	
###################################################################################################################################################################
    	
    	# Em caso de a instrução não ser identificada    	
    	lw    $a0, -4($sp)    # Carrega o valor da pilha (descritor do arquivo de escrita) em $a0
	la    $a1, indefinida_instrucao   # Carrega o endereço da string "indefinida_instrucao" em $a1
	li    $a2, 26        # Carrega o valor 26 em $a2 (tamanho da string a ser impressa)
	li    $v0, 15        # Carrega o valor 15 em $v0 (código da chamada do sistema para imprimir string)
	syscall              # Faz a chamada do sistema para imprimir a string

	# Ajuste para próxima linha
	jal ajuste_proxima_linha

	j le_arquivo         # Pula para o label 'le_arquivo'

###################################################################################################################################################################

hex_string:
	# Imprime o prefixo de hexadecimal (0x)
	li    $t0, '0'                  # Carrega o valor ASCII '0' no registrador $t0
	sb    $t0, 0($a1)               # Armazena o valor de $t0 no endereço $a1
	li    $t0, 'x'                  # Carrega o valor ASCII 'x' no registrador $t0
	sb    $t0, 1($a1)               # Armazena o valor de $t0 no endereço $a1 + 1
	addiu $a1, $a1, 2               # Incrementa o endereço $a1 em 2 (prefixo(2) + número(8) \0(1))

	# Introdução da máscara, contador e tabela hexadecimal
	lui   $t1, 0xF000               # Carrega a parte superior imediata de $t1 com o valor 0xF000
	li    $t2, 32                   # Carrega o valor 32 no registrador $t2 (contador)
	addiu $t2, $t2, -4              # Decrementa o valor de $t2 em 4
	la    $t3, tabela_hexadecimal   # Carrega o endereço da tabela hexadecimal no registrador $t3

loop_hex_string:
	srlv  $t4, $a0, $t2             # Executa um deslocamento lógico direito variável de $a0 pelo valor de $t2 e armazena o resultado em $t4
	and   $t4, $t4, 0x0F            # Realiza uma operação lógica AND entre $t4 e 0x0F para manter apenas os 4 bits inferiores
	add   $t4, $t3, $t4             # Adiciona $t3 e $t4 e armazena o resultado em $t4
	lbu   $t4, 0($t4)               # Carrega um byte não sinalizado de memória no endereço $t4 e armazena o resultado em $t4
	sb    $t4, 0($a1)               # Armazena o valor de $t4 no endereço $a1
	addiu $a1, $a1, 1               # Incrementa o endereço $a1 em 1
	addiu $t2, $t2, -4              # Decrementa o valor de $t2 em 4
	srl   $t1, $t1, 4               # Executa um deslocamento lógico direito de $t1 por 4 bits e armazena o resultado em $t1

	bne   $t1, $zero, loop_hex_string # Desvia para a etiqueta loop_hex_string se $t1 for diferente de zero
	lb    $zero, 0($a1)              # Carrega um byte de memória no endereço $a1 e armazena o resultado em $zero

	jr    $ra                        # Pula para o endereço armazenado em $ra
                          	
###################################################################################################################################################################

registrador:
	# Seleciona o registrador
	beq $s1, 0x00, reg_0  # $zero
	beq $s1, 0x01, reg_1  # $at
	beq $s1, 0x02, reg_2  # $v0
	beq $s1, 0x03, reg_3  # $v1
	beq $s1, 0x04, reg_4  # $a0
	beq $s1, 0x05, reg_5  # $a1
	beq $s1, 0x06, reg_6  # $a2
	beq $s1, 0x07, reg_7  # $a3
	beq $s1, 0x08, reg_8  # $t0
	beq $s1, 0x09, reg_9  # $t1
	beq $s1, 0x0a, reg_10 # $t2
	beq $s1, 0x0b, reg_11 # $t3
	beq $s1, 0x0c, reg_12 # $t4
	beq $s1, 0x0d, reg_13 # $t5
	beq $s1, 0x0e, reg_14 # $t6
	beq $s1, 0x0f, reg_15 # $t7
	beq $s1, 0x10, reg_16 # $s0
	beq $s1, 0x11, reg_17 # $s1
	beq $s1, 0x12, reg_18 # $s2
	beq $s1, 0x13, reg_19 # $s3
	beq $s1, 0x14, reg_20 # $s4
	beq $s1, 0x15, reg_21 # $s5
	beq $s1, 0x16, reg_22 # $s6
	beq $s1, 0x17, reg_23 # $s7
	beq $s1, 0x1d, reg_29 # $sp
	beq $s1, 0x1f, reg_31 # $ra

	# Em caso de o registrador não ser identificado    	
    	lw    $a0, -4($sp)    # Carrega o valor da pilha (descritor do arquivo de escrita) em $a0
	la    $a1, indefinido_registrador   # Carrega o endereço da string "indefinido_registrador" em $a1
	li    $a2, 28        # Carrega o valor 28 em $a2 (tamanho da string a ser impressa)
	li    $v0, 15        # Carrega o valor 15 em $v0 (código da chamada do sistema para imprimir string)
	syscall              # Faz a chamada do sistema para imprimir a string
	
	jr $ra               # Retorna para a função
	   
# Escreve o registrador selecionado
reg_0:
	lw    $a0, -4($sp)    # Carrega o valor de -4($sp) em $a0
	la    $a1, r_zero     # Carrega o endereço de r_zero em $a1
	li    $a2, 5          # Carrega o valor 5 em $a2
	li    $v0, 15         # Carrega o valor 15 em $v0
	syscall               # Faz uma chamada de sistema
	jr $ra                # Salta para a próxima instrução após a chamada de função

reg_1:
	lw    $a0, -4($sp)    # Carrega o valor de -4($sp) em $a0
	la    $a1, r_at       # Carrega o endereço de r_at em $a1
	li    $a2, 3          # Carrega o valor 3 em $a2
	li    $v0, 15         # Carrega o valor 15 em $v0
	syscall               # Faz uma chamada de sistema
	jr $ra                # Salta para a próxima instrução após a chamada de função

reg_2:
	lw    $a0, -4($sp)    # Carrega o valor de -4($sp) em $a0
	la    $a1, r_v0       # Carrega o endereço de r_v0 em $a1
	li    $a2, 3          # Carrega o valor 3 em $a2
	li    $v0, 15         # Carrega o valor 15 em $v0
	syscall               # Faz uma chamada de sistema
	jr $ra                # Salta para a próxima instrução após a chamada de função

reg_3:
	lw    $a0, -4($sp)    # Carrega o valor de -4($sp) em $a0
	la    $a1, r_v1       # Carrega o endereço de r_v1 em $a1
	li    $a2, 3          # Carrega o valor 3 em $a2
	li    $v0, 15         # Carrega o valor 15 em $v0
	syscall               # Faz uma chamada de sistema
	jr $ra                # Salta para a próxima instrução após a chamada de função

reg_4:
	lw    $a0, -4($sp)    # Carrega o valor de -4($sp) em $a0
	la    $a1, r_a0       # Carrega o endereço de r_a0 em $a1
	li    $a2, 3          # Carrega o valor 3 em $a2
	li    $v0, 15         # Carrega o valor 15 em $v0
	syscall               # Faz uma chamada de sistema
	jr $ra                # Salta para a próxima instrução após a chamada de função

reg_5:
	lw    $a0, -4($sp)    # Carrega o valor de -4($sp) em $a0
	la    $a1, r_a1       # Carrega o endereço de r_a1 em $a1
	li    $a2, 3          # Carrega o valor 3 em $a2
	li    $v0, 15         # Carrega o valor 15 em $v0
	syscall               # Faz uma chamada de sistema
	jr $ra                # Salta para a próxima instrução após a chamada de função

reg_6:
	lw    $a0, -4($sp)    # Carrega o valor de -4($sp) em $a0
	la    $a1, r_a2       # Carrega o endereço de r_a2 em $a1
	li    $a2, 3          # Carrega o valor 3 em $a2
	li    $v0, 15         # Carrega o valor 15 em $v0
	syscall               # Faz uma chamada de sistema
	jr $ra                # Salta para a próxima instrução após a chamada de função

reg_7:
	lw    $a0, -4($sp)    # Carrega o valor de -4($sp) em $a0
	la    $a1, r_a3       # Carrega o endereço de r_a3 em $a1
	li    $a2, 3          # Carrega o valor 3 em $a2
	li    $v0, 15         # Carrega o valor 15 em $v0
	syscall               # Faz uma chamada de sistema
	jr $ra                # Salta para a próxima instrução após a chamada de função
reg_8:
	lw    $a0, -4($sp)    # Carrega o valor de -4($sp) em $a0
	la    $a1, r_t0       # Carrega o endereço de r_t0 em $a1
	li    $a2, 3          # Carrega o valor 3 em $a2
	li    $v0, 15         # Carrega o valor 15 em $v0
	syscall               # Faz uma chamada de sistema
	jr $ra                # Salta para a próxima instrução após a chamada de função

reg_9:
	lw    $a0, -4($sp)    # Carrega o valor de -4($sp) em $a0
	la    $a1, r_t1       # Carrega o endereço de r_t1 em $a1
	li    $a2, 3          # Carrega o valor 3 em $a2
	li    $v0, 15         # Carrega o valor 15 em $v0
	syscall               # Faz uma chamada de sistema
	jr $ra                # Salta para a próxima instrução após a chamada de função

reg_10:
	lw    $a0, -4($sp)    # Carrega o valor de -4($sp) em $a0
	la    $a1, r_t2       # Carrega o endereço de r_t2 em $a1
	li    $a2, 3          # Carrega o valor 3 em $a2
	li    $v0, 15         # Carrega o valor 15 em $v0
	syscall               # Faz uma chamada de sistema
	jr $ra                # Salta para a próxima instrução após a chamada de função

reg_11:
	lw    $a0, -4($sp)    # Carrega o valor de -4($sp) em $a0
	la    $a1, r_t3       # Carrega o endereço de r_t3 em $a1
	li    $a2, 3          # Carrega o valor 3 em $a2
	li    $v0, 15         # Carrega o valor 15 em $v0
	syscall               # Faz uma chamada de sistema
	jr $ra                # Salta para a próxima instrução após a chamada de função

reg_12:
	lw    $a0, -4($sp)    # Carrega o valor de -4($sp) em $a0
	la    $a1, r_t4       # Carrega o endereço de r_t4 em $a1
	li    $a2, 3          # Carrega o valor 3 em $a2
	li    $v0, 15         # Carrega o valor 15 em $v0
	syscall               # Faz uma chamada de sistema
	jr $ra                # Salta para a próxima instrução após a chamada de função

reg_13:
	lw    $a0, -4($sp)    # Carrega o valor de -4($sp) em $a0
	la    $a1, r_t5       # Carrega o endereço de r_t5 em $a1
	li    $a2, 3          # Carrega o valor 3 em $a2
	li    $v0, 15         # Carrega o valor 15 em $v0
	syscall               # Faz uma chamada de sistema
	jr $ra                # Salta para a próxima instrução após a chamada de função

reg_14:
	lw    $a0, -4($sp)    # Carrega o valor de -4($sp) em $a0
	la    $a1, r_t6       # Carrega o endereço de r_t6 em $a1
	li    $a2, 3          # Carrega o valor 3 em $a2
	li    $v0, 15         # Carrega o valor 15 em $v0
	syscall               # Faz uma chamada de sistema
	jr $ra                # Salta para a próxima instrução após a chamada de função

reg_15:
	lw    $a0, -4($sp)    # Carrega o valor de -4($sp) em $a0
	la    $a1, r_t7       # Carrega o endereço de r_t7 em $a1
	li    $a2, 3          # Carrega o valor 3 em $a2
	li    $v0, 15         # Carrega o valor 15 em $v0
	syscall               # Faz uma chamada de sistema
	jr $ra                # Salta para a próxima instrução após a chamada de função

reg_16:
	lw    $a0, -4($sp)    # Carrega o valor de -4($sp) em $a0
	la    $a1, r_s0       # Carrega o endereço de r_s0 em $a1
	li    $a2, 3          # Carrega o valor 3 em $a2
	li    $v0, 15         # Carrega o valor 15 em $v0
	syscall               # Faz uma chamada de sistema
	jr $ra                # Salta para a próxima instrução após a chamada de função

reg_17:
	lw    $a0, -4($sp)    # Carrega o valor de -4($sp) em $a0
	la    $a1, r_s1       # Carrega o endereço de r_s1 em $a1
	li    $a2, 3          # Carrega o valor 3 em $a2
	li    $v0, 15         # Carrega o valor 15 em $v0
	syscall               # Faz uma chamada de sistema
	jr $ra                # Salta para a próxima instrução após a chamada de função

reg_18:
	lw    $a0, -4($sp)    # Carrega o valor de -4($sp) em $a0
	la    $a1, r_s2       # Carrega o endereço de r_s2 em $a1
	li    $a2, 3          # Carrega o valor 3 em $a2
	li    $v0, 15         # Carrega o valor 15 em $v0
	syscall               # Faz uma chamada de sistema
	jr $ra                # Salta para a próxima instrução após a chamada de função

reg_19:
	lw    $a0, -4($sp)    # Carrega o valor de -4($sp) em $a0
	la    $a1, r_s3       # Carrega o endereço de r_s3 em $a1
	li    $a2, 3          # Carrega o valor 3 em $a2
	li    $v0, 15         # Carrega o valor 15 em $v0
	syscall               # Faz uma chamada de sistema
	jr $ra                # Salta para a próxima instrução após a chamada de função
	
reg_20:
	lw    $a0, -4($sp)    # Carrega o valor de -4($sp) em $a0
	la    $a1, r_s4       # Carrega o endereço de r_s4 em $a1
	li    $a2, 3          # Carrega o valor 3 em $a2
	li    $v0, 15         # Carrega o valor 15 em $v0
	syscall               # Faz uma chamada de sistema
	jr $ra                # Salta para a próxima instrução após a chamada de função

reg_21:
	lw    $a0, -4($sp)    # Carrega o valor de -4($sp) em $a0
	la    $a1, r_s5       # Carrega o endereço de r_s5 em $a1
	li    $a2, 3          # Carrega o valor 3 em $a2
	li    $v0, 15         # Carrega o valor 15 em $v0
	syscall               # Faz uma chamada de sistema
	jr $ra                # Salta para a próxima instrução após a chamada de função

reg_22:
	lw    $a0, -4($sp)    # Carrega o valor de -4($sp) em $a0
	la    $a1, r_s6       # Carrega o endereço de r_s6 em $a1
	li    $a2, 3          # Carrega o valor 3 em $a2
	li    $v0, 15         # Carrega o valor 15 em $v0
	syscall               # Faz uma chamada de sistema
	jr $ra                # Salta para a próxima instrução após a chamada de função

reg_23:
	lw    $a0, -4($sp)    # Carrega o valor de -4($sp) em $a0
	la    $a1, r_s7       # Carrega o endereço de r_s7 em $a1
	li    $a2, 3          # Carrega o valor 3 em $a2
	li    $v0, 15         # Carrega o valor 15 em $v0
	syscall               # Faz uma chamada de sistema
	jr $ra                # Salta para a próxima instrução após a chamada de função

reg_29:
	lw    $a0, -4($sp)    # Carrega o valor de -4($sp) em $a0
	la    $a1, r_sp       # Carrega o endereço de r_sp em $a1
	li    $a2, 3          # Carrega o valor 3 em $a2
	li    $v0, 15         # Carrega o valor 15 em $v0
	syscall               # Faz uma chamada de sistema
	jr $ra                # Salta para a próxima instrução após a chamada de função

reg_31:
	lw    $a0, -4($sp)    # Carrega o valor de -4($sp) em $a0
	la    $a1, r_ra       # Carrega o endereço de r_ra em $a1
	li    $a2, 3          # Carrega o valor 3 em $a2
	li    $v0, 15         # Carrega o valor 15 em $v0
	syscall               # Faz uma chamada de sistema
	jr $ra                # Salta para a próxima instrução após a chamada de função

###################################################################################################################################################################
  
fim_programa:
        li    $v0, 17           # Carrega o valor 17 no registrador $v0 (encerrar programa)
        syscall                 # Faz uma chamada ao sistema para encerrar o programa

###################################################################################################################################################################

label_erro_input:
        la    $a0, erro_input   # Carrega o endereço da mensagem "erro_input" no registrador $a0
        li    $v0, 4            # Carrega o valor 4 no registrador $v0 para realizar uma chamada de sistema para imprimir a string
        syscall                 # Faz uma chamada ao sistema para imprimir a string

    	j fim_programa          # Pula para o rótulo "fim_programa"

label_erro_output:
        la    $a0, erro_output  # Carrega o endereço da mensagem "erro_output" no registrador $a0
        li    $v0, 4            # Carrega o valor 4 no registrador $v0 para realizar uma chamada de sistema para imprimir a string
        syscall                 # Faz uma chamada ao sistema para imprimir a string

    	j fim_programa          # Pula para o rótulo "fim_programa"

###################################################################################################################################################################

escreve_espaco:
	la    $a1, espaco       # Carrega o endereço da variável "espaco" em $a1
	li    $a2, 1            # Carrega o valor 1 em $a2 (tamanho do espaço a ser escrito)
    	li    $v0, 15           # Carrega o valor 15 em $v0 (código do syscall para escrever)
    	syscall                 # Faz uma chamada de sistema para escrever o espaço

    	jr    $ra               # Salta para a próxima instrução após a chamada de função

###################################################################################################################################################################
			
escreve_virgula:
	la    $a1, virgula      # Carrega o endereço da variável "virgula" em $a1
	li    $a2, 1            # Carrega o valor 1 em $a2 (tamanho da vírgula a ser escrita)
	li    $v0, 15           # Carrega o valor 15 em $v0 (código do syscall para escrever)
	syscall                 # Faz uma chamada de sistema para escrever a vírgula
	
    	jr    $ra               # Salta para a próxima instrução após a chamada de função
    
###################################################################################################################################################################    

ajuste_proxima_linha:
	la    $a1, nova_linha  # Carrega o endereço da string "nova_linha" em $a1
	li    $a2, 2           # Carrega o valor 2 em $a2 (tamanho da string a ser impressa)
	li    $v0, 15          # Carrega o valor 15 em $v0 (código da chamada do sistema para imprimir string)
	syscall                # Faz a chamada do sistema para imprimir a string
	
    	jr    $ra               # Salta para a próxima instrução após a chamada de função
	
###################################################################################################################################################################    
