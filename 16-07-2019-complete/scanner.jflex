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
token1 = "%"{date}("$$$"("$")* | ":"{time})";"

date = (2019 "/" ((A|a)ugust "/" (1[5-9] | 2[0-9] |3[01] ) |
                 (S|s)eptember "/" (0[1-9] | (1|2)[0-9] | 30) |
                 (O|o)ctober "/" (0[1-9] | (1|2)[0-9] | 3[01])|
                 (N|n)ovember "/" (0[1-9] | (1|2)[0-9] | 30)|
                 (D|d)ecember "/" (0[1-9] | (1|2)[0-9] | 3[01]))) |
       (2020 "/" ((J|j)anuary "/" (0[1-9] | (1|2)[0-9] | 3[01]) |
                 (F|f)ebruary "/" (0[1-9] | 1[0-9] | 2[0-8])))

time = 07":"( 3[1-9] | (4|5)[0-9] ) |
       08":"( 0[1-9] | (1|2|3|4|5)[0-9] ) |
       09":"( 0[1-9] | (1|2|3|4|5)[0-9] ) |
       (10 | 11 | 12 | 13 | 14 |15 |16 )":"( 0[1-9] | (1|2|3|4|5)[0-9] ) |
       17":"( 0[1-9] | 1[0-5] )

//TOKEN2
token2 = "#"{word}{number}?";"
word = ([AC-Z]* B [AC-Z]*){6}(([AC-Z]* B [AC-Z]*){2})*
number = "-"(27[0-3] | 2[0-6][0-9] | 1[0-9][0-9] | [1-9][0-9] | [0-9]) | ([0-9] | 1[0-9] | 2[0-3])

//TOKEN3
token3 = ("@@" | "&&" | "??" | "!!" ){5,120}{token3_end}";"
token3_end = (({token3_word}"$"){3}{token3_word}) | (({token3_word}"$"){8}{token3_word})
token3_word = [a-zA-Z]{2} | [a-zA-Z]{5} | [a-zA-Z]{12}

//PARSER
decimal = [0-9]+"."[0-9][0-9]
parser_date = 201907(0[2-9] | (1|2)[0-9] | 3[0-1])
id = [_a-zA-Z][_a-zA-Z0-9]*
quoted_string = \" [a-zA-Z]+ \"

%%

{token1} {p(); return new Symbol(sym.TOKEN1);}
{token2} {p(); return new Symbol(sym.TOKEN2);}
{token3} {p(); return new Symbol(sym.TOKEN3);}

"$$"      {p(); return new Symbol(sym.SEP);}
"START"   {p(); return new Symbol(sym.START_WORD);}
";"       {p(); return new Symbol(sym.SC);}
{decimal} {p(); return new Symbol(sym.VAL,new Float(yytext()));}
{parser_date}    {p(); return new Symbol(sym.DATE,new String(yytext()));}
":"       {p(); return new Symbol(sym.COL);}
"DEF"     {p(); return new Symbol(sym.DEF);}
"("       {p(); return new Symbol(sym.RO);}
")"       {p(); return new Symbol(sym.RC);}
"{"       {p(); return new Symbol(sym.BO);}
"}"       {p(); return new Symbol(sym.BC);}
"ASSIGN"  {p(); return new Symbol(sym.ASSIGN);}
"TO"      {p(); return new Symbol(sym.TO);}
"="       {p(); return new Symbol(sym.EQ);}
"AND"     {p(); return new Symbol(sym.AND);}
"OR"      {p(); return new Symbol(sym.OR);}
"NOT"     {p(); return new Symbol(sym.NOT);}
"true"    {p(); return new Symbol(sym.TRUE);}
"false"   {p(); return new Symbol(sym.FALSE);}
"IF"      {p(); return new Symbol(sym.IF);}
"DEC"     {p(); return new Symbol(sym.DEC);}
"INC"     {p(); return new Symbol(sym.INC);}
"."       {p(); return new Symbol(sym.DOT);}
"CASE"    {p(); return new Symbol(sym.CASE);}
"EQ"      {p(); return new Symbol(sym.EQ_WORD);}
"PRINT"   {p(); return new Symbol(sym.PRINT);}
{quoted_string} {p(); return new Symbol(sym.Q_STRING,yytext());}


{id}      {p(); return new Symbol(sym.ID, new String(yytext()));}


\r | \n | \r\n | " " | \t	{;}
.				{ System.out.println("Scanner Error: " + yytext()); }
