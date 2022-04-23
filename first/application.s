// labaratory 1 - 3 variant
// https://opensource.apple.com/source/xnu/xnu-1504.3.12/bsd/kern/syscalls.master - all mac os syscalls
.global _start
.align 2

.text
    _start:
        mov X0, #0              // fd = stdin
        adrp X1, buffer@PAGE    // address of buffer
        mov X2, #200            // buffer size
        mov X16, #3             // { user_ssize_t read(int fd, user_addr_t cbuf, user_size_t nbyte); } 
        svc #0x80               // system unterrupt

        mov X0, #1      // fd = stdout
        mov X2, #1      // bufsize = 1 character
        mov X16, #4     // { user_ssize_t write(int fd, user_addr_t cbuf, user_size_t nbyte); }
        mov X10, #200    // make counter for loop

        loop:
            adrp X1, buffer@PAGE        // addres of word -> X1
            add X1, X1, X10             // make shift to certain character
            subs X10, X10, #1           // --counter
            svc #0x80                   // system unterrupt
            b.pl loop                   // jump to loop if pozitive or zero counter

        mov X0, #0      // returning 0 to system, use "echo $?" to view it
        mov X16, #1     // { void exit(int rval); }
        svc #0x80       // system unterrupt

.data
    buffer: .fill 200, 1, 0     // word wich will reverse

