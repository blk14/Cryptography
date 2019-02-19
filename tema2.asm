extern puts
extern printf
extern strlen

%define BAD_ARG_EXIT_CODE -1

section .data
filename: db "./input0.dat", 0
inputlen: dd 2263

fmtstr:            db "Key: %d",0xa, 0
usage:             db "Usage: %s <task-no> (task-no can be 1,2,3,4,5,6)", 10, 0
error_no_file:     db "Error: No input file %s", 10, 0
error_cannot_read: db "Error: Cannot read input file %s", 10, 0

section .text
global main

;=======================================TASK 1================================================

xor_strings:
	; TODO TASK 1                               ;pe stiva: string - cheie
                    push ebp
	mov ebp, esp

                    xor eax, eax
                    xor ebx, ebx
                    xor ecx, ecx
                    mov eax, [ebp + 8]                          ; salvez inceputul string-ului in eax si al cheii in ebx
                    mov ebx, [ebp + 12]
                    
                    iterate_11:
                   
                    mov byte cl, [eax + edx]
                    inc edx
                    cmp cl, 0                                           ; numar cate caractere am in string
                    jne iterate_11
                    
                    dec edx
                    mov ecx, edx                                 ; si salvez numarul de caractere in ecx
                   
         xor_byte:
                    mov byte dl, [eax + ecx]
                    mov byte dh, [ebx + ecx]               ; iau cate un byte din string si cheie
                    xor byte dl, dh                                ; fac xor intre cei 2 bati si rezultatul se pune im byte-ul din string
                    mov byte [eax + ecx], dl             
                    dec ecx
                   cmp ecx, 0
                   jge xor_byte
                    leave
	ret

;============================================TASK 2===================================

rolling_xor:
	; TODO TASK 2                             stiva: string - dimensiunea
                     push ebp
	mov ebp, esp
                    xor eax, eax
                    xor ecx, ecx
                    xor ebx, ebx
                    mov edx, 1
                    
                    mov eax, [ebp + 8]                      ; inceputul string-ului
                    
               parse_2:
                   
                    mov byte cl, [eax + edx]
                    inc edx                                  ; aflu numarul de caractere
                    cmp cl, 0
                    jne parse_2
                    
                    mov ecx, edx                       ; le pun in ecx
                    sub ecx, 2
        next_roll_xor:
                    mov byte bl, [eax + ecx]                             ; plecand de la ultimul caracter fac xor 
                    mov byte bh, [eax + ecx - 1]                      ; intre el si cel dinaintea lui, iar rezultatul e pus
                    xor bl, bh                                                   ; pe byte-ul caracterului curent
                    mov byte [eax + ecx], bl
                    dec ecx
                    cmp ecx, 0
                    jg next_roll_xor
                    leave
	ret
; ==============================================TASK 3========================================

convert_al_from_int:
            sub al, '0'
            jmp back_al
            
convert_ah_from_char:
                sub ah, 'W'
                jmp back_ah
                
convert_ah_from_int:
            sub ah, '0'
            jmp back_ah
            
push_dim:
                push edx
                jmp back

