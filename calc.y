%{
#include <stdio.h>
#include <math.h>

int yyerror(char *s);
int yylex(void);
%}

// %union {
//   int ival;
// }

%start  input

// %token  <ival>  CONSTANT
// %type   <ival>  exp
%token  CONSTANT REGISTER ACCUMULATOR PUSH POP TOP SIZE SHOW LOAD

%left   AND OR NOT
%left   '+' '-'
%left   '*' '/' '\\'
%precedence   NEG

%%

input:		/* empty */
		| exp	{ cout << "Result: " << $1 << endl; }
		;

exp:
  CONSTANT           { $$ = $1;           }
| exp '+' exp        { $$ = $1 + $3;      }
| exp '-' exp        { $$ = $1 - $3;      }
| exp '*' exp        { $$ = $1 * $3;      }
| exp '/' exp        { $$ = $1 / $3;      }
| '-' exp  %prec NEG { $$ = -$2;          }
| '(' exp ')'        { $$ = $2;           }
;

%%

int yyerror(string s)
{
  extern int yylineno;	// defined and maintained in lex.c
  extern char *yytext;	// defined and maintained in lex.c
  
  cerr << "ERROR: " << s << " at symbol \"" << yytext;
  cerr << "\" on line " << yylineno << endl;
  exit(1);
}

int yyerror(char *s)
{
  return yyerror(string(s));
}

