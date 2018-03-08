D			[0-9]
L			[A-Z]
H			[a-fA-F0-9]

%option noyywrap
%{
#include <stdio.h>
#include <string.h>
#include "calc.tab.h"

int hexToDec(char *);
%}

%%

("AND"|"and")                   { return AND; }
("OR"|"or")                    { return OR; }
("NOT"|"not")                   { return NOT; }
"+"                     { return '+'; }
"-"                     { return '-'; }
"*"                     { return '*'; }
"/"                     { return '/'; }
"\\"                    { return '\\'; }
"^"                     { return '^'; }
"("                     { return '('; }
")"                     { return ')'; }

("PUSH"|"push")             { return PUSH; }
("POP"|"pop")               { return POP; }
("SHOW"|"show")             { return SHOW; }
("LOAD"|"load")             { return LOAD; }

{H}{1,4}"h"             { yylval = hexToDec(yytext); return CONSTANT; }
{D}+                    { yylval = atoi(yytext); return CONSTANT; }

"$r"{L}              	{ yylval = yytext[2] - 'A'; return REG; }
"$acc"                  { yylval = 26; return REG; }
"$top"                  { yylval = 27; return REG; }
"$size"                 { yylval = 28; return REG; }

[ \t\v\f]				{ /* ignore whitespace */ }

\n                      { yylineno++; return '\n'; }

.						{ return yytext[0]; }

%%

int hexToDec(char *s)
{
	int i = 0, value = 0;
	for (i = 0; s[i] != 'h'; i++)
	{
		value *= 16;
		if (s[i] >= '0' && s[i] <= '9')
		{
			value += s[i] - '0';
		}
		else
		{
			if (s[i] >= 65 && s[i] <= 90)
				s[i] = s[i] + 32;
			value += s[i] - 'A' + 10;
		}
	}

	return value;
}