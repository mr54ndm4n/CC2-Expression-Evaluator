%{
  #include <stdio.h>
  #include <stdlib.h>

  extern int yylex();
  void yyerror(char *msg);
  void lexerror(int code);
  float acc = 0;
  int var[26];
  int size;

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
      size += 1;
      return head;
  }

  struct node* pop(struct node *head,int *element)
  {
      if(head == NULL){
        lexerror(1);
        return NULL;
      }
      struct node* tmp = head;
      *element = head->data;
      head = head->next;
      free(tmp);
      size -= 1;
      return head;
  }

  struct node* reg = NULL;

%}
%union {
    int i;
    char c;
}
%token <i> AND OR NOT XOR
%token <i> NUM ACC PUSH POP SHOW LOAD TOP SIZE
%token <i> UNKNOWN
%token <c> VAR
%type <i> E T F R

%%
program:
  program S '\n'
  | /* NULL */
  ;

S : E                {acc = $1; printf("= %d\n> ", $1);}
  | VAR '=' E        {acc = $3; var[$1] = $3; printf("=  %d\n> ", $3);}
  | PUSH R           {reg = push(reg, $2); printf("> ");}
  | POP R            {reg = pop(reg, &var[$2]); printf("> ");}
  | SHOW R           {printf("= %d\n> ", $2);}
  | LOAD R VAR       {var[$3] = $2; printf("> ");}
  | LOAD R TOP       {lexerror(1); printf("> ");}
  | LOAD R SIZE      {lexerror(1); printf("> ");}
  | UNKNOWN          {lexerror(1); printf("> ");}
  ;

E : E '+' T          {$$ = $1 + $3;}
  | E '-' T          {$$ = $1 - $3;}
  | T                {$$ = $1;}
  ;

T : T '*' F          {$$ = $1 * $3;}
  | T '/' F          {$$ = $1 / $3;}
  | T '\\' F         {$$ = $1 % $3;}
  | T AND F          {$$ = $1 & $3;}
  | T OR F           {$$ = $1 | $3;}
  | NOT F            {$$ = ~ $2;}
  | T XOR F          {$$ = $1 ^ $3;}
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
  | SIZE             {$$ = size;}
%%

void yyerror(char *msg) {
  fprintf(stderr, "%s\n", msg);
}
int main(void) {
 init(reg);
 size = 0;
 printf("> ");
 yyparse();
}

void lexerror(int code){
  switch(code){
    case 1:
      printf("!ERROR \n");
      break;
    default:
      printf("!ERROR \n");
      break;
  }
  return;
}
