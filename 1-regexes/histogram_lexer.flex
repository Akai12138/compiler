%option noyywrap

%{
/* Now in a section of C that will be embedded
   into the auto-generated code. Flex will not
   try to interpret code surrounded by %{ ... %} */

/* Bring in our declarations for token types and
   the yylval variable. */
#include "histogram.hpp"


// This is to work around an irritating bug in Flex
// https://stackoverflow.com/questions/46213840/get-rid-of-warning-implicit-declaration-of-function-fileno-in-flex
extern "C" int fileno(FILE *stream);

/* End the embedded code section. */
%}



%%

(-?[0-9]+)\/(-?[0-9]+) {   fprintf(stderr, "Number : %s\n", yytext);//stderr generate file
                           char *numerator = strtok(yytext,"/");//strtok() split  
                           char *denominator = strtok(NULL,"/");
                           yylval.numberValue = std::atof(numerator)/std::atof(denominator);//std::atof
                           return Number;
}
                               
-?[0-9]+\.?[0-9]* {  fprintf(stderr, "Number : %s\n", yytext);
                     yylval.numberValue = strtod(yytext, NULL);
                     return Number; 
                  }
                                 

[a-zA-Z]*         {  fprintf(stderr, "Word : %s\n", yytext);
                     yylval.wordValue = new std::string(yytext);
                     return Word;
                  }

\[[^\]]*\]        {  fprintf(stderr, "Word : %s\n", yytext);
                     yylval.wordValue = new std::string(yytext);
                     return Word;
                  }

[ \t\n]+       
.                 {  fprintf(stderr, "Newline\n");
                  }


%%

/* Error handler. This will get called if none of the rules match. */
void yyerror (char const *s)
{
  fprintf (stderr, "Flex Error: %s\n", s); /* s is the text that wasn't matched */
  exit(1);
}
