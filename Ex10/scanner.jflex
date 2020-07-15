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
token1 = {word1}"|"{hex}?";"
word1 = [xyz]{6}([xyz]{2})*
hex = "-"(3[13579Bb] | [12][13579BbDdFf] | [13579BbDdFf]) | [aA][bB][13] | [aA][1-9Aa][13579BbDdFf] | [1-9][1-9AaBbCcDdEeFf][13579BbDdFf] | [1-9AaBbCcDdEeFf][13579BbDdFf] | [13579BbDdFf]

//TOKEN2
token2 = ( 10":"(11":"(1[2-9] | [2345][0-9]) | 1[2-9]":"[0-5][0-9] |[2345][0-9]":"[0-5][0-9]) |
           1[1234]":"[0-5][0-9]":"[0-5][0-9] |
           15":"(36":"(4[7-9] | 5[0-9]) | 3[7-9]":"[0-5][0-9] | [4-5][0-9]":"[0-5][0-9]) )";"

//TOKEN3
token3 = ({binary}("." | "-" | "+")){3}{binary}";" | ({binary}("." | "-" | "+")){5}{binary}";"
binary = [01]{3} | [01]{15}
//PARSER
comment = "/*" ~ "*/"
id = [A-Z][A-Z0-9_]
name = [a-z]+
integer = "-"?[0-9]+
q_string = \" [a-zA-Z0-9\ ]+ \"
%%

{token1}    {p(); return new Symbol(sym.T1);}
{token2}    {p(); return new Symbol(sym.T2);}
{token3}    {p(); return new Symbol(sym.T3);}

"##"        {p(); return new Symbol(sym.SEP);}
"="         {p(); return new Symbol(sym.EQ);}
";"         {p(); return new Symbol(sym.SC);}
"["         {p(); return new Symbol(sym.SQO);}
"]"         {p(); return new Symbol(sym.SQC);}
","         {p(); return new Symbol(sym.CM);}
"INIT"      {p(); return new Symbol(sym.INIT);}
"DEFAULT"   {p(); return new Symbol(sym.DEFAULT);}
"WHEN"      {p(); return new Symbol(sym.WHEN);}
"DO"        {p(); return new Symbol(sym.DO);}
"DONE"      {p(); return new Symbol(sym.DONE);}
"("         {p(); return new Symbol(sym.RO);}
")"         {p(); return new Symbol(sym.RC);}
"&&"        {p(); return new Symbol(sym.AND);}
"||"        {p(); return new Symbol(sym.OR);}
"!"         {p(); return new Symbol(sym.NOT);}
"."         {p(); return new Symbol(sym.DOT);}
"PRINT"     {p(); return new Symbol(sym.PRINT);}
"NEXT"      {p(); return new Symbol(sym.NEXT);}
"CASE"      {p(); return new Symbol(sym.CASE);}

{integer}   {p(); return new Symbol(sym.INTEGER,new Integer(yytext()));}

{q_string}  {p(); return new Symbol(sym.Q_STRING,yytext());}
{name}      {p(); return new Symbol(sym.NAME,yytext());}
{id}        {p(); return new Symbol(sym.ID,yytext());}
{comment}       {;}
\r | \n | \r\n | " " | \t	{;}

.				{ System.out.println("Scanner Error: " + yytext()); }
