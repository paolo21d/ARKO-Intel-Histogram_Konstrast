	.globl func
	.intel_syntax noprefix
        
func:
        push    rbp
        push    rbx
        sub     rsp, 656
        cmp     edx, 1
        je      .L15
        test    esi, esi
        jle     .L4
        lea     edx, [rsi-1]
        lea     rbp, [rdi+4+rdx*4]
        mov     rdx, rdi
.L12:
        movzx   r9d, BYTE PTR [rdx]
        cmp     al, r9b
        cmova   eax, r9d
        cmp     r10b, r9b
        cmovb   r10d, r9d
        movzx   r9d, BYTE PTR [rdx+1]
        cmp     cl, r9b
        cmova   ecx, r9d
        cmp     r11b, r9b
        cmovb   r11d, r9d
        movzx   r9d, BYTE PTR [rdx+2]
        cmp     r8b, r9b
        cmova   r8d, r9d
        cmp     bl, r9b
        cmovb   ebx, r9d
        add     rdx, 4
        cmp     rdx, rbp
        jne     .L12
.L4:
        movzx   r9d, r8b
        movzx   ebx, bl
        pxor    xmm0, xmm0
        movzx   r8d, cl
        sub     ebx, r9d
        movzx   r11d, r11b
        movzx   ecx, al
        movzx   r10d, r10b
        cvtsi2sd        xmm0, ebx
        sub     r11d, r8d
        sub     r10d, ecx
        mov     eax, 1
        movsd   xmm1, QWORD PTR .LC2[rip]
        not     r9d
        not     r8d
        not     ecx
        movapd  xmm3, xmm1
        movapd  xmm2, xmm1
        divsd   xmm3, xmm0
        pxor    xmm0, xmm0
        cvtsi2sd        xmm0, r11d
        divsd   xmm2, xmm0
        pxor    xmm0, xmm0
        cvtsi2sd        xmm0, r10d
        divsd   xmm1, xmm0
.L13:
        lea     edx, [r9+rax]
        pxor    xmm0, xmm0
        cvtsi2sd        xmm0, edx
        mulsd   xmm0, xmm3
        cvttsd2si       edx, xmm0
        pxor    xmm0, xmm0
        mov     BYTE PTR [rsp-121+rax], dl
        lea     edx, [r8+rax]
        cvtsi2sd        xmm0, edx
        mulsd   xmm0, xmm2
        cvttsd2si       edx, xmm0
        pxor    xmm0, xmm0
        mov     BYTE PTR [rsp+135+rax], dl
        lea     edx, [rcx+rax]
        cvtsi2sd        xmm0, edx
        mulsd   xmm0, xmm1
        cvttsd2si       edx, xmm0
        mov     BYTE PTR [rsp+391+rax], dl
        add     rax, 1
        cmp     rax, 257
        jne     .L13
        test    esi, esi
        jle     .L1
        lea     eax, [rsi-1]
        lea     rdx, [rdi+4+rax*4]
.L14:
        movzx   eax, BYTE PTR [rdi]
        add     rdi, 4
        movzx   eax, BYTE PTR [rsp+392+rax]
        mov     BYTE PTR [rdi-4], al
        movzx   eax, BYTE PTR [rdi-3]
        movzx   eax, BYTE PTR [rsp+136+rax]
        mov     BYTE PTR [rdi-3], al
        movzx   eax, BYTE PTR [rdi-2]
        movzx   eax, BYTE PTR [rsp-120+rax]
        mov     BYTE PTR [rdi-2], al
        cmp     rdi, rdx
        jne     .L14
.L1:
        add     rsp, 656
        pop     rbx
        pop     rbp
        ret
.L15:
        xor     edx, edx
        movsd   xmm2, QWORD PTR .LC0[rip]
        pxor    xmm3, xmm3
        movsd   xmm4, QWORD PTR .LC2[rip]
        jmp     .L2
.L23:
        comisd  xmm1, xmm4
        jb      .L24
        mov     BYTE PTR [rsp+392+rdx], -1
.L7:
        add     rdx, 1
        cmp     rdx, 256
        je      .L27
.L2:
        pxor    xmm1, xmm1
        cvtsi2sd        xmm1, edx
        subsd   xmm1, xmm2
        mulsd   xmm1, xmm0
        addsd   xmm1, xmm2
        comisd  xmm3, xmm1
        jb      .L23
        mov     BYTE PTR [rsp+392+rdx], 0
        add     rdx, 1
        cmp     rdx, 256
        jne     .L2
.L27:
        test    esi, esi
        jle     .L1
        lea     eax, [rsi-1]
        lea     rdx, [rdi+4+rax*4]
.L11:
        movzx   eax, BYTE PTR [rdi]
        add     rdi, 4
        movzx   eax, BYTE PTR [rsp+392+rax]
        mov     BYTE PTR [rdi-4], al
        movzx   eax, BYTE PTR [rdi-3]
        movzx   eax, BYTE PTR [rsp+392+rax]
        mov     BYTE PTR [rdi-3], al
        movzx   eax, BYTE PTR [rdi-2]
        movzx   eax, BYTE PTR [rsp+392+rax]
        mov     BYTE PTR [rdi-2], al
        cmp     rdi, rdx
        jne     .L11
        add     rsp, 656
        pop     rbx
        pop     rbp
        ret
.L24:
        cvttsd2si       eax, xmm1
        mov     BYTE PTR [rsp+392+rdx], al
        jmp     .L7
.LC0:
        .long   0
        .long   1080025088
.LC2:
        .long   0
        .long   1081073664