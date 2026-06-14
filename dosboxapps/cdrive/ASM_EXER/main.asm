 .model small
 .stack 100h

.data
 mensaje db 'Hola, mundo $'
	
.code
main:
    mov ax, @data       ; 1. Pone la dirección de los datos en AX
    mov ds, ax          ; 2. Mueve AX a DS (registro de datos)

    mov ah, 09h         ; 3. Función DOS: mostrar cadena
    lea dx, mensaje     ; 4. Carga la dirección del mensaje
    int 21h             ; 5. Llama a DOS

    mov ax, 4C00h       ; 6. Función DOS: terminar programa
    int 21h             ; 7. Ejecuta la función
end main
