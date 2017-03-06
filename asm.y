%{
  #include <stdio.h>
  #include <stdlib.h>

  extern int yylex();
  void yyerror(char *msg);
  float acc = 0;
  int var[26];
%}
%union {
    int i;
    char c;
}

%token <i> NUM AND OR NOT ACC
%token <c> VAR
%type <i> E T F

%%
program:
  program S '\n'
  | /* NULL */
  ;

S : E                {acc = $1; printf("= %d\n> ", $1);}
  | VAR '=' E        {acc = $3; var[$1] = $3; printf("=  %d\n> ", $3);}
  ;

E : E '+' T          {$$ = $1 + $3;}
  | E '-' T          {$$ = $1 - $3;}
  | T                {$$ = $1;}
  | E AND T          {$$ = $1 & $3;}
  | E OR T           {$$ = $1 | $3;}
  | NOT T            {$$ = ~ $2;}
  ;

T : T '*' F          {$$ = $1 * $3;}
  | T '/' F          {$$ = $1 / $3;}
  | T '\\' F         {$$ = $1 % $3;}
  | F                {$$ = $1;}
  ;

F : '(' E ')'        {$$ = $2;}
  | '-' F            {$$ = -$2;}
  | NUM              {$$ = $1;}
  | ACC              {$$ = acc;}
  | VAR              {$$ = var[$1];}
  ;

%%

void yyerror(char *msg) {
  fprintf(stderr, "%s\n", msg);
}
int main(void) {
 printf("> ");
 yyparse();
}
