package LexicalAnalyzer; // pacote ao qual pertencerÃ¡ a classe gerada pelo jflex

import java_cup.runtime.ComplexSymbolFactory.Location;
import java_cup.runtime.ComplexSymbolFactory;
import java.io.IOException;
import java_cup.runtime.Symbol;
import SyntacticAnalyzer.sym;
import java.io.FileInputStream;


%%

// nome da classe a ser gerada pelo jflex
%class LexicalAnalyzer 

// implementa a classe sym gerada pelo cup
%implements sym 
// privacidade da classe a ser gerada
%public 
// codificaÃ§Ã£o do arquivo
%unicode 
// habilita uso de yyline
%line  
// habilita uso de yycolumn
%column 
// habilita integraÃ§Ã£o com o cup
%cup

%char
//define o s estados
%state ST_STRING
%state CODESEG
//define variaveis ?

/*
* yyline: linha analisada no momento atual pelo analisador lÃ©xico (lembre do automato) (comeÃ§a na linha 0)
* yycolumn: coluna analisada no momento atual pelo analisador lÃ©xico (lembre do automato) (comeÃ§a na coluna 0)
* yychar: caractere analisado no momento atual pelo analisador lÃ©xico (lembre do automato)
* yylenght(): retorna comprimento da palavra de entrada no momento atual do analisador lÃ©xico (lembre do automato)
* yytext(): palavra de entrada no momento atual do analisador lÃ©xico (lembre do automato)
*/

// inÃ­cio do cÃ³digo Java
%{
	
    private ComplexSymbolFactory symbolFactory;

    public StringBuffer string = new StringBuffer();
    

    /*
    * Construtor utilizado na chamada do analisador lÃ©xico pelo CUP
    * @param sf instÃ¢ncia da fÃ¡brica de sÃ­mbolos implementada pelo CUP que usaremos
    * @param is instÃ¢ncia do arquivo de entrada em Pasito que serÃ¡ analisado
    */
    public LexicalAnalyzer(ComplexSymbolFactory sf, FileInputStream is) {
        this(is);
        symbolFactory = sf;
    }
    public LexicalAnalyzer(ComplexSymbolFactory sf, java.io.Reader reader) {
        this(reader);
        symbolFactory = sf;
    }

    /*
    * Retorna de sÃ­mbolos identificados pelo analisador lÃ©xico
    * O sÃ­mbolo retornado Ã© um objeto da classe ComplexSymbolFactory implementada pelo CUP
    * TambÃ©m Ã© retornada a localizaÃ§Ã£o do sÃ­mbolo no arquivo, Ãºtil para fins de feedback ao usuÃ¡rio sobre a  posiÃ§Ã£o do erro (caso haja)
    * VocÃªs provavelmente vÃ£o precisar sobrecarregar essa funÃ§Ã£o para cobrir todos os tipos de sÃ­mbolo q vcs precisam retornar
    */
    public Symbol symbol(String nome, int code) {
    	
    	System.out.println("<" + nome + ", " + yytext() + "> (" + yyline + " - " + yycolumn + ")");
    	
        return symbolFactory.newSymbol(nome, code,
                            new Location(yyline+1, yycolumn+1, yychar),
                            new Location(yyline+1, yycolumn+yylength(), yychar+yylength()));
    }
	
	public Symbol symbol(String nome, int code, Object val) {
    	
    	System.out.println("<" + nome + ", " + yytext() + "> (" + yyline + " - " + yycolumn + ")");
    	
        return symbolFactory.newSymbol(nome, code,
                            new Location(yyline+1, yycolumn+1, yychar),
                            new Location(yyline+1, yycolumn+yylength(), yychar+yylength()));
    }
    
    	public Symbol symbol(String nome, int code, String val) {
    	
    	System.out.println("<" + nome + ", " + val + "> (" + yyline + " - " + yycolumn + ")");
    	
        return symbolFactory.newSymbol(nome, code,
                            new Location(yyline+1, yycolumn+1, yychar),
                            new Location(yyline+1, yycolumn+yylength(), yychar+yylength()));
    }

    /*
    * Emite um feedback no console com mensagem de erro, posiÃ§Ã£o e caractere
    */
    protected void emit_warning(String message){
        System.out.println("lexicalAnalyzer warning: " + message + " at : 2 "+
                (yyline+1) + " " + (yycolumn+1) + " " + yychar);
    }
%}
// fim do cÃ³digo Java (esse cÃ³digo serÃ¡ criado no arquivo exatamente da forma escrita acima)

