include "console.iol"
include "prova.iol"
include "json_utils.iol"
include "exec.iol"

execution{ concurrent }

inputPort Input {
  Location: Location_JolieLS
  Protocol: jsonrpc { .debug = true }
  Interfaces: Prova
}

init {
  println@Console("Started")()
}

main {
  initialize(req)(res) {
    println@Console("connessione avvenuta"+ response)()
  }
}
