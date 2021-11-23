%include 
{
#include <assert.h>
#include <stdlib.h>
#include "parser.h"
#include "ast.h"
#define LIST 1000
Node * linkn(Node *a, Node *b,int type){
Node *d=malloc(sizeof(Node));
d->a=a;
d->b=b;
d->name=0;
d->type=type;
return d;
}
void dump(Node *n){
 if (n->a)
   dump(n->a);
 if (n->b)
   dump(n->b);
 if (n->name)
  printf(n->name);
}
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
program ::= statlist(A).  {dump(A);}
statlist(D) ::= stat(A) statlist(B).  {D=linkn(A,B,LIST);}
statlist(D) ::= stat(A). {D=A;}
stat(D) ::= ident(A) EQUA expr(B) SEMI. {D=linkn(A,B,EQUA);}
expr(D) ::= OPENP expr(A) CLOSEP.  {D=A;}
expr(D) ::= expr(A) PLUS expr(B).  {D=linkn(A,B,PLUS);}
expr(D) ::= expr(A) DIVIDE expr(B). {D=linkn(A,B,DIVIDE);}
expr(D) ::= expr(A) TIMES expr(B). {D=linkn(A,B,TIMES);}
expr(D) ::= expr(A) MINUS expr(B).  {D=linkn(A,B,MINUS);}
expr(D) ::= DOUBLE(A).  {printf("num %s\n",A->name);D=A;} 
expr(D) ::= ident(A). {D=A;}
ident(D) ::= IDENT(A).  {printf("ident %s\n",A->name);D=A;}
