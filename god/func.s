	.globl func
	.intel_syntax noprefix
func:
        push    rbp
        mov     rbp, rsp
        sub     rsp, 976
        mov     QWORD PTR [rbp-1080], rdi
        mov     DWORD PTR [rbp-1084], esi
        mov     DWORD PTR [rbp-1088], edx
        movsd   QWORD PTR [rbp-1096], xmm0
        cmp     DWORD PTR [rbp-1088], 1
        jne     .L2
        mov     DWORD PTR [rbp-20], 0
        jmp     .L3
.L9:
        cvtsi2sd        xmm0, DWORD PTR [rbp-20]
        movsd   xmm1, QWORD PTR .LC0[rip]
        subsd   xmm0, xmm1
        movapd  xmm1, xmm0
        mulsd   xmm1, QWORD PTR [rbp-1096]
        movsd   xmm0, QWORD PTR .LC0[rip]
        addsd   xmm0, xmm1
        movsd   QWORD PTR [rbp-48], xmm0
        pxor    xmm0, xmm0
        comisd  xmm0, QWORD PTR [rbp-48]
        jb      .L21
        mov     eax, DWORD PTR [rbp-20]
        cdqe
        mov     BYTE PTR [rbp-1072+rax], 0
        jmp     .L6
.L21:
        movsd   xmm0, QWORD PTR [rbp-48]
        comisd  xmm0, QWORD PTR .LC2[rip]
        jb      .L22
        mov     eax, DWORD PTR [rbp-20]
        cdqe
        mov     BYTE PTR [rbp-1072+rax], -1
        jmp     .L6
.L22:
        cvttsd2si       eax, QWORD PTR [rbp-48]
        mov     edx, eax
        mov     eax, DWORD PTR [rbp-20]
        cdqe
        mov     BYTE PTR [rbp-1072+rax], dl
.L6:
        add     DWORD PTR [rbp-20], 1
.L3:
        cmp     DWORD PTR [rbp-20], 255
        jle     .L9
        mov     rax, QWORD PTR [rbp-1080]
        mov     QWORD PTR [rbp-16], rax
        mov     DWORD PTR [rbp-24], 0
        jmp     .L10
.L11:
        mov     rax, QWORD PTR [rbp-16]
        movzx   eax, BYTE PTR [rax]
        movzx   eax, al
        cdqe
        movzx   edx, BYTE PTR [rbp-1072+rax]
        mov     rax, QWORD PTR [rbp-16]
        mov     BYTE PTR [rax], dl
        mov     rax, QWORD PTR [rbp-16]
        add     rax, 1
        movzx   eax, BYTE PTR [rax]
        movzx   eax, al
        mov     rdx, QWORD PTR [rbp-16]
        add     rdx, 1
        cdqe
        movzx   eax, BYTE PTR [rbp-1072+rax]
        mov     BYTE PTR [rdx], al
        mov     rax, QWORD PTR [rbp-16]
        add     rax, 2
        movzx   eax, BYTE PTR [rax]
        movzx   eax, al
        mov     rdx, QWORD PTR [rbp-16]
        add     rdx, 2
        cdqe
        movzx   eax, BYTE PTR [rbp-1072+rax]
        mov     BYTE PTR [rdx], al
        add     QWORD PTR [rbp-16], 4
        add     DWORD PTR [rbp-24], 1
.L10:
        mov     eax, DWORD PTR [rbp-24]
        cmp     eax, DWORD PTR [rbp-1084]
        jl      .L11
        jmp     .L23
.L2:
        mov     rax, QWORD PTR [rbp-1080]
        mov     QWORD PTR [rbp-16], rax
        mov     DWORD PTR [rbp-28], 0
        jmp     .L13
.L14:
        mov     rax, QWORD PTR [rbp-16]
        movzx   eax, BYTE PTR [rax]
        movzx   edx, BYTE PTR [rbp-5]
        cmp     BYTE PTR [rbp-5], al
        cmovbe  eax, edx
        mov     BYTE PTR [rbp-5], al
        mov     rax, QWORD PTR [rbp-16]
        movzx   eax, BYTE PTR [rax]
        movzx   edx, BYTE PTR [rbp-6]
        cmp     BYTE PTR [rbp-6], al
        cmovnb  eax, edx
        mov     BYTE PTR [rbp-6], al
        add     QWORD PTR [rbp-16], 1
        mov     rax, QWORD PTR [rbp-16]
        movzx   eax, BYTE PTR [rax]
        movzx   edx, BYTE PTR [rbp-3]
        cmp     BYTE PTR [rbp-3], al
        cmovbe  eax, edx
        mov     BYTE PTR [rbp-3], al
        mov     rax, QWORD PTR [rbp-16]
        movzx   eax, BYTE PTR [rax]
        movzx   edx, BYTE PTR [rbp-4]
        cmp     BYTE PTR [rbp-4], al
        cmovnb  eax, edx
        mov     BYTE PTR [rbp-4], al
        add     QWORD PTR [rbp-16], 1
        mov     rax, QWORD PTR [rbp-16]
        movzx   eax, BYTE PTR [rax]
        movzx   edx, BYTE PTR [rbp-1]
        cmp     BYTE PTR [rbp-1], al
        cmovbe  eax, edx
        mov     BYTE PTR [rbp-1], al
        mov     rax, QWORD PTR [rbp-16]
        movzx   eax, BYTE PTR [rax]
        movzx   edx, BYTE PTR [rbp-2]
        cmp     BYTE PTR [rbp-2], al
        cmovnb  eax, edx
        mov     BYTE PTR [rbp-2], al
        add     QWORD PTR [rbp-16], 2
        add     DWORD PTR [rbp-28], 1
.L13:
        mov     eax, DWORD PTR [rbp-28]
        cmp     eax, DWORD PTR [rbp-1084]
        jl      .L14
        mov     DWORD PTR [rbp-32], 0
        jmp     .L15
.L16:
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
        add     DWORD PTR [rbp-32], 1
.L15:
        cmp     DWORD PTR [rbp-32], 255
        jle     .L16
        mov     rax, QWORD PTR [rbp-1080]
        mov     QWORD PTR [rbp-16], rax
        mov     DWORD PTR [rbp-36], 0
        jmp     .L17
.L18:
        mov     rax, QWORD PTR [rbp-16]
        movzx   eax, BYTE PTR [rax]
        movzx   eax, al
        cdqe
        movzx   edx, BYTE PTR [rbp-816+rax]
        mov     rax, QWORD PTR [rbp-16]
        mov     BYTE PTR [rax], dl
        mov     rax, QWORD PTR [rbp-16]
        add     rax, 1
        movzx   eax, BYTE PTR [rax]
        movzx   eax, al
        mov     rdx, QWORD PTR [rbp-16]
        add     rdx, 1
        cdqe
        movzx   eax, BYTE PTR [rbp-560+rax]
        mov     BYTE PTR [rdx], al
        mov     rax, QWORD PTR [rbp-16]
        add     rax, 2
        movzx   eax, BYTE PTR [rax]
        movzx   eax, al
        mov     rdx, QWORD PTR [rbp-16]
        add     rdx, 2
        cdqe
        movzx   eax, BYTE PTR [rbp-304+rax]
        mov     BYTE PTR [rdx], al
        add     QWORD PTR [rbp-16], 4
        add     DWORD PTR [rbp-36], 1
.L17:
        mov     eax, DWORD PTR [rbp-36]
        cmp     eax, DWORD PTR [rbp-1084]
        jl      .L18
.L23:
        nop
        leave
        ret
.LC0:
        .long   0
        .long   1080025088
.LC2:
        .long   0
        .long   1081073664