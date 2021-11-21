%include 
{
#include <assert.h>
#include "parser.h"
}
%parse_failure {
     fprintf(stderr,"Giving up.  Parser is hopelessly lost...\n");
}
%syntax_error{
extern int lpos(void);
extern char *data;
fprintf(stderr,"syntax error...\n%s",data);
int i;
for (i=0;i<lpos();i++) fprintf(stderr," ");
fprintf(stderr,"^~\n");
}
%left PLUS MINUS.
%left DIVIDE TIMES.
program ::= statlist.  {printf("prog\n");}
statlist ::= stat statlist.
stat ::= ident EQUA expr SEMI.  {printf("statement\n");}
expr ::= OPENP expr CLOSEP.
expr ::= expr PLUS expr. 
expr ::= expr DIVIDE expr. 
expr ::= expr TIMES expr. 
expr ::= expr MINUS expr. 
expr ::= DOUBLE. 
expr ::= ident.
ident ::= IDENT. 
