include "console.iol"
include "prova.iol"
include "ui/swing_ui.iol"
include "json_utils.iol"
include "exec.iol"

execution{ concurrent }

inputPort Input {
  Location: "socket://localhost:8090"
  Protocol: jsonrpc { .debug = true }
  Interfaces: Prova
}

main {
  check(req)(res) {
    println@Console("connessione avvenuta")();
    showMessageDialog@SwingUI("conn avvenuta")();
    res = "Conn avvenuta"
  }
}
