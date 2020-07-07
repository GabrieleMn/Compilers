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
token1 = ( ("%%%%%"(\%\%)*) | (("**" | "???"){2,3}) ){number}?";"
number = ( 33[0-3] | 3[0-3][0-9] | [1-2][0-9][0-9] | [1-9][0-9] | [0-9] ) | ("-" (3[0-5] | [1-2][0-9] | [0-9]) )

//TOKEN2
token2 = {date}( "-" | "+" ){date}";"
date = 2015 "/" 12 "/" ( 1[2-9] | 2[0-9] | 3[0-1] ) |
       2016 "/" 01 "/" ( 0[1-4] | 0[6-9] | (1|2)[0-9] | 3[0-2] ) |
       2016 "/" 02 "/" ( 0[1-9] | (1|2)[0-9] ) |
       2016 "/" 03 "/" ( 0[1-9] | 1[0-3] )

//TOKEN3
token3 = "$"{binary}";"
binary = 101 | 111 | 1[0-1]{3} | 1[0-1]{4} | 100[0-1]{3} | 101000

//////////

sep = "##"("##")*
comment = "//" .*
id = \" [_a-zA-Z][_a-zA-Z0-9]* \"
number	=	[0-9]+
part = "PART"{number}
%%

\r | \n | \r\n | " " | \t	{;}

{token1} { p(); return new Symbol(sym.TOKEN1); }
{token2} { p(); return new Symbol(sym.TOKEN2); }
{token3} { p(); return new Symbol(sym.TOKEN3); }

{sep}    { p(); return new Symbol(sym.SEP); }
{part}   { p(); return new Symbol(sym.PART_NAME,yytext()); }
{id}     { p(); return new Symbol(sym.ID,yytext()); }
"{"      { p(); return new Symbol(sym.BO); }
"}"      { p(); return new Symbol(sym.BC); }
"("      { p(); return new Symbol(sym.RO); }
")"      { p(); return new Symbol(sym.RC); }
","      { p(); return new Symbol(sym.CM); }
";"      { p(); return new Symbol(sym.SC); }
"m\/s"   { p(); return new Symbol(sym.MS); }
"="      { p(); return new Symbol(sym.EQ); }
"->"     { p(); return new Symbol(sym.ARROW); }
"|"      { p(); return new Symbol(sym.OR); }
":"      { p(); return new Symbol(sym.COL); }
"m"      { p(); return new Symbol(sym.M_CHAR); }
{number} { p(); return new Symbol(sym.NUMBER,new Integer(yytext())); }
"PRINT_MIN_MAX" {p(); return new Symbol(sym.FUN_NAME); }

{comment} {;}
.				{ System.out.println("Scanner Error: " + yytext()); }
