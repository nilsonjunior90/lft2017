package CompiladorPasito;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.nio.file.Paths;

import  LexicalAnalyzer.*;
import SyntacticAnalyzer.sym;
import java_cup.runtime.ComplexSymbolFactory;


public class Main {
	public static void main(String[] args) {
        String caminho = Paths.get("").toAbsolutePath().toString();
        String codigoFonte = caminho + "/src/Teste.Pasito";
        
        ComplexSymbolFactory f = new ComplexSymbolFactory(); // cria instância do ComplexSymbolFactory

        File file = new File(codigoFonte); // lê arquivo de entrada em Pasito
        
        FileInputStream fis = null;
        
        try {
            fis = new FileInputStream(file);
        } catch (IOException e) {
            e.printStackTrace();
        }

        LexicalAnalyzer lexical = new LexicalAnalyzer(f, fis); // Instância o Analisador Léxico

        try {
			while (lexical.next_token().sym != sym.EOF) { // Enquanto houverem novos tokens...
			    System.out.println("\n");
			}
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
    
	}
}
