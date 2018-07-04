/* Definition section */
%{
	#include <stdio.h>
	#include <stdlib.h>
	#include <string.h>

        #define T_CPPCOMMENT 300
	#define T_COMMENT 301
	#define T_PRINTLN 302
	#define T_PRINT 303
        #define T_FOR 304
        #define T_IF 305
        #define T_ELSE 306
        #define T_VAR 307
        #define T_INT 308
        #define T_FLOAT 309
        #define T_ADD 310
        #define T_SUB 311
        #define T_ASSIGN 312
        #define T_ID 313
        #define T_NUMBER 314
        #define T_WS 315
        #define T_INC 316
        #define T_DEC 317
        #define T_CHANGELINE 318
        #define T_MUL 319
        #define T_DIV 320
        #define T_MOD 321
        #define T_LESS 322
        #define T_GREAT 323
        #define T_LESSEQUAL 324
        #define T_GREATEQUAL 325
        #define T_EQUAL 326
        #define T_NOTEQUAL 327
        #define T_ADDASSIGN 328
        #define T_SUBASSIGN 329
        #define T_MULASSIGN 330
        #define T_MODASSIGN 331
        #define T_DIVASSIGN 332
        #define T_AND 333
        #define T_OR 334
        #define T_NOT 335
        #define T_LB 336
        #define T_RB 337
        #define T_LCB 338
        #define T_RCB 339
        #define T_QUA 340
	#define T_FLOATNUMBER 341


	#define TableSize 300


	int IsString = 0;
	int lineCount = 0;
	int CommentLine = 0;
	int currentIndex = 0;
	int IsVar = 0;
	int keytype = 2;
	int IsFirst = 0;
	int IsThesameLine = 0;
	char inputID[100];
	const char * keyword[] = {
		"int",
		"float32"
		""
	};
	typedef struct Symbol {
		int index;
		int type;
		char name[100];
		struct Symbol *next;		
	} symBol;

	typedef struct hashTable {
		struct Symbol *head;
	} Node;
	Node table[TableSize];


	int entryNumber(char* key);
        symBol* create_symbol(char* id,int type);
        void insert_symbol(char* id,int type);
        int lookup_symbol(char* id);
        void dump_symbol();
%}

/* Define regular expression label */

letter [a-zA-Z]
digit [0-9]
id {letter}+({letter}|{digit})*
number {digit}+
ws [ \t]+
float {digit}+.{digit}+


/* Rules section */
%%


"//"("/"|"*"|[digit]|{id}|{number}|[ \t]|"("|")"|"+"|"-"|"["|"]"|"{"|"}"|","|";"|">"|"<"|"="|"?"|'.')* {
	CommentLine++;
	IsThesameLine++;
	printf("%s \t  C++ Comment \n",yytext);
	return T_CPPCOMMENT;
	}
"/*"([^*]|[*]+[^*/])*[*]*"*/" {
	CommentLine++;
	IsThesameLine++;
	for(int i = 0; i<yyleng ; i++) {
		if((yytext[i]) == '\n') {
			lineCount++;
			CommentLine++;
		}
	}
	printf("%s \t  C Comment \n",yytext);
	return T_COMMENT;
	}

"println" { printf("%s \t Println Function \n", yytext);return T_PRINTLN; }
"print" { printf("%s \t Print Function \n", yytext);return T_PRINT; }
"for"	{ printf("%s \t For Function \n", yytext);return T_FOR; }
"if"	{ printf("%s \t If Statement \n", yytext);return T_IF; }
"else"	{ printf("%s \t Else Statement \n", yytext);return T_ELSE; }
"var"	{ return T_VAR; }
"int"	{ return T_INT; }
"float32"	{ return T_FLOAT; }



"+" 	{ printf("%s \t Add \n", yytext);return T_ADD; }
"-"	{ printf("%s \t Sub \n", yytext);return T_SUB; }
"="	{ printf("%s \t Assign \n", yytext);return T_ASSIGN; }
{id}	{return T_ID;}
{number} { return T_NUMBER; }
{float} { printf("%s \t FloatNumber \n", yytext);return T_FLOATNUMBER; }
\n	{ 
		lineCount++;
		if(IsThesameLine != 0)
			CommentLine = CommentLine - IsThesameLine + 1;
		IsThesameLine = 0;
		return T_CHANGELINE; 
	}
{ws}	{ return T_WS; }
"++"	{ printf("%s \t Increment \n", yytext);return T_INC; }
"--"	{ printf("%s \t Decrement \n", yytext);return T_DEC; }
"*"	{ printf("%s \t Mul \n", yytext);return T_MUL; }
"/"	{ printf("%s \t Div \n", yytext);return T_DIV; }
"%"	{ printf("%s \t Mod \n", yytext);return T_MOD; }
"<"	{ printf("%s \t Less than \n", yytext);return T_LESS; }
">"	{ printf("%s \t Greater than \n", yytext);return T_GREAT; }
"<="	{ printf("%s \t Less than or Equal to \n", yytext);return T_LESSEQUAL; }
">="	{ printf("%s \t Greater than or Equal to \n", yytext);return T_GREATEQUAL; }
"=="	{ printf("%s \t Equal to \n", yytext);return T_EQUAL; }
"!="	{ printf("%s \t Not Equal to \n", yytext);return T_NOTEQUAL; }
"+="	{ printf("%s \t Addition Assignment \n", yytext);return T_ADDASSIGN; }
"-="	{ printf("%s \t Subtraction Assignment \n", yytext);return T_SUBASSIGN; }
"*="	{ printf("%s \t Mul Assignment \n", yytext);return T_MULASSIGN; }
"/="	{ printf("%s \t Div Assignment \n", yytext);return T_DIVASSIGN; }
"%="	{ printf("%s \t Mod Assignment \n", yytext);return T_MODASSIGN; }
"&&"	{ printf("%s \t And \n", yytext);return T_AND; }
"||"	{ printf("%s \t Or \n", yytext);return T_OR; }
"!"	{ printf("%s \t Not \n", yytext);return T_NOT; }
"("	{ printf("%s \t LB \n", yytext);return T_LB; }
")"	{ printf("%s \t RB \n", yytext);return T_RB; }
"{"	{ printf("%s \t LCB \n", yytext);return T_LCB; }
"}"	{ printf("%s \t RCB \n", yytext);return T_RCB; }
\"	{
		IsString = (IsString+1)%2;
		if(IsString == 0) {
			printf("\t String \n");
		}
		printf("%s \t Quotation \n", yytext);
		return T_QUA;
	}



