include "console.iol"
include "string_utils.iol"
include "runtime.iol"

execution{ concurrent }

include "aliases.iol"


init {
  println@Console( "Jolie-IDE Server Started" )()
  global.receivedShutdownReq = false
}

main {
    [ initialize( initializeParams )( serverCapabilities ) {
      println@Console( "connessione avvenuta" )()
      global.processId = initializeParams.processId
      global.rootUri = initializeParams.rootUri
      global.clientCapabilities << initializeParams.capabilities
      valueToPrettyString@StringUtils( initializeParams )( client )
      println@Console( client )()
      with( serverCapabilities.capabilities ) {
        .textDocumentSync = 1 //0 = none, 1 = full, 2 = incremental
        with( .completionProvider ) {
          .resolveProvider = false
          .triggerCharacters[0] = "="
          .triggerCharacters[1] = "."
          .triggerCharacters[2] = "@"
        };
        .signatureHelpProvider.triggerCharacters[0] = "("
        .definitionProvider = true
        .hoverProvider = true
        .documentSymbolProvider = true
        .referenceProvider = true
        //.experimental;
      }
    }]

    [ initialized( initializedParams ) ] {
      println@Console( "Initialized " )()
    }

    [ shutdown( req )( res ) {
        println@Console( "Shutdown request received..." )()
        global.receivedShutdownReq = true
    }]
    [ onExit( notification ) ] {
      if( !global.receivedShutdownReq ) {
        println@Console( "Did not received the shutdown request, exiting anyway..." )()
      }
      println@Console( "Exiting Jolie Language server..." )()
      exit
    }
}
