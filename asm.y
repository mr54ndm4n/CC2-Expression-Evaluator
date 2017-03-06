%{
  #include <stdio.h>
  #include <stdlib.h>

  extern int yylex();
  void yyerror(char *msg);
  float acc = 0;
  int var[26];

  struct node
  {
      int data;
      struct node* next;
  };

  void init(struct node* head)
  {
      head = NULL;
  }

  struct node* push(struct node* head,int data)
  {
      struct node* tmp = (struct node*)malloc(sizeof(struct node));
      if(tmp == NULL)
      {
          exit(0);
      }
      tmp->data = data;
      tmp->next = head;
      head = tmp;
      return head;
  }

  struct node* pop(struct node *head,int *element)
  {
      struct node* tmp = head;
      *element = head->data;
      head = head->next;
      free(tmp);
      return head;
  }

  struct node* reg = NULL;

%}
%union {
    int i;
    char c;
}

%token <i> NUM AND OR NOT ACC PUSH POP SHOW LOAD TOP
%token <c> VAR
%type <i> E T F R

%%
program:
  program S '\n'
  | /* NULL */
  ;

S : E                {acc = $1; printf("= %d\n> ", $1);}
  | VAR '=' E        {acc = $3; var[$1] = $3; printf("=  %d\n> ", $3);}
  | PUSH R           {printf("PUSH %d\n> ", $2); reg = push(reg, $2);}
  | POP R            {printf("POP %d\n> ", var[$2]); reg = pop(reg, &var[$2]);}
  | SHOW R           {printf("SHOW %d\n> ", $2);}
  | LOAD R R         {printf("LOAD");}
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
  | R                {$$ = $1;}
  ;

R : ACC              {$$ = acc;}
  | VAR              {$$ = var[$1];}
  | TOP              {$$ = reg->data;}
%%

void yyerror(char *msg) {
  fprintf(stderr, "%s\n", msg);
}
int main(void) {
 init(reg);
 printf("> ");
 yyparse();
}
