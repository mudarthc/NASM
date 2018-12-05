%include "asm_io.inc"

SECTION .data

; strings are defines here
; with arr being the empty array with a length of 9
; The messages for the pegs are also initialized here


arr: dd 0,0,0,0,0,0,0,0,0
err1: db "incorrect number of command line arguments",10,0

err2: db "incorrect command line argument",10,0
X1: db "XXXXXXXXXXXXXXXXXXX",10,0
One1: db "        o|o        ",10,0
Two1: db "	 oo|oo       ",10,0
Three1: db "	  ooo|ooo      ",10,0
Four1: db "     oooo|oooo     ",10,0
Five1: db "    ooooo|ooooo    ",10,0
Six1: db "   oooooo|oooooo   ",10,0
Seven1: db "  ooooooo|ooooooo  ",10,0
Eight1: db " oooooooo|oooooooo ",10,0
Nine1: db "ooooooooo|ooooooooo",10,0
finals: db "final configuration",10,0
finalss: db "initial configuration",10,0

SECTION .bss

SECTION .text
   global  asm_main


sorthem:

;sorthem function is defined

   enter 0,0             ; setup routine
   pusha                 ; save all registers

cmp ecx, 1 ; compare number of disks to 1
je ENDOF  ; of less than 1 terminate function

add edx, 4   ; call sorthem for array + 4 and n - 1
sub ecx, 1
push edx
push ecx
call sorthem
add esp, 8

mov eax, 0   ; move eax to 0, move edx to ebx, shift ebx over 1 and set esi to 0
mov ebx, edx
add ebx, 4
mov esi, 0


; REC is the loop
; subtract disks by 1 and compare to compare to eax
; mov ebp to the first number of array and compare to first number of edx
; if ebp is above jump to GREAT else jump to ACC
; continue by incrementing values
; jump back to loop

REC:
    	sub ecx, 1
        cmp eax, ecx
        je ACC
	add ecx, 1

        mov ebp, dword [ebx]
        cmp ebp, dword [edx]

        ja GREAT
        jb ACC

        FOLL:
        add edx, 4
        add ebx, 4
        add eax, 1
        add esi, 4
        jmp REC


; GREAT is used to swap places if number before is less than the number to the right
; swaps numbers then jumps to FOLL to continue incrementing

GREAT:
mov edi, dword [edx]
mov ebp, dword [ebx]
mov dword [edx], ebp
add edx, 4
mov dword [edx], edi
sub edx, 4
mov edi, 1
jmp FOLL

; ACC goes to function showp using address of global array and original number of disks
; this function also prevents the same pegs being printed twice by comparing edi to 1 to see if a change was made
; if no change made skip to ENDOF
; if change is made  move pointer to end of array and call showp

ACC:
cmp edi, 1
jne ENDOF
sub edx, esi
mov eax, ecx
mov ebx, 0
NO:
add ebx, 4
dec eax
cmp eax, 0
je YES
jmp NO
YES:
mov eax, ebx
add edx, eax
push ecx
mov edx, arr


add edx, 32
push edx
call showp
add esp, 8
add edx, esi

; ENDOF simply pops and returns all registers

ENDOF:
 popa
   leave
   ret


; showp shows configuration of pegs

showp:

   enter 0,0             ; setup routine
   pusha
   mov eax, [ebp+12]	  ; the parameter

mov ebx, ecx

call read_char   ; character is read before begining

mov ecx, dword 1

; VIEW loops to compare number to number from 2-9 in order to display configuration for each line
VIEW:

cmp dword [edx], 1
je ONE

cmp dword [edx], 2
je TWO

cmp dword [edx], 3
je THREE

cmp dword [edx], 4
je FOUR

cmp dword [edx], 5
je FIVE

cmp dword [edx], 6
je SIX

cmp dword [edx], 7
je SEVEN

cmp dword [edx], 8
je EIGHT

cmp dword [edx], 9
je NINE

CO9:
 ; after comparing loop is checked to see if it is less than or euqal to 9 if it is jump to VIEW again

sub edx, 4
inc ecx

cmp ecx, 9
jbe VIEW

jmp OVER ; jump to OVER if greater than 9

; ONE, TWO .. used to display configuration for each line

ONE:
mov eax, One1
call print_string
call print_nl
jmp CO9

TWO:
mov eax, Two1
call print_string
call print_nl
jmp CO9


THREE:
mov eax, Three1
call print_string
call print_nl
jmp CO9

FOUR:
mov eax, Four1
call print_string
call print_nl
jmp CO9


