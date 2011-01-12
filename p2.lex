%{
    /* Header */
%}
%%
[\t ]+    /* ignore space */
exit      { printf( "%s\n", yytext ); exit(0); }
is        { printf( "%s: is a verb\n", yytext); }
[a-zA-Z]+ { printf( "%s: is not a verb\n", yytext); }
.|\n      { ECHO; /* default */ }
%%

int main( int argc, char* argv[] )
{
    yylex();
}

