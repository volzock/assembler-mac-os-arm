.global _start
.align 2

.text
    _start:
        mov X0, #0
        adrp X1, buffer@PAGE
        mov X2, #10
        mov X16, #3
        svc #0x80

        mov X0, #1
        adrp X1, buffer@PAGE
        mov X2, #10
        mov X16, #4
        svc #0x80

        mov X0, #0
        mov X16, #1
        svc #0x80

.data
    buffer: .fill 10, 1, 0