FIVE:
mov eax, Five1
call print_string
call print_nl
jmp CO9

SIX:
mov eax, Six1
call print_string
call print_nl
jmp CO9

SEVEN:
mov eax, Seven1
call print_string
call print_nl
jmp CO9

EIGHT:
mov eax, Eight1
call print_string
call print_nl
jmp CO9

NINE:
mov eax, Nine1
call print_string
call print_nl
jmp CO9


; OVER prints string and pops and returns all registers

OVER:

mov eax, X1
call print_string
call print_nl
   popa
   leave
   ret


; printi is an initial configuration printer
; calls the string for message
; then pushes two registers and calls show for initial configuration

printi:

   enter 0,0             ; setup routine
   pusha                 ; save all registers

   mov eax, [ebp+12]	  ; the parameter

mov eax, finalss
call print_string
call print_nl

push ecx
push edx
call showp
add esp, 8

   popa
   leave
   ret


; printf prints final configuration
; the message is printed
; then loops the first item through array to see where to place it in descending order

printf:

   enter 0,0             ; setup routine
   pusha                 ; save all registers

   mov eax, [ebp+12]	  ; the parameter

call print_nl
mov edx, ebx
add edx, 4
mov esi, 0

 LOOpPP:
 ; Loops through array to see where to place head of array

        mov eax, dword [ebx]
        cmp dword [edx], 9   ;in event that eax is 1
        ja FINAL
        cmp eax, dword [edx]
        jb BELOW
        jmp FINAL
        FOLLw:
	add ebx, 4
        add edx, 4
        add esi, 4
        jmp LOOpPP

; If head is below swap places
; and continue the loop

BELOW:
mov edi, dword [ebx]
mov ebp, dword [edx]
mov dword [ebx], ebp
add ebx, 4
jmp FOLLw

; final sees if first any changes were made
; if changes were made call showp

FINAL:
cmp esi, 0
je LOST
sub ebx, esi
add ebx, 32
mov edx, ebx
push ecx
push edx
call showp
add esp, 8

; this pop and returns all registers

LOST:
   popa
   leave
   ret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

asm_main:

   enter 0,0             ; setup routine
   pusha                 ; save all registers

   mov eax, dword [ebp+8]   ; argc
   cmp eax, dword 2         ; argc should be 2
   jne ERR1
   ; so we have the right number of arguments
   mov ebx, dword [ebp+12]  ; address of argv[]
   mov eax, dword [ebx+4]   ; argv[1]
   mov bl, byte [eax]       ; 1st byte of argv[1]
   try1: cmp bl, '2' ;compare to 2
   jge try2 ; if greater or equal to 2 jump
   jmp ERR2 ; jump to error if not
   try2: cmp bl, '9' ;compare to 9
   jg ERR2 ; if greater than 9 go to error
   byte_1_ok:
   sub bl, '0'
   mov ecx,0
   mov cl, bl               ; so ecx holds either number from 2 - 9
   ; check the second byte
   mov bl, byte [eax+1]     ; 2nd byte of argv[1]
   cmp bl, byte 0
   jne ERR2

; used to modify pointer of array

mov eax, ecx
mov ebx, eax
dec ebx
dec ebx
mov eax, 4
mul ebx
mov ebx, eax
mov eax, ecx
mov edx, arr


; rconf is called

push ecx
push edx
call rconf
add esp, 8


; pointer of array modified
sub edx, ebx
mov ecx, eax
inc ecx
add edx, 32

; array and number of disks pushed
; print i is called to shw initial configuration

push edx
push ecx
call printi
add esp, 8

; sorthem is called
; subtract by 32 to start at first number at array

sub edx, 32
mov eax, dword [edx]
call print_nl
push edx
push ecx
call sorthem
add esp, 8

; printf is called to show final configuration

mov ebx, arr
push ebx
push ecx
call printf
add esp, 8

; showp is called again last time to show final configuration with message

mov eax, finals
call print_string
call print_nl
mov ebx, arr
add ebx, 32
mov edx, ebx
push ecx
push ebx
call showp
add esp, 8


jmp asm_main_end ; jmp to the end and pop and reutrn

 ERR1:   ; ERR1 is the error, jmp to end if there is an error
   mov eax, err1
   call print_string
   jmp asm_main_end

 ERR2: ; ERR2 is an error, jmp to end and return/ pop
   mov eax, err2
   call print_string
   jmp asm_main_end

 asm_main_end:
   popa                  ; restore all registers
   leave
   ret

