LEX=flex
CC=gcc

PROGRAMS=p1 p2

all: $(PROGRAMS)

%: %.c
	echo "compiling"
	$(CC) -o $@ $^ -lfl

%.c: %.lex
	echo "lexing"
	$(LEX) -o $@ $^

clean:
	rm -f $(PROGRAMS)
