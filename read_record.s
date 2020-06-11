.include "record_def.s"
.include "linux.s"

# PARAMS
# - File descriptor
# - Buffer

.equ ST_BUFFER, 8
.equ ST_FILEDES, 12
.section .text
.globl read_record
.type read_record, @function
read_record:
  pushl %ebp
  movl %esp, %ebp

  pushl %ebx

  movl ST_FILEDES(%ebp), %ebx
  movl ST_BUFFER(%ebp), %ecx
  movl $RECORD_SIZE, %edx
  movl $SYS_READ, %eax
  int $LINUX_SYSCALL

  popl %ebx

  movl %ebp, %esp
  popl %ebp
  ret
