.model small
public crypto
extrn start : far
extrn key : byte
extrn keylen : word

.code
crypto proc
	local @@
	@@ibuf equ [bp+6]
	@@obuf equ [bp+8]
	push bp
	push ax
	push bx
	push cx
	push dx
	push si
	push di
mov bp, sp
mov si, @@ibuf
mov bx, @@obuf
push bx
xor bx, bx
@@pr:
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
    cmp al,'$'      ;сравниваем с концом строки
  	jne @@j6          ;если не равен обрабатываем
  	jmp @@endstr      ;иначе завершаем
@@j6:
    xor al,  key[bx] ;сумма по модулю 2 с ключом
    inc bx    ;увеличиваем счетчик ключа
    cmp bx, keylen ;проверяем длину
    jne @@t       ;если не равно продолжаем
    xor bx, bx  ;иначе обнуляем его
    @@t:
    pop di
    mov di, si   ;берем адрес следущего символа
    dec di        ;уменьшаем на 1
    mov [di], al  ;заносим зашифрованный символ
jmp @@pr    ;повторяем пока не дойдем до конца строки
@@endstr:     ;выходим из макроса
pop dx
pop di
pop si
pop dx
pop cx
pop bx
pop ax
pop bp
ret
crypto endp
end