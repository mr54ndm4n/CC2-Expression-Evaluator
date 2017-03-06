%{
  #include <stdio.h>
  #include <stdlib.h>
  #include "y.tab.h"
  void yyerror(char *);
%}

%%
"$r"[A-Z]                           { yylval.c = yytext[2]-'A';  return VAR;}
[0-9]+(\.[0-9]+)?([eE][0-9]+)?      {yylval.i = atoi(yytext); return NUM;}
[-+*()\n/=\\]                       {return *yytext;}
"AND"                               {return AND;}
"OR"                                {return OR;}
"NOT"                               {return NOT;}
"$acc"                              {return ACC;}
[ \t\f\v] ; //Ignore
. yyerror("Unknown character");

%%

int yywrap(void){
  return 1;
}
