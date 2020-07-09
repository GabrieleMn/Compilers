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
      System.out.println(yytext());
  }

%}


//TOKEN1
token1 = {word1}{word2}{number_t1}?";"
word1 = ("*" | "#" | "&"){6}(("*" | "#" | "&"){2})*
word2 = [a-zA-Z0-9]*[A-zA-Z]{2}
number_t1 = "-"(2[024] | 1[02468] | [02468]) | 125[02468] | 12[0-4][02468] | 1[0-1][0-9][02468] | [0-9]{1,2}[02468] | [02468]

//TOKEN2
token2 = ( ({hex}("-" | ":")){3}{hex} | ({hex}("-" | ":")){6}{hex} | ({hex}("-" | ":")){18}{hex} )";"
hex = [0-9a-fA-F]{3} | [0-9a-fA-F]{5}

//TOKEN3
token3 = (09":"(3[1-9] | [45][0-9]) | 1[0123456]":"[012345][0-9] | 17":"([0123][0-9] | 4[0-6]) |
         09":"(3[1-9] | [45][0-9])"am" | 1[012]":"[012345][0-9]"am" | 0[1234]":"[012345][0-9]"pm" | 05":"([0123][0-9] | 4[0-6])"pm")";"
//PARSER
comment = "/*" ~ "*/"
id = [_a-zA-Z][_a-zA-Z0-9]*
number = [0-9]+"."[0-9]+
q_string = \" [a-zA-Z0-9\ ]+ \"
%%

{token1}    {p(); return new Symbol(sym.TOKEN1);}
{token2}    {p(); return new Symbol(sym.TOKEN2);}
{token3}    {p(); return new Symbol(sym.TOKEN3);}

"FZ"        {p(); return new Symbol(sym.FZ);}
"PATH"      {p(); return new Symbol(sym.PATH,yytext());}
"MAX"       {p(); return new Symbol(sym.MAX,yytext());}
"IF"        {p(); return new Symbol(sym.IF,yytext());}
"IN"        {p(); return new Symbol(sym.IN,yytext());}
"RANGE"     {p(); return new Symbol(sym.RANGE,yytext());}
"PRINT"     {p(); return new Symbol(sym.PRINT,yytext());}

{q_string}  {p(); return new Symbol(sym.Q_STRING,yytext());}

"$$$"       {p(); return new Symbol(sym.SEP);}
{id}        {p(); return new Symbol(sym.ID,yytext());}
"="         {p(); return new Symbol(sym.EQ);}
{number}    {p(); return new Symbol(sym.NUMBER,new Float(yytext()));}
"+"         {p(); return new Symbol(sym.PLUS);}
"-"         {p(); return new Symbol(sym.MINUS);}
"*"         {p(); return new Symbol(sym.MUL);}
"/"         {p(); return new Symbol(sym.DIV);}
"("         {p(); return new Symbol(sym.RO);}
")"         {p(); return new Symbol(sym.RC);}
";"         {p(); return new Symbol(sym.SC);}
","         {p(); return new Symbol(sym.CM);}
"["         {p(); return new Symbol(sym.SQO);}
"]"         {p(); return new Symbol(sym.SQC);}
":"         {p(); return new Symbol(sym.COL);}

{comment}   {;}




\r | \n | \r\n | " " | \t	{;}

.				{ System.out.println("Scanner Error: " + yytext()); }
