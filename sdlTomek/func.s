	; rdi - poczatek bitmapy -> r15
	; rsi - ilosc pixeli ->r14
	; rdx - opcja (0-rozciaganie histogramu; 1-zmiana kontrastu)
	; xmm0 - parameter(wspolczynik zmiany kontrastu)-> r13 (tylko jesli kontrast)


section .data
	align 64
	lutR TIMES 256 DB 0
	lutG TIMES 256 DB 0
	lutB TIMES 256 DB 0
	lut TIMES 256 DB 0 ;zmiana kontrastu
	minMaxTable TIMES 256 DB 0 ;Bmin, Bmax, Gmin, Gmax, Rmin, Rmax, Amin, Amax
	bitmap: dd 0 
	iMaxHalf: dd 127.5

section .text
	global func

func:
	push rbp
	mov rbp, rsp

	mov r15, rdi ;dane o pixelach
	;push r15 ;na stosie jest poczatek danych
	mov r14, rsi ;ilosc pixeli
	movss xmm1, xmm0 ;parametr dla kontrastu

	mov byte [minMaxTable], 255
	mov byte [minMaxTable+1], 0
	mov byte [minMaxTable+2], 255
	mov byte [minMaxTable+3], 0
	mov byte [minMaxTable+4], 255
	mov byte [minMaxTable+5], 0

	cmp rdx, 1
	jl histogram

kontrast:
	movss xmm3, dword [iMaxHalf]
	mov r13, 0
	;cvtsi2ss xmm1, rcx ;zamiana int->double
	;cvtss2si r11, xmm10 ;zamiana double->int
k_calcLut:
	cvtsi2ss xmm0, r13 ;i
	subss xmm0, xmm3; i-iMaxHalf
	movss xmm10, xmm0 ;(i-iMaxHalf)
	mulss xmm10, xmm1 ;a*(i-iMaxHalf)
	addss xmm10, xmm3 ;a*(i-iMaxHalf) + iMaxHalf
	cvtss2si r11, xmm10 ;zamiana double->int
	mov [lut+r13], byte r11 ;;;;;;;;;;		UWAGA - pomyslec nad tym

	inc r13
	cmp r13, 255
	jl k_calcLut 

k_calcLut_end:
	mov r13, 0
k_write:
	mov r12, 0
	mov r12b, [r15] ;blue
	mov r11, [lut+r12]
	mov [r15+r13], r11
	inc r15

	mov r12, 0
	mov r12b, [r15] ;green
	mov r11, [lut+r12]
	mov [r15+r13], r11
	inc r15

	mov r12, 0
	mov r12b, [r15] ;red
	mov r11, [lut+r12]
	mov [r15+r13], r11
	inc r15
	inc r15

	inc r13
	cmp r13, r14
	jl k_write
	

histogram:
	
	mov r13, 0
findMinMax:
	inc r13
	mov r8b, byte[r15]

end:	

	mov rsp, rbp	
	pop rbp
	ret