xor_hex_strings:
	; TODO TASK 3
	push ebp
                    mov ebp, esp

                    xor eax, eax
                    xor ecx, ecx
                    mov ecx, [ebp + 8]
                    mov ebx, [ebp + 12]
                    xor ebx, ebx
                    xor edx, edx
                    mov eax, 0
                    push eax                     ; eax = 0 reprezinta faptul ca am lucrat pe string, eax = 1 rep faptul ca am lucrat pe cheie
                    
                    parse_3:
                   
                    mov byte al, [ecx + edx]
                    mov byte ah, [ecx + edx + 1]                   ; iau cate 2 bytes si ii convertesc conform criteriilor hexa
                    cmp al, 'a'
                    jge convert_al_from_char
                    jmp convert_al_from_int
                back_al:
                    cmp ah, 'a'
                    jge convert_ah_from_char
                    jmp convert_ah_from_int
                back_ah:
                    push edx
                    mov dh, ah
                    mov bl, 16                               ; inmultesc primul byte cu 16 si il adun la al doilea
                    imul bl
                    add al, dh                            ; rezultatul ramane in primul byte (toate "rezultatele" vor fi pe bytes pari din string si cheie)
                    pop edx
                    mov byte [ecx + edx], al
                    add edx, 2                            ; ecx + edx pointeaza la al treilea element pt a verifica daca am ajuns la finalul stringului sau cheii
                    mov byte ah, [ecx + edx]
                    cmp ah, 0
                    jne parse_3
                    
                    inc edx
                    pop eax                                ; daca eax (care a fost puspe stiva la inceput) este 0 inseamna ca am terminat de transformat stringul
                    cmp eax, 0                          ; inainte de a trece la cheie, salvez dimensiunea
                    je push_dim
            back:
                    inc eax
                    push eax                               
                    cmp eax, 1                            ; transform si cheia
                    je parse_3
                    pop eax
                    
                    pop edx                             ; dimensiunea stringului
                    
                    push edx                           ;*1
                    add ecx, edx
                    mov ebx, ecx                    ; in ebx retin zona de inceput a cheii
                    
                    sub ecx, edx
                    mov eax, ecx                 ; in eax am zona de inceput a stringului
                    
                    dec edx
                    mov ecx, edx             ; in ecx pun dimensiunea stringului
                    xor edx, edx
                               
         xor_byte_3:
                    mov byte dl, [eax + ecx]
                    mov byte dh, [ebx + ecx]         ; iau cate un byte din string si cheie, fac xor intre ei
                    xor byte dl, dh
                    mov byte [eax + ecx], dl        ; salvez rezultatul in byte-ul din string
                    sub ecx, 2                              ; avand grija sa ma deplasez doar pe pozitiile pare unde am rezultatele convertirii la hexa
                   cmp ecx, 0
                   jge xor_byte_3
                   
                   pop ecx                    ; corespunde cu '*1' si reprezinta dimensiunea, fiind nevoie sa fie restaurata 
                   xor edx, edx
                   mov edx, 1
                   xor ebx, ebx
                   
             create_string:
                   mov byte bl, [eax + 2 * edx]          ; creez string-ul rezultat concatenand pozitiile pare din string intr-un "string continuu"
                   mov byte [eax + edx], bl              ; in  poz pare avand acei bytes doriti
                   inc edx
                   push eax
                   mov eax, edx
                   mov bh, 2
                   imul bh
                   mov ebx, eax
                   pop eax
                   cmp ebx, ecx
                   jl create_string
                   mov byte [eax + edx], 0
                    leave
                    ret
                    
      ; ===============================================TASK 4=========================================


convert_from_char:
            sub dl, 'A'
            jmp back_convert
            
convert_from_int:
        sub dl, '0'
        add dl, 24
        jmp back_convert
convert_from_equal:
       mov dl, 0
       jmp back_convert
       

       
 shift:
        push eax
        push ebx
        push ecx
        push edx
        
        mov ecx, eax
        mov dword edx, [ecx - 4]
        mov dword eax, [ecx]
          
         mov bl, 5
         ;mov bh, 0
         push ecx
    repeat:
         shl eax, 1
         mov ecx, 0
         setc cl                                  ; adaug in edx valoarea data de carry flag
         add edx, ecx
         shl edx, 1
        dec bl
        cmp bl, 0
        jg repeat
        
        shr edx, 1
        
        pop ecx
        
        mov dword [ecx - 4], edx
        mov dword [ecx], eax
        
        pop edx
        pop ecx
        pop ebx
        pop eax
       
       jmp do_or
       
 do_or:
        push ebx
         push eax
         push ecx
         
        
         or byte [eax + 3], dl        
         
         pop ecx
         pop eax
         pop ebx
         jmp back_or
        
  another_5_bytes:
        add eax, 8
        mov dh, 8
        jmp iteration
        
        
       


