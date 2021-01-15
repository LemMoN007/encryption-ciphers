%include "io.mac"

section .text
    global bin_to_hex
    extern printf

bin_to_hex:
    push    ebp
    mov     ebp, esp
    pusha

    mov     edx, [ebp + 8]      ; hexa_value
    mov     esi, [ebp + 12]     ; bin_sequence
    mov     ecx, [ebp + 16]     ; length

	sub ecx, 1
	xor edi, edi					; folosesc edi pentru grupurile de cate 4 biti
	xor ebx, ebx					; folosesc ebx ca si contor pentru numarul hexadecimal
	push 0							; adaug pe stiva noua suma

binhex:								; transforma un numar din baza 2 in baza 16
	cmp ecx, 0
	jle last
	mov al, byte[esi + ecx]		; iau bit din secventa
	cmp al, '1'
	je addsum						; daca bit-ul este '1' ii adaug valoarea la suma
cycle:
	add edi, 1						; incrementam indexul de grupuri de 4
	cmp edi, 4						; daca am ajuns la 4 resetez 
	jne nonreset

; daca am ajuns aici atunci am suma grupului de 4 biti pe care trebuie sa o adaug in edx
	xor edi, edi					; resetam la 0 contorul de grup
	pop eax							; luam suma de pe stiva
	cmp eax, 10
	jl cifra

; daca sunt aici atunci am un numar >=10 deci il fac litera
	sub eax, 10						; vad a cata litera e
	add eax, 'A'					; transform in litera
	jmp addchar						; sar peste instructiunile de la cifra

cifra:								; este cifra deci o fac caracter adunand cu '0'
	add eax, '0'
addchar:
	mov edx, [ebp + 8]				; refac legatura cu adresa
	mov byte[edx + ebx], al			; adaug caracterul calculat
	push 0							; adaug pe stiva noua suma
	add ebx, 1						; incrementam indexul din edx
nonreset:
	dec ecx
	jnz binhex

; aici calculez valoarea bitului si o adaug la suma din stiva
addsum:								; adauga un bit la suma grupului
	mov eax, 1						; valoarea minima 1
	push edi						; salvez numarul bitului din grup
	cmp edi, 0						; daca este pe pozitia 0 nu mai inmultesc cu 2
	je ready
power:								; inmultesc valoarea cu 2 de cate ori e nevoie
	sub edi, 1						; edi reprezinta puterea lui 2 la care trebuie sa aduc 'eax'
	push ecx
	mov ecx, 2
	mul ecx							; inmultesc valoarea din eax cu 2
	pop ecx
	cmp edi, 0
	jg power						; daca mai trebuie sa inmultesc continui
ready:
	mov edi, eax					; mut valoarea bit-ului in 'edi'
	mov eax, [esp + 4]				; suma este a 2-a valoarea din stiva
	add eax, edi					; adaug valoarea bit-ului curent
	mov edi, [esp]					; valoarea originala din 'edi'
	add esp, 8						; mut varful stivei
	push eax						; adaug suma inapoi pe stiva
	jmp cycle	

; mai am suma unui grup de 4 neprelucrata pe stiva, o adaug
; aceeasi abordare ca si mai sus
last:								; ultimul grup de 4 biti neprelucrat
	pop eax							; ultima suma de pe stiva
	cmp eax, 10
	jl cifra2
	sub eax, 10						; numar >=10 deci il fac litera
	add eax, 'A'
	jmp back2
cifra2:
	add eax, '0'
back2:
	mov edx, [ebp + 8]				; refac legatura cu adresa
	cmp al, '0'						; daca e '0' nu il mai adaug
	je endcase
	mov byte[edx + ebx], al			; adaug caracterul
	add ebx, 1
	
; am obtinut string-ul, dar INVERSAT, deci il inversez 
endcase:
	xor edi, edi					; edi reprezinta inceputul cozii
	mov esi, ebx					; esi reprezinta sfarsitul cozii
	mov ecx, ebx
	xor ebx, ebx
reverse:			
	sub esi, 1						; decrementez cu 1 in a 2-a jumatate
	mov al, byte[edx + esi]			; caracter de la sfarsit
	mov bl, byte[edx + edi]			; caracter de la inceput
	mov byte[edx + esi], bl			; schimb caracterele
	mov byte[edx + edi], al			; schimb caracterele
	add edi, 1						; incrementez cu 1 in prima jumatate
	cmp esi, edi					; cat timp nu am trecut de jumatate
	jg reverse
	
	mov byte[edx + ecx], 0xA		; adaug newline
	mov byte[edx + ecx + 1], 0		; terminator de string

    popa
    leave
    ret
