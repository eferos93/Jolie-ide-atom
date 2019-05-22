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

define newDoc
{
  newDoc -> notification.textDocument
  uri -> notification.textDocument.uri
  newDocVersion -> notification.textDocument.version
  docs -> global.textDocument
  keepRunning = true

  for(i = 0, i < #docs && keepRunning, i++) {
    if(docs[i].uri == uri && docs[i].version < newDocVersion) {
      splitReq = newDoc.text
      splitReq.regex = "\n"
      split@StringUtils( splitReq )( splitRes )
      splitRes << {
        uri = newDoc.uri
        languageId = newDoc.languageId
        version = newdoc.version
      }
      docs[i] << splitRes
      keepRunning = false
    }
  }

  if( keepRunning ) {
    docs[#docs] << newDoc
  }
}

define searchDoc
{
  fileFound = false
  docs -> global.textDocument
  for(i = 0, i<#docs && !fileFound, i++) {
    if(textDocUri == docs[i].uri) {
      fileFound = true
      document -> docs[i]
    }
  }
}

define printAllDocUris
{
  for( i = 0, i < #docs, i++ ) {
    println@Console( docs[i] )()
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
    newDoc
    printAllDocUris

  }

  [ didChange( notification ) ] {
    println@Console( "didChange received" )()
    newDoc
    printAllDocUris
  }

  [ willSave( notification ) ] {
    global.textDocument = notification.textDocument
    println@Console( "willSave received" )()
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
      textDocUri = completionParams.textDocument.uri
      position << completionParams.position
      context << completionParams.context
      //search if the doc is saved in global.textDocumentSync
      searchDoc
      if( fileFound ) {

      } else {

      }

  } ]

  [ hover( hoverReq )( hoverResp ) {
      println@Console( "hover req received.." )(  )
  } ]

}
