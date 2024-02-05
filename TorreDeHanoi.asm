;Documentação em PTBR
section .bss
    buffer resb 16	;tamanho do buffer para receber o input
section .text                         

global _start                     ; Início do código

_start:                           ; Início do programa

    ;  função principal
    push ebp                      ; Salva o valor do registrador ebp na pilha
    mov ebp, esp                  ; Estabelece um novo ponteiro de frame (ebp) apontando para o topo da pilha

    ; Escreve mensagens para o usuário
    mov edx, len_title               ; Tamanho da mensagem do título
    mov ecx, title_msg                  ; Mensagem do título
    mov ebx, 1                    ; Descritor de arquivo para saída padrão (stdout)
    mov eax, 4                    ; Número da chamada do sistema indicando que é para escrever
    int 128  ; Software interrupt n-> kernel

    mov edx, len_user              ; Tamanho da mensagem para instruções ao usuário
    mov ecx, user_msg                  ; Mensagem para instruções ao usuário
    mov ebx, 1                    ; Descritor de arquivo para saída padrão (stdout)
    mov eax, 4                    ; Número da chamada do sistema para escrever
    int 128  ; Software interrupt  

    ; Lê a entrada do usuário
    mov eax, 3                    ; Número da chamada do sistema para ler
    mov ebx, 0                    ; Descritor de arquivo para entrada padrão (stdin)
    lea ecx, [buffer]             ; Endereço do buffer de entrada
    mov edx, 16                   ; Número máximo de caracteres a serem lidos
    int 128                     ; Software interrupt

    ; Converte a string para um número
    xor eax, eax                  ; Limpa o registrador eax
    lea esi, [buffer]             ; Endereço do buffer de entrada

convert:
    movzx edx, byte [esi]         ; Converte um byte para um valor inteiro
    cmp dl, 0x0A   ; Verifica se é o caractere de nova linha
    je done                       ; Se sim, encerra o loop
    cmp dl,'9'  ; verifica se o caracter é maior que 9
    jg _start   ; se sim, volta para o inicio do cod
    imul eax, 10                  ; Multiplica o número atual por 10
    sub edx, '0'                  ; Converte o caractere ASCII para um valor numérico
    add eax, edx                  ; Adiciona o valor numérico ao acumulador
    inc esi                       ; Avança para o próximo caractere
    jmp convert                   ; Salta de volta para o início do loop

done:
    ; Configuração inicial para o jogo Torre de Hanoi
    push dword 2                  ; Torre Auxiliar
    push dword 3                  ; Torre Destino
    push dword 1                  ; Torre Origem
    push eax                      ; Quantidade de discos
    
    call hanoi                    ; Chamada da função recursiva Hanoi

    ; Gera uma interrupção -> kernel para finalizar o programa
    mov eax, 1                    ; Número da chamada do sistema para sair
    mov ebx, 0                    ; Código de saída padrão
    int 128                       ; Software interrupt -> kernel

