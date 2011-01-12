%{

#include <glib.h>
#include <stdlib.h>

/* token recognizer */
enum {
    LOOKUP = 0, /* default is lookup, not add */
    VERB,
    ADJ,
    ADV,
    NOUN,
    PREP,
    PRON,
    CONJ
};

int state;

int add_word( int type, char* word );
int lookup_word( char* word );
int print_word( gpointer data, gpointer userdata );

%}

%%
\n        {state=LOOKUP;} /* go back to default */
^verb     {state=VERB;}
^adj      {state=ADJ; }
^adv      {state=ADV; }
^noun     {state=NOUN; }
^prep     {state=PREP; }
^pron     {state=PRON; }
^conj     {state=CONJ; }
[a-zA-Z]+ {
    if( state!=LOOKUP ) {
        add_word( state, yytext );
    }
    else {
        switch( lookup_word( yytext ) ) {
            case VERB:
                printf("%s: verb\n", yytext);
                break;
            case ADJ:
                printf("%s: adjective\n", yytext);
                break;
            case ADV:
                printf("%s: adverb\n", yytext);
                break;
            case NOUN:
                printf("%s: noun\n", yytext);
                break;
            case PREP:
                printf("%s: preposition\n", yytext);
                break;
            case PRON:
                printf("%s: pronoun\n", yytext);
                break;
            case CONJ:
                printf("%s: conjuction\n", yytext);
                break;
            default:
                printf("%s: don't recognize\n", yytext );
                break;
        }
    }
}
. /* ignore other characters. */
%%

GList* list=NULL;

int main( int argc, char* argv[] )
{
    yylex();
    g_list_foreach(list, (GFunc)print_word, NULL);
    g_list_free(list);
}

struct word {
    GString* word_name;
    gint word_type;
};

int print_word( gpointer data, gpointer userdata ) {
    struct word* word=(struct word*)data;
    g_printf( "word=%s type=%d\n", word->word_name->str, word->word_type );
    return 0;
}

int add_word( int type, char* word) {
    struct word* wp;
    if( lookup_word( word )!=LOOKUP ) {
        printf("!!! Warning: word %s already defined.\n", word );
        return 0;
    }

    wp = g_new0(struct word, 1);
    wp->word_name=g_string_new( word );
    wp->word_type=type;
    list = g_list_append(list, wp);
    return 1;
}

gint compare_word( gconstpointer a, gconstpointer b) {
    struct word *p1=(struct word*)a;
    GString* s=g_string_new( (char*)b );
    int ret=0;
    if( !g_string_equal( p1->word_name, s ) )
        ret=1;
    g_string_free(s, FALSE);
    return ret;
}

int lookup_word( char* word ) {
    GList* found=g_list_find_custom( list, word, compare_word );
    if( found )
        return ((struct word*)found->data)->word_type;
    return LOOKUP;
}

