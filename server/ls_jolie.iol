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
    definition( TextDocumentPositionParams )( Location )
}

interface WorkspaceInterface {
  OneWay:
    didChangeWatchedFiles( DidChangeWatchedFilesParams ),
    didChangeWorkspaceFolders( DidChangeWorkspaceFoldersParams ),
    didChangeConfiguration( DidChangeConfigurationParams )
  RequestResponse:
    symbol( WorkspaceSymbolParams )( SymbolInformation ),
    executeCommand( ExecuteCommandParams )( ExecuteCommandResult )
}
