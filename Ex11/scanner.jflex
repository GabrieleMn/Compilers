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
token1 = {number} ( ("$" | "?"){5}(("$" | "?"){2})* | {word1} )";"
word1 = [a-zA-Z]{4} | [a-zA-Z]{6} | [a-zA-Z]{9}
number = "-"(2[024] | 1[02468] | [02468]) | [02468] | [1-9][02468] | [1-9][0-9][02468] | 1[0-9]{2}[0248] | 2[0-3][0-9][02468] | 24[0-6][02468] | 247[02]

//TOKEN2
token2 = {date}{hour}?";"

date =   2015"/"12"/"(0[6-9] | [12][0-9] | 3[01]) |
         2016"/"01"/"(0[1-9] | [12][0-9] | 3[01]) |
         2016"/"02"/"(0[1-9] | 1[0-9] | 2[0-9]) |
         2016"/"03"/"(0[1-9] | [12][0-9] | 3[01])

hour = ":"04":"(3[2-9] | [45][0-9]) |
       ":"0[56789]":"[0-5][0-9]  |
       ":"1[01234]":"[0-5][0-9] |
       ":"15":"([0-3][0-9] | 4[0-7])

//PARSER
comment = "//".*
sep = "%%%%"("%%")* | "#"("##")*
integer = ("-" | "+")[0-9]+
id = [a-zA-Z]+[0-9]+

%%

{token1}        {p(); return new Symbol(sym.T1);}
{token2}        {p(); return new Symbol(sym.T2);}

{sep}           {p(); return new Symbol(sym.SEP);}
{integer}       {p(); return new Symbol(sym.INTEGER,new Integer(yytext()));}
";"             {p(); return new Symbol(sym.SC);}
","             {p(); return new Symbol(sym.CM);}
"START"         {p(); return new Symbol(sym.START);}
"{"             {p(); return new Symbol(sym.BO);}
"}"             {p(); return new Symbol(sym.BC);}
":"             {p(); return new Symbol(sym.COL);}
"."             {p(); return new Symbol(sym.DOT);}
"AND"           {p(); return new Symbol(sym.AND);}
"OR"            {p(); return new Symbol(sym.OR);}
"NOT"           {p(); return new Symbol(sym.NOT);}
"!="            {p(); return new Symbol(sym.NEQ);}
"="             {p(); return new Symbol(sym.EQ);}
"MOVE"          {p(); return new Symbol(sym.MOVE);}
"WHEN"          {p(); return new Symbol(sym.WHEN);}
"THEN"          {p(); return new Symbol(sym.THEN);}
"DONE"          {p(); return new Symbol(sym.DONE);}
"VAR"           {p(); return new Symbol(sym.VAR);}


{id}            {p(); return new Symbol(sym.ID,yytext());}

{comment}   {;}

\r | \n | \r\n | " " | \t	{;}

.				{ System.out.println("Scanner Error: " + yytext()); }
