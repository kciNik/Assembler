	.model small
	.stack 100h
	.data
key	db	'w', 0
string	db	'Hweeq', 0
	.code
	mov ax, @data
	mov ds, ax	
	mov es, ax
	cld
	call cipher
	call cipher 
	mov ax,4c00h
    	int 21h
	
cipher	proc
	locals @@
	lea di, string
	xor bx, bx
	xor dx, dx
	xor cx, cx
	push cx
	push cx
	push cx
	jmp @@ls
@@cha:	mov al, 255
	jmp @@mmm
@@chng:	mov al, 0
	jmp @@mmm1
@@ls:	lea si, key
	pop cx
	cmp cx, 0
	je @@m1
	mov cx, dx
@@lp1:	inc si
	loop @@lp1
@@m1:	lodsb
	cmp al, 0
	je @@m2
	mov bl, al
	lea si, string
	pop cx
	cmp cx, 0
	je @@mm
@@lp2:	inc si
	loop @@lp2
@@mm:	lodsb
	cmp al, 0
	je @@gg
	cmp al, 255
	je @@chng
@@mmm1:	xor al, bl
	cmp al, 0
	je @@cha
@@mmm:	stosb
	pop cx
	inc cx
	inc dx
	push cx
	push cx
	push cx
	jmp @@ls
@@m2:	xor dx, dx
	lea si, key
	jmp @@m1
@@gg:	pop cx
	ret
	endp
	end