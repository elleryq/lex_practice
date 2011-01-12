LEX=flex
CC=gcc

PROGRAMS=p1 p2

all: $(PROGRAMS)

%: %.c
	echo "compiling"
	$(CC) -o $@ $^ -lfl `pkg-config --cflags --libs glib-2.0`

%.c: %.lex
	echo "lexing"
	$(LEX) -o $@ $^

clean:
	rm -f $(PROGRAMS)
