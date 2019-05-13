include "console.iol"
include "string_utils.iol"
include "runtime.iol"

execution{ concurrent }

include "aliases.iol"


init {
  println@Console("Jolie Language Server Started")();
  global.receivedShutdownReq = false
}

main {
  [ initialize( initializeParams )( serverCapabilities ) {
    println@Console( "connessione avvenuta" )();
    global.processId = initializeParams.processId;
    global.rootUri = initializeParams.rootUri;
    global.clientCapabilities << initializeParams.capabilities;
    println@Console( "Process ID: " + global.processId )();
    println@Console( "Root Uri: " + global.rootUri )();
    with( serverCapabilities.capabilities ) {
      .textDocumentSync = 2;
      with( .completionProvider ) {
        //.resolveProvider = true;
        .triggerCharacters[0] = "=";
        .triggerCharacters[1] = "."
        //.triggerCharacters[2] = "A-Za-z0-9";
      };
      //.signatureHelpProvider.triggerCharacters[0] = "(";
      //.definitionProvider = true;
      //.typeDefinitionProvider = true;
      //.implementationProvider = true;
      //.referenceProvider = true;
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
        .supported = true;
        .changeNotifications = true
      }
      //.experimental;
    }
  }]

  [ shutdown( req )( res ) {
    println@Console( "Shutdown request received..." )();
    undef(global);
    global.receivedShutdownReq = true
  }]

  [ onExit( notification ) ] {
    if( global.receivedShutdownReq ) {
      exit
      //callExit@Runtime(0)()
    } else {
      println@Console( "Did not received the shutdown request, exiting anyway..." )();
      exit
      //callExit@Runtime(1)()
    }
  }

  [ initialized( initializedParams ) ] {
    println@Console( "Initialized " )()
  }
}
