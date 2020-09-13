	.model medium
public output, inputline, input, readfile, writefile, menu, crypto
extrn start:far
extrn key:byte
extrn keylen:word
	.code
output proc
	locals @@
@@buffer equ [bp+6]
	push bp
	mov bp, sp
	push ax
	push bx
	push cx
	push dx
	push di
	mov di, @@buffer
	xor al, al
	mov cx, 0ffffh
	repne scasb
	neg cx
	dec cx
	dec cx
	jcxz @@ex
	cmp cx, 4095
	jbe @@m
	mov cx, 4095
@@m: mov ah, 40h
	xor bx, bx
	inc bx
	mov dx, @@buffer
	int 21h
@@ex: pop di
	pop dx
	pop cx
	pop bx
	pop ax
	pop bp
	ret
	endp
input	proc
	locals @@
@@buffer	equ [bp+6]
	push bp
	mov bp,sp
	push ax
	push bx
	push cx
	push dx
	push di
	xor bx,bx
	mov cx,4095
	mov dx,@@buffer
@@m1:	mov ah,3fh
	int 21h
	jc @@ex
	cmp ax,2
	je @@m2
	sub cx,ax
	jcxz @@m2
	add dx,ax
	jmp @@m1
@@m2:	mov di,@@buffer
	add di,4095
	sub di,cx
	xor al,al
	stosb
@@ex:	pop di
	pop dx
	pop cx
	pop bx
	pop ax
	pop bp
	ret
	endp
inputline proc
	locals @@
@@buffer	equ [bp+6]
	push bp
	mov bp, sp
	mov bp,sp
	push ax
	push bx
	push cx
	push dx
	push di
	mov ah, 3fh
	xor bx, bx
	mov cx, 80
	mov dx, @@buffer
	int 21h
	jc @@ex
	cmp ax, 80
	jne @@m
	stc
	jmp short @@ex
@@m: mov di, @@buffer
	dec ax
	dec ax
	add di, ax
	xor al, al
	stosb
@@ex: pop di
	pop dx
	pop cx
	pop bx
	pop ax
	pop bp
	ret
	endp
readfile proc
	locals @@
@@buffer equ [bp+6]
@@filename equ [bp+8]
	push bp
	mov bp, sp
	push ax
	push bx
	push cx
	push dx
	push di
	mov ax, 3d00h
	mov dx, @@filename
	int 21h
	jc @@ex
	mov bx, ax
	mov cx, 4095
	mov dx, @@buffer
@@m1: mov ah, 3fh
	int 21h
	jc @@er
	or ax, ax
	je @@m2
	sub cx, ax
	jcxz @@m2
	add dx, ax
	jmp @@m1
@@m2: mov di, @@buffer
	add di, 4095
	sub di, cx
	xor al, al
	stosb
	mov ah, 3eh
	int 21h
@@ex: pop di
	pop dx
	pop cx
	pop bx
	pop ax
	pop bp
	ret
@@er: mov ah, 3eh
	int 21h
	stc
	jmp @@ex
	endp
writefile proc
	locals @@
@@filename equ [bp+8]
@@buffer equ [bp+6]
	push bp
	mov bp,sp
	push ax
	push bx
	push cx
	push dx
	push di
    mov ah,3ch
	xor cx,cx
	mov dx,@@filename
	int 21h
	jc @@ex
	mov bx, ax
	mov di, @@buffer
	xor al, al
	mov cx, 0ffffh
	repne scasb
	neg cx
	dec cx
	dec cx
	jcxz @@ex1
	cmp cx, 4095
	jbe @@m
	mov cx, 4095
@@m: mov ah, 40h
	mov dx, @@buffer
	int 21h
	jc @@er
@@ex1: mov ah, 3eh
	int 21h
@@ex: pop di
	pop dx
	pop cx
	pop bx
	pop ax
	pop bp
	ret
@@er:	mov ah, 3eh
	int 21h
	stc
	jmp @@ex
	endp
menu proc
	locals @@
@@ax	equ [bp-82]
@@buffer equ [bp-80]
@@items equ[bp+6]
	push bp
	mov bp, sp
	sub sp,80
	push ax
@@m: push @@items
	call output
	pop ax
	jc @@ex
	push ds
	push es
	push ss
	push ss
	pop ds
	pop es
	mov ax, bp
	sub ax, 80
	push ax
	call inputline
	pop ax
	pop es
	pop ds
	jc @@ex
	mov al, @@buffer
	cbw
	sub ax,'0'
	cmp ax, 0
	jl @@m
	cmp ax, @@ax
	jg @@m
	clc
@@ex: mov sp, bp
	pop bp
	ret
	endp
space	proc
	locals @@
	push ax
	push cx
	push di
	xor ax, ax
	mov cx,65535
	repne scasb 
	neg cx 
	dec cx
	push cx 
@@m1:	pop cx
	pop di
	push di
	push cx
	lodsb 
	repne scasb
	jcxz @@m2
	jmp @@m1
@@m2:	dec si
	add sp,2
	pop di
	pop cx
	pop ax
	ret
	endp
words	proc
	locals @@
	push ax
	push cx
	push di
	xor al,al
	mov cx,65535
	repne scasb
	neg cx
	push cx
@@m:	pop cx
	pop di
	push di
	push cx
	lodsb
	repne scasb
	jcxz @@m
	dec si
	add sp,2
	pop di
	pop cx
	pop ax
	ret
	endp
crypto proc
	local @@
@@ibuf equ [bp+6]
@@obuf equ [bp+8]
	push bp
	mov bp, sp
	push ax
	push bx
	push cx
	push dx
	push si
	push di
mov si, @@ibuf
mov di, @@obuf
xor bx, bx
jmp @@loop
@@pr:
mov [di], al
inc di
@@loop:
cld             ;cброс флага направления
xor ax,ax
lodsb     ;загружаем в al символ по адресу si, увеличиваем si на 1
@@c:
	  cmp al,32       ;сравниваем с пробелом
	  jne @@j1          ;если не равен продолжаем сравнение
	  jmp @@pr          ;иначе пропускаем
@@j1:
    cmp al,44       ;сравниваем с запятой
	  jne @@j2          ;если не равен продолжаем сравнение
	  jmp @@pr          ;иначе пропускаем
@@j2:
    cmp al,59       ;сравниваем с точкой-запятой
  	jne @@j3          ;если не равен продолжаем сравнение
  	jmp @@pr          ;иначе пропускаем
@@j3:
    cmp al,13       ;сравниваем с символом возврата каретки
  	jne @@j4          ;если не равен продолжаем сравнение
  	jmp @@pr          ;иначе пропускаем
@@j4:
    cmp al,10       ;сравниваем с \n
  	jne @@j5          ;если не равен продолжаем сравнение
  	jmp @@pr          ;иначе пропускаем
@@j5:
    cmp al, 0      ;сравниваем с концом строки
  	jne @@j6          ;если не равен обрабатываем
  	jmp @@endstr      ;иначе завершаем
@@j6:
    xor al,  key[bx] ;сумма по модулю 2 с ключом
    inc bx    ;увеличиваем счетчик ключа
    cmp bx, keylen ;проверяем длину
    jne @@t       ;если не равно продолжаем
    xor bx, bx  ;иначе обнуляем его
    @@t:
    mov [di], al 
    inc di
jmp @@loop    ;повторяем пока не дойдем до конца строки
@@endstr:     ;выходим из макроса
pop di
pop si
pop dx
pop cx
pop bx
pop ax
pop bp
ret
endp
	end
