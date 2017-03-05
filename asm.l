%{
  #include <stdio.h>
  #include <stdlib.h>
  #include "y.tab.h"
  void yyerror(char *);
%}

%%
[0-9]+(\.[0-9]+)?([eE][0-9]+)? {yylval.f = atof(yytext); return NUM;}
[-+*()\n/=\\]  {return yytext[0];}
[ \t\f\v] ;
. yyerror("Unknown character");

%%

int yywrap(void){
  return 1;
}
