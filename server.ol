include "console.iol"
include "prova.iol"

execution{ concurrent }

inputPort Input {
  Location: "socket://localhost:8090"
  Protocol: jsonrpc { .debug = true }
  Interface: Prova
}

main {
  check(req)(res) {
    println@Console("connessione avvenuta")();
    res = "Conn avvenuta"
  }
}
