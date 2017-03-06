%{
  #include <stdio.h>
  #include <stdlib.h>
  #include <string.h>
  #include "y.tab.h"
  void yyerror(char *);
  int htoi(char *);
  int Ohtoi(char c);
%}

%%

"$r"[A-Z]                           { yylval.c = yytext[2]-'A';  return VAR;}
[0-9A-Fa-f]+[Hh]                    {yylval.i = htoi(yytext); return NUM;}
[0-9]+                              {yylval.i = atoi(yytext); return NUM;}
[-+*()\n/=\\]                       {return *yytext;}
"AND"                               {return AND;}
"OR"                                {return OR;}
"NOT"                               {return NOT;}
"^"                                 {return XOR;}
"PUSH"                              {return PUSH;}
"POP"                               {return POP;}
"SHOW"                              {return SHOW;}
"LOAD"                              {return LOAD;}
"$top"                              {return TOP;}
"$size"                             {return SIZE;}
"$acc"                              {return ACC;}
[ \t\f\v] ; //Ignore
. yyerror("Unknown character");

%%

int Ohtoi(char c){
	int r;
	if(c>='0' && c<='9'){
		r = c - '0';
	}
	else if(c>='A' && c<='F'){
		r = c - 'A' + 10;
	}
	else if(c>='a' && c<='f'){
		r = c - 'a' + 10;
	}
	return r;
}	

int htoi(char *s){
	int i;
	int result = Ohtoi(s[0]);
	for(i=1; i<strlen(s)-1; i++){
		result *= 16;
		result += Ohtoi(s[i]);
	}
	return result;
}


int yywrap(void){
  return 1;
}
