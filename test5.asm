; The following program is a small game in assembler. It will only run in the MCU8051 IDE due to some simulation components. The game is about a random pattern is showed for a short time period, and the user has to rebuild this pattern. The user will start with the score 3 and will +1 hen he has the pattern corect. -1 when the rebuild pattern is wrong.

; We the need the following components
; P0 7 LED Display
; P1 simple keypad
; P2 column of LED Matrix P2.0 - P2.6. P2.7 is unused
; P3 only P3.0 is used for the first row
;INIT Begin
score_board DATA P0
input DATA P1
output_x DATA P2
output_y DATA P3

;Prepare Lines
COUNT EQU 10H
COUNT2 EQU 98H
LINE1 EQU 20H
LINE2 EqU 30H
LINE3 EqU 40H
LINE4 EqU 50H
LINE01 EQU 60H
LINE02 EqU 70H
LINE03 EqU 80H
LINE04 EqU 90H


;Constanly enable 1 to A in LED matrix
mov output_y, #01h
mov count, #04h
mov count2, #04h
jmp init




;INIT END

win:
	mov output_x, #11000000b
	lcall wait
	mov output_x, #00110000b
	lcall wait
	mov output_x, #00001100b
	lcall wait
	mov output_x, #00000011b
	lcall wait
	mov output_x, #11000000b
	lcall wait
	mov output_x, #00110000b
	lcall wait
	mov output_x, #00001100b
	lcall wait
	mov output_x, #00000011b
	lcall wait
	jmp init


init:
	;The score of the user is saved in R7
	;Starting with score R7 =3
	mov R7, #03h
	;Set 7seg to 3
	lcall three_seg
	;Starting begin simulation
	lcall animation_anfang
	mov output_x, #0FFh

start:
	
	lcall wait
	mov A, R7
checkifwin:
	jmp iswin
checkiflost:
	cjne A, #00h, random
	jmp game_over

iswin:
	cjne A, #05h, checkiflost
	jmp win
random:
	MOV A, COUNT
	JZ random1
	SUBB a, #01
	JZ random1
	SUBB a, #01
	JZ random1
	SUBB a, #01
	JZ random1
	SUBB a, #01
	JZ random1

	mov output_x, R2
	lcall wait
	mov R0, output_x
	mov A, #001111111b
	anl A, R0
	mov R0, A
	mov output_x, #0FFh
	jmp eingabe

random1:	
	dec R2
	inc R5
	mov A, R2
	add A, R5
	mov R2, A
	mov output_x, R2
	mov A, input
	cjne A, #00h, random1
	mov LINE1, R2
	dec COUNT
	jmp random
random2:	
	mov output_y, #01h
	mov output_X, line1
	lcall wait
	mov output_y, #02h
	dec R2
	inc R5
	mov A, R2
	add A, R5
	mov R2, A
	mov output_x, R2
	mov A, input
	cjne A, #00h, random2
	mov LINE2, R2
	dec COUNT
	jmp random
random3:	
	mov output_y, #01h
	mov output_X, line1
	lcall wait
	mov output_y, #02h
	mov output_x, line2
	lcall wait
	mov output_y, #04h
	dec R2
	inc R5
	mov A, R2
	add A, R5
	mov R2, A
	mov output_x, R2
	mov A, input
	cjne A, #00h, random3
	mov LINE3, R2
	dec COUNT
	jmp random
random4:	
	mov output_y, #01h
	mov output_X, line1
	lcall wait
	mov output_y, #02h
	mov output_x, line2
	lcall wait
	mov output_y, #04h
	mov output_x, line3
	lcall wait
	mov output_y, #08h
	dec R2
	inc R5
	mov A, R2
	add A, R5
	mov R2, A
	mov output_x, R2
	mov A, input
	cjne A, #00h, random4
	mov LINE4, R2
	dec COUNT
	jmp random

eingabe: ;Eingabe des Musterrs
	MoV count, #04h
zeile_0:
        MOV A, COUNt
	SUBB a, #01
	JZ zeile_4
	SUBB a, #01
	JZ zeile_3
	SUBB a, #01
	JZ zeile_2
	SUBB a, #01
	JZ Zeile_1
zeile_1: 
	mov A, input
	mov output_x, A
	jnb P1.7, zeile_1
	mov line01, A
	dec count
	jmp zeile_0
zeile_2: 
	mov output_y, #01h
	mov output_X, line01
	lcall wait
	mov output_y, #02h
	mov A, input
	mov output_x, A
	lcall wait
	mov line02, A
	jb P1.7, zeile_2
	dec count
	jmp zeile_0
zeile_3: 
	mov output_y, #01h
	mov output_X, line01
	lcall wait
	mov output_y, #02h
	mov output_x, line02
	lcall wait
	mov output_y, #04h
	mov A, input
	mov output_x, A
	lcall wait
	jnb P1.7, zeile_3
	mov line03, A
	dec count
	jmp zeile_0
zeile_4: 
	mov output_y, #01h
	mov output_X, line01
	lcall wait
	mov output_y, #02h
	mov output_x, line02
	lcall wait
	mov output_y, #04h
	mov output_x, line03
	lcall wait
	mov output_y, #08h
	mov A, input
	mov output_x, A
	lcall wait
	jb P1.7, zeile_4
	mov line04, A
	
abfrage: 
	mov A, LINE01
	cjne A, LINE1, falsch
	mov A, LINE02
	cjne A, LINE2, falsch
	mov A, LINE03
	cjne A, LINE3, falsch
	mov A, LINE04
	cjne A, LINE4, falsch

richtig: 
	mov A, R7
	inc A
	mov R7, A
	lcall select_7seg
	jmp start

falsch:
	mov A, R7
	dec A
	mov R7, A
	lcall select_7seg
	jmp start

wait:
	mov R5, #02h
w1_s1:
	mov R6, #001h

w1_s2:
	djnz R6, w1_s2
	djnz R5, w1_s1	
	ret 	

animation_anfang:
	mov output_x, #10101010b
	lcall wait
	mov output_x, #01010101b
	lcall wait
	mov output_x, #10101010b
	lcall wait
	ret

select_7seg:
	cjne R7, #00h, one_seg
	mov score_board, #00111111b  
	jmp game_over
	ret

one_seg:
	cjne R7, #01h, two_seg
	mov score_board, #00000110b
	ret
two_seg:
	cjne R7, #02h, three_seg
	mov score_board, #01011011b
	ret
three_seg:
	cjne R7, #03h, four_seg
	mov score_board, #01001111b
	ret 
four_seg:
	cjne R7, #04h, five_seg
	mov score_board, #01100110b
	ret
five_seg:
	cjne R7, #05h, game_over
	mov score_board, #01101101b
	ret
game_over:
	lcall wait
	lcall animation_anfang
	lcall wait
	lcall animation_anfang
	lcall wait
	jmp init
	
end