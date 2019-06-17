/***************************************************************************
 *   Copyright (C) 2019 by Eros Fabrici <eros.fabrici@gmail.com>       *
 *                                                                         *
 *   This program is free software; you can redistribute it and/or modify  *
 *   it under the terms of the GNU Library General Public License as       *
 *   published by the Free Software Foundation; either version 2 of the    *
 *   License, or (at your option) any later version.                       *
 *                                                                         *
 *   This program is distributed in the hope that it will be useful,       *
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of        *
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the         *
 *   GNU General Public License for more details.                          *
 *                                                                         *
 *   You should have received a copy of the GNU Library General Public     *
 *   License along with this program; if not, write to the                 *
 *   Free Software Foundation, Inc.,                                       *
 *   59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.             *
 *                                                                         *
 *   For details about the authors of this software, see the AUTHORS file. *
 ***************************************************************************/
package lspservices;

import java.io.IOException;
import java.net.URI;
import java.util.ArrayList;
import jolie.CommandLineException;
import jolie.CommandLineParser;
import jolie.lang.parse.ParserException;
import jolie.lang.parse.SemanticException;
import jolie.lang.parse.SemanticVerifier;
import jolie.lang.parse.ast.InterfaceDefinition;
import jolie.lang.parse.ast.Program;
import jolie.lang.parse.ast.types.TypeDefinition;
import jolie.lang.parse.util.ParsingUtils;
import jolie.lang.parse.util.ProgramInspector;
import jolie.runtime.JavaService;
import jolie.runtime.Value;
import jolie.runtime.ValueVector;

/**
 *
 * @author Eros Fabrici
 */


public class TextDocumentServices extends JavaService {
    
    class Position {
        private int line;
        private int character;
        
        public Position( int line, int character ) {
            this.line = line;
            this.character = character;
        }
        
        public void setLine( int newLine ) {
            line = newLine;
        }
        
        public void setChar( int newChar ) {
            character = newChar;
        }
        
        public int getLine() {
            return line;
        }
        
        public int getChar() {
            return character;
        }
        
        @Override
        public String toString() {
            return "Line: " + line + "\n Character: " + character;
        }
    }
    
    /**
     * operation that returns the symbols of the given documnet
     * @param txtDoc uri of the document
     * @return 
     */
    public Value documentSymbol( Value txtDoc ) {
        Value response = Value.create();
        try {
            ProgramInspector programInspector = getInspector( txtDoc.getFirstChild( "uri" ).strValue() );
            InterfaceDefinition[] interfaces = programInspector.getInterfaces();
            URI[] sources = programInspector.getSources();
            TypeDefinition[] types = programInspector.getTypes();
            
        
        
            return response;
        } catch( Exception e ) {
            //return response;
        }
        return response;
    }
    
    /**
     * operation that returns a list of completion items
     * @param completionReq
     * @return 
     */
    public Value completion( Value completionReq ) {
        System.out.println( "TextDocumentService: completion req received" );
        Value response = null;
        try {
            ProgramInspector programInspector = getInspector( completionReq.getFirstChild( "uri" ).strValue() );
            ValueVector lines = completionReq.getChildren( "lines" );
            ArrayList<String> stringLines = new ArrayList<String>();
            int line = completionReq.getFirstChild( "position" ).getFirstChild( "line" ).intValue();
            int character = completionReq.getFirstChild( "position" ).getFirstChild( "chararcter" ).intValue();
            Position position = new Position(line, character);
            lines.forEach( (v) -> stringLines.add( v.strValue() ) );
            System.out.println( "hello"  + stringLines );
            System.out.println( position );
            String trigChar;
            if( completionReq.hasChildren( "triggerChar" ) ) {
                trigChar = completionReq.getFirstChild( "triggerChar" ).strValue();
                System.out.println( trigChar );
            }   
        
        } catch( Exception e ) {
          
        }
        return response;
  }

  
  private static ProgramInspector getInspector( String filename ) throws CommandLineException, IOException, ParserException, SemanticException {
    SemanticVerifier.Configuration configuration = new SemanticVerifier.Configuration();
    configuration.setCheckForMain( false );
    CommandLineParser commandLineParser;
    String[] args = { filename };
    commandLineParser = new CommandLineParser( args, TextDocumentServices.class.getClassLoader() );
    Program program = ParsingUtils.parseProgram(
      commandLineParser.programStream(),
      commandLineParser.programFilepath().toURI(),
      commandLineParser.charset(),
      commandLineParser.includePaths(),
      commandLineParser.jolieClassLoader(),
      commandLineParser.definedConstants(),
      configuration
    );
    
    return ParsingUtils.createInspector( program );
 }
}

