include "types.iol"
include "types/JavaException.iol"
/*
 * @author Eros Fabrici
 */
interface GeneralInterface {
  OneWay:
    initialized( InitializedParams ),
    onExit( void ),
    cancelRequest
  RequestResponse:
    initialize( InitializeParams )( InitializeResult ),
    shutdown( void )( void )
}

interface TextDocumentInterface {
  OneWay:
    didOpen( DidOpenTextDocumentParams ),
    didChange( DidChangeTextDocumentParams ),
    willSave( WillSaveTextDocumentParams ),
    didSave( DidSaveTextDocumentParams ),
    didClose( DidCloseTextDocumentParams )
  RequestResponse:
    willSaveWaitUntil( WillSaveTextDocumentParams )( WillSaveWaitUntilResponse ),
    completion( CompletionParams )( CompletionResult ),
    hover( TextDocumentPositionParams )( HoverInformations ),
    documentSymbol( DocumentSymbolParams )( undefined ),
    signatureHelp( TextDocumentPositionParams )( SignatureHelpResponse )
}

interface JavaServiceInterface {
  RequestResponse:
    documentSymbol( DocumentSymbolParams )( undefined ),
}

interface WorkspaceInterface {
  OneWay:
    didChangeWatchedFiles( DidChangeWatchedFilesParams ),
    didChangeWorkspaceFolders( DidChangeWorkspaceFoldersParams ),
    didChangeConfiguration( DidChangeConfigurationParams )
  RequestResponse:
    documentSymbol( WorkspaceSymbolParams )( undefined ),
    executeCommand( ExecuteCommandParams )( ExecuteCommandResult )
}

interface ServerToClient {
  OneWay:
    publishDiagnostics( PublishDiagnosticParams )
}

interface SyntaxCheckerInterface {
  OneWay:
    syntaxCheck
}

interface InspectorInterface {
  RequestResponse:
  	inspectProgram( InspectionRequest )( ProgramInspectionResponse )
      throws ParserException( WeakJavaExceptionType )
             SemanticException( WeakJavaExceptionType )
             FileNotFoundException( WeakJavaExceptionType )
             IOException( WeakJavaExceptionType ),
             inspectTypes( InspectionRequest )( TypesInspectionResponse )
      throws ParserException( WeakJavaExceptionType )
             SemanticException( WeakJavaExceptionType )
             FileNotFoundException( WeakJavaExceptionType )
             IOException( WeakJavaExceptionType )
}

interface UtilsInterface {
  RequestResponse:
    getDocument( string )( TextDocument )
  OneWay:
    insertNewDocument( DidOpenTextDocumentParams ),
    updateDocument( DocumentModifications ),
    deleteDocument( DidCloseTextDocumentParams )

}
