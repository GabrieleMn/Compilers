import java_cup.runtime.*;

%%


%unicode
%cup
%line
%column


%{
  private Symbol symbol(int type) {
    return new Symbol(type, yyline, yycolumn);
  }
  private Symbol symbol(int type, Object value) {
    return new Symbol(type, yyline, yycolumn, value);

  }
%}

nl = \r|\n|\r\n	//newline
ws = [ \t]	//whitespace

//TOKEN1
month_29 = 0[1-9] | (1|2)[0-9]
month_30 = 0[1-9] | (1|2)[0-9] | 30
month_31 = 0[1-9] | (1|2)[0-9] | 3[0-1]

token1={date}"?"(({hour}("*"|"$")){2}{hour})("*"{hour}("*"|"$"){hour})*";"

date=2020"/"((01"/"((1[2-9])|(2[0-9])|(30[01])))|
            (02"/"{month_29})|
            (03"/"{month_31})|
            (04"/"{month_30})|
            (05"/"{month_31})|
            (06"/"{month_30})|
            (07"/"(0[0-9]|1[0-3])))

hour = (((0[0-9])|(1[0-9])|(2[0-3]))":"((0[0-9])|((1|2|3|4)[0-9])|(5[0-9])))

//TOKEN2
token2="!"({integer}|{char_seq})";"

integer = "-"(1[0-5] | [0-9]) | (13[0-6] | 1[0-2][0-9] | [1-9][0-9] | [0-9])
char_seq = (xx | yy | aa | bb){2} | (xx | yy | aa | bb){7} | (xx | yy | aa | bb){23}

//SECOND PART
ident  		=	[_a-zA-Z][_a-zA-Z0-9]*
value = \" ~ \"
%%

{token1}            { //System.out.println("TOK1");
                      return new Symbol(sym.TOK1);
                    }
{token2}            { //System.out.println("TOK2");
                      return new Symbol(sym.TOK2);
                    }

"%%%"               { //System.out.println("SEP");
                      return new Symbol(sym.SEP);
                    }

"IF"               {return new Symbol(sym.IF);}
"ELSE"             {return new Symbol(sym.ELSE);}
"TRUE"             {return new Symbol(sym.TRUE,new Boolean(true));}
"FALSE"            {return new Symbol(sym.FALSE,new Boolean(false));}

{ident}            { //System.out.println("ID");
                    return new Symbol(sym.ID,new String(yytext()));
                   }

"="                { //System.out.println("EQ");
                    return new Symbol(sym.EQ);
                   }

{value}            { //System.out.println("VAL");
                      return new Symbol(sym.VAL, new String(yytext()));
                   }

";"                {return new Symbol(sym.SC);}

"("                {return new Symbol(sym.RO);}
")"                {return new Symbol(sym.RC);}

"["                {return new Symbol(sym.SQO);}
"]"                {return new Symbol(sym.SQC);}

"&"                {return new Symbol(sym.AND);}
"|"                {return new Symbol(sym.OR);}
"!"                {return new Symbol(sym.NOT);}


"((--" ~ "--))"     {;}
{nl}                {;}
{ws}                {;}

.			              {System.out.print(" ERR("+yytext()+")");}
