# Encryption-Ciphers
### OTP
Realizeaza criptarea One Time Pad. Parcurge fiecare caracter din cele 2 siruri
si prin efectuarea operatiei 'xor' intre ele se obtine mesajul criptat.
### Caesar
Realizeaza criptarea Caesar. Prima oara se copiaza tot mesajul initial
	pentru a obtine pozitiile non-literelor, iar apoi se parcurge mesajul si
	iau cele 2 cazuri: litere mici sau litere mari. In primul caz, caracterele
	vor fi verificate pentru a apartine literelor mici 'a-z', iar in caz afirmativ
	vor fi inlocuite cu valorea acestora dupa deplasarea circulara de un numar
	de ori egal cu cheia. Aceeasi abordare si pentru cazul 2, cu literele mari. 
	In final vom obtine mesajul criptat.
### Vigenere
Realizeaza criptarea Vigenere. Prima oara se copiaza tot mesajul initial
	pentru a obtine pozitiile non-literelor. Se tranforma mesajul copiat in 'edx'
	prin repetarea cheii, pentru a obtine literele din cheie corespunzatoare fiecarei
	litere din mesaj(spre exemplu pentru mesajul "Murica" si cheia "AB", 'edx' va
	contine "ABABAB"). Luam apoi cheia transformata si mesajul initial si le parcurgem,
	separate pe 2 cazuri: litere mici si litere mari. In primul caz, caracterele
	vor fi verificate pentru a apartine literelor mici 'a-z', iar in caz afirmativ
	va fi calculata valoare cheii corespunzatoare acelei litere si deplasata circular
	de numarul de ori calculat. Aceeasi abordare si pentru cazul 2, cu literele mari.
	In final vom obtine mesajul criptat.
### My_strstr
Gaseste prima aparitie a unui substring intr-un sir sursa. Parcurg string-ul si
	compar caracterele din acesta cu primul caracter din substring. Daca acestea sunt 
	egale atunci incep sa compar incepand de la sfarsitul substring-ului. Daca toate 
	caracterele comparate sunt egale atunci inseamna ca am gasit prima aparitie
	a substring-ului si returnez indexul. Daca nu am gasit substring-ul, atunci
	returnez len + 1.
### Bin_to_Hex
Trece numerele din baza 2 in baza 16. Parcurg string-ul de binary incepand
	de la sfarsit si formez grupuri de cate 4 biti. Pentru fiecare bit calculez valoarea
	si o adaug la suma grupului respectiv, care este stocata pe stiva. Odata parcurs
	grupul, resetez contorul de grup la 0 si apoi iau suma de pe stiva si ii verific
	valoarea. Daca este o cifra atunci o adun cu '0', altfel trebuie sa o schimb in 
	litera, scazand-o astfel cu 10, la care adaug apoi 'A'. Valoarea obtinuta este
	adaugata in 'edx'. O sa mai ramana un grup de 4 biti neprelucrat cu suma
	ramasa pe stiva, deci il prelucrez si pe acela. In final obtin string-ul cu
	reprezentarea in baza 16, dar inversat, deci trebuie sa il inversez la loc.
  
