; Follow link bellow to view more information about ncursor
; https://www.lihaoyi.com/post/BuildyourownCommandLinewithANSIescapecodes.html
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

.text

    _start:
        ; output message = Nikita Obydenkov and Konstantin Kozlov
        ; background black colour = \u001b[40m
        ; reset for background colour = \u001b[0m
        ; characters bright blue colour = \u001b[34;1m
        ; reset for character colour = \u001b[0m
        string_print char_sequence, char_sequence_length

        mov X0, 0
        mov X16, 1
        svc #0x80

.data
    char_sequence_length: .byte 141
    char_sequence: .ascii "\x1b[5B\x1b[46C\x1b[40m\x1b[34;1m\x1b[5B\x1b[46C\x1b[40m\x1b[34;1m\x1b[40m\x1b[34;1mNikita Obydenkov and Konstantin Kozlov\x1b[34;1m\x1b[40m\x1b[0m\x1b[34;1m\x1b[40m\x1b[0m\x1b[34;1m\x1b[40m\x1b[0m\n"