---
author: Jacob Martin
layout: default
title: Short x86_64 Assembly Tutorial with Complex Example
code: yes
math: yes
---
Knowing assembly language likely won't get you any jobs, but it's helpful to understand it. It shows the bare instructions that the processors perform. We'll proceed by example. (This tutorial assumes you know how to use some sort of high-level language but does not assume you know anything about the way these programs are executed. It also assumes you know what a bit and byte are and how the boolean logical operations operate on these.)

When you run ("execute") a program, the operating system loads the file which you are running into your computer's RAM (Random Access Memory). RAM is a temporary holding place that your processor can access and use to store and retrieve information faster than it can from your hard drive.  The operating system then instructs the CPU to start executing instructions starting at a certain point in your RAM.  An instruction is just a couple of bytes of binary code that the processor can understand which instruct it to do something very specific, such as alter a byte in RAM or send a signal to a hardware device.

When a compiler takes a program in a language and makes it into an executable file, most often, it first puts the program into an intermediate format.  Often, this is assembly language. Assembly language is simply the bare instructions put into a mnemonic format so that the programmer does not have to remember the binary number of every single instruction.  An assembler can read a plain-text file which contains assembly language code and put it into a binary format that the processor can read by translating the instructions one-by-one into the proper binary format. Often, as I stated earlier, a high-level compiler, like the C compiler, will first translate its code into assembly language, then will use another program to translate the assembly language into binary code. (Often, binary format simply means a non-human-readable format.)

The processor does its work by reading and writing memory locations, performing arithmetic, and jumping back-and-forth between places in the program.  It may do a little more, but that's the bulk of it. Any processor which allows you to jump to a place in the code based on some condition and allows you to write to any memory location can compute any computable algorithm. This is called Turing-completeness. Let's unpack what all of this means.

As before stated, RAM is simply a quickly-accessible way to store information.  We retrieve this information by referencing its address.  When a program is first started on a 64-bit processor it is given a rather-large amount of memory (on the order of 2^41 bytes).  Each byte (!) is given an address which can fit into eight bytes (64 bits, hence the naming of the processor design or "architecture").  You can think of the address space of the program as a giant array of bytes, the address of each of which is its array index. The following table is an example of a very small (4-bit) addressing space with the addresses given in binary and the contents given in hex. The contents of the memory of each program are different and highly program specific and also highly changeable!  This is just a contrived example.  (Hex is useful when representing binary code because each hex character corresponds to four bits, so one byte is two hex characters.) 

<table>
  <tr><th>Address</th><th>Contents</th></tr>
  <tr><td>0001</td><td>0x42</td></tr>
  <tr><td>0010</td><td>0xA6</td></tr>
  <tr><td>0011</td><td>0x4F</td></tr>
  <tr><td>0100</td><td>0x67</td></tr>
  <tr><td>0101</td><td>0xB4</td></tr>
  <tr><td>0110</td><td>0xFF</td></tr>
  <tr><td>0111</td><td>0x6F</td></tr>
</table>

We can find the contents of any spot in memory just by referencing it's location.  For instance, the contents of address `2` are `0xA6.` We usually write this as `[2] = 0xA6.` (If you've ever used C, you know this notation as `*(2) = 0xA6.` Although, of course, this is an assignment and not an expression.) In higher level languages, these addresses are often called pointers as they point to a byte in memory. When you derefence a pointer, you find (or assign) its contents.

RAM isn't the only place that programs can use to store information.  Every processor has registers.  These are temporary storage places which processors can access very quickly.  64-bit processor have 16 64-bit "general purpose" registers, which are to be used for any kind of information, viz., `rax, rcx, rdx, rbx, rsp, rbp, rsi, rdi, r8, r9, r10, r11, r12, r13, r14, r15.`  There are many more registers, but they have specific purposes, which we can get to later.  Some of these registers are broken down into smaller registers which reference only a portion of the register.


<table border="1px black solid" cellspacing="0" cellpadding="4px 2px 4px 2px">
  <tr><th colspan="8" width="100%">rax</th></tr>
  <tr><th colspan="4" width="50%"></th><th colspan="4" width="50%">eax</th></tr>
  <tr><th colspan="4" width="50%"></th><th colspan="2" width="25%"></th><th colspan="2" width="25%">ax</th></tr>
  <tr><th colspan="4" width="50%"></th><th colspan="2" width="25%"></th><th width="12.5%">ah</th><th width="12.5%">al</th></tr>
  <tr><td colspan="4" width="50%">32 bits</td><td colspan="2" width="25%">16-bits</td><td width="12.5%">8 bits</td><td width="12.5%">8 bits</td></tr>
