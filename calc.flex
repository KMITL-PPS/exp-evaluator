D			[0-9]
L			[a-zA-Z_]
H			[a-fA-F0-9]

%option noyywrap
%{
#include <stdio.h>
#include <string.h>

enum {DECIMAL=300, HEXADECIMAL, REGISTER, ACCUMULATOR, TOP, SIZE};
enum {AND=400, OR, NOT, NEGATIVE};
enum {PUSH=500, POP, SHOW, LOAD};

void comment(void);
%}

%%
"/*"					{ comment(); }

"#"[^\n]*				{ /* ignore C preprocessor */ }
"//"[^\n]*              { /* ignore single-line comment */ }

"AND"                   { return AND; }
"OR"                    { return OR; }
"NOT"                   { return NOT; }

"PUSH"                  { return PUSH; }
"POP"                   { return POP; }
"SHOW"                  { return SHOW; }
"LOAD"                  { return LOAD; }

{D}+                    { yylval = atoi(yytext); return DECIMAL; }
{D}{1,4}"h"             { yylval = hexToDec(yytext); return HEXADECIMAL; }

[ \t\v\f]				{ /* ignore whitespace */ }

[\n]                    { yylineno++; }

.						{ /* ignore bad characters */ }

%%

void comment(void)
{
	char c, prev = 0;
  
	while ((c = input()) != 0)      /* (EOF maps to 0) */
	{
		if (c == '/' && prev == '*')
			return;
		prev = c;
	}
}

int main(int argc, char **argv)
{
	while(yylex()) {
        printf("%s\n", yytext);
    }

	return 0;
}