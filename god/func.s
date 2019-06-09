	.globl func
	.intel_syntax noprefix
func:
        push    rbp
        mov     rbp, rsp
        sub     rsp, 976 ;zostawione miejsce na zmienne lokalne lutR[256], lutG[256], lutB[256], minMax R/G/B, lut[256]
        mov     QWORD PTR [rbp-1080], rdi ;poczatek bitmapy
        mov     DWORD PTR [rbp-1084], esi ;ilosc pixeli
        mov     DWORD PTR [rbp-1088], edx ;operacja do wykonania 0-histogram, 1-kontrast
        movsd   QWORD PTR [rbp-1096], xmm0 ;parameter(wspolczynik zmiany kontrastu)
		;wybor operacji: 1-kontrast, 0-histogram
        cmp     DWORD PTR [rbp-1088], 1
        jne     .histogram
.kontrast:
        mov     DWORD PTR [rbp-20], 0 ;inicjacja do petli obliczajacej tablice LUT dla zmiany kontrastu
        jmp     .k_obliczLut_warunek
.k_obliczLut:
	;obliczenie wartosci val dla danego pixela w LUT
        cvtsi2sd xmm0, DWORD PTR [rbp-20]
        movsd   xmm1, QWORD PTR .LC0[rip]
        subsd   xmm0, xmm1
        movapd  xmm1, xmm0
        mulsd   xmm1, QWORD PTR [rbp-1096]
        movsd   xmm0, QWORD PTR .LC0[rip]
        addsd   xmm0, xmm1
        movsd   QWORD PTR [rbp-48], xmm0
		; if val<0
        pxor    xmm0, xmm0
        comisd  xmm0, QWORD PTR [rbp-48]
        jb      .k_val_great255
        mov     eax, DWORD PTR [rbp-20]
        cdqe
        mov     BYTE PTR [rbp-1072+rax], 0
        jmp     .k_obliczLut_inkrementacja
.k_val_great255: ;if val>255
        movsd   xmm0, QWORD PTR [rbp-48]
        comisd  xmm0, QWORD PTR .LC2[rip]
        jb      .k_val_between0_255
        mov     eax, DWORD PTR [rbp-20]
        cdqe
        mov     BYTE PTR [rbp-1072+rax], -1
        jmp     .k_obliczLut_inkrementacja
.k_val_between0_255: ;if 0<val<255 - wpisz do lut[i] obliczona wartosc
        cvttsd2si       eax, QWORD PTR [rbp-48]
        mov     edx, eax
        mov     eax, DWORD PTR [rbp-20]
        cdqe
        mov     BYTE PTR [rbp-1072+rax], dl
.k_obliczLut_inkrementacja:
        add     DWORD PTR [rbp-20], 1
.k_obliczLut_warunek:
        cmp     DWORD PTR [rbp-20], 255
        jle     .k_obliczLut
		;wskazanie na poczatek danych
        mov     rax, QWORD PTR [rbp-1080]
        mov     QWORD PTR [rbp-16], rax
		;inicjacja iteratora do petli zmiany pixeli 
        mov     DWORD PTR [rbp-24], 0
        jmp     .k_zamianaPixeli_warunek
.k_zamianaPixeli:
	;pixel B change *ptr = lut[*ptr];
        mov     rax, QWORD PTR [rbp-16]
        movzx   eax, BYTE PTR [rax]
        movzx   eax, al
        cdqe
        movzx   edx, BYTE PTR [rbp-1072+rax]
        mov     rax, QWORD PTR [rbp-16]
        mov     BYTE PTR [rax], dl
	;pixel G change
        mov     rax, QWORD PTR [rbp-16]
        add     rax, 1
        movzx   eax, BYTE PTR [rax]
        movzx   eax, al
        mov     rdx, QWORD PTR [rbp-16]
        add     rdx, 1
        cdqe
        movzx   eax, BYTE PTR [rbp-1072+rax]
        mov     BYTE PTR [rdx], al
	;pixel R change
        mov     rax, QWORD PTR [rbp-16]
        add     rax, 2
        movzx   eax, BYTE PTR [rax]
        movzx   eax, al
        mov     rdx, QWORD PTR [rbp-16]
        add     rdx, 2
        cdqe
        movzx   eax, BYTE PTR [rbp-1072+rax]
        mov     BYTE PTR [rdx], al
		
        add     QWORD PTR [rbp-16], 4 ;przesuniecie wskaźnika w danych obrazka o 4 subpixele, czyli cały pixel
        add     DWORD PTR [rbp-24], 1 ;zwiekszenie iteratora po petli zamiany pixeli
