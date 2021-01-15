%include "io.mac"

section .text
    global otp
    extern printf

otp:
    push    ebp
    mov     ebp, esp
    pusha

    mov     edx, [ebp + 8]      ; ciphertext
    mov     esi, [ebp + 12]     ; plaintext
    mov     edi, [ebp + 16]     ; key
    mov     ecx, [ebp + 20]     ; length

caracter:								; iau fiecare caracter din cele 2 stringuri si le fac xor
	mov al, byte[esi + ecx - 1]			; caracterul din primul string
	mov bl, byte[edi + ecx - 1]			; caracterul din al doilea string
	xor al, bl							; xor intre cele 2 caractere
	mov byte[edx + ecx - 1], al			; il adaug in cipher final
	loop caracter
	
    popa
    leave
    ret
