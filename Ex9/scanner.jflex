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
token1 = {number}{word}?("ABC" | {word2})";"
number = "-"(12[024] | 1[0-1][02468] | [1-9][02468] | [02468]) | [02468] | [1-7][02468] | 8[0246]
word = [a-z]{5}([a-z]{2})*
word2 = ("XX" | "YY" | "YX" | "XY"){3}("XX" | "YY" | "YX" | "XY")*

//TOKEN2
token2 = ({word3}("*" | "-")){4} {word3} (("*" | "-"){word3})* ";"
word3 = 10 | 11 | [01]{3,5} | 10[01]{4} | 110[01]{3} | 1110[01]{2} | 11110

//TOKEN3
token3 =  (08":"(12":"(3[4-9] | [45][0-9]) | 1[3-9]":"[0-5][0-9] | [2345][0-9]":"[0-5][0-9]) |
          (09 | 1[0-6])":"[0-5][0-9]":"[0-5][0-9] |
          17":"([01][0-9]":"[0-5][0-9] | 20":"[0-5][0-9] | 21":"([0-2][0-9] | 3[0-7])))";"
//PARSER
comment = "%".*
signed_integer = "-"?[0-9]+
id = [a-zA-Z]+


%%

{token1}        {p(); return new Symbol(sym.T1);}
{token2}        {p(); return new Symbol(sym.T2);}
{token3}        {p(); return new Symbol(sym.T3);}

"set"           {p(); return new Symbol(sym.SET);}
"position"      {p(); return new Symbol(sym.POSITION);}
"fuel"          {p(); return new Symbol(sym.FUEL);}
"declare"       {p(); return new Symbol(sym.DECLARE);}

";"             {p(); return new Symbol(sym.SC);}
","             {p(); return new Symbol(sym.CM);}
"="             {p(); return new Symbol(sym.EQ);}
"-"             {p(); return new Symbol(sym.SCORE);}
"{"             {p(); return new Symbol(sym.BO);}
"}"             {p(); return new Symbol(sym.BC);}
"("             {p(); return new Symbol(sym.RO);}
")"             {p(); return new Symbol(sym.RC);}
"and"           {p(); return new Symbol(sym.AND);}
"or"            {p(); return new Symbol(sym.OR);}
"not"           {p(); return new Symbol(sym.NOT);}
"mv"            {p(); return new Symbol(sym.MV);}
"."             {p(); return new Symbol(sym.DOT);}
"?"             {p(); return new Symbol(sym.QUESTION);}
"min"           {p(); return new Symbol(sym.MIN,yytext());}
"max"           {p(); return new Symbol(sym.MAX,yytext());}
":"             {p(); return new Symbol(sym.COL);}
"increases"      {p(); return new Symbol(sym.INCREASE);}
"decreases"      {p(); return new Symbol(sym.DECREASE);}
"else"          {p(); return new Symbol(sym.ELSE_W);}

{id}            {p(); return new Symbol(sym.ID,yytext());}

{signed_integer}  {p(); return new Symbol(sym.INTEGER,new Integer(yytext()));}


"$$"            {p(); return new Symbol(sym.SEP);}
{comment}       {;}

\r | \n | \r\n | " " | \t	{;}

.				{ System.out.println("Scanner Error: " + yytext()); }
