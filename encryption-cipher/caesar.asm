%include "io.mac"

section .text
    global caesar
    extern printf

caesar:
    push    ebp
    mov     ebp, esp
    pusha

    mov     edx, [ebp + 8]      ; ciphertext
    mov     esi, [ebp + 12]     ; plaintext
    mov     edi, [ebp + 16]     ; key
    mov     ecx, [ebp + 20]     ; length

	push ecx
caracter:							; scriem tot string-ul initial pentru non-caractere
	mov al, byte[esi + ecx - 1]
	mov byte[edx + ecx - 1], al
	loop caracter


	pop ecx
	push ecx
lowercase:							; parcurg mesajul si iau literele mici si le tranform cu cheia
	sub ecx, 1
	cmp ecx, 0						; daca indexul <0 am terminat
	jl endlowercase
	mov al, byte[esi + ecx]			; iau caracterul din mesaj
	cmp al, 'a'						; verific sa fie litera mica
	jb lowercase
	cmp al, 'z'
	jg lowercase
	cmp edi, 0						; daca nu trebuie sa mut deloc literele
	je skipnull1

	push ecx
	mov ecx, edi					; numarul de deplasari circulare ale literei
changechar1:						; mut cate o pozitie de "key" ori
	cmp al, 'z'
	jne cycle1						; daca e ultima litera si trebuie sa refac ciclul
	mov al, '`'
cycle1:
	add al, 1
	loop changechar1

	pop ecx 						; iau inapoi valoarea din stiva, cat a mai ramas din mesaj
skipnull1:
	mov byte[edx + ecx], al			; adaug in edx litera modificata
	cmp ecx, 0
	jg lowercase
endlowercase:
	pop ecx							; reiau numarul de litere pentru o noua parcurgere a cuvantului

; exact aceeasi abordare ca si mai sus, dar pentru majuscule
uppercase:							; parcurg mesajul si iau majusculele si le tranform cu cheia
	sub ecx, 1
	cmp ecx, 0
	jl endcase
	mov al, byte[esi + ecx]			; iau caracterul din mesaj
	cmp al, 'A'						; verific sa fie majuscula
	jb uppercase
	cmp al, 'Z'
	jg uppercase
	cmp edi, 0						; daca nu trebuie sa mut deloc literele
	je skipnull2

	push ecx
	mov ecx, edi
changechar2:						; mut cate o pozitie de "key" ori
	cmp al, 'Z'
	jne cycle2
	mov al, '@'						; caracterul de dinaintea literei 'A', ca sa pot face mereu 'add'	
cycle2:
	add al, 1
	loop changechar2

	pop ecx
skipnull2:
	mov byte[edx + ecx], al
	cmp ecx, 0
	jg uppercase

endcase:

    popa
    leave
    ret