</table>

So, if you have some information stored in `rax` but only need to access the lower byte, you can just use the `al` register. Notice, these are actually mnemonics. The register `ax` was originally the accumulator register on 16-bit machines.  You could access the high byte with `ah` and the low byte with `al.` As the register sizes grew, they didn't simply do away with the old registers but rather expanded them.

Now on to the part where we actually write some assembler code.  I use NASM, the netwide assembler, you can [find it](http://www.nasm.us/) for free (BSD-licensed). (Technical note, this is Intel syntax code, which looks and feels quite difference from AT&T syntax, which I won't cover here. You can read many boring manuals on it if you want to code in it.) The simplest instruction is the <code>mov</code> instruction. This simply stores a piece of information somewhere.  Its syntax is `mov dest,src` which may seem a little backwards, but it soon becomes automatic. (In assembly, comments are made with a semicolon.)

{% highlight nasm %}
mov eax, 5                 ; moves 5 into eax register
mov [2], 6                 ; moves the value 6 into the memory location 2
mov eax, ebx               ; copies the value of ebx into eax
{% endhighlight %}

This little snippet of code puts the value 5 (binary 0101) into the eax register. When the assembler reads this, it is going to translate it straight into the binary code `B805000000`.  The assembly code is much more human-readable, eh?

Of course, we can do much more interesting things, too.  The `add` instruction can take two operands, add them together, then store it within the first operand (the destination operand). The `sub` operation works similarly for subtraction.

{% highlight nasm %}
add eax, 5                  ; eax = eax + 5
add eax, ebx                ; eax = eax + ebx
add [2], 6                  ; [2] = [2] + 6

sub eax, 5                  ; eax = eax - 5
sub eax, ebx                ; eax = eax - ebx
sub [2], 6                  ; [2] = [2] - 6
{% endhighlight %}

A label is a human-readable name for a point in the program. You can "jump" to labels with the `jmp` instruction. This simply means you go back (or forward) to that point in the program and start executing the instructions there.

{% highlight nasm %}
label1:
    sub ecx, 1              ; this executes an infinite loop that
    jmp label1              ; repeatedly decrements the ecx register
{% endhighlight %}

Now, this instruction is useful but not terribly. We want our execution to stop sometime, so we have conditional jump instructions, which jump only if some condition is met.  For instance, we can do a subtraction, and if it yields zero, it sets a bit in the special-purpose `FLAGS` register. When this bit is set, we can use the `je` (jump if equal) instruction. (By the way, this makes just the instructions we've learned so far into a Turing-complete language.) Let's make a loop that only executes five times.

{% highlight nasm %}
    mov eax, 5
label2:
    sub eax, 1
    je label2
{% endhighlight %}

Now, I want to do an example. Let's make a real-world example that we'll walk through. I want to make an `strlen` function which will return the length of a string. A string is simply an array of characters. A character is just a single byte that programs know how to render to look a letter or symbol, etc. So-called C strings are terminated by a null character. So to find this length, we are going to start with the address of the first character of a string and count up until we find a null character. We'll assume that the address of the first character is in `rdi` and use the `rax` register to count up.

{% highlight nasm %}
strlen:
    mov rax,0               ; make sure there's no junk in the register
.looplabel:
    cmp byte [rdi],0        ; subtract zero from the value of the memory location
                            ; pointed to by rax and set the flags, but don't change rax
    je  .end                ; go to the end if we're finished
    inc rdi                 ; setup the loop by going to the next character
    inc rax                 ; add one to our character count
    jmp .looplabel          ; if the character wasn't the null character, go back
.end:
    ret                     ; otherwise, if it is, return from our function!
                            ; whatever place in the code called it can use rcx as
                            ; the length of its string
{% endhighlight nasm %}

Several things just happened here, so let's unpack them. A function in assembly is simply defined by a label. We can return from the function and it goes back to the point where it was called from!

"Okay, that's great and all, but we haven't actually made a usable program, yet."

(The Windows part of this tutorial is a work-in-progress, and I won't be able to help you there.)

We're about to compile a tradition <code>hello, world</code> program for Linux.  In a text editor, create a file like `helloworld.asm` or similar and type,

{% highlight nasm %}
BITS 64

section .text
global _start

_start:
    mov   rax, 1                ; sys_write
    mov   rdi, 1                ; stdout
    mov   rsi, msg              ; pointer to beginning of our message
    mov   rdx, msg_len          ; length of it, this is found by
                                ; the assembler
    syscall                     ; transfer control to the kernel

    mov   rax, 60               ; sys_exit
    mov   rdi, 0                ; exit(0)
    syscall                     ; transfer control to the kernel

section .data
    msg db "hello, world",0xA   ; define all these bytes as beginning
                                ; at the label msg
    msg_len equ $ - msg         ; define a constant that the assembler
                                ; knows that subtracts the current addr.
                                ; of the program from the addr. of msg
{% endhighlight %}

You can compile this with

{% highlight sh %}
$ nasm -f elf64 helloworld.asm -o helloworld.o
$ ld helloworld.o -o helloworld
$ ./helloworld
hello, world
$
{% endhighlight %}
	
Okay, I've introduce a lot here, so let's unpack it. First, we have `section` directives. These tell the operating system what kind of data come after them. The `.text` section is full of instructions, while the `.data` section has normal data. When a label is followed by `db` or similar, it tells the assembler, "reproduce this data exactly as I have it here." The `equ` directive actually defines a macro. These things won't go into the final executable, but they are calculated by the assembler and inserted literally where they are in the code.

Now, we have also the concept of a syscall. When you want to interact with the outside world, get any input, put any output, etc., you call the kernel and tell it what you want to do. You tell it these things by putting the right numbers into the right registers. Each thing that the kernel does has a syscall number, which goes into `eax.` The syscall number 1 tells the kernel to write to a file. Everything is a file in linux, so if you want to output to the screen you write to the file `stdout.` Every file that your program opens comes with a file descriptor, which is simply a number that the kernel keeps track of and uses to write to files. The file descriptor of `stdout` is always 1. So, we put 1 into `rdi` as the first argument. (Using `rdi` as the first argument to a function traditionally.) Next, we put the beginning of the string we want to  write into `rsi.` (This is also traditional.) Next, we put the length of that strength into `rdx` (again, traditional). We then tell the kernel, "It's all up to you now, buddy." And the kernel takes over and outputs to the screen. If this is successful, a zero will be put into `rax.` (Traditionally, this is where the return value goes. And zero usually means "All is going well.") Then, we exit. To exit, we use the syscall number 60 and put the exit code into `rdi.`

Now, let's put our strlen program to good use. I'll name this file `strlen.asm` for use in this tutorial.

{% highlight nasm %}
BITS 64

section .text
global _start

strlen:
    mov rax,0                   ; make sure there's no junk in the register
.looplabel:
    cmp byte [rdi],0            ; subtract zero from the value of the memory location
                                ; pointed to by rax and set the flags, but don't change rax
    je  .end                    ; go to the end if we're finished
    inc rdi                     ; setup the loop by going to the next character
    inc rax                     ; add one to our character count
    jmp .looplabel              ; if the character wasn't the null character, go back
.end:
    ret                         ; otherwise, if it is, return from our function!
                                ; whatever place in the code called it can use rcx as
                                ; the length of its string
    
_start:
    mov   rdi, msg              ;  eax = strlen(rdi = msg)
    call  strlen

    add   al, '0'               ; This converts the number into a
                                ; usable character that will can
                                ; be printed
    mov  [len],al               ; Move this character to a string that can
                                ; be printed
    
    mov   rax, 1                ; sys_write
    mov   rdi, 1                ; stdout
    mov   rsi, len              ; pointer to beginning of our length string
    mov   rdx, 2                ; length of our length string is two
                                ; chars, the number & return
    syscall                     ; transfer control to the kernel

    mov   rax, 60               ; sys_exit
    mov   rdi, 0                ; exit(0)
    syscall                     ; transfer control to the kernel

section .data
    msg db "hello",0xA,0        ; define all these bytes as beginning
                                ; at the label msg
    len db 0,0xA                ; this is the string that will eventually be printed
                                ; the zero is a placeholder and 0xA is ascii for
                                ; return
{% endhighlight %}

There, it works right. We have a language replete with branching, functions, variables, and arithmetic. Easy, right?

Well, I wanna show one more application. I want to find the length of a UTF-8 string.

Here's the program we are going to use to test our function. I'm going to name it test.asm.

{% highlight nasm %}
BITS 64
section .text

%include "utf8_strlen.inc"

global _start
_start:
    mov   rdi, msg              ; rax = strlen(rdi = msg)
    call  utf8_strlen
    
    add   al, '0'               ; Convert number to char
    mov [len], al               ; Store in string

    mov   rax, 1                ; sys_write
    mov   rdi, 1                ; stdout
    mov   rsi, len              ; string
    mov   rdx, 2                ; strlen(len)
    syscall

    mov   rax, 60               ; sys_exit
    xor   rdi, rdi              ; exit(0)
    syscall

section .data
    msg db "á€sgfé𐀢ña",0
    len db 0,0xA
{% endhighlight %}

The `%include` directive tells the assembler to copy the file being included into the file. I'm simply separating these files for clarity's sake. The test string here includes 1, 2, 3, and 4 byte characters. Our program should print out a 9. Let's hope. Our regular `strlen` won't work because it just counts bytes, but many unicode characters take more than one byte, but not all of them. This is called variable-length encoding. The following table shows how, in binary, various lengths of Unicode characters are encoded.  The x's represent the Unicode code point, which tells the program which character it is exactly. (All of the 7-bit characters correspond exactly to ascii characters in order to preserve compatibility.)

<table>
  <tr><th>Bits of Code Point</th><th>Bytes in Char Sequence</th><th>Byte 1</th><th>Byte 2</th><th>Byte 3</th><th>Byte 4</th></tr>
  <tr><td>7</td><td>1</td><td>0xxxxxxx</td><td></td><td></td><td></td></tr>
  <tr><td>11</td><td>2</td><td>110xxxxx</td><td>10xxxxxx</td><td></td><td></td></tr>
  <tr><td>16</td><td>3</td><td>1110xxxx</td><td>10xxxxxx</td><td>10xxxxxx</td><td></td></tr>
  <tr><td>21</td><td>4</td><td>11110xxx</td><td>10xxxxxx</td><td>10xxxxxx</td><td>10xxxxxx</td></tr>
</table>

We'll notice that if the eighth bit is set, then this is a non-ascii character. Also, for the beginning of every non-ascii character, the number of ones after the highest zero is the number of bytes the entire character takes up. So, we can count the total number of bytes in the string and then subtract the surplus bytes that Unicode characters take up. We can't subtract all the bytes they take up because a unicode character is still a character, so we subtract all but one of the bytes. So, here is the code I have made. `utf8_strlen.inc`

{% highlight nasm %}
utf8_strlen:
	cld
	lea   rsi,[rdi]
.lp:
	lodsb
	cmp   al, 0	
	je    .end
	bt    ax, 7
	jnc   .lp
	inc   rdi
	inc   rsi
	bt    ax, 5
	jnc   .lp
	inc   rdi
	inc   rsi
	bt    ax, 4
	jnc   .lp
	inc   rdi
	inc   rsi
	jmp   .lp
.end:
	sub   rsi,rdi
	lea   rax,[rsi - 1]
	ret
{% endhighlight %}

I've introduced many instructions here, so let's unpack each one of them. One of the bits in the `FLAGS` register is the direction bit. This tells the processor whether to go forwards or backwards when it operates on arrays (like strings). The `cld` instruction sets the direction as forward. (Clear Direction) The `lea` instruction stands for Load Effective Address, and it puts the address of the data of the source operand into the destination operand. The instruction `lea rsi,[rdi]` is equivalent to `mov rsi,rdi.` It takes the address of the data which `rdi` is pointing to, which is the value of `rdi.`Some of the time, it simply takes up less space, especially if you need to do arithmetic on the addresses, like the penultimate line does.

Next, we introduce the string instruction `lodsb.` This is LOaD String Byte. It takes the byte pointed to by `rsi` and loads it into `al.` Then it adds one to `rsi,` advancing the string counter. (If you see an opportunity to improve our primitive `strlen`, then you are understanding this correctly.) The `bt reg,n` instruction takes the nth byte (zero-addressed, starting from the least significant byte) and sets the carry register to that byte. In other words, if `al = 10100000`, then `bt al,7` is going to set the carry bit, because the eight bit is set. The `jnc` instruction jumps to a label only if the carry bit is not set. ("Jump on Not Carry")

Our string argument is passed to us as a pointer in `rdi.` Since `lodsb` operates on `rsi`, we copy our address there. Then, we load the byte into `al`, and advance to the next character. We check to see if our first character, in `al,` is zero. If so, we go to the end; we've found the end of our string. If it isn't the end, however, we check to see if this is the beginning of a Unicode character by checking to see if the eight bit of it is set. If it is, we know we have to consume at least one more byte, so we advance the `rsi` and `rdi` registers. We advance the `rdi` register because it is the beginning address of our string, so to find the length of the string, we are going to subtract where we end from where we started. But, this is only going to give us the length in bytes. We can fool our own arithmetic, however, by pretending that we started later, hence reducing the character count as much as we need to to compensate for the extra length of the Unicode characters. We do this for the number of bytes we need to for each character, then move to the next character.

In the end, as aforementioned, we simply take the difference and return. We subtract one because `lodsb` is going to advance `rsi` to the null character, which is unnecessary.

And, as expected,

{% highlight sh %}
$ nasm -f elf64 try.asm -o try.o
$ ld try.o -o try
$ ./try
9
$
{% endhighlight %}

Now, we are to talk about one last concept in the assembly language---the stack.  A stack is a data structure, where you `push` data onto it. You can think of this as putting a sheet of paper on top of a stack of papers. When you need to access this data, you `pop` the data off it into some variable or place in memory, etc. This removes that data. You can think of this as picking up a piece of paper off the top of the stack. You see that the last thing you push on the stack is the first thing you pop off the stack.

When a program is loaded into memory it is given stack space.  This is a limited but large amount of memory that functions as a stack with special instructions to make your life easier.

{% highlight nasm %}
push  eax                    ; Put the value from eax onto the top of the stack
pop   ecx                    ; Take this value into ecx
{% endhighlight %}

The top of the stack is stored in the special register `rsp` (Register of the Stack Pointer). The bottom of the stack is referenced by the special register `rbp` (Register of the Base Pointer). You'll notice, however, that `rbp > rsp.` This is because the stack grows downwards. The base pointer is essentially the highest address one can access. (This isn't strictly true, but you shouldn't try to push it unless you know what you are doing.) When you use the `push` instruction, `rsp` is *decremented* by the number of bytes of data you are pushing onto the stack. When you use the `pop` instruction, `rsp` is incremented by the number of bytes you are popping off.

As an example, take the following stack.

<table>
  <tr><th colspan="2">Address</th><td></td></tr>
  <tr><th>From rbp</th><th>From rsp</th><th>Data</th></tr>
  <tr><td>rbp</td><td>rsp + 2</td><td>0x5A</td></tr>
  <tr><td>rbp - 1</td><td>rsp + 1</td><td>0xFF</td></tr>
  <tr><td>rbp - 2</td><td>rsp</td><td>0xA1</td></tr>
</table>

(Note that the data pointed to by `rbp` is not, strictly speaking, part of this stack.)

With this stack and `bl = 0x04, cl = 0xA8`, the following instructions will yield the results following.

{% highlight nasm %}
pop  al                 ; al  = 0xA1, rsp = rsp + 1, [rsp] = [rbp - 1] = 0xFF
push bl                 ; rsp = rsp - 1, [rsp] = [rbp - 2] = bl
push cl                 ; rsp = rsp - 1, [rsp] = [rbp - 3] = cl
{% endhighlight %}

<table>
  <tr><th colspan="2">Address</th><td></td></tr>
  <tr><th>From rbp</th><th>From rsp</th><th>Data</th></tr>
  <tr><td>rbp</td><td>rsp + 3</td><td>0x5A</td></tr>
  <tr><td>rbp - 1</td><td>rsp + 2</td><td>0xFF</td></tr>
  <tr><td>rbp - 2</td><td>rsp + 1</td><td>0x04</td></tr>
  <tr><td>rbp - 3</td><td>rsp</td><td>0xA8</td></tr>
</table>

The `call` instruction pushes the address of the instruction after it on the stack and changes the base pointer to point to it. The `ret` instruction jumps to the value on top of the stack, popping it off, and decrementing *both* `rsp` and `rbp` by eight (the length in bytes of the address).

Now, when we push or pop from/into a memory address, we must specify how much data to do so with. (With registers, this is assumed to be the entire register's worth of data, but we can change this if we desire by specifying the amount anyways.)

{% highlight nasm %}
pop byte [2]
pop word [eax]
{% endhighlight %}

The words we can use for these sizes are in the table below.

<table>
  <tr><th>Name</th><th>Number of bits</th></tr>
  <tr><td>byte</td><td>8</td></tr>
  <tr><td>word</td><td>16</td></tr>
  <tr><td>dword</td><td>32</td></tr>
  <tr><td>qword</td><td>64</td></tr>
</table>

There are many more. A fantastic reference document where we can find all these and much more information about what each instruction does can be found at the [Flat Assembler's Programming Manual](flatassembler.net/docs.php?article=manual).

A note on the praxis of assembly programming is that the `-l listfile` argument to `nasm` will give you a listing file `listfile` which shows the address and contents of all the data in your output. This is useful for fine-tuning, seeing what instructions correspond to what binary operands, etc.