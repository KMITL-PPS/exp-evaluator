%{
#include <stdio.h>
#include <stdlib.h>
#include <math.h>

void yyerror(char *s);
int yylex(void);
void push(int);
void pop(int);
int* getRegister(int);
void load(int, int);	// TODO: return error

typedef struct node {
	int value;
	struct node* back;
} node_t;

int reg[26] = {0}, acc = 0, size = 0;
node_t *top = NULL;
%}

%start  				input

%token  				CONSTANT REG ACCUMULATOR PUSH POP TOP SIZE SHOW LOAD

%left   				AND OR
%left   				'+' '-'
%left   				'*' '/' '\\'
%right					NOT
%precedence				NEG
%right					'^'

%%

input:
  %empty				{ printf("> "); 							}
| input line			{ printf("> "); 							}
;

line:
  '\n'
| exp '\n'  			{ acc = $1; printf("= %d\n", $1); 			}
| regop '\n'
;

exp:
  CONSTANT				{ $$ = $1;           						}
| REG					{ $$ = *getRegister($1);					}
| exp AND exp			{ $$ = $1 & $3;								}
| exp OR exp			{ $$ = $1 | $3;								}
| exp '+' exp			{ $$ = $1 + $3;     						}
| exp '-' exp			{ $$ = $1 - $3;      						}
| exp '*' exp			{ $$ = $1 * $3;      						}
| exp '/' exp			{ $$ = $1 / $3;      						}
| exp '\\' exp			{ $$ = $1 % $3;								}
| NOT exp				{ $$ = ~$2;									}
| '-' exp  %prec NEG	{ $$ = -$2;          						}
| exp '^' exp			{ $$ = pow($1, $3);     					}
| '(' exp ')'			{ $$ = $2;           						}
;

regop:
  SHOW REG				{ printf("= %d\n", *getRegister($2));		}
| LOAD REG REG			{ load($2, $3);								}
| PUSH REG				{ push($2);									}
| POP REG				{ pop($2);									}
;

%%

void yyerror(char *s)
{
	printf("! ERROR: %s\n", s);
}

void push(int i)
{
	node_t *tmp = (node_t *) malloc(sizeof(node_t));
	tmp->value = *getRegister(i);
	tmp->back = top;
	top = tmp;
	size++;
}

void pop(int i)
{
	if (i >= 0 && i <= 25)
	{
		if (size > 0)
		{
			node_t *tmp = top;
			*getRegister(i) = tmp->value;
			top = tmp->back;
			free(tmp);
			size--;
		}
		else
		{
			// TODO: show error
		}
	}
	else
	{
		// TODO: show error
	}
}

int* getRegister(int i)
{
	if (i >= 0 && i <= 25)
	{
		return &reg[i];
	}
	else if (i == 26)
	{
		return &acc;
	}
	else if (i == 27)
	{
		if (size > 0)
		{
			return &(top->value);
		}
		else
		{
			// TODO: show error
			int tmp = 0;
			return &tmp;
		}
	}
	else if (i == 28)
	{
		return &size;
	}
	else	// ERROR
	{
		return 0;
	}
}

void load(int src, int dest)
{
	if (dest >= 0 && dest <= 25)
	{
		*getRegister(dest) = *getRegister(src);
	}
	else
	{
		// TODO: return error
	}
}