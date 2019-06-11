/*autohor: paolo21d*/
/*ARKO - Zamiana histogramu i kontrastu obrazka*/

/*void func(unsigned char* line, int pixelQuantity, int operation, double contrast)*/
/*rdi - poczatek bitmapy - od razu czytać dane, nie ma nagłówka, obrazek w bmp 32bit*/
/*rsi - ilosc pixeli w calym obrazku - każdy pixel składa się z 4 subpixeli po 8b*/
/*rdx - wybór co mamy zrobić: 0-histogram, 1-zmiana kontrastu*/
/*xmm0 - parametr zmiany kontrastu*/

	.globl func
	.intel_syntax noprefix
        
func:
        push    rbp
        push    rbx
        sub     rsp, 904 
        /*if operacja to kontrast*/
        cmp     edx, 1
        je      .c_obliczenieLut_petla
/*HISTOGRAM*/
/*inicjaliacja petli obliczajacej lut*/
        test    esi, esi /*sprawdzenie czy ==0*/
        jle     .h_obliczLut
        lea     eax, [rsi-1]
        lea     rbp, [rdi+4+rax*4] /*rbp =256 ???? moze 255*/
		
        mov     rax, rdi /*wskazanie na poczatek danych*/
.h_znajdzMinMax:
	/*minB*/
        movzx   edx, BYTE PTR [rax]
        cmp     cl, dl
        cmova   ecx, edx /*move if above - wieksze*/
	/*maxB*/
        cmp     r9b, dl
        cmovb   r9d, edx /*move if below - mniejsze*/
	/*minG*/
        movzx   edx, BYTE PTR [rax+1]
        cmp     r8b, dl
        cmova   r8d, edx
	/*maxG*/
        cmp     r11b, dl
        cmovb   r11d, edx
	/*minR*/
        movzx   edx, BYTE PTR [rax+2]
        cmp     r10b, dl
        cmova   r10d, edx
	/*maxR*/
        cmp     bl, dl
        cmovb   ebx, edx
		
        add     rax, 4 /*przesuniecie wskazania na nastepny pixel*/
        cmp     rbp, rax /*sprawdzenie warunku konca*/
        jne     .h_znajdzMinMax
.h_obliczLut:
	/*lutR (255.0/(maxR-minR))*(i-minR)*/
        movzx   ebx, bl /*move with 0 extension*/
        movzx   eax, r10b
        sub     ebx, eax
        pxor    xmm0, xmm0
        cvtsi2sd xmm0, ebx /*int -> double*/
        movsd   xmm1, QWORD PTR .et2[rip] /*move double*/
        movapd  xmm3, xmm1
        divsd   xmm3, xmm0
		
	movzx   r9d, r10b
        not     r9d
	/*lutG (255.0/(maxG-minG))*(i-minG)*/
        movzx   r11d, r11b
        movzx   eax, r8b
        sub     r11d, eax
        pxor    xmm0, xmm0
        cvtsi2sd xmm0, r11d
        movapd  xmm2, xmm1
        divsd   xmm2, xmm0
		
	movzx   r8d, r8b
        not     r8d
	/*lutB (255.0/(maxB-minB))*(i-minB)*/
        movzx   r9d, r9b
        movzx   eax, cl
        sub     r9d, eax
        pxor    xmm0, xmm0
        cvtsi2sd        xmm0, r9d
        divsd   xmm1, xmm0
        mov     eax, 1
		
        movzx   ecx, cl
        not     ecx
        
.h_saveLut:
	/*lutR*/
        lea     edx, [r9+rax]
        pxor    xmm0, xmm0
        cvtsi2sd        xmm0, edx
        mulsd   xmm0, xmm3
        cvttsd2si       edx, xmm0
        mov     BYTE PTR [rsp+647+rax], dl
	/*lutG*/
        lea     edx, [r8+rax]
        pxor    xmm0, xmm0
        cvtsi2sd        xmm0, edx
        mulsd   xmm0, xmm2
        cvttsd2si       edx, xmm0
        mov     BYTE PTR [rsp+391+rax], dl
	/*lutB*/
        lea     edx, [rcx+rax]
        pxor    xmm0, xmm0
        cvtsi2sd        xmm0, edx
        mulsd   xmm0, xmm1
        cvttsd2si       edx, xmm0
        mov     BYTE PTR [rsp+135+rax], dl
        add     rax, 1
		/*warunek konca petli obliczajacej lut histogram*/
        cmp     rax, 257
        jne     .h_saveLut
		
		/*inicjacja petli zamieniajacej pixele histogram*/
        test    esi, esi
        jle     .koniec
        lea     eax, [rsi-1]
        lea     rdx, [rdi+4+rax*4]
