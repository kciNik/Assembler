	.model small
	.stack 100h
	.486
	.data
a dw 100
b dw 93
	.code
	mov ax, @data
	mov ds, ax
	mov ax, a
	mov bx, b
	div bx
	xor ax, ax
	xor bx, bx
	mov cx, 16
	JMP loop_start
	point2:
	inc al
	JMP there2
	point:
	inc bl
	CMP bl, 3
	JE point2
	JMP there
	loop_start:
	shr dx, 1
	JAE point; if cf == 0
	there2:
	xor bx, bx
	there:
	LOOP loop_start
	mov ax, 4C00h
	int 21h
	end