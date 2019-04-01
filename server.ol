include "console.iol"

interface Prova {
  RequestResponse: check(undefined))(undefined)
}

inputPort Input {
  Location: "socket://localhost:8090"
  Protocol: jsonrpc { .debug = true }
  Interface: prova
}

main {
  check(req)(res) {
    println@Console("connessione avvenuta")()
  }
}
