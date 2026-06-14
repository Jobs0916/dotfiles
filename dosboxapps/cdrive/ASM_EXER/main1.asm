.186  ;   o   286
title Programa que muestra un mensaje
pila segment stack 'stack'
  db 64 dup(?)
pila ends
datos segment
	msg db ' <<< HOLA A TODOS >>> atte: Crispin Condori Rodriguez$'
datos ends
;
codigo segment
	assume ds:datos,cs:codigo,ss:pila
	principal proc far	
		mov ax,datos
		mov ds,ax
		;================= PROGRAMA ====================================
		;lea dx,msg
		mov dx,offset msg
		mov ah,9
		int 21h
		;==================== FIN ========================================
		mov ah,4ch
		int 21h	
		ret
	principal endp
codigo ends
end principal