// inÃ­cio das expressÃµes regulares que vÃ£o definir a classe de palavras identificadas (lembrem do automato)

/* BÃ¡sico */
LineTerminator = [\n|\r|\r\n] // fim de linha
Comment = {LineComment}|{BlockComment}
// @@@@@@@@@@@@ FAZER EXPRESSÃ•ES REGULARES PARA COMENTÃ�RIOS NO PASITO @@@@@@@@@@@@
LineComment = ("//")++{LineTerminator}
BlockComment = ("/**") //+(?)+("**/")
WhiteSpace = {LineTerminator}|[\t|\f| ] // espaÃ§o em branco
Ignore = {WhiteSpace}|{Comment} // tudo isso serÃ¡ ignorado
Letter = [a-z|A-Z] // letras
Digit = [0-9] // nÃºmeros

Id = {Letter}+({Letter}|{Digit})*

Caracter = (Letter|Digit)*

String = "\""


//liteais
Inteiro = {Digit}+
Float = {Digit}+"."{Digit}* | {Digit}* "." {Digit}+

Number = Inteiro|
            Float

//operadores
Operador = Plus |
            Minus |
             Star  |
              Slash  |
              Rem

//operacao
//Expr = Number+Operador+Number

/**
ExprList = Expr+Semicolon|
            Expr+LineTerminator|
            Expr+Operador+Expr|
            Expr+Operador+Expr+LineTerminator|
            Exp+Operador+Expr+Semicolon
**/


/* Operadores aritmÃ©ticos */
Plus = "+" // operador de soma
Minus = "-" // operador de subtraÃ§Ã£o
Star =  "*" // operador de multiplicacao
Slash = "/" // operador de divisao
Rem = "%" // operador de resto


/* Operadores lÃ³gicos */
And = "&&" // operador lÃ³gico And
Gt = ">" // operador logico maior que
Lt = "<" // operador logico menor que
Eq = "==" // operador logico igual a
Le = "<=" // operador logico menor igual que
Ge = ">=" // operador logico maior igual que
Neq = "!=" // operador logico diferente de
Or = "||" // operador logico Or

/*delimitador*/
Limiter = OpenLimiter | CloseLimiter |SimpleLimiter
OpenLimiter = LPAREN 
			|LBRACE
			|LBRACKET

CloseLimiter = RPAREN 
			|RBRACE
			|RBRACKET
			
SimpleLimiter = Dot
			|Comma
			|Semicolon



/* SÃ­mbolos */
Dot = "..." // ponto
Comma = "," // vÃ­rgula
Semicolon = ";" // ponto e virgula
LPAREN =  "(" // parantese abrindo
RPAREN =  ")" // parentese fechando
LBRACE =  "{" // chaves abrindo
RBRACE =  "}" // chaves fechando
LBRACKET =  "[" // colchete abrindo
RBRACKET =  "]" // colchete fechando

/* Tipos primitivos */
Boolean = "boolean" // boleano

/* Palavras reservadas */
Default = "default" // palavra reservada default //"(d|D)(e|E)(f|F)(a|A)(u|U)(l|L)(t|T)" case insensive
Func = "func" // palavra reservada func
Case = "case"
Else = "else"
Const = "const"
For = "for"
Struct = "struct"
Switch = "switch"
Fallthrough = "fallthrough"
Interface = "interface"
Type = "type"
If = "if"
Var = "val"

