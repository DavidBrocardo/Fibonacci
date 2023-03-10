; N-essimo numero de fibonacci
; arquivo: Fibonacci.asm
; Autor : David Antonio Brocardo , Gabriel Santos da Silva ; Leonardo B. Balan de Oliveira.
; nasm -f elf64 Fibonacci.asm ; ld Fibonacci.o -o Fibonacci.x

; valores em octal
%define maxChars 10 ; no. máximo de caracteres a serem lidos
%define createopenw  101o ; flag open() - criar + escrita
%define userWR 644o       ; Read+Write+Execute: -rw-r--r--


section .data    
    fileName: db "fib(00).bin", 0 ; null-terminated string!

    strNessimo :  dd "Entre com o valor do n-éssimo número fibonacci: ", 10, 0
    strNessimoL: equ $ - strNessimo
    len equ $ - strNessimo ; Calcula o comprimento da Funcao
    
    strBye : dd "VALOR INVALIDO", 0
    strByeL: equ $ - strBye

    strLF : db 10 ; quebra de linha ASCII!
    strLFL : dd 1
        
    v1: dq 1
    v2: dq 0


section .bss
    strLida  : resb maxChars
    strLidaL : resd 1

    value : resq 1
    valueL : equ $ - value
    
   
   ; texto: resb maxChars
    fileHandle: resd 1

section .text
 	global _start

_start:
    ; ssize_t write(int fd , const void *buf, size_t count);
    ; eax     write(int edi, const void *rsi, size_t edx  );
    mov rax, 1
    mov rdi, 1  ; std_file
    lea rsi, [strNessimo]          ; lea é passagem como de ponteiro, não passa o valor e sim a posicao da memoria
    mov edx, strNessimoL           ; mov passa o valor realmente 
    
    
    syscall
    mov rbx, 1
leitura:
    mov dword [strLidaL], maxChars ; %define é constantes!

    ; ssize_t read(int fd , const void *buf, size_t count);
    ; eax     read(int edi, const void *rsi, size_t edx  );
    mov rax, 0  ; READ
    mov rdi, 1
    lea rsi, [strLida] ; ponteiro 
    mov edx, [strLidaL]
   
    mov ecx, [strLida]     ; Colocar o comprimento da string em ECX
    syscall




convert_int:
    mov al, [strLida]   ; Para o nome do arquivo
    mov [fileName+4], al
    mov r8, [strLida+1] ;
    mov [fileName+5], r8b
    xor eax, eax     ; limpar o registrador EAX
    mov rdi, [strLida] ; 
    mov r8, [strLida+1] ; 
    mov rbx ,[strLida +2] ; Verifica se tem um 3 digito   
    

    sub rdi, 0x30       ;  Extrai o número da tabela ASCII    
    sub r8, 0x30        
    sub rbx , 0x30  
    cmp rdi,  -38       ; verificar se é enter
    je fim 
    cmp r8,  -38       ; verificar se é uma variavel só 
    je somenteValor       
    cmp rbx,  -38       ; verificar se tem mais que 2 digito 
    jne erro  
    
    
    

 
    imul rdi, 10 ;  Transforma em dezena
    add rdi, r8 ;  Soma a unidade com a dezena, armazenando o número total em rdi
    
  
    syscall
    




somenteValor: 
    and rdi, 0xFF 
    ;and r8, 0xFF 
    cmp rdi, 94  ; Caso seja maior que o limite mensagem de erro apresentada
    jge erro 
    
    cmp rdi , 1
    je um
    
    cmp rdi , 0
    je zero
syscall





fibonacci:
; Calculo de Fibonacci
; if (n == 1) return 1;                   
;      else                                    
;        if (n == 2) return 1;                 
;        else return fib(n - 1) + fib(n - 2);  
    
    cmp rdi, 1       ; verificar se foi feito todas
    je open   ; se sim, pular para o final
         sub rdi, 1   ; edx -- 
         mov r8 , [v2] ; r8  = Fib (-2)
         add r8,  [v1] ; Fib(-1) + Fib (-2)               
         mov [value], r8 ; guardar o valor 
         mov  r8, [v1] ; Recebe o valor novamente para vira o V2 
         mov  [v2] , r8 ; v2 = v1
         mov r8 , [value] ; Recebe o valor guardado para vira v1
         mov [v1], r8 ; v1 = soma atual;
       jmp fibonacci ; i--

um :
   mov r8 , [v1] ; v1 contem o valor 1 dentro
    mov [value], r8; para  1 fibonacci é igual a um 
    jmp open;

zero :
   mov r8 , [v2] ; v2 contem o valor 0 dentro
    mov [value], r8; para 0 fibonacci é igual a zero 
    
open:
    ;mov [value], ebx ; salvar no valor para ser gravado 
    ;xor eax, eax 
    mov rax, 2          ; open file  2 comando para abrir e possivel criar arquivo
    lea rdi, [fileName]
    mov esi, createopenw
    mov edx, userWR
    syscall

    mov [fileHandle], eax

    
    


escrita:
    mov rax, 1   ; escrita em terminal
    mov rdi, [fileHandle]
    lea rsi, [value]
    mov edx, valueL
   syscall
   


fecha:
    mov rax, 3  ; fechar arquivo
    mov rdi, [fileHandle]
    jmp fim 
    syscall

erro:
     xor eax, eax     ; limpar o registrador EAX
    mov rax, 1  ; WRITE
    mov rdi, 1
    mov rsi, strBye
    mov rdx, strByeL
    syscall  

    mov rax, 1  ; WRITE
    mov rdi, 1
    lea rsi, [strLF]
    mov edx, [strLFL]
   
    syscall




fim:
    ; void _exit(int status );
    ; void _exit(int edi/rdi);
    mov rax, 60 ; EXIT
    mov rdi, 0
    syscall