base32decode:
	; TODO TASK 4
	 push ebp
	mov ebp, esp
                    xor eax, eax
                    xor ebx, ebx
                    xor ecx, ecx
                    xor edx, edx
                       
                     mov ebx, [ebp + 8]         ; zona sirului criptat
                     mov ecx, [ebp + 12]       ; dimensiunea
                     dec ecx
                     
                     ; setez dimensiunea in octeti a zonei de memorie rezultate

                      mov ax, [ebp + 12]
                      mov dl, 8
                      div dl
                      mov dl, al                       ; dl reprezinta numarul de grupuri de cate 8 caractere
                             
                      xor eax, eax
                                          
                     push ebx
                     add ebx, ecx
                     add ebx, 200
                     mov eax, ebx             ; zona in care creez este eax
                     pop ebx
                     
                     push eax
                     mov ecx, 0
                    
                    mov dh, 8                      ; dh rep contor pt shiftare
            
            iteration:
                    
                     mov byte dl, [ebx + ecx]
                     cmp dl, '='
                     je convert_from_equal
                     cmp dl, 'A'
                     jge convert_from_char
                     jmp convert_from_int
                     
                 back_convert:
                     
                     cmp dh, 0
                     jne shift

           back_or:
        
                     inc ecx
                     cmp ecx, [ebp + 12]
                     jg finish
                     
                     dec dh
                     cmp dh, 0
                     je another_5_bytes
                     
                     jmp iteration
                     ;pop ebx
                     
                     
               finish:
                   mov ecx, [ebp + 12] 
                   pop eax
                   sub eax, 1
                    push ebx
                   jmp link
                   
                   finish2:
                   
                   ;mov byte [eax + 8], 0
                  
                   pop ebx
                    mov eax, ebx
                    leave
	ret

link:
                       push eax
                       xor eax, eax
                       mov ax, [ebp + 12]
                      mov dl, 8
                      div dl
                      mov dl, 5
                      imul dl
                      mov ecx, eax
                      pop eax
                      
                      xor edx, edx
          mov dl, 0
         rep_link:
         push ecx
         mov byte cl, [eax + edx]
         mov byte  [ebx], cl
         pop ecx
         inc ebx
         inc edx
         inc ch
         cmp ch, 4
         je jump
         
         back_jump:
         cmp dl, cl
         jle rep_link
         mov byte [ebx], 0
         
         jmp finish2
         
         
         jump:
            add edx, 2
            jmp back_jump
  ; =========================== TASK 5 =================================================

bruteforce_singlebyte_xor:
	; TODO TASK 5
                    push ebp
                    mov ebp, esp
                    xor eax, eax
                    xor ebx,ebx
                    xor ecx, ecx
                    xor edx, edx
                    
                    mov eax, [esp  + 8]
                
                    mov byte bh, -1                       ; in bh tin octetul pe care se face bruteforce
              iterate_byte:
                    inc bh                                     ; testez un nou octet
                    mov ecx, 0
             iterate_string:
                    mov byte bl, [eax + ecx]          ; parcurg string-ul byte cu byte
                    push ecx                                    ; salvez index-ul pt a permite modificarea lui la testul caracterelor lui 'force'
                    jmp test_byte                       ; testez daca urmeaza o serie de caractere pe care daca se face xor cu octetul curent ( bh)
             back_test:                                   ; se obtine cuvantul force
                    pop ecx
                    inc ecx                                       ; restaurez index-ul si verific daca urmaturul caracter este terminator de sir
                    cmp byte [eax + ecx], 0           ; pt a trece la urmatoarea varianta a octetului pe care se face bruteforce
                    je iterate_byte
                    jmp iterate_string
                    
               finish_5:
                    mov bl, 0
                    mov bl, bh                    ; pun valoarea cheii in ebx
                    mov bh, 0
                    leave
	ret
test_byte:
        mov byte bl, [eax + ecx]
        xor bl, bh                                 ; iau caracterul curent, fac xor si verific daca este egal cu f
        cmp bl, 'f'                                 ; daca este continui acelasi procedeu si pt urmatoarele caractere din force
        je test_o                                      ; altfel ma intorc si verific alt caracter din string sau daca am ajuns la final 
        jmp back_test                          ; schimb octetul bh
test_o:
        inc ecx
        mov byte bl, [eax + ecx]
        xor bl, bh
        cmp bl, 'o'
        je test_r
        jmp back_test
        
test_r:
        inc ecx
        mov byte bl, [eax + ecx]
        xor bl, bh
        cmp bl, 'r'
        je test_c
        jmp back_test
 test_c:
        inc ecx
        mov byte bl, [eax + ecx]
        xor bl, bh
        cmp bl, 'c'
        je test_e
        jmp back_test
        
