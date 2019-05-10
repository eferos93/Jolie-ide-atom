interface GeneralInterface {
  OneWay:
    initialized,
    onExit,
    cancelRequest

  RequestResponse:
    initialize,
    shutdown
}

interface TextDocumentInterface {
  OneWay:
    didOpen,
    didChange,
    willSave,
    didSave,
    didClose
     //server -> client
  RequestResponse:
    willSaveWaitUntil,
    completion,
    publishDiagnostics
}

interface WorkspaceInterface {
  OneWay:
    didChangeWatchedFiles,
    didChangeWorkspaceFolders,
    didChangeConfiguration
  RequestResponse:
    symbol,
    executeCommand
}
