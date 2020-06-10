.include "linux.s"
.include "record-def.s"

.section .data
file_name:
  .ascii "test.dat\0"

.section .bss
.lcomm record_buffer, RECORD_SIZE

.section .text

.equ ST_INPUT_FILEDES, -4
.equ ST_OUTPUT_FILDES, -8

.globl _start
_start:
  movl %esp, %ebp
  subl $8, %esp

  movl $SYS_OPEN, %eax
  movl $file_name, %ebx
  movl $RDONLY, %ecx
  movl $0666, %edx
  int $LINUX_SYSCALL

  movl %eax, ST_INPUT_FILEDES(%ebp)
  movl $STDOUT, ST_OUTPUT_FILDES(%ebp)

record_read_loop:
  pushl ST_INPUT_FILEDES(%ebp)
  pushl $record_buffer
  call read_record
  addl $8, %esp

  cmpl $RECORD_SIZE, %eax
  jne finished_reading

  pushl $RECORD_FIRSTNAME + record_buffer
  call count_chars
  addl $4, %esp

  movl %eax, %edx
  movl $SYS_WRITE, %eax
  movl ST_OUTPUT_FILDES(%ebp), %ebx
  movl $RECORD_FIRSTNAME + record_buffer, %ecx
  int $LINUX_SYSCALL

  pushl ST_OUTPUT_FILDES(%ebp)
  call write_newline
  addl $4, %esp

  jmp record_read_loop

finished_reading:
  movl $SYS_EXIT, %eax
  movl $0, %ebx
  int $LINUX_SYSCALL
