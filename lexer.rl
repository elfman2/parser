#include<stdio.h>
#include<stddef.h>
#include<stdlib.h>
#include "parser.h"
#include <unistd.h>
void *ParseAlloc( void*(*malloc)(size_t) );
void ParseFree(void *pParser, void(*free)(void*) );
void Parse(void *pParser, int tokenCode, void*  token);
void ParseTrace(FILE *stream, char *zPrefix);
void* lparser;
%%{

machine calc;
action ident_tok {
   Parse(lparser,IDENT,0);
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
   Parse(lparser, DIVIDE, 0);
}

action openp_tok {
   Parse(lparser, OPENP, 0);
}

action closep_tok {
   Parse(lparser, CLOSEP, 0);
}

action number_tok{ 
   Parse(lparser, DOUBLE, 0);
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
char *data=0;
int lpos(void){
return ts-data;
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
//    printf("%d\n",len);
    const char *pe,*eof=0;
    if (len <=0 ){
      p=pe=eof;
    }else{
      p=data;
      pe = data + len;
    }
%% write exec;
   }while(len>0);
}
