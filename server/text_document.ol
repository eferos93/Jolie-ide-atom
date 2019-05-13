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
  k -> global.keywords[#global.keywords];
  k = "include";
  k = "execution";
  K = "inputPort";
  k = "Interfaces";
  k = "global";
  k = "Protocol";
  k = "OneWay";
  k = "RequestResponse";
  k = "type";
  k = "define";
  //TODO add all keywords
}

main {
  [ didOpen( notification ) ]  {
    uri -> notification.textDocument.uri;
    newVersion -> notification.textDocument.version;
    docs -> global.textDocument;
    keepRun = true;
    for(i = 0, i < #docs && keepRun, i++) {
      if(doc.uri == uri && docs.version < newVersion) {
        docs[i] << notification.textDocument;
        keepRun = false;
      }
    }

    if(keepRun) {
      docs[#doc+1] << notification.textDocument
    }

    valueToPrettyString@StringUtils( docs )( docsString );
    println@Console( docsString )()
  }

  [ didChange( notification ) ] {
    global.textChanges = notification.textDocument
  }

  [ willSave( notification )] {
    global.textDocument = notification.textDocument
  }

  [ didSave( notification ) ] {
    println@Console( "File changed " + notification.textDocument.uri )()
  }

  [ didClose( notificantion ) ] {
    uri -> notification.textDocument.uri;
    docs -> global.textDocument;
    keepRun = true;
    for(i = 0, i < #docs && keepRun, i++) {
      if(docs[i].uri == uri) {
        undef(docs[i]);
        keepRun = false
      }
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
