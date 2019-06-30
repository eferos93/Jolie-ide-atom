include "console.iol"
include "string_utils.iol"
include "runtime.iol"

/*
 * Main Service that communicates directly with the client and provides the basic
 * operations
 * The port is defined in aliases.iol
 */
execution { concurrent }

include "aliases.iol"

/*
 * @author Eros Fabrici
 */
init {
  Client.location -> global.clientLocation
  println@Console( "Jolie-IDE Server Started" )()
  global.receivedShutdownReq = false
  //we want full document sync as we build the ProgramInspector for each
  //time we modify the document
  global.textDocumentSync = 1
}

main {
    [ initialize( initializeParams )( serverCapabilities ) {
      println@Console( "Initialize message received" )()
      global.processId = initializeParams.processId
      global.rootUri = initializeParams.rootUri
      global.clientCapabilities << initializeParams.capabilities
      //for full serverCapabilities spec, see
      //https://microsoft.github.io/language-server-protocol/specification
      //and types.iol
      serverCapabilities.capabilities << {
        textDocumentSync = global.textDocumentSync //0 = none, 1 = full, 2 = incremental
        completionProvider << {
          resolveProvider = false
          triggerCharacters[0] = "@"
        }
        //signatureHelpProvider.triggerCharacters[0] = "("
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
        println@Console( "Did not receive the shutdown request, exiting anyway..." )()
      }
      println@Console( "Exiting Jolie Language server..." )()
      exit
    }
    //message received from the service utils.ol
    [ publishDiagnostics( diagnosticParams ) ] {
      println@Console( "publishing Diagnostics" )()
      //sending the diagnostics to the client
      publishDiagnostics@Client( diagnosticParams )
    }

    [ cancelRequest( cancelReq ) ] {
        println@Console( "cancelRequest received ID: " + cancelReq.id )()
        //TODO using a courier
    }
}