%eofval{
    return symbolFactory.newSymbol("EOF",sym.EOF);
%eofval}


// fim das expressÃµes regulares

%%

// inÃ­cio das aÃ§Ãµes de retorno
<YYINITIAL> {
    {Ignore}                    { }

    {Plus}                      { return symbol("PLUS", PLUS); }
    {Minus}			            { return symbol("MINUS", MINUS); }
    {Star} 						{ return symbol("STAR", STAR); }
    {Slash}						{ return symbol("SLASH", SLASH); }
    {Rem} 						{ return symbol("REM", REM); }
    

    {And}				       	{ return symbol("AND", AND); }
    {Gt}     					{ return symbol("GT", GT); }
    {Lt}     					{ return symbol("LT", LT); }	
    {Eq}						{ return symbol("EQ", EQ); }
    {Le} 						{ return symbol("LE",LE); }
    {Ge} 						{ return symbol("GE", GE); }	
    {Neq}		 				{ return symbol("NEQ", NEQ); }
    {Or}						{ return symbol("OR", OR); }

    {Dot}			            { return symbol("DOT", DOT); }
    {Comma}		        	    { return symbol("COMMA", COMMA); }
    {Semicolon}                 { return symbol("SEMICOLON", SEMICOLON); }
    {LPAREN} 					{ return symbol("LPAREN", LPAREN); }
	{RPAREN} 					{ return symbol("RLPAREN", RPAREN); }
    {LBRACE}					{ return symbol("LBRACE", LBRACE); }
    {RBRACE} 					{ return symbol("RBRACE", RBRACE); }
    {LBRACKET}					{ return symbol("LBRACKET", LBRACKET); }
    {RBRACKET} 					{ return symbol("RBRACKET", RBRACKET); }

    {Boolean}                   { return symbol("BOOLEAN", BOOLEAN); }

    {Default}					{ return symbol("DEFAULT", DEFAULT); }
    {Func}				      	{ return symbol("FUNC", FUNC); }
    {For}                       { return symbol("FOR", FOR); }
    {If}                        { return symbol("IF", IF); }
    {Struct}                    { return symbol("STRUCT", STRUCT); }
    {Switch}                    { return symbol("SWITCH", SWITCH); }
    {Fallthrough}               { return symbol("FALLTHROUGH", FALLTHROUGH); }
//    {Return}                    { return symbol("RETURN", RETURN); }
    {Interface}                 { return symbol("INTERFACE", INTERFACE); }
    {Type}                      { return symbol("TYPE", TYPE); }
    {If}                        { return symbol("IF", IF); }
    {Var}                       { return symbol("VAR", VAR); }
    {Case}                      { return symbol("CASE",CASE); }

    {Float}                     { return symbol("FLOAT", NUMBER , new Float(yytext())); }   
    {Inteiro}                   { return symbol("INT", NUMBER , new Integer(yytext())); }

//    {Limiter}                   { return symbol("LIMITER",)}

//    {Expr}                      { return symbol("expr",expr,yytext());}

    {String}                    {
									string.setLength(0);
                                    yybegin(ST_STRING);
                                }

    

// aviso de erro
.|\n						 	{ emit_warning("Caracter nÃ£o reconhecido '" + yytext() + "' -- ignorado"); }

}

<ST_STRING>{

	{String}	                {
									yybegin(YYINITIAL);
									return symbol("STRING", STRING, string.toString());
								}

    {Letter}                	{ string = string.append(yytext());} // deve existir o mesmo para qualquer coisa menos "\"" fecha string
	[^\n\r\"\\]+                { string.append( yytext() ); }
	\\t                         { string.append('\t'); }// caracteres escapados
	\\n                         { string.append('\n'); }
	\\r                         { string.append('\r'); }
	\\\"                        { string.append('\"'); }
	\\                          { string.append('\\'); }
}