%%

/*	C Code section */
int yywrap(void)
{
    return 1;
}

int entryNumber(char* key) {
	int entry = 0;
	int i = 0;
	while(key[i]!='\0') {
		entry = ( ( entry<<4 ) + key[i]) % TableSize;
		i++;
	}
	return entry;
}

symBol* create_symbol(char* id,int type) {
	if(IsFirst == 0) {
		memset(table,0,sizeof(table));
		printf("Create a symbol table with TableSize %d\n",TableSize);
		IsFirst = 1;
	}
	symBol *current = (symBol *)malloc(sizeof(symBol));
	strcpy(current->name,id);
	current->type = type;
	current->next = NULL;
	return current;
}
void insert_symbol(char* id,int type) {
	symBol* current = create_symbol(id,type);

	currentIndex = entryNumber(id);

	if(lookup_symbol(id)!=-1) {
		printf("********** Redefined variables : %s {line} : %d **********\n",id,lineCount+1);
		free(current);
		return;
	}

	printf("Insert a symbol : %s\n",id);

	symBol* last;
	if(table[currentIndex].head==NULL) {
		current->index = currentIndex;
		table[current->index].head = current;
		//currentIndex = (currentIndex + 1)%TableSize;
		return;
	}
	else {
		for(last=table[currentIndex].head;last->next!=NULL;last=last->next) {
		}
		last->next = current;
		current->index = currentIndex;
		//currentIndex = (currentIndex + 1)%TableSize;
	}
	return;
}
int lookup_symbol(char* id) {
	symBol *current;
	int tableindex = entryNumber(id);
	for(current = table[tableindex].head;current!=NULL;current=current->next) {
		if(strcmp(current->name,id)==0) {
			return current->index;
		}
	}
	return -1;
}
void dump_symbol() {
	symBol *current;
	printf("\nThe Symbol Table Dump:\n");
	printf("Index	ID	Type\n");
	for(int i = 0;i<TableSize;i++) {
		for(current = table[i].head ; current!=NULL ; current=current->next) {
			printf("%2d	%s	%s\n",current->index,current->name,keyword[current->type]);
		}
	}
	return;
}


int main(int argc,char *argv[])
{
	int i;
	yyin = fopen(argv[1],"r");
	memset(inputID,0,sizeof(inputID));
	do {
		i = yylex();
		switch(i) {
			case T_VAR:
				IsVar = 1;
				break;
			case T_NUMBER:
				if(IsString == 0) {
					printf("%s \t Number \n", yytext);
				}
				else
					printf("%s",yytext);
				break;
			case T_ID:
				if(IsVar == 1) {
					strcpy(inputID,yytext);
				}
                		else if(IsString == 0) {
                        		printf("%s \t ID \n", yytext);
					int tableindex = lookup_symbol(yytext);
					if(tableindex == -1) {
						printf("********** Undeclared variables : %s   {line} : %d **********\n",yytext,lineCount+1);
					}
				}
        		        else
		                        printf("%s ",yytext);

				break;
			case T_WS:
				if(IsString == 0){}
				else
					printf("%s",yytext);
				break;
			case T_INT:
				if(IsVar == 1) {
					keytype = 0;
					IsVar = 0;
					printf("%s \t int TYPE VAR\n",inputID);
					insert_symbol(inputID,keytype);
					keytype = 2;
				}
				break;
			case T_FLOAT:
                                if(IsVar == 1) {
                                        keytype = 1;
                                        IsVar = 0;
                                        printf("%s \t float TYPE VAR\n",inputID);
                                        insert_symbol(inputID,keytype);
                                        keytype = 2;
                                }
				break;
			default:
				break;
		}
	} while(i!=0);
	printf("\nParse over, the line number is %d.\n",lineCount);
	printf("\nComment %d lines\n",CommentLine);
	dump_symbol();
	return 0;
}
