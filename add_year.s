.include "linux.s"
.include "record-def.s"

.section .data
input_file_name:
  .ascii "test.dat\0"
output_file_name:
  .ascii "testout.dat\0"

.section .bss
.lcomm record_buffer, RECORD_SIZE

.equ ST_INPUT_FD, -4
.equ ST_OUTPUT_FD, -8

.section .text
.globl _start
_start:
  movl %esp, %ebp
  subl $8, %esp
  
  movl $SYS_OPEN, %eax
  movl $input_file_name, %ebx
  movl $RDONLY, %ecx
  movl $0666, %edx
  int $LINUX_SYSCALL

  movl %eax, ST_INPUT_FD(%ebp)

  cmpl $0, %eax
  jg continue_processing

.section .data
no_open_file_code:
  .ascii "0001: \0"
no_open_file_msg:
  .ascii "Can't open input file\0"

.section .text
  pushl $no_open_file_msg
  pushl $no_open_file_code
  call error_exit

continue_processing:
  movl $SYS_OPEN, %eax
  movl $output_file_name, %ebx
  movl $CREATE_WRITE_TRUNC, %ecx
  movl $0666, %edx
  int $LINUX_SYSCALL

  movl %eax, ST_OUTPUT_FD(%ebp)

loop_begin:
  pushl ST_INPUT_FD(%ebp)
  pushl $record_buffer
  call read_record
  addl $8, %esp

  cmpl $RECORD_SIZE, %eax
  jne loop_end

  incl record_buffer + RECORD_AGE

  pushl ST_OUTPUT_FD(%ebp)
  pushl $record_buffer
  call write_record
  addl $8, %esp

  jmp loop_begin

loop_end:
  movl $SYS_EXIT, %eax
  movl $0, %ebx
  int $LINUX_SYSCALL

