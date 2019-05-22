include "console.iol"
include "ls_jolie.iol"
include "string_utils.iol"
include "runtime.iol"
include "exec.iol"
include "utils/tree_utils"

execution{ concurrent }

inputPort TextDocumentInput {
  Location: "local"
  Interfaces: TextDocumentInterface
}

outputPort TreeUtils {
Location: "local"
Protocol: soap
Interfaces: TreeInterface
}

define saveDoc {
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
}

define findTextDoc {
  docs -> global.textDocument
  keepRunning = true
  for(i=0, i<#docs && keepRunning, i++) {
    if()
  }
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
    saveDoc

    for( i = 0, i < #docs, i++ ) {
      println@Console( docs[i].uri )()
    }
  }

  [ didChange( notification ) ] {
    println@Console( "didChange received" )()
    saveDoc
  }

  [ willSave( notification ) ] {
    //global.textDocument = notification.textDocument
    println@Console( "willSave received" )()
  }

  [ didSave( notification ) ] {
    println@Console( "File saved " + notification.textDocument.uri )()
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
      valueToPrettyString@StringUtils( completionParams )( completionParamsString )
      println@Console( "Completion req received" )()
      println@Console( completionParamsString )()
      textDocUri = completionParams.textDocument.uri
      position << completionParams.position
      context << completionParams.context
      println@Console( "" )()
  } ]

  [ hover( hoverReq )( hoverResp ) {
      println@Console( "hover req received.." )(  )
  } ]

  [ definition( defRequest )( defResponse ){
      valueToPrettyString@StringUtils( defRequest )( reqString )
      println@Console( reqString )()
  }]

}
