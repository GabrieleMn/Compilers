/**************************
 Scanner
***************************/

import java_cup.runtime.*;

%%

%unicode
%cup
%line
%column

%{
	private Symbol sym(int type) {
		return new Symbol(type, yyline, yycolumn);
	}

	private Symbol sym(int type, Object value) {
		return new Symbol(type, yyline, yycolumn, value);
	}

  private void p(){
    //System.out.println(yytext());
  }

%}

//TOKEN1
token1 = ("?"{binary} | "?"{word})";"
binary = ([01]*1[01]*){2} | ([01]*1[01]*){4}
word = [xy]*x? | [yx]*y?

//TOKEN2
token2 = {date}{hour}?";"
date =   2017"/"01"/"(1[89] | 2[0-9] | 3[01]) |
         2017"/"02"/"(0[0-9] | [12][89] | 2[0-8] ) |
         2017"/"0[35]"/"(0[0-9] | [12][89] | 2[0-9] | 3[01] ) |
         2017"/"0[46]"/"(0[0-9] | [12][89] | 2[0-9] | 30 ) |
         2017"/"07"/"(0[0-2])
hour = ":"01":"(1[2-9] | [345][0-9] ) |
        ":"0[23456789]":"(0[0-9]| [12345][0-9]) |
        ":"10":"(0[0-9]| [12345][0-9]) |
        ":"11":"(0[0-9]| [12][0-9] | 3[0-7])

//TOKEN3
token3 = ({word_t3}("/" | "$" | "+")){5}{word_t3}((("/" | "$" | "+"){word_t3}){2})*";"
word_t3 = 1[5-9] | [23456789][13579] | [1-9][0-9][13579] | 1[0-4][0-9][13579] | 15[0-6][13579] | 157[13]

//PARSER
comment = "/*" ~ "*/"
sep = "###"(\#)*
signed_int = [0-9]+
id = [_a-zA-Z][_a-zA-Z0-9]*

%%


{token1}        {p(); return new Symbol(sym.TOKEN1);}
{token2}        {p(); return new Symbol(sym.TOKEN2);}
{token3}        {p(); return new Symbol(sym.TOKEN3);}

{sep}           {p(); return new Symbol(sym.SEP);}
{signed_int}    {p(); return new Symbol(sym.INTEGER,new Integer(yytext()));}

"CONFIGURE"     {p(); return new Symbol(sym.CONFIGURE);}
"TEMPERATURE"   {p(); return new Symbol(sym.TEMPERATURE);}
"HUMIDITY"      {p(); return new Symbol(sym.HUMIDTY);}
"STORE"         {p(); return new Symbol(sym.STORE);}
"avg" | "AVG"   {p(); return new Symbol(sym.AVG);}
"CASE"          {p(); return new Symbol(sym.CASE);}
"IS"            {p(); return new Symbol(sym.IS);}
"IN"            {p(); return new Symbol(sym.IN);}
"RANGE"         {p(); return new Symbol(sym.RANGE);}
"EQUAL"         {p(); return new Symbol(sym.EQUAL);}

";"             {p(); return new Symbol(sym.SC);}
"="             {p(); return new Symbol(sym.EQ);}
"+"             {p(); return new Symbol(sym.PLUS);}
"*"             {p(); return new Symbol(sym.MUL);}
"/"             {p(); return new Symbol(sym.DIV);}
"-"             {p(); return new Symbol(sym.MINUS);}
"("             {p(); return new Symbol(sym.RO);}
")"             {p(); return new Symbol(sym.RC);}
"^"             {p(); return new Symbol(sym.POW);}
","             {p(); return new Symbol(sym.CM);}
"{"             {p(); return new Symbol(sym.BO);}
"}"             {p(); return new Symbol(sym.BC);}

{id}            {p(); return new Symbol(sym.ID,yytext());}

{comment}     {;}
\r | \n | \r\n | " " | \t	{;}

.				{ System.out.println("Scanner Error: " + yytext()); }
