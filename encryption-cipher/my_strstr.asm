%include "io.mac"

section .text
    global my_strstr
    extern printf

my_strstr:
    push    ebp
    mov     ebp, esp
    pusha

    mov     edi, [ebp + 8]      ; substr_index
    mov     esi, [ebp + 12]     ; haystack		- mesajul
    mov     ebx, [ebp + 16]     ; needle 		- ce trebuie sa gasesc
    mov     ecx, [ebp + 20]     ; haystack_len
    mov     edx, [ebp + 24]     ; needle_len

	mov edi, 0
substring:							; caut substringul in string
	push ecx						; am nevoie de ecx pentru 
	mov al, byte[esi + edi]			; caracterul din string-ul mare
	mov cl, byte[ebx]				; primul caracter din substring
	cmp al, cl
	jne keepsearching				; daca nu am gasit inceputul substringului continui sa caut

; daca am ajuns aici atunci am gasit litera de inceput in stringul mare
	push edx
cycle:								; compar caracterele incepand de la sfarsitul substring-ului
	sub edx, 1						; decrementez contorul
	mov cl, byte[ebx + edx]			; caracter din substring
	add edx, edi					; adaug edi pentru a obtine caracterul din stringul mare
	mov al, byte[esi + edx]			; caracter din stringul mare
	sub edx, edi
	cmp al, cl
	jne notfound					; daca caracterele difera ies din ciclu
	cmp edx, 0
	jg cycle

; daca am ajuns aici atunci am gasit substringul bun
	jmp foundsubstring
notfound:
	pop edx
keepsearching:						; trec la urmatorul caracter din stringul mare
	pop ecx
	add edi, 1						; incrementez contorul si il compar cu numarul de caractere
	cmp edi, ecx
	jl substring

; daca am ajuns aici atunci nu am gasit substring
	add edi, 1						; daca nu am gasit substring atunci returnez len+1
	jmp result

foundsubstring:
	pop edx
	pop ecx
result:
	mov eax, edi
	mov edi, [ebp + 8]				; refac adresa si pun rezultatul
	mov [edi], eax

endcase:
    popa
    leave
    ret


