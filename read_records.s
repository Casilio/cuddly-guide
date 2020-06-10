.include "linux.s"
.include "record-def.s"

.section .data
file_name:
  .ascii "test.dat\0"
firstname:
  .asciz "First Name: "
  .equ FNAME_LEN, 13
lastname:
  .asciz "Last Name: "
  .equ LNAME_LEN, 12
address:
  .asciz "Address: "
  .equ ADDR_LEN, 10
age:
  .asciz "Age: "
  .equ AGE_LEN, 6

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

  pushl ST_OUTPUT_FILDES(%ebp)
  pushl $firstname
  pushl $FNAME_LEN
  pushl $RECORD_FIRSTNAME
  call write_field
  addl $16, %esp

  pushl ST_OUTPUT_FILDES(%ebp)
  pushl $lastname
  pushl $LNAME_LEN
  pushl $RECORD_LASTNAME
  call write_field
  addl $16, %esp

  pushl ST_OUTPUT_FILDES(%ebp)
  pushl $address
  pushl $ADDR_LEN
  pushl $RECORD_ADDRESS
  call write_field
  addl $16, %esp

#  pushl ST_OUTPUT_FILDES(%ebp)
#  pushl $age
#  pushl $AGE_LEN
#  pushl $RECORD_AGE
#  call write_field
#  addl $16, %esp

  movl $SYS_WRITE, %eax
  movl ST_OUTPUT_FILDES(%ebp), %ebx
  movl $age, %ecx
  movl $AGE_LEN, %edx
  int $LINUX_SYSCALL

  movl $SYS_WRITE, %eax
  movl ST_OUTPUT_FILDES(%ebp), %ebx
  addl $RECORD_AGE + record_buffer, %ecx
  movl $4, %edx
  int $LINUX_SYSCALL

  pushl ST_OUTPUT_FILDES(%ebp)
  call write_newline
  addl $4, %esp

  pushl ST_OUTPUT_FILDES(%ebp)
  call write_newline
  addl $4, %esp

  jmp record_read_loop

finished_reading:
  movl $SYS_EXIT, %eax
  movl $0, %ebx
  int $LINUX_SYSCALL

# PARAMS
# - output file descriptor
# - field name
# - field length
# - field offset in a record
.equ F_OFFSET, 8
.equ F_LENGTH, 12
.equ F_NAME, 16
.equ OUTPUT_FD, 20
.type write_field, @function
write_field:
  pushl %ebp
  movl %esp, %ebp

  movl $SYS_WRITE, %eax
  movl OUTPUT_FD(%ebp), %ebx
  movl F_NAME(%ebp), %ecx
  movl F_LENGTH(%ebp), %edx
  int $LINUX_SYSCALL

  movl $record_buffer, %eax
  addl F_OFFSET(%ebp), %eax
  pushl %eax
  call count_chars
  addl $4, %esp

  movl %eax, %edx
  movl $SYS_WRITE, %eax
  movl OUTPUT_FD(%ebp), %ebx
  movl $record_buffer, %ecx
  addl F_OFFSET(%ebp), %ecx
  int $LINUX_SYSCALL

  pushl OUTPUT_FD(%ebp)
  call write_newline
  addl $4, %esp

  movl %ebp, %esp
  popl %ebp
  ret
