CC = gcc

calc:
	bison -d calc.y
	flex calc.flex
	$(CC) lex.yy.c -o calc

clean:
	rm calc.tab.c calc.tab.h lex.yy.c