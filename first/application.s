// labaratory 1 - 3 variant
// https://opensource.apple.com/source/xnu/xnu-1504.3.12/bsd/kern/syscalls.master - all mac os syscalls
.global _start
.align 2

_start:
    mov X0, #1      // fd = stdout
    mov X2, #1      // bufsize = 1 character
    mov X16, #4     // { user_ssize_t write(int fd, user_addr_t cbuf, user_size_t nbyte); }
    mov X10, #12    // make counter for loop

    loop:
        adr X1, word        // addres of word -> X1
        add X1, X1, X10     // make shift to certain character
        subs X10, X10, #1   // --counter
        svc #0x80           // system unterrupt
        b.pl loop           // jump to loop if pozitive or zero counter

    mov X0, #0      // returning 0 to system, use "echo $?" to view it
    mov X16, #1     // { void exit(int rval); }
    svc #0x80       // system unterrupt

word: .ascii "Hello world!"     // word wich will reverse
