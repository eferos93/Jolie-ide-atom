include "console.iol"
include "ls_jolie.iol"
include "string_utils.iol"
include "runtime.iol"
include "exec.iol"

execution{ concurrent }

inputPort TextDocumentInput {
  Location: "local"
  Interfaces: TextDocumentInterface
}


init {
  println@Console( "txtDoc running" )()
}

main {
  [ didOpen( notification ) ]  {
    global.textDocument = notification.textDocument
    //TODO implement diagnostics here
  }
  [ didChange( notification ) ] {
    global.textDocument = notification.textDocument
  }
  [ willSave( notification )] {
    global.textDocument = notification.textDocument
  }
  [ didSave( notification ) ] {
    global.textDocument = notification.textDocument
  }
  [ didClose( notificantion ) ] {
    if( notification.textDocument.uri == global.textDocument.uri ) {
      undef( global.textDocument )
    }
  }
  [ completion( completionParams )( completionList ) {
    textDoc = completionParams.textDocument;
    position = completionParams.position;
    line = position.line;
    character = position.character;
    context = completionParams.context
  } ]

}
