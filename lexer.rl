#include<stdio.h>
#include<stddef.h>
#include<stdlib.h>
#include "parser.h"
#include "ast.h"
#include <unistd.h>
#include <string.h>

#define LIST 1000

void *ParseAlloc( void*(*malloc)(size_t) );
void ParseFree(void *pParser, void(*free)(void*) );
void Parse(void *pParser, int tokenCode, void*  token);
void ParseTrace(FILE *stream, char *zPrefix);
void* lparser;

%%{

machine calc;
action ident_tok {
   Node *n=malloc(sizeof(Node));
   n->name=malloc(te-ts+1);
   n->type=IDENT;
   strncpy(n->name,ts,te-ts);
   n->name[te-ts]='\0';
   n->a=0;
   n->b=0;
   Parse(lparser,IDENT,n);
}
action semi_tok {
   //Terminate this calculation.
   Parse(lparser, SEMI, 0);
}

action plus_tok {
   Parse(lparser, PLUS, 0);
}

action minus_tok {
   Parse(lparser, MINUS, 0);
}
                   
action times_tok {
   Parse(lparser, TIMES, 0);
}

action divide_tok {
   Node *n=malloc(sizeof(Node));
   n->type=DIVIDE;
   Parse(lparser, DIVIDE, n);
}

action openp_tok {
   Parse(lparser, OPENP, 0);
}

action closep_tok {
   Parse(lparser, CLOSEP, 0);
}

action EOF{
  Parse(lparser,0,0);
  ParseFree(lparser, free );
}

action number_tok{ 
   Node *n=malloc(sizeof(Node));
   n->name=malloc(te-ts+1);
   n->type=DOUBLE;
   strncpy(n->name,ts,te-ts);
   n->name[te-ts]='\0';
   Parse(lparser, DOUBLE, n);
}

action equa_tok{
   Parse(lparser, EQUA,0);
}

number = [0-9]+('.'[0-9]+)?;
plus = '+';
minus = '-';
openp = '(';
closep = ')';
times = '*';
divide = '/';
equal = '=';
semi = ';';
ident = [A-Za-z_]+;
main := |*
  number => number_tok;
  plus => plus_tok;
  minus => minus_tok;
  openp => openp_tok;
  closep => closep_tok;
  times => times_tok;
  divide => divide_tok;
  semi => semi_tok;
  equal => equa_tok;
  ident => ident_tok;
  space;
*|;

}%%

%% write data;
static const char *ts;
static char *data=0;
static inline int lpos(void){
  return ts-data;
}
void syntax_error(void){
  fprintf(stderr,"syntax error...\n%s",data);
  int i;
  for (i=0;i<lpos();i++) fprintf(stderr," ");
  fprintf(stderr,"^~\n");
}
void main(int argc ,char *argv[]){
    int cs;
    int act;
    const char* te,*p;
    int len;
    lparser=ParseAlloc(malloc);
    if (getopt(argc,argv,"d")!=-1)
      ParseTrace(stderr,"[dbg]:");
%% write init;
    do{
      len=getline(&data,&len,stdin);
      const char *pe,*eof=0;
      if (len >0 ){
        p=data;
        pe = data + len;
      }else{
	eof=pe;
      }
%% write exec;
   }while(len>0);
      Parse(lparser,0,0);
      ParseFree(lparser, free );
}