test_e:
        inc ecx
        mov byte bl, [eax + ecx]
        xor bl, bh
        cmp bl, 'e'
        je bingo                               ; daca am ajuns aici si corespunde si caracterul e, atunci am gasit octetul ce reprezinta cheia
        jmp back_test                      ; si fac xor intre fiecare byte din string si el
      
bingo:
         mov ecx, 0
   iterate_bingo:
         mov byte bl, [eax + ecx]
         xor bl, bh
         mov byte [eax + ecx], bl
         inc ecx
         cmp byte [eax + ecx], 0                                 ; apoi ies din functie
         jne iterate_bingo
         jmp finish_5
        
        
    ;=====================================TASK 6======================================================


decode_vigenere:
	; TODO TASK 6
                    push ebp
                    mov ebp, esp
                    mov eax, [esp + 8]                           ; encoded
                    mov ebx, [esp + 12]                         ; key
                    
                    xor edx, edx                         ; indice pt encoded
                    xor ecx, ecx                        ; indice pt key
                    
            offset_key:
                    mov byte cl, [ebx + edx]
                    sub cl, 'a'
                    mov byte [ebx + edx], cl                        ; am transformat fiecare litera din key in offset
                    inc edx
                    cmp  byte [ebx + edx], 0
                    jne offset_key
                    mov byte [ebx + edx], -1                    ; terminatorul de sir pt cazul in care offset-ul e 0
                    
                    xor edx, edx                         ; indice pt encoded
                    xor ecx, ecx                        ; indice pt key
                    
            iterate:
                    cmp byte [eax + ecx], ' '
                    je increment
                    cmp byte [eax + ecx], '.'                       ; serie de caractere la care nu sunt encoded
                    je increment
                    cmp byte [eax + ecx], '!'
                    je increment
                    push edx
                    mov byte dh, [ebx + edx]
                    sub [eax + ecx], dh                           ; scad din fiecare caracter din string (ce necesita asta) valoarea ce ii corespunde
                    cmp byte [eax + ecx], 'a'                    ; din cheie (fiind treansformata in intregi)
                    jl reconstruction                               ; daca imi da un numar mai mic decat 'a' trebuie sa se continue sub forma circulara scaderea de la
           back_reconstruction:                                  ; valoarea lui 'z'
                    pop edx
                    inc edx
                    cmp byte [ebx + edx], -1                    ; daca am ajuns la finalul cheii, restaurez indexul de iterare, facandu-l 0
                    je do_zero
        back_from_do_zero:
             increment:
                    inc ecx
                    cmp byte [eax + ecx], 0                 ; daca am ajuns la finalul cheii atunci ies din functie
                    je finish_6
               
                    jmp iterate
                   
                    finish_6:
                    leave
	ret


reconstruction:
      push edx
      xor edx, edx
      mov byte dh, [eax + ecx]
      mov dl, 122
      sub dh, 'a'                                          ; scad din valoarea obtinuata 'a' pt a afla cu cate caractere fata de a s-a dusmai jos pe ascii
      add dh, 123                                       ; obtin un nr negativ la care adun valoarea lui z pe ascii + 1
      mov byte [eax + ecx], dh
      
      pop edx
      jmp back_reconstruction


do_zero:
    mov edx, 0
    jmp back_from_do_zero

main:
	push ebp
	mov ebp, esp
	sub esp, 2300

	; test argc
	mov eax, [ebp + 8]
	cmp eax, 2
	jne exit_bad_arg

	; get task no
	mov ebx, [ebp + 12]
	mov eax, [ebx + 4]
	xor ebx, ebx
	mov bl, [eax]
	sub ebx, '0'
	push ebx

	; verify if task no is in range
	cmp ebx, 1
	jb exit_bad_arg
	cmp ebx, 6
	ja exit_bad_arg

	; create the filename
	lea ecx, [filename + 7]
	add bl, '0'
	mov byte [ecx], bl

	; fd = open("./input{i}.dat", O_RDONLY):
	mov eax, 5
	mov ebx, filename
	xor ecx, ecx
	xor edx, edx
	int 0x80
	cmp eax, 0
	jl exit_no_input

	; read(fd, ebp - 2300, inputlen):
	mov ebx, eax
	mov eax, 3
	lea ecx, [ebp-2300]
	mov edx, [inputlen]
	int 0x80
	cmp eax, 0
	jl exit_cannot_read

	; close(fd):
	mov eax, 6
	int 0x80

	; all input{i}.dat contents are now in ecx (address on stack)
	pop eax
	cmp eax, 1
	je task1
	cmp eax, 2
	je task2
	cmp eax, 3
	je task3
	cmp eax, 4
	je task4
	cmp eax, 5
	je task5
	cmp eax, 6
	je task6
	jmp task_done