; Função recursiva Torre de Hanoi
hanoi: 

    ;[ebp+8] Número de discos restantes na Torre de origem
    ;[ebp+12] Torre de origem
    ;[ebp+16] Torre auxiliar
    ;[ebp+20] Torre de destino

    ; função Hanoi
    push ebp                      ; Salva o valor do registrador ebp na pilha
    mov ebp, esp                   ; Estabelece um novo ponteiro de frame (ebp) apontando para o topo da pilha

    mov eax, [ebp+8]              ; Move para o registrador eax o número de discos na Torre de origem

    cmp eax, 0                    ; Verifica se ainda há discos a serem movidos na torre de origem
    je desempilhar                ; Se não houver, pula para desempilhar

    ; Primeira recursividade    
    push dword [ebp+16]           ; Empurra a Torre Auxiliar
    push dword [ebp+20]           ; Empurra a Torre Destino
    push dword [ebp+12]           ; Empurra a Torre Origem
    
    dec eax                       ; Tira o disco do topo da Torre de origem para ser colocado em outra Torre
    push dword eax                ; Empurra o número de discos restantes a serem movidos na Torre de origem
    
    call hanoi                    ; Chama a função Hanoi -> recursividade
    
    add esp,16                    ; Após retornar da chamada da função Hanoi, remove o "lixo" da pilha

    ; Imprime os movimentos
    push dword [ebp+16]           ; Empilha a Torre de Saída
    push dword [ebp+12]           ; Empilha a Torre de Origem
    push dword [ebp+8]            ; Empilha o Disco
    
    call imprime                  ; Chama a função imprime para printar os movimentos
    
    add esp, 12                   ; Após retornar da chamada da função Hanoi, remove o "lixo" da pilha

    ; Segunda recursividade
    push dword [ebp+12]           ; Empilha a Torre Origem
    push dword [ebp+16]           ; Empilha a Torre Trabalho
    push dword [ebp+20]           ; Empilha a Torre Destino
    
    mov eax, [ebp+8]              ; Move para o registrador eax o número de discos restantes
    
    dec eax                       ; Tira o disco do topo da Torre de origem para ser colocado em outra Torre
    push dword eax                ; Empurra o número de discos restantes a serem movidos na Torre de origem
    
    call hanoi                    ; Chama a função Hanoi -> recursividade

desempilhar: 

    mov esp, ebp                  ; Aponta o ponteiro da base da pilha (ebp) para o topo
    pop ebp                       ; Tira o elemento do topo da pilha e guarda o valor em ebp
    ret                           ; Retira o último valor do topo da pilha e faz um jump para ele (a linha de retorno nesse caso)

; Função para imprimir os movimentos
imprime:

    ;função imprime
    push ebp                      ; Salva o valor do registrador ebp na pilha
    mov ebp, esp                  ; Estabelece um novo ponteiro de frame (ebp) apontando para o topo da pilha

    ; Converte valores para ASCII e imprime
    mov eax, [ebp + 8]            ; Move para o registrador eax o disco a ser movido
    add al, 48                    ; Converte para ASCII
    mov [disco], al               ; Coloca o valor no [disco] para a impressão

    mov eax, [ebp + 12]           ; Move para o registrador eax a Torre de onde o disco saiu
    add al, 64                    ; Converte para ASCII
    mov [torre_saida], al         ; Coloca o valor no [torre_saida] para a impressão

    mov eax, [ebp + 16]           ; Move para o registrador eax a Torre de onde o disco foi
    add al, 64                    ; Converte para ASCII
    mov [torre_ida], al           ; Coloca o valor no [torre_ida] para a impressão

    ; Escreve a mensagem  de mopvimentação formatada
    mov edx, lenght               ; Tamanho da mensagem
    mov ecx, fullmsg              ; Mensagem formatada
    mov ebx, 1                    ; Descritor de arquivo para saída padrão (stdout)
    mov eax, 4                    ; Número da chamada do sistema para escrever
    int 128                       ; Software interrupt para o kernel

    ; final da função imprime
    mov esp, ebp                  ; Aponta o ponteiro da base da pilha (ebp) para o topo
    pop ebp                       ; Tira o elemento do topo da pilha e guarda o valor em ebp
    ret                           ; Retira o último valor do topo da pilha e faz um jump para ele (a linha de retorno nesse caso)

section .data                         

    ; Definindo as mensagens
    fullmsg:
        msg:            db        "Moveu o disco "         
        disco:          db        " "
                        db        " da Torre "
        torre_saida:    db        " "  
                        db        " para a Torre "     
        torre_ida:      db        " ", 0xa  ; Para quebrar linha
        
        lenght            equ       $- fullmsg
        
        title_msg:
        title:  db  0xa, "<Atividade avaliativa torre de hanoi em assembly>", 0xa
        len_title   equ $-title_msg
    user_msg:
        for_user:  db  0xa,"Com quantos discos você quer brincar? (1-9)", 32  ;32 para dar espaço ao invés de quebrar a linha
        len_user   equ $-user_msg
