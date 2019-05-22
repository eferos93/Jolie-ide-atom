include "ls_jolie.iol"

outputPort TextDocument {
Interfaces: TextDocumentInterface
}

outputPort Workspace {
Interfaces: WorkspaceInterface
}

embedded {
  Jolie: "text_document.ol" in TextDocument,
         "workspace.ol" in Workspace
}
inputPort Input {
  //Location: "socket://localhost:8080"
  Location: Location_JolieLS
  Protocol: jsonrpc { //.debug = true
                      .transport="lsp"
                      .osc.onExit.alias = "exit"
                      .osc.cancelRequest.alias = "$/cancelRequest"
                      .osc.didOpen.alias = "textDocument/didOpen"
                      .osc.didChange.alias = "textDocument/didChange"
                      .osc.willSave.alias = "textDocument/willSave"
                      .osc.didSave.alias = "textDocument/didSave"
                      .osc.didClose.alias = "textDocument/didClose"
                      .osc.completion.alias = "textDocument/completion"
                      .osc.hover.alias = "textDocument/hover"
                      .osc.definition.alias = "textDocument/definition"
                      .osc.didChangeWatchedFiles.alias = "workspace/didChangeWatchedFiles"
                      .osc.didChangeWorkspaceFolders.alias = "workspace/didChangeWorkspaceFolders"
                      .osc.didChangeConfiguration.alias = "workspace/didChangeConfiguration"
                      .osc.symbol.alias = "workspace/symbol"
                      .osc.executeCommand.alias = "workspace/executeCommand"
                      }
  Interfaces: GeneralInterface
  Aggregates: TextDocument, Workspace
}
