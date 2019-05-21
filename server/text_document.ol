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
  k -> global.keywords[#global.keywords]
  k = "include"
  k = "execution"
  K = "inputPort"
  k = "Interfaces"
  k = "global"
  k = "Protocol"
  k = "OneWay"
  k = "RequestResponse"
  k = "type"
  k = "define"
  k = "true"
  k = "false"
  k = "int"
  k = "inputPort"
  k = "outputPort"
  k = "interface"
  
  //TODO add all keywords
}

main {
  [ didOpen( notification ) ]  {
    newDoc -> notification.textDocument
    uri -> notification.textDocument.uri
    newDocVersion -> notification.textDocument.version
    docs -> global.textDocument
    keepRunning = true

    for(i = 0, i < #docs && keepRunning, i++) {
      if(docs[i].uri == uri && docs[i].version < newDocVersion) {
        docs[i] << newDoc
        keepRunning = false
      }
    }

    if( keepRunning ) {
      docs[#docs] << newDoc
    }

    for( i = 0, i < #docs, i++ ) {
      println@Console( docs[i].uri )()
    }
  }

  [ didChange( notification ) ] {
    println@Console( "didChange received" )()
    global.textChanges = notification.textDocument
  }

  [ willSave( notification ) ] {
    global.textDocument = notification.textDocument
  }

  [ didSave( notification ) ] {
    println@Console( "File changed " + notification.textDocument.uri )()
  }

  [ didClose( notification ) ] {
    uri -> notification.textDocument.uri
    docs -> global.textDocument
    keepRunning = true
    for(i = 0, i < #docs && keepRunning, i++) {
      if(docs[i].uri == uri) {
        undef(docs[i])
        keepRunning = false
      }
    }

    for( i = 0, i < #docs, i++ ) {
      println@Console( docs[i].uri )()
    }
  }

  [ completion( completionParams )( completionList ) {
      println@Console( "Completion req received" )()
      textDoc << completionParams.textDocument
      position << completionParams.position
      line << position.line
      character << position.character
      context << completionParams.context
  } ]

  [ hover( hoverReq )( hoverResp ) {
      println@Console( "hover req received.." )(  )
  } ]

}
