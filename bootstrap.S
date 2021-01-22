.global _start
.global _usb_transfer_wrapper
.extern kernel
_start:
    ldr r0, =string
    mov r1, #str_len
    ldr r4, =_continue
    bl _usb_transfer
_continue:
    ldr r0, =string2
    mov r1, #str2_len
    ldr r4, =_c2
    bl _usb_transfer
_c2:
    bl kernel
_end:
    bl _end
_usb_transfer:
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
    bx r4
_usb_transfer_wrapper:
    push {lr}
    ldr r4, =_return_back
    bl _usb_transfer
_return_back:
    pop {lr}
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