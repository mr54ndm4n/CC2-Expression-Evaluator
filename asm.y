%{
  #include <stdio.h>
  #include <stdlib.h>

  extern int yylex();
  void yyerror(char *msg);
  void lexerror(int code); /* return "!ERROR" function */
  float acc = 0;
  int var[26];
  int size;

  struct node   /* structure of stack */
  {
      int data;
      struct node* next;
  };

  void init(struct node* head)  /*create a stack*/
  {
      head = NULL;
  }

  struct node* push(struct node* head,int data) /* push data to stack */
  {
      struct node* tmp = (struct node*)malloc(sizeof(struct node));
      if(tmp == NULL) /*if create node fail */
      {
          exit(0);
      }
      tmp->data = data;
      tmp->next = head;
      head = tmp;
      size += 1;
      return head;
  }

  struct node* pop(struct node *head,int *element) /* pop stack */
  {
      if(head == NULL){ /* if stack is Empty */
        lexerror(1);  /* Return "!Error" */
        return NULL;
      }
      struct node* tmp = head;
      *element = head->data;
      head = head->next;
      free(tmp);
      size -= 1;
      return head;
  }

  struct node* reg = NULL; /* create frist node */

%}
%union {
    int i;
    char c;
}
%token <i> AND OR NOT XOR  /* Operation Token */
%token <i> NUM ACC PUSH POP SHOW LOAD TOP SIZE /* Options Token */
%token <i> UNKNOWN /* Error Token */
%token <c> VAR  /* Variable token */
%type <i> E T F R /* Gramma */

%%
program:
  program S '\n' /* Start gramma */
  | /* NULL */
  ;

S : E                {acc = $1; printf("= %d\n> ", $1);}
  | VAR '=' E        {acc = $3; var[$1] = $3; printf("=  %d\n> ", $3);} /* Example : $rA = 1, Variable $rA is 1 */
  | PUSH R           {reg = push(reg, $2); printf("> ");}               /* Example : PUSH $rA push value of $rA to stack*/
  | POP TOP          {lexerror(1); printf("> ");}                       /* "!Error" when pop to $top */
  | POP ACC          {lexerror(1); printf("> ");}                       /* "!Error" when pop to $acc */
  | POP SIZE         {lexerror(1); printf("> ");}                       /* "!Error" when pop to $size*/
  | POP R            {reg = pop(reg, &var[$2]); printf("> ");}          /* Example : POP $rA pop value in top of stack to $rA*/
  | SHOW R           {printf("= %d\n> ", $2);}                          /* Example : SHOW $rA show value of $rA */
  | LOAD R TOP       {lexerror(1); printf("> ");}                       /* "!Error" when load to $top */
  | LOAD R ACC       {lexerror(1); printf("> ");}                       /* "!Error" when load to $top */
  | LOAD R SIZE      {lexerror(1); printf("> ");}                       /* "!Error" when load to $top */
  | LOAD R VAR       {var[$3] = $2; printf("> ");}                      /* Exameple : LOAD $acc $rA move value of $acc to $rA*/
  | UNKNOWN          {lexerror(1); printf("> ");}                       /* "!Error" when out of gramma character */
  ;

E : E '+' T          {$$ = $1 + $3;}                                    /* '+' Operation*/
  | E '-' T          {$$ = $1 - $3;}                                    /* '-' Operation*/
  | T                {$$ = $1;}                                         /* to more piority operation*/
  ;

T : T '*' F          {$$ = $1 * $3;}                                    /* '*' Operation*/
  | T '/' F          {$$ = $1 / $3;}                                    /* '/' Operation*/
  | T '\\' F         {$$ = $1 % $3;}                                    /* modulus Operation*/
  | T AND F          {$$ = $1 & $3;}                                    /* Bitwise AND Operation*/
  | T OR F           {$$ = $1 | $3;}                                    /* Bitwise OR  Operation*/
  | NOT F            {$$ = ~ $2;}                                       /* Bitwise NOT Operation*/
  | T XOR F          {$$ = $1 ^ $3;}                                    /* Bitwise XOR Operation*/
  | F                {$$ = $1;}                                         /* to more piority operation*/
  ;

F : '(' E ')'        {$$ = $2;}                                         /* ( ) */
  | '-' F            {$$ = -$2;}                                        /* negative value */
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
