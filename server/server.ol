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
      .textDocumentSync = 2
      with( .completionProvider ) {
        .resolveProvider = false
        .triggerCharacters[0] = "="
        .triggerCharacters[1] = "."
        .triggerCharacters[2] = "a"
        .triggerCharacters[3] = "b"
        .triggerCharacters[4] = "c"
        .triggerCharacters[5] = "d"
        .triggerCharacters[6] = "e"
        .triggerCharacters[7] = "f"
        .triggerCharacters[8] = "g"
        .triggerCharacters[9] = "h"
        //.triggerCharacters[2] = "A-Za-z0-9";
      };
      .signatureHelpProvider.triggerCharacters[0] = "(";
      .definitionProvider = true;
      .typeDefinitionProvider = true;
      //.implementationProvider = true;
      .referenceProvider = true;
      //.documentHighlightProvider = false;
      //.workspaceSymbolProvider = false;
      //.documentSymbolProvider = false;
      //.codeActionProvider = false;
      //.codeLensProvider = false;
      //.documentFormattingProvider = false;
      //.documentOnTypeFormattingrvider;
      //.renameProvider = false;
      //.documentLinkProvider;
      //.colorProvider = false;
      //.foldingRangeProvider = false;
      //.declarationProvider = false;
      //.executeCommandProvider;
      with( .workspace.workspaceFolders ) {
        .supported = true
        .changeNotifications = true
      }
      //.experimental;
    }
  }]

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

  [ initialized( initializedParams ) ] {
    println@Console( "Initialized " )()
  }
}