task1:
	; TASK 1: Simple XOR between two byte streams

	; TODO TASK 1: find the address for the string and the key
	; TODO TASK 1: call the xor_strings function


                    xor edx, edx
             
          iterate_1:
                   
                    mov byte al, [ecx + edx]
                    inc edx
                    cmp al, 0
                    jne iterate_1
                    
                    add ecx, edx
                    push ecx                ;adresa cheii
                    sub ecx, edx
                    dec edx
                    push ecx                 ; adresa de inceput
                   
                    call xor_strings
                    add esp, 8
                    mov ecx, eax
                    
	push ecx
	call puts                   ;print resulting string
	add esp, 4

	jmp task_done

task2:
	; TASK 2: Rolling XOR

	; TODO TASK 2: call the rolling_xor function
                    
                    xor edx, edx
                    xor eax, eax

                    push ecx                 ; adresa de inceput
                    
                    call rolling_xor
                    add esp, 4
                    mov ecx, eax

	push ecx
	call puts
	add esp, 4

	jmp task_done


convert_al_from_char:
                sub al, 'a'
                add al, 10
                jmp back_al
                


task3:
	; TASK 3: XORing strings represented as hex strings

	; TODO TASK 1: find the addresses of both strings
	; TODO TASK 1: call the xor_hex_strings function
 
                        xor edx, edx
                        xor ebx, ebx   ; dimensiunea sirului dupa conversie
                        xor eax, eax
                        
                        mov ebx, ecx
                        
                parse_33:
            
                   mov byte al, [ebx + edx]
                    inc edx
                   cmp al, 0                                           ; numar cate caractere am in string
                   jne parse_33
           
                  add ebx, edx
                  push ebx                ;adresa cheii
                    
                    push ecx                 ; adresa de inceput
                    
                    call xor_hex_strings
                    add esp, 8
                    mov ecx, eax

	push ecx                     ;print resulting string
	call puts
	add esp, 4

	jmp task_done

task4:
	; TASK 4: decoding a base32-encoded string

	; TODO TASK 4: call the base32decode function
                    xor eax, eax
                    xor edx, edx
            size:
                    mov byte al, [ecx + edx]
                    inc edx
                    cmp al, 0
                    jne size
                    dec edx
                    push edx      ; push la dimensiune
                    push ecx      ; push la string
                    call base32decode
                    add esp, 8
	  
                    mov ecx, eax
	push ecx
	call puts                    ;print resulting string
	pop ecx
	
	jmp task_done

task5:
	; TASK 5: Find the single-byte key used in a XOR encoding

	; TODO TASK 5: call the bruteforce_singlebyte_xor function
                    push ecx
                    call bruteforce_singlebyte_xor
                    add esp, 4
                    mov ecx, eax

	push ecx                    ;print resulting string
	call puts
	pop ecx
                    
                    mov eax, ebx
                    
	push eax                    ;eax = key value
	push fmtstr
	call printf                 ;print key value
	add esp, 8

	jmp task_done

task6:
	; TASK 6: decode Vignere cipher

	; TODO TASK 6: find the addresses for the input string and key
	; TODO TASK 6: call the decode_vigenere function

	push ecx
	call strlen
	pop ecx

	add eax, ecx
	inc eax

	push eax
	push ecx                   ;ecx = address of input string 
	call decode_vigenere
	pop ecx
	add esp, 4

	push ecx
	call puts
	add esp, 4

task_done:
	xor eax, eax
	jmp exit

exit_bad_arg:
	mov ebx, [ebp + 12]
	mov ecx , [ebx]
	push ecx
	push usage
	call printf
	add esp, 8
	jmp exit

exit_no_input:
	push filename
	push error_no_file
	call printf
	add esp, 8
	jmp exit

exit_cannot_read:
	push filename
	push error_cannot_read
	call printf
	add esp, 8
	jmp exit

exit:
	mov esp, ebp
	pop ebp
	ret
