%include 
{
#include <assert.h>
#include "parser.h"
#include "ast.h"
}
%token_type    {Node*}
%parse_failure {
     fprintf(stderr,"Giving up.  Parser is hopelessly lost...\n");
}
%syntax_error{
extern void syntax_error(void);
syntax_error();
}
%left PLUS MINUS.
%left DIVIDE TIMES.
program ::= statlist.  {printf("prog\n");}
statlist ::= stat statlist.
stat ::= ident EQUA expr SEMI.
expr ::= OPENP expr CLOSEP.
expr ::= expr PLUS expr. 
expr ::= expr DIVIDE expr. 
expr ::= expr TIMES expr. 
expr ::= expr MINUS expr. 
expr ::= DOUBLE(B).  {printf("num %s\n",B->name);} 
expr ::= ident.
ident ::= IDENT(B).  {printf("ident %s\n",B->name);}
