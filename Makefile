LEX=flex
YACC=bison
CC=gcc

PROGRAMS=p1 p2 p3 p1-4y

all: $(PROGRAMS)

%y: %_lex.c %_yacc.c
	echo "lex/yacc"
	$(CC) -o $@ $^ -lfl `pkg-config --cflags --libs glib-2.0`

%: %.c
	echo "compiling"
	$(CC) -o $@ $^ -lfl `pkg-config --cflags --libs glib-2.0`

%_lex.c: %.lex
	$(LEX) -o $@ $^

%_yacc.c: %.y
	$(YACC) -o $@ --defines=y.tab.h $^

%.c: %.lex
	echo "lexing"
	$(LEX) -o $@ $^

clean:
	rm -f $(PROGRAMS) y.tab.h
