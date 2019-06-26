include "ls_jolie.iol"
/*
 * @author Eros Fabrici
 */
//location sent by the client
constants {
  Location_JolieLS = ""
}

outputPort TextDocument {
  Interfaces: TextDocumentInterface
}

outputPort Workspace {
  Interfaces: WorkspaceInterface
}

embedded {
  Jolie: "text_document.ol" in TextDocument,
         "workspace.ol" in Workspace,
         "syntax_checker.ol",
         "utils.ol"
}

inputPort Input {
  //Location: "socket://localhost:8080"
  Location: Location_JolieLS
  Protocol: jsonrpc { //.debug = true
                      clientLocation -> global.clientLocation
                      clientOutputPort = "Client"
                      transport = "lsp"
                      osc.onExit.alias = "exit"
                      osc.cancelRequest.alias = "$/cancelRequest"
                      osc.didOpen.alias = "textDocument/didOpen"
                      osc.didChange.alias = "textDocument/didChange"
                      osc.willSave.alias = "textDocument/willSave"
                      osc.didSave.alias = "textDocument/didSave"
                      osc.didClose.alias = "textDocument/didClose"
                      osc.completion.alias = "textDocument/completion"
                      osc.hover.alias = "textDocument/hover"
                      osc.publishDiagnostics.alias = "textDocument/publishDiagnostics"
                      osc.publishDiagnostics.isNullable = true
                      osc.signatureHelp.alias = "textDocument/signatureHelp"
                      osc.didChangeWatchedFiles.alias = "workspace/didChangeWatchedFiles"
                      osc.didChangeWorkspaceFolders.alias = "workspace/didChangeWorkspaceFolders"
                      osc.didChangeConfiguration.alias = "workspace/didChangeConfiguration"
                      osc.symbol.alias = "workspace/symbol"
                      osc.executeCommand.alias = "workspace/executeCommand"
                      }
  Interfaces: GeneralInterface
  Aggregates: TextDocument, Workspace
}


/*
 * port that points to the client, used for publishing diagnostics
 */
outputPort Client {
  Protocol: jsonrpc {
    transport = "lsp"
  }
  Interfaces: ServerToClient
}

/*
 * port in which we receive the messages to be forwarded to the client
 */
inputPort NotificationsToClient {
  Location: "local://Client"
  interfaces: ServerToClient
}
