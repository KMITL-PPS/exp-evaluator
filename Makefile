OBJS = calc.y calc.flex main.c

CC = gcc

calc: $(OBJS)
	bison -d calc.y
	flex calc.flex
	$(CC) main.c calc.tab.c lex.yy.c -ll -o calc

clean:
	rm calc.tab.c calc.tab.h lex.yy.c calc