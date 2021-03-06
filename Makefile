CC=cc
CFLAGS=-O -I../..

UNZ_OBJS = miniunz.o unzip.o ioapi.o ../../libz.a
ZIP_OBJS = minizip.o zip.o   ioapi.o ../../libz.a
TEST_FILES = test.zip readme.old readme.txt

.c.o:
	$(CC) -c $(CFLAGS) $*.c

all: miniunz minizip

miniunz:  $(UNZ_OBJS)
	$(CC) $(CFLAGS) -o $@ $(UNZ_OBJS)

minizip:  $(ZIP_OBJS)
	$(CC) $(CFLAGS) -o $@ $(ZIP_OBJS)

.PHONY: test clean

test:	miniunz minizip
	@rm -f $(TEST_FILES)
	@cp README.md readme.txt
	@touch -t 200712301223.44 readme.txt
	./minizip test.zip readme.txt
	./miniunz -l test.zip
	mv readme.txt readme.old
	./miniunz test.zip
	@diff -q README.md readme.txt || echo "Test failed: files differ"
	@[[ "$$(stat -c %Y readme.txt)" = "$$(stat -c %Y readme.old)" ]] || echo "Test failed: timestamp not preserved"
	@rm -f $(TEST_FILES)

clean:
	/bin/rm -f *.o *~ minizip miniunz $(TEST_FILES)
