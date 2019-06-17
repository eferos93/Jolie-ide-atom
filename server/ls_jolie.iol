include "types.iol"

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
    hover( TextDocumentPositionParams )( Hover ),
    documentSymbol( DocumentSymbolParams )( undefined )
}

interface JavaServiceInterface {
  RequestResponse:
    documentSymbol( DocumentSymbolParams )( undefined ),
    completion
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
