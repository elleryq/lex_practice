%{
/* lexer */
#include <stdio.h>
%}

%token NOUN PRONOUN VERB ADVERB ADJECTIVE PREPOSITION CONJUNCTION

%%
sentense: subject VERB object { printf("Sentence is valid.\n"); }
    ;

subject: NOUN | PRONOUN
    ;

object: NOUN
    ;

%%

extern FILE* yyin;

int main( int argc, char* argv[] ) {
    do {
        yyparse();
    }while( !feof(yyin) );
}

int yyerror( char* s ) {
    fprintf( stderr, "%s\n", s );
}
