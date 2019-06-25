include "console.iol"
include "string_utils.iol"
include "runtime.iol"

execution { concurrent }

include "aliases.iol"


init {
  Client.location -> global.clientLocation
  println@Console( "Jolie-IDE Server Started" )()
  global.receivedShutdownReq = false
  global.textDocumentSync = 1
  
}

main {
    [ initialize( initializeParams )( serverCapabilities ) {
      println@Console( "Initialize message received" )()
      global.processId = initializeParams.processId
      global.rootUri = initializeParams.rootUri
      global.clientCapabilities << initializeParams.capabilities
      serverCapabilities.capabilities << {
        textDocumentSync = global.textDocumentSync //0 = none, 1 = full, 2 = incremental
        completionProvider << {
          resolveProvider = false
          triggerCharacters[0] = "@"
        }
        signatureHelpProvider.triggerCharacters[0] = "("
        definitionProvider = true
        hoverProvider = true
        documentSymbolProvider = true
        referenceProvider = false
        //experimental;
      }
    }]

    [ initialized( initializedParams ) ] {
      println@Console( "Initialization done " )()

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

    [ publishDiagnostics( diagnosticParams ) ] {
      println@Console( "publishing Diagnostics" )()
      publishDiagnostics@Client( diagnosticParams )
    }

    [ cancelRequest( cancelReq ) ] {
        println@Console( "cancelRequest received ID: " + cancelReq.id )()
        //TODO
    }
}
