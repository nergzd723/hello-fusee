.global _start
.global _usb_transfer_wrapper
.global _reset
.extern kernel
_start:
    ldr r0, =string
    mov r1, #str_len
    bl _usb_transfer
    ldr r0, =string2
    mov r1, #str2_len
    bl _usb_transfer
    bl kernel
_end:
    bl _end
_usb_transfer:
    push {lr}
    sub r2, sp, #4
    sub sp, sp, #4
    ldr ip, =0xFFF05093
    mov lr, pc
    bx ip
_usb_reset:
    add sp, sp, #4
    mov r0, #0
    mov r1, #1
    ldr ip, =0xFFF04997
    mov lr, pc
    bx ip
    pop {pc}
_usb_transfer_wrapper:
    push {lr}
    bl _usb_transfer
    pop {lr}
    bx lr
_reset:
    ldr lr, =0x0
    bx lr
.global  string
.size   string, str_end - string
.align 4
string:
    .asciz "hello, grouper world!\n"
str_end:
    .equ    str_len, . - string
.global  string2
.size   string2, str2_end - string2
.align 4
string2:
    .asciz "hello, grouper world, the second time around :O!\n"
str2_end:
    .equ    str2_len, . - string2