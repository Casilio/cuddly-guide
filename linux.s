# Common linux definitions

.equ LINUX_SYSCALL, 0x80
.equ SYS_OPEN, 5
.equ SYS_CLOSE, 6
.equ SYS_WRITE, 4
.equ SYS_READ, 3
.equ SYS_EXIT, 1
.equ SYS_BRK, 45

.equ RDONLY, 0
.equ CREATE_WRITE_TRUNC, 03101

.equ STDIN, 0
.equ STDOUT, 1
.equ STDERR, 2

.equ EOF, 0
