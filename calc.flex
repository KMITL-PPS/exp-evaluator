D			[0-9]
L			[a-zA-Z_]
H			[a-fA-F0-9]

%option noyywrap
%{
#include <stdio.h>
#include <string.h>
#include "calc.tab.h"

int hexToDec(char *);
%}

%%

"AND"                   { return AND; }
"OR"                    { return OR; }
"NOT"                   { return NOT; }

"PUSH"                  { return PUSH; }
"POP"                   { return POP; }
"SHOW"                  { return SHOW; }
"LOAD"                  { return LOAD; }

{D}+                    { yylval = atoi(yytext); return CONSTANT; }
{H}{1,4}"h"             { yylval = hexToDec(toupper(yytext)); return CONSTANT; }

[ \t\v\f]				{ /* ignore whitespace */ }

[\n]                    { yylineno++; }

.						{ /* ignore bad characters */ }

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
            value += s[i] - 'A' + 10;
        }
    }

    return value;
}