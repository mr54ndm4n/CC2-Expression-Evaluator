%{
  #include <stdio.h>
  #include <stdlib.h>
  #include <string.h>
  #include "y.tab.h"
  void yyerror(char *);
  int htoi(char *);   /* change base 16 to base 10 number */
  int Ohtoi(char c);  /* change base 16 to base 10 number (1 character) */
%}

%%

"$r"[A-Z]                           { yylval.c = yytext[2]-'A';  return VAR;}   /* Variable Token ($rA-$rZ) */
[0-9]+                              {yylval.i = atoi(yytext); return NUM;}      /* number Token (0-infinity)*/
[0-9A-Fa-f]+[Hh]                    {yylval.i = htoi(yytext); return NUM;}      /* base 16 number Token (15AH) */
[-+*()\n/=\\]                       {return *yytext;}                           /* operation Token */
("AND"|"&")                         {return AND;}                               /* Bitwise AND Token */
("OR"|"|")                          {return OR;}                                /* Bitwise OR  Token */
("NOT"|"!"|"~")                     {return NOT;}                               /* Bitwise NOT Token */
("XOR"|"^")                         {return XOR;}                               /* Bitwise XOR Token */
"PUSH"                              {return PUSH;}                              /* PUSH Token */
"POP"                               {return POP;}                               /* POP Token */
"SHOW"                              {return SHOW;}                              /* SHOW Token */
"LOAD"                              {return LOAD;}                              /* LOAD Token */
"$top"                              {return TOP;}                               /* $top Token */
"$size"                             {return SIZE;}                              /* $size Token */
"$acc"                              {return ACC;}                               /* $acc Token */
[ \t\f\v] ; //Ignore
.                                   {return UNKNOWN;}                           /* out of gramma character Token */

%%

int Ohtoi(char c){  /* change base 16 to base 10 number (1 character) */
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

int htoi(char *s){  /* change base 16 to base 10 number */
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
