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
  RequestResponse:
    willSaveWaitUntil,
    completion
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
