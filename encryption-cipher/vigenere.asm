%include "io.mac"

section .text
    global vigenere
    extern printf

vigenere:
    push    ebp
    mov     ebp, esp
    pusha

    mov     edx, [ebp + 8]      ; ciphertext
    mov     esi, [ebp + 12]     ; plaintext
    mov     ecx, [ebp + 16]     ; plaintext_len
    mov     edi, [ebp + 20]     ; key
    mov     ebx, [ebp + 24]     ; key_len

	push ecx
copie:								; scriem tot mesajul initial pentru non-caractere
	mov al, byte[esi + ecx - 1]
	mov byte[edx + ecx - 1], al
	loop copie


	pop ecx
	push esi
	xor eax, eax					; contorul pentru cheie
	xor esi, esi					; esi este contorul, il initializez cu 0
caracter:							; evit non-literele si transform cifrul prin repetarea cheii in mesaj
	cmp eax, ebx					; verific daca s-a terminat cheia ca sa o resetez
	jl skipreset
	xor eax, eax					; resetez ciclul pentru cheie
skipreset:
	push ebx
	mov bl, byte[edx + esi]			; iau caracterul din mesaj si verifica daca e litera
	cmp bl, 'A'						; verific caracterul >= 'A'
	jl nonletter
	cmp bl, 'z'						; verific caracterul <= 'z'
	jg nonletter
	cmp bl, '['						; verifica daca face parte din caracterele non-litere dintre 'Z' si 'a'
	jl letter
	cmp bl, '`'						
	jl nonletter
letter:								; daca am ajuns aici inseamna ca e litera
	push ecx
	mov cl, byte[edi + eax]
	mov byte[edx + esi], cl			; adaug caracterul din cheie in 'edx', adica in cypher
	pop ecx
	add eax, 1						; trec la urmatorul caracter din cheie
nonletter:							; daca nu e litera trec peste 
	pop ebx
	add esi, 1
	cmp esi, ecx
	jl caracter						; cat timp esi<ecx mai am litere


	pop esi
	push ecx						; tin minte numarul de litere din mesaj
lowercase:							; parcurg mesajul si iau literele mici si le tranform cu cheia
	sub ecx, 1
	cmp ecx, 0						; daca indexul <0 am terminat
	jl endlowercase
	mov al, byte[esi + ecx]			; iau caracterul din mesaj
	cmp al, 'a'						; verific sa fie litera mica
	jb lowercase
	cmp al, 'z'
	jg lowercase

	mov bl, byte[edx + ecx]			; iau litera corespunzatoare din cheie si calculez numarul de pasi
	sub bl, 'A'						; numarul de deplasari ale literei
	cmp bl, 0
	je skipnull1					; daca cheia e 'A' atunci bl e 0 si nu schimb nimic deci sar peste

changechar1:						; mut cate o pozitie de "key" ori care e stocat in bl
	sub bl, 1
	cmp al, 'z'
	jne cycle1						; daca e ultima litera si trebuie sa refac ciclul
	mov al, '`'						; caracterul de dinaintea literei 'a', ca sa pot face mereu 'add'
cycle1:
	add al, 1
	cmp bl, 0
	jg changechar1

skipnull1:
	mov byte[edx + ecx], al			; adaug in edx litera modificata
	cmp ecx, 0
	jg lowercase
endlowercase:
	pop ecx							; reiau numarul de litere pentru o noua parcurgere a cuvantului

; exact aceeasi abordare ca si mai sus, dar pentru majuscule
uppercase:							; parcurg mesajul si iau majusculele si le transfrom cu cheia
	sub ecx, 1						
	cmp ecx, 0
	jl endcase						
	mov al, byte[esi + ecx]			; iau caracterul din mesaj
	cmp al, 'A'						; verific sa fie litera mica
	jb uppercase
	cmp al, 'Z'
	jg uppercase

	mov bl, byte[edx + ecx]
	sub bl, 'A'
	cmp bl, 0
	je skipnull2					; daca cheia e 'A' atunci bl e 0 si nu schimb nimic deci sar peste

changechar2:						; mut cate o pozitie de "key" ori
	sub bl, 1
	cmp al, 'Z'
	jne cycle2
	mov al, '@'						; caracterul de dinaintea literei 'A', ca sa pot face mereu 'add'		
cycle2:
	add al, 1
	cmp bl, 0
	jg changechar2

skipnull2:
	mov byte[edx + ecx], al
	cmp ecx, 0
	jg uppercase
endcase:


    popa
    leave
    ret
