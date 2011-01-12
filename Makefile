LEX=flex

all: p1

p1: p1.c
    $(CC) -o $@ $^

p1.c: p1.lex
	$(LEX) -o $@ $^
