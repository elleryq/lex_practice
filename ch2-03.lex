%{
/**
 * chap2-01.lex
 * wc
 */
unsigned long char_count=0, word_count=0, line_count=0;
#undef yywrap  /* Turn off */
%}

word [^ \t\n]+
eol  \n
%%
{word}    { word_count++; char_count+=yyleng; }
{eol}     { char_count++; line_count++; }
.         { char_count++; }
%%

char **file_list;
unsigned current_file=0;
unsigned n_files;
unsigned long total_cc=0;
unsigned long total_wc=0;
unsigned long total_lc=0;

int main( int argc, char* argv[] )
{
    FILE *file;
    file_list=argv+1;
    n_files=argc-1;

    if( argc==2 ) {
        current_file=1;
        file=fopen( argv[1], "r" );
        if( !file ) {
            fprintf( stderr, "could not open %s\n", argv[1] );
            exit(1);
        }
        yyin=file;
    }
    if( argc>2 )
        yywrap();

    yylex();

    if( argc>2 ) {
        printf( "%8lu %8lu %8lu %s\n",
                line_count, word_count, char_count, file_list[current_file-1] );
        total_cc+=char_count;
        total_wc+=word_count;
        total_lc+=line_count;
        printf( "%8lu %8lu %8lu total\n",
                total_lc, total_wc, total_cc );
    }
    else {
        printf( "%8lu %8lu %8lu\n",
                line_count, word_count, char_count );
    }
    return 0;
}

int yywrap(void) {
    FILE *file=NULL;

    if( (current_file!=0) && (n_files>1) && (current_file<n_files) ) {
        printf("%8lu %8lu %8lu %s\n", 
                line_count, word_count, char_count, file_list[current_file-1] );
        total_cc+=char_count;
        total_wc+=word_count;
        total_lc+=line_count;
        char_count=word_count=line_count=0;
        fclose(yyin);
    }

    while( file_list[current_file]!=(char*)0 ) {
        file=fopen( file_list[current_file++], "r" );
        if( file ) {
            yyin=file;
            break;
        }
        fprintf( stderr, "could not open %s\n",
                file_list[current_file-1] );
    }
    return file?0:1;
}

