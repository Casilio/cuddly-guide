AS=as
LD=ld
AFLAGS=--32
LDFLAGS=-m elf_i386
DEPS = linux.s record-def.s

%.o: %.s $(DEPS)
	$(AS) $(AFLAGS) -o $@ $^

write: write_records.o write_record.o
	$(LD) $(LDFLAGS) -o $@ $^

read: read_record.o read_records.o count_chars.o write_newline.o
	$(LD) $(LDFLAGS) -o $@ $^

add_year: add_year.o read_record.o write_record.o 
	$(LD) $(LDFLAGS) -o $@ $^
