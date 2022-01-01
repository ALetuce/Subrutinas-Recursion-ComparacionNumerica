	.data
mode:	.byte 3
numero: .byte 8 @ max 4351
str1:	.ascii ""
str2:	.ascii ""
lens1:	.byte -
lens2:	.byte -
arr:	.word 8,6,4,2,2,4,6,8
	

	.text
main:	ldr r0, =mode
	ldrb r1, [r0]
	
	cmp r1, #1
	beq mod1
	cmp r1, #2
	beq mod2	
	cmp r1, #3
	beq mod3	

mod1:	ldr r2, =lens1		@ funcion StringIsReverse
	ldrb r0, [r2] 		@ r0 <- lenght str1
	ldr r2, =lens2
	ldrb r1, [r2]		@ r1 <- lenght str2
	cmp r0, r1
	bne log_0 		@ retorna 0 a la consola 
	@mov r0, #4		@ r0 <- 4
	@mul r1, r0, r1		@ r1 = 4*r1
	ldr r1, =str2		@ r1 <- puntero str2
	sub r0, #1		@ restamos 1 por el rango [0-3]
	mov r5, r0
	mov r3, #0		@ r3 = i -> para recorrer la memoria 
	mov r4, r13
	b inv_s
	@ r0 = indice i (decreciente) | largo del string | palabra a comparar str1	
	@ r1 = puntero a str2 | puntero a str1
	@ r3 = indice i (creciente)
	@ r4 = puntero memoria r13
	@ r5 = guarda largo del string
	@ r6 = palabra a comparar str2
inv_s:	ldrb r2, [r1, r0]
	strb r2, [r4, r3]	
	cmp r0, #0
	beq cmp_s

	add r3, #1		@ r3 + 4
	sub r0, #1		@ r1 - 4	
	b inv_s
	
cmp_s:	ldr r6, =str1
	mov r3, #0

loop1:	ldrb r0, [r6, r3]
	ldrb r1, [r4, r3] 	
	cmp r0, r1
	bne log_0
	
	cmp r3, r5
	beq log_1
	add r3, #1
	b loop1

mod2:	ldr r0, =numero
	ldrb r1, [r0]

	mov r5, #0 	@ contador
	mov r6, #0	@ acceso arr tipo append -> mult de 4
	mov r7, #0	@ acceso arr por valor ordenado -> recorre el arreglo 

	b f_rec
	@ r0 = dividendo variable	
	@ r1 = divisor 2 | 3
	@ r2, r3 cambian cuando sdivide -> confiables?
	@ r2 = valor temporal <- r13 para acceder al arreglo
	@ r4 = guarda el valor original en rec, sin el se pierde luego de la primera division
	@ r5 = contador retorno
	@ r6 = acceso arr -> append
	@ r7 = acceso arr -> recorre el arreglo
	
@ recordatorio, con sdivide cambia r0, r1, r2 y r3
f_rec: 	cmp r1,  #0
	bne rec
	  sub r7, #4
	  sub r5, r6, r7
	  mov r0, r5
	  mov r1, #4
	  bl sdivide
	  @ en r0 queda el resultado final 
	  mov r2, r0
	  mov r0, #0
       	  mov r1, #0
	  bl printInt
	  b endsim
rec:	mov r4, r1	@ en rec guardamos los 2 valores //2 y //3 en la memoria

	mov r0, r4	
	mov r1, #2	
	bl sdivide
	mov r2, r13	@ base del arreglo en r2
	str r0, [r2, r6]@ almacenamos el valor //2
	add r6, #4
	
	mov r0, r4	
	mov r1, #3
	bl sdivide
	mov r2, r13	@ base del arreglo en r2
	str r0, [r2, r6]@ almacenamos el valor //3
	add r6, #4

	mov r2, r13	@ base del arreglo en r2
	ldr r1, [r2, r7]
	add r7, #4

	b f_rec

	
	

mod3:	ldr r2, =numero
	ldrb r1, [r2]	
	sub r1, r1, #1		@ restamos 1 arr[0-5] 	
	mov r0, #0		@ inicializamos r0 en 0
	ldr r3, =arr

	@ r0 = i
	@ r1 = N-1
	@ r2 = #4 | registro de almacenamiento temporal
	@ r3 = arr pointer

	@ [por definir] r4 = valor Xi | valor de acceso Xi
	@ [por definir] r5 = valor X2n-i | valor de acceso X2n-i
	@ [por definir] r6 = suma -> valor de retorno  
loop3:	cmp r0, r1
	bgt log_r6
	  mov r2, #4
	  mov r4, r0
	  mov r5, r1
	  mul r4, r2, r4	@ r4 = 4*i
	  mul r5, r2, r5	@ r5 = 4*2n-i

	  ldrb r4, [r3, r4]	@ se cargo el valor Xi en r4
	  ldrb r5, [r3, r5]	@ se cargo el valor X2n-i en r5
	  cmp r4, r5
	  ble else
	    @ si r4 es mayor estricto que r5
	    sub r2, r4, r5	@ calculamos la diferencia
	    sub r6, r6, r2 	@ restamos al valor de retorno
	    b cont 		@continue
else:	  @ si r4 es menor o igual a r5
	  sub r2, r5, r4
	  add r6, r6, r2
	  
cont:	  sub r1, r1, #1
	  add r0, r0, #1
	b loop3

log_r6:	mov r2, r6
	mov r0, #0
	mov r1, #0
	bl printInt
	b endsim

log_0:	mov r2, #0
	mov r0, #0
	mov r1, #0
	bl printInt
	b endsim

log_1:	mov r2, #1
	mov r0, #0
	mov r1, #0
	bl printInt
	b endsim

endsim:	wfi
	.end
