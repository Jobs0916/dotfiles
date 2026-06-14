.model smalL
.stack 100h
.data
.code 
main:
   mov ax,@data
   mov ds,ax

   mov al, 255
   add al,1  
end main

