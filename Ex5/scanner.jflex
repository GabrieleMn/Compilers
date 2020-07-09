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
token1 = {hex}"_"{word}"_"( SOS | {word_end})?";"
hex = "-"(2[0-7] | 1[0-9A-F] | [0-9A-F]) | 256[0-9A-C] | 25[0-5][0-9A-C] | 2[0-4][0-9A-C]{2} | 1[0-9A-F]{3} | [0-9A-F]{1,3}
word = [a-zA-Z]{5}([a-zA-Z]{2})*
word_end = X Y((YY){2})* ZZ((ZZ){2})* X

//TOKEN2
token2 = ( 9":"(2[1-9] | [345][0-9])":"(1[2-9] | [2345][0-9])? |
           1[0123456]":"([0-5][0-9])":"([012345][0-9])? |
           17":"([0123][0-9] | 4[0-3])":"([012][0-9] | 3[0-4])? )";" |
         ( 9":"(2[1-9] | [345][0-9])"am" |
           1[01]":"([0-5][0-9])"am" |
           1[23456]":"([0-5][0-9])"pm" |
           17":"([0123][0-9] | 4[0-3])"pm")";"

//TOKEN3
token3 = ("$$"{binary} | "&&"{word_t3}) ";"
binary = (0*10*){3} | (0*10*){5}
word_t3 = (XO)+X? | (OX)+O?

//PARSER
comment = "/-"~"-/"
q_string = \" [a-zA-Z0-9\ ]+ \"
number = [0-9]+"."[0-9]+
number_2_dec = [0-9]+ "." [0-9]{2}
integer = [0-9]+
%%



{token1}      {p(); return new Symbol(sym.TOKEN1);}
{token2}      {p(); return new Symbol(sym.TOKEN2);}
{token3}      {p(); return new Symbol(sym.TOKEN3);}

{q_string}    {p(); return new Symbol(sym.Q_STRING,yytext());}
{number_2_dec}      {p(); return new Symbol(sym.NUMBER_2_DEC,new Float(yytext()));}
{number}      {p(); return new Symbol(sym.NUMBER,new Float(yytext()));}
{integer}     {p(); return new Symbol(sym.INTEGER,new Integer(yytext()));}

"->"          {p(); return new Symbol(sym.ARROW);}
"##"          {p(); return new Symbol(sym.SEP);}
";"           {p(); return new Symbol(sym.SC);}
","           {p(); return new Symbol(sym.CM);}
":"           {p(); return new Symbol(sym.COL);}
"%"           {p(); return new Symbol(sym.PERC);}
"km"          {p(); return new Symbol(sym.KM_W);}
"km/h"        {p(); return new Symbol(sym.KM_H_W);}
"COMPUTE"     {p(); return new Symbol(sym.COMPUTE_W);}
"TO"          {p(); return new Symbol(sym.TO_W);}
"TIME"        {p(); return new Symbol(sym.TIME_W,yytext());}
"EXPENSE"     {p(); return new Symbol(sym.EXPENSE_W,yytext());}
"EXTRA"       {p(); return new Symbol(sym.EXTRA_W);}
"-"           {p(); return new Symbol(sym.SCORE);}
"euro/km"     {p(); return new Symbol(sym.EURO_KM_W);}
"DISC"        {p(); return new Symbol(sym.DISC_W);}
"euro"        {p(); return new Symbol(sym.EURO_W);}



{comment}   {;}
\r | \n | \r\n | " " | \t	{;}

.				{ System.out.println("Scanner Error: " + yytext()); }