.k_zamianaPixeli_warunek:
        mov     eax, DWORD PTR [rbp-24]
        cmp     eax, DWORD PTR [rbp-1084]
        jl      .k_zamianaPixeli
        jmp     .koniec
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.histogram:
        mov     rax, QWORD PTR [rbp-1080] ;wskazanie na poczatek danych obrazka
        mov     QWORD PTR [rbp-16], rax
		
        mov     DWORD PTR [rbp-28], 0 ;inicjacja petli findMinMax
        jmp     .h_findMinMax_warunek
.h_findMinMax:
	;minB
        mov     rax, QWORD PTR [rbp-16]
        movzx   eax, BYTE PTR [rax]
        movzx   edx, BYTE PTR [rbp-5]
        cmp     BYTE PTR [rbp-5], al
        cmovbe  eax, edx
        mov     BYTE PTR [rbp-5], al
	;maxB
        mov     rax, QWORD PTR [rbp-16]
        movzx   eax, BYTE PTR [rax]
        movzx   edx, BYTE PTR [rbp-6]
        cmp     BYTE PTR [rbp-6], al
        cmovnb  eax, edx
        mov     BYTE PTR [rbp-6], al
		
        add     QWORD PTR [rbp-16], 1 ;przesuniecie subpixela na G
	;minG	
        mov     rax, QWORD PTR [rbp-16]
        movzx   eax, BYTE PTR [rax]
        movzx   edx, BYTE PTR [rbp-3]
        cmp     BYTE PTR [rbp-3], al
        cmovbe  eax, edx
        mov     BYTE PTR [rbp-3], al
	;maxG
        mov     rax, QWORD PTR [rbp-16]
        movzx   eax, BYTE PTR [rax]
        movzx   edx, BYTE PTR [rbp-4]
        cmp     BYTE PTR [rbp-4], al
        cmovnb  eax, edx
        mov     BYTE PTR [rbp-4], al
		
        add     QWORD PTR [rbp-16], 1 ;przesuniecie subpixela na G
	;minR
        mov     rax, QWORD PTR [rbp-16]
        movzx   eax, BYTE PTR [rax]
        movzx   edx, BYTE PTR [rbp-1]
        cmp     BYTE PTR [rbp-1], al
        cmovbe  eax, edx
        mov     BYTE PTR [rbp-1], al
	;maxR	
        mov     rax, QWORD PTR [rbp-16]
        movzx   eax, BYTE PTR [rax]
        movzx   edx, BYTE PTR [rbp-2]
        cmp     BYTE PTR [rbp-2], al
        cmovnb  eax, edx
        mov     BYTE PTR [rbp-2], al
		
        add     QWORD PTR [rbp-16], 2 ;przesuniecie do końca tego pixela, żeby wskazywało na kolejny pixel
        add     DWORD PTR [rbp-28], 1 ;zwiekszenie iteratora
.h_findMinMax_warunek:
        mov     eax, DWORD PTR [rbp-28]
        cmp     eax, DWORD PTR [rbp-1084]
        jl      .h_findMinMax
		
        mov     DWORD PTR [rbp-32], 0 ;inicjajca petli zamiana pixeli
        jmp     .h_obliczLut_warunek
