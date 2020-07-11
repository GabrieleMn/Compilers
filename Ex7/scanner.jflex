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
token1 = ({date}("-" | "#")){2}{date}(("-" | "#")date{2})*";"
date = 2017"/"07"/"(0[2-9] | [12][0-9] | 3[01]) |
       2017"/"08"/"(0[0-9] | [12][0-9] | 3[01]) |
       2017"/"09"/"(0[0-9] | [12][0-9] | 30)    |
       2017"/"10"/"(0[0-9] | [12][0-9] | 3[01])

//TOKEN2
token2 = "$"({word} | {binary})";"
word = ([b-df-hl-np-tv-z]*[aeiou][b-df-hl-np-tv-z]*){2} | ([b-df-hl-np-tv-z]*[aeiou][b-df-hl-np-tv-z]*){5}
binary = 10 | 11 | [01]{3} | [01]{4} | [01]{5} | 100[01]{3} | 10100[01]

//TOKEN3
token3 = {word_t3}{number}?";"
word_t3 = ("@" | "%" | "&"){4}(("@" | "%" | "&"){2})*
number = "-"(4[0-3] | [0-3][0-9] | [0-9]) | 123[0-1] | 12[0-2][0-9] | 1[0-1][0-9]{2} | [0-9]{1,3}

//PARSER
comment = "//".*
sep = "****"(\*)*
id = [_a-zA-Z][_a-zA-Z0-9]*
integer = [0-9]+
q_string = \" [a-zA-Z0-9\ \']+ \"
%%

{token1}          {p(); return new Symbol(sym.TOKEN1);}
{token2}          {p(); return new Symbol(sym.TOKEN2);}
{token3}          {p(); return new Symbol(sym.TOKEN3);}

"START"           {p(); return new Symbol(sym.START);}
"STATE"           {p(); return new Symbol(sym.STATE);}
"IF"              {p(); return new Symbol(sym.IF);}
"FI"              {p(); return new Symbol(sym.FI);}
"CASE"            {p(); return new Symbol(sym.CASE);}
"DO"              {p(); return new Symbol(sym.DO);}
"DONE"            {p(); return new Symbol(sym.DONE);}
"&&"              {p(); return new Symbol(sym.AND);}
"||"              {p(); return new Symbol(sym.OR);}
"!"               {p(); return new Symbol(sym.NOT);}
"("               {p(); return new Symbol(sym.RO);}
")"               {p(); return new Symbol(sym.RC);}
"."               {p(); return new Symbol(sym.DOT);}
"NEW"             {p(); return new Symbol(sym.NEW);}
"PRINT"           {p(); return new Symbol(sym.PRINT);}

{q_string}        {p(); return new Symbol(sym.Q_STRING,yytext());}
{sep}             {p(); return new Symbol(sym.SEP);}
{id}              {p(); return new Symbol(sym.ID,yytext());}
{integer}         {p(); return new Symbol(sym.INTEGER,new Integer(yytext()));}


"="               {p(); return new Symbol(sym.EQ);}
"!="              {p(); return new Symbol(sym.NEQ);}
"{"               {p(); return new Symbol(sym.BO);}
"}"               {p(); return new Symbol(sym.BC);}
";"               {p(); return new Symbol(sym.SC);}

{comment}         {;}

\r | \n | \r\n | " " | \t	{;}

.				{ System.out.println("Scanner Error: " + yytext()); }
