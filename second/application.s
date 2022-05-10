.global _start
.align 2

.macro save_registers
    stp	    X0, X1, [SP, #-16]!
	stp	    X2, X3, [SP, #-16]!
	stp	    X4, X5, [SP, #-16]!	
	stp	    X6, X7, [SP, #-16]!	
	stp	    X8, X9, [SP, #-16]!	
	stp	    X10, X11, [SP, #-16]!	
	stp	    X12, X13, [SP, #-16]!	
	stp	    X14, X15, [SP, #-16]!	
	stp	    X16, X17, [SP, #-16]!	
	stp	    X18, LR, [SP, #-16]!
.endm

.macro load_registers
    ldp	    X18, LR, [SP], #16
	ldp	    X16, X17, [SP], #16
	ldp	    X14, X15, [SP], #16
	ldp	    X12, X13, [SP], #16
	ldp	    X10, X11, [SP], #16
	ldp	    X8, X9, [SP], #16
	ldp	    X6, X7, [SP], #16
	ldp	    X4, X5, [SP], #16
	ldp	    X2, X3, [SP], #16
	ldp	    X0, X1, [SP], #16
.endm

.macro string_print out_str, out_str_size
    save_registers

    mov X0, #1
    adrp X1, \out_str@PAGE
    add X1, X1, \out_str@PAGEOFF

    adrp X2, \out_str_size@PAGE
    add X2, X2, \out_str_size@PAGEOFF
    ldr X2, [X2]
    and X2, X2, #0x00000000000000FF

    mov x16, #4
    svc #0x80

    load_registers
.endm

.macro save_char char, char_place
    save_registers

    adrp X1, \char_place@PAGE
    add X1, X1, \char_place@PAGEOFF
    mov X2,  \char
    str X2, [X1]

    load_registers
.endm

.macro number_print number
    save_registers

    mov X1, \number
    mov X2, #10
    mov X10, #0
    mov X11, #0

    loop_:
        udiv X3, X1, X2
        mul X4, X3, X2
        sub X4, X1, X4
        add X4, X4, '0'
        stp	X4, X11, [SP, #-16]!
        mov X1, X3
        cmp X1, #0
        add X10, X10, #1
        cmp X1, #0
        b.ne loop_

    output_loop_:
        ldp	X4, X11, [SP], #16
        save_char X4, char_sequence
        string_print char_sequence, char_sequence_length
        sub X10, X10, #1
        cmp X10, #0
        b.ne output_loop_

    load_registers
.endm

.text

    _start:
        bl _first_expression
        bl _second_expression

        mov X0, 0
        mov X16, 1
        svc #0x80

    ; print number from X0
    _print_number:
        save_registers

        cmp X0, #0
        b.ge positive_

        save_char '-', char_sequence
        string_print char_sequence, char_sequence_length
        mov X1, #-1
        mul X0, X0, X1

        positive_:
            number_print X0
            save_char '\n', char_sequence
            string_print char_sequence, char_sequence_length

        load_registers
        ret

    ; 4 * X2 + 21 * Y2 + 9 * М2
    _first_expression:
        save_registers


        ; init constants
        mov X0, #0      ; value of expression
        mov X1, #0      ; clear X1
        mov X2, #2      ; value of X2
        mov X3, #2      ; value of Y2
        mov X4, #2      ; value of M2
        mov X5, #4      ; value of constant
        mov X6, #21     ; value of constant
        mov X7, #9      ; value of constant

        ; computing expression
        mul X0, X2, X5  ; X0 = 4 * X2
        mul X1, X3, X6  ; X1 = 21 * Y2
        add X0, X0, X1  ; X0 = 4 * X2 + 5 * Y2
        mul X1, X4, X7  ; X1 = 9 * М2
        add X0, X0, X1  ; X0 = 4 * X2 + 21 * Y2 + 9 * М2

        ; output the value of these expression
        bl _print_number

        load_registers
        ret
    
    ; 3*x + x*z - 17*y*z + 30  x=3, y=9, z=27
    _second_expression:
        save_registers

        ; init constants
        mov X0, #30     ; init value of expression
        mov X1, #0      ; clear X1
        mov X2, #3      ; value of x
        mov X3, #9      ; value of y
        mov X4, #27     ; value of z
        mov X5, #3      ; value of constant
        mov X6, #17     ; value of constant

        mul X1, X2, X4  ; X1 = x * z
        add X0, X0, X1  ; X0 = x*z + 30
        mul X1, X2, X5  ; X1 = x * 3
        add X0, X0, X1  ; X0 = 3*x + x*z + 30
        mul X1, X3, X4  ; X1 = y * z
        mul X1, X1, X6  ; X1 = 17 * y * z
        sub X0, X0, X1  ; X0 = 3*x + x*z - 17*y*z + 30

        ; output the value of these expression
        bl _print_number

        load_registers
        ret

.data
    char_sequence_length: .byte 1
    char_sequence: .byte '5'