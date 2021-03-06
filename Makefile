AS=as
LD=ld
ASFLAGS=--32 -g
LDFLAGS=-m elf_i386
DEPS = linux.s record-def.s

%.o: %.s $(DEPS)
	$(AS) $(ASFLAGS) -o $@ $^

all: write read add_year

write: write_records.o write_record.o
	$(LD) $(LDFLAGS) -o $@ $^

read: read_record.o read_records.o count_chars.o write_newline.o print_number.o
	$(LD) $(LDFLAGS) -o $@ $^

add_year: add_year.o read_record.o write_record.o error_exit.o count_chars.o write_newline.o
	$(LD) $(LDFLAGS) -o $@ $^

.PHONY: clean
clean:
	rm *.o write read add_year

