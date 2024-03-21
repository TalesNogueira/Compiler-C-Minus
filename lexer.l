%{
/* (LEX) Definition(s) */
#include "globals.h"
#include "util.h"
#include "scan.h"


/* lexeme of identifier or reserved word */
char tokenString[MAXTOKENLEN+1];
static int yylex(void);
%}

/* (LEX) Declaration(s) */

digit       	[0-9]
letter      	[a-zA-Z]
whitespace  	[ \t\r]+

/* (LEX) Translation(s) */
%%

"void"		      return VOID;
"int"           return INT;

"if"            return IF;
"else"          return ELSE;
"while"         return WHILE;
"return"        return RETURN;

"+"             return SUM;
"-"             return SUB;
"*"             return MUL;
"/"             return DIV;

"="             return GET;
">"	            return MORE;
"<"             return LESS;
">="	          return EQUALMORE;
"<="	          return EQUALESS;
"=="            return EQUAL;
"!="            return DIFER;

","             return COMMA;
";"             return SEMICOLON;

"("             return OPARENTHESIS;
")"             return CPARENTHESIS;
"["             return OBRACKETS;
"]"             return CBRACKETS;
"{"             return OKEYS;
"}"             return CKEYS;

"/*"            {
  char c;
  
  while (c != '*' && c != EOF) {
    c = input();

    if (c == '*') {
      while (c == '*') {
        if ((c = input()) == '/') break;
      }
    }

    if (c == '\n') lineno++;
  }
}

"\n"            {lineno++;}

{digit}+        return NUM;
{letter}+ 		  return ID;
{whitespace}    {/* skip whitespace */}

<<EOF>>         return 0;
.               return ERROR;

%%

//-------------------------------------------------------------------------------------------------
/* (LEX) Auxiliary Function(s) */

TokenType getToken(void) {
  static int firstExecution = TRUE;
  TokenType currentToken;
  
  if (firstExecution) {
    firstExecution = FALSE;

    yyin = source;
    
    // yyout = listing;
    lineno++;
  }

  currentToken = yylex();
  
  strncpy(tokenString, yytext, MAXTOKENLEN);

  // if (TraceScan) {
  //   fprintf(listing, "\t%d: ", lineno);
  //   printToken(currentToken,tokenString);
  // }

  if (currentToken == ERROR) {
    printf("Error (Lexical Type) Line %d: %s", (lineno), yytext);
  }
  
  return currentToken;
}