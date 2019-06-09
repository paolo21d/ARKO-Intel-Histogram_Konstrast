	.globl func
	.intel_syntax noprefix
        
func:
        push    rbp
        push    rbx
        sub     rsp, 904
        /*if operacja to kontrast*/
        cmp     edx, 1
        je      .L15
/*HISTOGRAM*/
        test    esi, esi
        jle     .L4
        lea     eax, [rsi-1]
        lea     rbp, [rdi+4+rax*4]
        mov     rax, rdi
.L12:
        movzx   edx, BYTE PTR [rax]
        cmp     cl, dl
        cmova   ecx, edx
        cmp     r9b, dl
        cmovb   r9d, edx
        movzx   edx, BYTE PTR [rax+1]
        cmp     r8b, dl
        cmova   r8d, edx
        cmp     r11b, dl
        cmovb   r11d, edx
        movzx   edx, BYTE PTR [rax+2]
        cmp     r10b, dl
        cmova   r10d, edx
        cmp     bl, dl
        cmovb   ebx, edx
        add     rax, 4
        cmp     rbp, rax
        jne     .L12
.L4:
        movzx   ebx, bl
        movzx   eax, r10b
        sub     ebx, eax
        pxor    xmm0, xmm0
        cvtsi2sd        xmm0, ebx
        movsd   xmm1, QWORD PTR .LC2[rip]
        movapd  xmm3, xmm1
        divsd   xmm3, xmm0
        movzx   r11d, r11b
        movzx   eax, r8b
        sub     r11d, eax
        pxor    xmm0, xmm0
        cvtsi2sd        xmm0, r11d
        movapd  xmm2, xmm1
        divsd   xmm2, xmm0
        movzx   r9d, r9b
        movzx   eax, cl
        sub     r9d, eax
        pxor    xmm0, xmm0
        cvtsi2sd        xmm0, r9d
        divsd   xmm1, xmm0
        mov     eax, 1
        movzx   r9d, r10b
        not     r9d
        movzx   r8d, r8b
        not     r8d
        movzx   ecx, cl
        not     ecx
.L13:
        lea     edx, [r9+rax]
        pxor    xmm0, xmm0
        cvtsi2sd        xmm0, edx
        mulsd   xmm0, xmm3
        cvttsd2si       edx, xmm0
        mov     BYTE PTR [rsp+647+rax], dl
        lea     edx, [r8+rax]
        pxor    xmm0, xmm0
        cvtsi2sd        xmm0, edx
        mulsd   xmm0, xmm2
        cvttsd2si       edx, xmm0
        mov     BYTE PTR [rsp+391+rax], dl
        lea     edx, [rcx+rax]
        pxor    xmm0, xmm0
        cvtsi2sd        xmm0, edx
        mulsd   xmm0, xmm1
        cvttsd2si       edx, xmm0
        mov     BYTE PTR [rsp+135+rax], dl
        add     rax, 1
        cmp     rax, 257
        jne     .L13
        test    esi, esi
        jle     .L1
        lea     eax, [rsi-1]
        lea     rdx, [rdi+4+rax*4]
.L14:
        movzx   eax, BYTE PTR [rdi]
        movzx   eax, BYTE PTR [rsp+136+rax]
        mov     BYTE PTR [rdi], al
        movzx   eax, BYTE PTR [rdi+1]
        movzx   eax, BYTE PTR [rsp+392+rax]
        mov     BYTE PTR [rdi+1], al
        movzx   eax, BYTE PTR [rdi+2]
        movzx   eax, BYTE PTR [rsp+648+rax]
        mov     BYTE PTR [rdi+2], al
        add     rdi, 4
        cmp     rdx, rdi
        jne     .L14
.L1:
        add     rsp, 904
        pop     rbx
        pop     rbp
        ret
/*KONTRAST*/
.L15:
        mov     edx, 0
        movsd   xmm2, QWORD PTR .LC0[rip]
        pxor    xmm3, xmm3
        movsd   xmm4, QWORD PTR .LC2[rip]
        jmp     .L2
.L27:
        mov     BYTE PTR [rsp-120+rdx], 0
.L7:
        add     rdx, 1
        cmp     rdx, 256
        je      .L26
.L2:
        pxor    xmm1, xmm1
        cvtsi2sd        xmm1, edx
        subsd   xmm1, xmm2
        mulsd   xmm1, xmm0
        addsd   xmm1, xmm2
        comisd  xmm3, xmm1
        jnb     .L27
        comisd  xmm1, xmm4
        jb      .L24
        mov     BYTE PTR [rsp-120+rdx], -1
        jmp     .L7
.L24:
        cvttsd2si       eax, xmm1
        mov     BYTE PTR [rsp-120+rdx], al
        jmp     .L7
.L26:
        test    esi, esi
        jle     .L1
        lea     eax, [rsi-1]
        lea     rdx, [rdi+4+rax*4]
.L11:
        movzx   eax, BYTE PTR [rdi]
        movzx   eax, BYTE PTR [rsp-120+rax]
        mov     BYTE PTR [rdi], al
        movzx   eax, BYTE PTR [rdi+1]
        movzx   eax, BYTE PTR [rsp-120+rax]
        mov     BYTE PTR [rdi+1], al
        movzx   eax, BYTE PTR [rdi+2]
        movzx   eax, BYTE PTR [rsp-120+rax]
        mov     BYTE PTR [rdi+2], al
        add     rdi, 4
        cmp     rdi, rdx
        jne     .L11
        jmp     .L1
.LC0:
        .long   0
        .long   1080025088
.LC2:
        .long   0
        .long   1081073664