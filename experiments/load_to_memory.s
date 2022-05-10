.global _start
.align 4

.text
    _start:
        mov X0, 0
        mov X16, 1
        svc #0x80

.data
    nubmer: .ascii "a"
    nubmer_len: .byte 1