# imports

%%

%class Lexer //Nome da classe que sera criada
%type Token 
%line //ativa a variavel yyline
%column  //ativa a variavel yycolumn

%{
	private Token token(Token.T type){
		return new Token(type, yyline, yycolumn);
	}
	
	private Token token(Token.T type, Object val){
		return new Token(type, val, yyline, yycolumn);
	}
%}

%state ST_STRING

%state ST_LINE_COMMENT
%state ST_BLOCK_COMMENT

alpha = [a-zA-Z]
digito = [0-9]

#digito_decimal?
#digito_octal?
#digito_hexadecimal?

id = {alpha}({alpha}|{digito})*

literal = inteiro | float

inteiro = {digito}+
float = {digito}+ "." {digito}* | {digito}* "." {digito}+

operador = operador_atribuicao | operador_comparacao
operador_atribuicao = ?
operador_comparacao = ?


delimitador = delimitador_inicio | delimitador_fim
delimitador_inicio = [regex?]
delimitador_fim = [regex?]


%%


<YYINITIAL>{
#palavras reservadas 

default 			{ return token(Token.T.DEFAULT);}
case 				{ return token(Token.T.CASE);}
else 				{ return token(Token.T.ELSE);}
const 				{ return token(Token.T.CONSTANTE);}
for					{ return token(Token.T.FOR);}
func 				{ return token(Token.T.FUNCAO);}
struct 				{ return token(Token.T.STRUCT);}
switch 				{ return token(Token.T.SWITCH);}
fallthrough 		{ return token(Token.T.FALLTHROUGH);}
return 				{ return token(Token.T.RETURN);}
interface 			{ return token(Token.T.INTERFACE);}
type				{ return token(Token.T.TYPE);}
if					{ return token(Token.T.IF);}
var 				{ return token(Token.T.VAR);}

#valores "extraidos"

{id}				{ return token(Token.T.ID, yytext());}
{inteiro} 			{ return token(Token.T.INT, new Integer(yytext));}
{float}				{ return token(Token.T.FLOAT, new Double)}


#mudancas de estado do analizador

//					{ 	// muda para o estado ST_LINE_COMMENT
						line_comment.setLength(0);
						yybegin(ST_LINE_COMMENT);
					}

/**					{   // muda para o estado ST_BLOCK_COMMENT
						block_comment.setLength(0);
						yybegin(ST_BLOCK_COMMENT);
					}
					
\"					{	//muda para o estado ST_STRING
						string.setLength(0);
						yybegin(ST_STRING)}
					}	


[ \t\n\r]+			{ /* do nothing */ }

<<EOF>>				{ return token(Token.T.EOF); }

 

} # fim do estado YYINITIAL

<ST_STRING>{

\"					{	//volta para o estado YYINITIAL
						
						yybegin(YYINITIAL);
						return token(Token.T.STRING, string.toString());
					}
									

} #fim do estado ST_STRING

