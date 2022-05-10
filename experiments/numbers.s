.global _start
.align 2

.equ BUFF_SIZE, 250

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

.macro unsigned_integer_print number
    save_registers

    mov X0, \number
    mov X1, #10
    
    // loop_:
    //    udiv X2, X0, X1
    //    mul X3, X2, X1
    //    sub X3, X0, X3
    //    add X3, X3, '0'
    //    mov X0, X2
    //    cmp X0, #0
    //    add X10, X10, #1
    //    b.eq loop_
    
    mov x10, #9
    add X10, X10, '0'
    adrp X11, char@PAGE
    add X11, X11, char@PAGEOFF
    stp X10, [X11]
    
    string_print char, char_size

    load_registers
.endm

.text
    _start:
        // mov X10, #123
        // unsigned_integer_print X10

        mov x10, #9
        add X10, X10, '0'
        adrp X11, char@PAGE
        add X11, X11, char@PAGEOFF
        stp X10, [X11]

        string_print char, char_size

        bl _end


    _end:
        mov X16, #1
        svc #0x80
    

.data
    output_size: .byte 9
    output: .ascii "Answer: \n"

    number: .ascii "9\n"
    number_size: .byte 2

    char: .ascii "a"
    char_size: .byte 2
    