.h_zamianaPixeli:
	/*B*/
        movzx   eax, BYTE PTR [rdi]
        movzx   eax, BYTE PTR [rsp+136+rax]
        mov     BYTE PTR [rdi], al
	/*G*/
        movzx   eax, BYTE PTR [rdi+1]
        movzx   eax, BYTE PTR [rsp+392+rax]
        mov     BYTE PTR [rdi+1], al
	/*R*/
        movzx   eax, BYTE PTR [rdi+2]
        movzx   eax, BYTE PTR [rsp+648+rax]
        mov     BYTE PTR [rdi+2], al
		
        add     rdi, 4 /*przesuniecie wskaznika na nastpeny pixel*/
		/*warunek konca petli zamieniajacej pixele histogram*/
        cmp     rdx, rdi
        jne     .h_zamianaPixeli
		
.koniec:
        add     rsp, 904 /*przywrocenie wierzchołka stosu*/
        pop     rbx
        pop     rbp
        ret
/********************************************KONTRAST*******************************************/
.c_obliczenieLut_petla:
        mov     edx, 0
        movsd   xmm2, QWORD PTR .et1[rip]
        pxor    xmm3, xmm3
        movsd   xmm4, QWORD PTR .et2[rip]
        jmp     .c_obliczenieLut_obliczenia
.c_obliczenieLut_les0: /*val<0*/
        mov     BYTE PTR [rsp-120+rdx], 0
.c_obliczenieLut_petla_end:
        add     rdx, 1
        cmp     rdx, 256
        je      .c_zamianaPixeli_przygotowanie
.c_obliczenieLut_obliczenia:
	/*obliczenie wartosci lut: contrast*(i-127.5) +127.5*/
        pxor    xmm1, xmm1
        cvtsi2sd        xmm1, edx
        subsd   xmm1, xmm2
        mulsd   xmm1, xmm0
        addsd   xmm1, xmm2
        comisd  xmm3, xmm1
        jnb     .c_obliczenieLut_les0
	/*val>255*/
        comisd  xmm1, xmm4
        jb      .c_obliczenieLut_between_0_255
        mov     BYTE PTR [rsp-120+rdx], -1
        jmp     .c_obliczenieLut_petla_end
.c_obliczenieLut_between_0_255: /*0<val<255 -> podstaw obliczona wartosc*/
        cvttsd2si       eax, xmm1
        mov     BYTE PTR [rsp-120+rdx], al
        jmp     .c_obliczenieLut_petla_end
		
.c_zamianaPixeli_przygotowanie:
        test    esi, esi
        jle     .koniec
        lea     eax, [rsi-1]
        lea     rdx, [rdi+4+rax*4]
.c_zamianaPixeli: /*podstawienie odpowienich wartosc pixeli w danych obrazka*/
	/*B*/
        movzx   eax, BYTE PTR [rdi]
        movzx   eax, BYTE PTR [rsp-120+rax]
        mov     BYTE PTR [rdi], al
	/*G*/
        movzx   eax, BYTE PTR [rdi+1]
        movzx   eax, BYTE PTR [rsp-120+rax]
        mov     BYTE PTR [rdi+1], al
	/*R*/
        movzx   eax, BYTE PTR [rdi+2]
        movzx   eax, BYTE PTR [rsp-120+rax]
        mov     BYTE PTR [rdi+2], al
		
        add     rdi, 4 /*przesuniecie wskazania na nastepny pixel*/
		
        cmp     rdi, rdx /*sprawdzenie warunku konca petli zamieniajacej pixele*/
        jne     .c_zamianaPixeli
        jmp     .koniec
.et1:
        .long   0
        .long   1080025088
.et2:
        .long   0
        .long   1081073664