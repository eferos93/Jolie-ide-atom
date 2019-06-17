include "console.iol"
include "ls_jolie.iol"
include "string_utils.iol"
include "runtime.iol"
include "exec.iol"
include "file.iol"

execution{ concurrent }

/**
  * PORTS
  */
inputPort TextDocumentInput {
  Location: "local"
  Interfaces: TextDocumentInterface
}

outputPort SyntaxChecker {
  location: "local://SyntaxChecker"
  Interfaces: SyntaxCheckerInterface
}

outputPort JavaService {
Interfaces: JavaServiceInterface
}

embedded {
  Java: "lspservices.TextDocumentServices" in JavaService
}
/**
  * DEFINITIONS
  */


/*define insertDoc {
  /*splitReq = newDoc.text
  splitReq.regex = "\n"
  split@StringUtils( splitReq )( splitRes )
  splitRes << {
    uri = newDoc.uri
    languageId = newDoc.languageId
    version = newDoc.version
  }
  docs[i] << newDoc
}*/

define newDocument
{
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

define searchDoc
{
  docFound = false
  docs -> global.textDocument
  for(i = 0, i<#docs && !fileFound, i++) {
    if(textDocUri == docs[i].uri) {
      docFound = true
      documentFoundIndex = i
    }
  }
}

define printAllDocs
{
  for( i = 0, i < #docs, i++ ) {
    //valueToPrettyString@StringUtils( docs[i] )( doc )
    println@Console( docs[i].uri )()
  }
}


/**
  * INIT and MAIN
  *
  */
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
  k = "is_defined"
  k = "undef"


  //TODO add all keywords
}

main {
  [ didOpen( notification ) ]  {
    println@Console( "didOpen received" )()
    newDocument
    doc.path = uri
    syntaxCheck@SyntaxChecker( doc )
    printAllDocs

  }

  [ didChange( notification ) ] {
    println@Console( "didChange received" )()
    modifiedDocText -> notification.contentChanges[0]
    newUri -> notification.textDocument.uri
    newVersion -> notification.textDocument.version
    newDoc << {
      text = modifiedDocText
      uri = newUri
      version = newVersion
    }
    docs -> global.textDocument
    textDocUri = newDoc.uri
    searchDoc
    if ( docFound ) {
      if( documentFound.version < newDoc.version ) {
        documentFound << newDoc
      }
    }
    /*for(i = 0, i < #docs && keepRunning, i++) {
      if(docs[i].uri == newUri && docs[i].version < newVersion) {
        splitReq = modifiedDoc[1].text
        splitReq.regex = "\n"
        split@StringUtils( splitReq )( splitRes )
        splitRes << {
          uri = newUri
          //languageId = newDoc.languageId
          version = newversion
        }
        docs[i] << splitRes
        keepRunning = false
      }
    }*/
    //doc.path = newDoc.uri
    //syntaxCheck@SyntaxChecker( doc )
    printAllDocs
  }

  [ willSave( notification ) ] {
    global.textDocument = notification.textDocument
    println@Console( "willSave received" )()
  }

  [ didSave( notification ) ] {
    println@Console( "File changed " + notification.textDocument.uri )()
    doc.path = notification.textDocument.uri
    syntaxCheck@SyntaxChecker( doc )
  }

  [ didClose( notification ) ] {
    println@Console( "didClose received" )()
    uri -> notification.textDocument.uri
    docs -> global.textDocument
    keepRunning = true
    for(i = 0, i < #docs && keepRunning, i++) {
      if(docs[i].uri == uri) {
        undef( docs[i] )
        keepRunning = false
      }
    }

    /*for( i = 0, i < #docs, i++ ) {
      println@Console( docs[i].uri )()
    }*/
  }

  [ completion( completionParams )( completionList ) {
      valueToPrettyString@StringUtils( completionParams )( str )
      println@Console( str )()
      document -> completionParams.textDocument


      subStrReq = document.uri
      subStrReq.begin = 7
      length@StringUtils( document.uri )( subStrReq.end )
      valueToPrettyString@StringUtils( subStrReq )( str )
      println@Console( str )()
      substring@StringUtils( subStrReq )( fileReq.filename )
      //fileReq.filename = document.uri
      fileReq.format = "text"
      valueToPrettyString@StringUtils( fileReq )( str )
      println@Console( str )()
      readFile@File( fileReq )( readFileRes )
      splitReq = readFileRes
      splitReq.regex = "\n"
      split@StringUtils( splitReq )( splitRes )
      completionReq.lines << splitRes.result
      completionReq.uri = document.uri
      completionReq.position << document.position
      undef( readFileRes )
      undef( splitRes )

      if ( is_defined( document.context ) ) {
        context = document.context
      }

      if ( context.triggerKind == 2 ) {
        // if compl was invoked by a triggerChar
        completionReq.triggerChar = context.triggerCharacter
      } //TODO triggerKind == 1 and == 0

      completion@JavaService( completionReq )( result )
      completionList << result
      
      println@Console( "Sending completion Item to the client" )()
  } ]

  [ hover( hoverReq )( hoverResp ) {
      println@Console( "hover req received.." )(  )
      //TODO
  } ]
}
