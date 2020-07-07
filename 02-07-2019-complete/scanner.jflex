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
token1 = {date}( "-" | "+" ){date} ( "-" | "+" ){date} (( "-" | "+" ){date}{2})* ";"

date =  (2019 "/" ( (09 | September) "/" (2[1-9] | 30) )                  |
                  ( (10 | October)   "/" (0[1-9] | [1-2][1-9] | 3[0-1]) ) |
                  ( (11 | November)  "/" (0[1-9] | [1-2][1-9] | 30) )     |
                  ( (12 | December)  "/" (0[1-9] | [1-2][1-9] | 3[0-1]) ))|
         (2020 "/"
                  ( (01 | January)   "/" (0[1-9] | 1[1-9] | 2[0-3])))
//TOKEN2
token2 = ( {binary}{2} | {binary}{19} | {binary}{36} ){word}";"
binary = ( 1011 | 1111 | 1[01]{4} | 1[01]{5} | 100[01]{4} | 1010[01]{3} | 10110[01]{2} | 101110[01] )"*"
word = (xx)(xx){0,11}(y){5}(yy)*

//TOKEN3
token3 = {hex}"$"{t3_word}{5}({t3_word}{2})*";"
hex = ( "-" ( 3[1-9A-C] | [12][1-9A-F] | [1-9A-F] ) ) |
            ( 1B3[1-9A] | 1B[1-2][1-9A-F] | 1[1-9A][1-9A-F] | [1-9A-F]{1,3})

//PARSER
sep = "%%"
comment = "[-" ~ "-]"
u_integer = [0-9]+
q_string = \" [a-zA-Z\ 0-9]+ \"
t3_word = ab | ba | aa | bb

%%

{token1}    {p(); return new Symbol(sym.TOKEN1); }
{token2}    {p(); return new Symbol(sym.TOKEN2); }
{token3}    {p(); return new Symbol(sym.TOKEN3); }

{sep}       {p(); return new Symbol(sym.SEP); }
"INIT"      {p(); return new Symbol(sym.INIT); }
"POWER"     {p(); return new Symbol(sym.POWER); }
"TIME"      {p(); return new Symbol(sym.TIME); }
";"         {p(); return new Symbol(sym.SC); }
"-"         {p(); return new Symbol(sym.SCORE); }
{u_integer} {p(); return new Symbol(sym.VALUE,new Integer(yytext())); }
"W"         {p(); return new Symbol(sym.W); }
"KW"        {p(); return new Symbol(sym.KW); }
"SEC"       {p(); return new Symbol(sym.SEC); }
"MIN"       {p(); return new Symbol(sym.MIN); }
"FZ"        {p(); return new Symbol(sym.FZ); }
"["         {p(); return new Symbol(sym.SQO); }
"]"         {p(); return new Symbol(sym.SQC); }
"("         {p(); return new Symbol(sym.RO); }
")"         {p(); return new Symbol(sym.RC); }
","         {p(); return new Symbol(sym.CM); }
"MAX"       {p(); return new Symbol(sym.MAX); }
"DEC"       {p(); return new Symbol(sym.DEC); }
"INC"       {p(); return new Symbol(sym.INC); }
"CASE"      {p(); return new Symbol(sym.CASE,yytext()); }
"ESAC"      {p(); return new Symbol(sym.ESAC,yytext()); }
"RANGE"     {p(); return new Symbol(sym.RANGE_WORD,yytext()); }
"DO"        {p(); return new Symbol(sym.DO_WORD,yytext()); }
"DONE"      {p(); return new Symbol(sym.DONE_WORD,yytext()); }
"PRINT"     {p(); return new Symbol(sym.PRINT_WORD,yytext()); }
"EQ"        {p(); return new Symbol(sym.EQ_WORD,yytext()); }
{q_string}  {p(); return new Symbol(sym.Q_STRING,yytext()); }
":"         {p(); return new Symbol(sym.COL); }



{comment}                 {;}
\r | \n | \r\n | " " | \t	{;}

.				{ System.out.println("Scanner Error: " + yytext()); }
