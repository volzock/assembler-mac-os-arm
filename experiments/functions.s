.global _start
.align 2

_start:
    bl _print_data
    bl _end

_end:
    mov X0, #0
    mov X16, #1
    svc #0x80

_print_data:
    str LR, [SP, #-16]
    bl _print_word
    bl _print_message
    ldr LR, [SP, #-16]
    ret

_print_word:
    mov X0, #1
    adr X1, word
    mov X2, #5
    mov X16, #4
    svc #0x80
    ret

_print_message:
    mov X0, #1
    adr X1, message
    mov X2, #13
    mov X16, #4
    svc #0x80
    ret

message: .ascii "hello wordl!\n"
word: .ascii "word\n"