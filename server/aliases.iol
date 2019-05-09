
include "ls_jolie.iol"

outputPort TextDocument {
Interfaces: TextDocumentInterface
}
embedded {
  Jolie: "text_document.ol" in TextDocument
}
inputPort Input {
  //Location: "socket://localhost:8080"
  Location: Location_JolieLS
  Protocol: jsonrpc { .debug = true;
                      .transport="lsp";
                      .osc.onExit.alias = "exit";
                      .osc.cancelRequest.alias = "$/cancelRequest";
                      .osc.didOpen.alias = "textDocument/didOpen";
                      .osc.didChange.alias = "textDocument/didChange";
                      .osc.willSave.alias = "textDocument/willSave";
                      .osc.didSave.alias = "textDocument/didSave";
                      .osc.didClose.alias = "textDocument/didClose";
                      .osc.completion.alias = "textDocument/completion"
                      }
  Interfaces: GeneralInterface
  Aggregates: TextDocument
}
