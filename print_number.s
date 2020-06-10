.include "linux.s"

.section .text
.globl print_number

# PARAMS
# - Output file descriptor
# - Number
.equ NUMBER, 8
.equ OUTPUT_FD, 12
.equ DIGITS, -4
.type print_number, @function
print_number:
  pushl %ebp
  movl %esp, %ebp
  subl $4, %esp

  movl NUMBER(%ebp), %eax
  movl $0, %edx

  movl $0, DIGITS(%ebp)
  movl $10, %ebx
print_number_convert:
  cmpl $0, %eax
  jle print_number_loop

  div %ebx
  pushl %edx
  incl DIGITS(%ebp)
  xor %edx, %edx
  jmp print_number_convert

print_number_loop:
  cmpl $0, DIGITS(%ebp)
  je print_number_end

  popl %ecx
  addl $48, %ecx
  pushl %ecx
  movl %esp, %ecx

  movl $SYS_WRITE, %eax
  movl OUTPUT_FD(%ebp), %ebx
  movl $1, %edx
  int $LINUX_SYSCALL

  popl %ecx

  decl DIGITS(%ebp)

  jmp print_number_loop

print_number_end:
  movl %ebp, %esp
  popl %ebp
  ret
