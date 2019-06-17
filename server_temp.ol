include "console.iol"
include "prova.iol"
include "json_utils.iol"
include "exec.iol"


execution{ concurrent }

inputPort Input {
  Location: "socket://localhost:8095"
  //Location: Location_JolieLS
  Protocol: jsonrpc { .debug = true;
                      .transport="lsp"}
  Interfaces: Prova
}

init {
  println@Console("Started")()
}

min {
  initialize(req)(res) {
    println@Console("connessione avvenuta")()
  }
}