.h_obliczLut:
	;lutR (255.0/(maxR-minR))*(i-minR);
        movzx   edx, BYTE PTR [rbp-2]
        movzx   eax, BYTE PTR [rbp-1]
        sub     edx, eax
        mov     eax, edx
        cvtsi2sd        xmm1, eax
        movsd   xmm0, QWORD PTR .LC2[rip]
        divsd   xmm0, xmm1
        movapd  xmm1, xmm0
        movzx   eax, BYTE PTR [rbp-1]
        mov     edx, DWORD PTR [rbp-32]
        sub     edx, eax
        mov     eax, edx
        cvtsi2sd        xmm0, eax
        mulsd   xmm0, xmm1
        cvttsd2si       eax, xmm0
        mov     edx, eax
        mov     eax, DWORD PTR [rbp-32]
        cdqe
        mov     BYTE PTR [rbp-304+rax], dl
	;lutG (255.0/(maxG-minG))*(i-minG);
        movzx   edx, BYTE PTR [rbp-4]
        movzx   eax, BYTE PTR [rbp-3]
        sub     edx, eax
        mov     eax, edx
        cvtsi2sd        xmm1, eax
        movsd   xmm0, QWORD PTR .LC2[rip]
        divsd   xmm0, xmm1
        movapd  xmm1, xmm0
        movzx   eax, BYTE PTR [rbp-3]
        mov     edx, DWORD PTR [rbp-32]
        sub     edx, eax
        mov     eax, edx
        cvtsi2sd        xmm0, eax
        mulsd   xmm0, xmm1
        cvttsd2si       eax, xmm0
        mov     edx, eax
        mov     eax, DWORD PTR [rbp-32]
        cdqe
        mov     BYTE PTR [rbp-560+rax], dl
	;lutB (255.0/(maxB-minB))*(i-minB);
        movzx   edx, BYTE PTR [rbp-6]
        movzx   eax, BYTE PTR [rbp-5]
        sub     edx, eax
        mov     eax, edx
        cvtsi2sd        xmm1, eax
        movsd   xmm0, QWORD PTR .LC2[rip]
        divsd   xmm0, xmm1
        movapd  xmm1, xmm0
        movzx   eax, BYTE PTR [rbp-5]
        mov     edx, DWORD PTR [rbp-32]
        sub     edx, eax
        mov     eax, edx
        cvtsi2sd        xmm0, eax
        mulsd   xmm0, xmm1
        cvttsd2si       eax, xmm0
        mov     edx, eax
        mov     eax, DWORD PTR [rbp-32]
        cdqe
        mov     BYTE PTR [rbp-816+rax], dl
		
        add     DWORD PTR [rbp-32], 1 ;inkrementacja iteratora petli
.h_obliczLut_warunek:
        cmp     DWORD PTR [rbp-32], 255
        jle     .h_obliczLut
		
        mov     rax, QWORD PTR [rbp-1080] ;wskazanie na poczatek danych obrazka
        mov     QWORD PTR [rbp-16], rax
		
        mov     DWORD PTR [rbp-36], 0 ;inicjacja petli zmiany pixeli histogram
        jmp     .h_zamianaPixeli_warunek
.h_zamianaPixeli:
	;zamiana B *ptr = lutB[*ptr];
        mov     rax, QWORD PTR [rbp-16]
        movzx   eax, BYTE PTR [rax]
        movzx   eax, al
        cdqe
        movzx   edx, BYTE PTR [rbp-816+rax]
        mov     rax, QWORD PTR [rbp-16]
        mov     BYTE PTR [rax], dl
	;zamiana G
        mov     rax, QWORD PTR [rbp-16]
        add     rax, 1
        movzx   eax, BYTE PTR [rax]
        movzx   eax, al
        mov     rdx, QWORD PTR [rbp-16]
        add     rdx, 1
        cdqe
        movzx   eax, BYTE PTR [rbp-560+rax]
        mov     BYTE PTR [rdx], al
	;zamiana R
        mov     rax, QWORD PTR [rbp-16]
        add     rax, 2
        movzx   eax, BYTE PTR [rax]
        movzx   eax, al
        mov     rdx, QWORD PTR [rbp-16]
        add     rdx, 2
        cdqe
        movzx   eax, BYTE PTR [rbp-304+rax]
        mov     BYTE PTR [rdx], al
		
        add     QWORD PTR [rbp-16], 4 ;przeuniecie wskaznika na nastepny pixel
        add     DWORD PTR [rbp-36], 1 ;inkrementacja iteratora petli
.h_zamianaPixeli_warunek:
        mov     eax, DWORD PTR [rbp-36]
        cmp     eax, DWORD PTR [rbp-1084]
        jl      .h_zamianaPixeli
.koniec:
        nop
        leave
        ret
.LC0:
        .long   0
        .long   1080025088
.LC2:
        .long   0
        .long   1081073664