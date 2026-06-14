// Programa funciona tomar como ejemplo
// No funciona completamente

.model smalL
.stack 100h
.data 
    num1 db 6
    num2 db 3
    def db 0
.code 
main:
  mov ax, @data
  mov ds,ax

  inc num1
  inc num1

  dec num2
  dec num2

  mov al, num2
  neg al
  add al, num1

  mov def,al

end main
