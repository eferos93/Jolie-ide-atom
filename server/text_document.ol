include "console.iol"
include "ls_jolie.iol"
include "string_utils.iol"
include "runtime.iol"
include "exec.iol"
include "file.iol"

execution{ concurrent }

constants {
  INTEGER_MAX_VALUE = 2147483647
}
/*
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

outputPort Utils {
  location: "local://Utils"
  Interfaces: UtilsInterface
}

embedded {
  Jolie: "utils.ol"
}

/*
 * INIT and MAIN
 *
 */
init {
  println@Console( "txtDoc running" )()
}

main {

  [ didOpen( notification ) ]  {
      println@Console( "didOpen received" )()
      insertNewDocument@Utils( notification )
      doc.path = notification.textDocument.uri
      syntaxCheck@SyntaxChecker( doc )
  }

  /*
   * Message sent from the L.C. when saving a document
   * Type: DidSaveTextDocumentParams
   */
  [ didChange( notification ) ] {
      println@Console( "didChange received " )()
      updateDocument@Utils( notification )
  }

  [ willSave( notification ) ] {
    //never received a willSave message though
    println@Console( "willSave received" )()
  }

  /*
   * Messsage sent from the L.C. when saving a document
   * Type: DidSaveTextDocumentParams
   */
  [ didSave( notification ) ] {
      println@Console( "File changed " + notification.textDocument.uri )()
      doc.path = notification.textDocument.uri
      syntaxCheck@SyntaxChecker( doc )
  }

  /*
   * Message sent from the L.C. when closing a doc
   * Type: DidCloseTextDocumentParams
   */
  [ didClose( notification ) ] {
      println@Console( "didClose received" )()
      deleteDocument@Utils( notification )
  }

  /*
   * RR sent sent from the client when requesting a completion
   * @Request: CompetionParams
   * @Response: CompletionResult
   */
  [ completion( completionParams )( completionRes ) {
      println@Console( "Completion Req Received" )()
      completionRes << {
        isIncomplete = false
      }
      txtDocId -> completionParams.textDocument
      position -> completionParams.position

      if ( is_defined( completionParams.context ) ) {
        context -> completionParams.context
      }

      getDocument@Utils( txtDocId.uri )( document )

      triggerChar -> context.triggerCharacter

      program -> document.jolieProgram
      operation = document.lines[position.line]
      trim@StringUtils( operation )( operationNameTrimmed )
      portFound = false

      for ( port in program.port ) {

        if ( port.isOutput && is_defined( port.interface ) ) {
          for( iFace in port.interface ) {

            if ( is_defined( iFace.operation ) ) {
              for( op in iFace.operation ) {

                if ( !is_defined( triggerChar ) ) {
                  //was not '@' to trigger the completion
                  temp = op.name
                  temp.substring = operationNameTrimmed
                  contains@StringUtils( temp )( operationFound )

                  if ( operationFound ) {
                    snippet = op.name + "@" + port.name
                    label = snippet
                    kind = 2 //method
                  }

                } else {
                  //@ triggered the completion
                  operationFound = ( op.name == operationNameTrimmed )
                  label = port.name
                  snippet = label
                  kind = 7
                }

              }

                //if the operation was found or, the programmer
                //made a mistaske while typing but we still found
                //a match
                if ( operationFound ) {
                  //build the rest of the snippet to be sent
                  if ( is_defined( op.responseType ) ) {
                    //is a reqRes operation

                    if ( is_defined( op.requestType.name ) ) {
                      reqVar = op.requestType.name
                    } else {
                      reqVar = "requestVar"
                    }

                    if ( is_defined( op.responseType.name ) ) {
                      resVar = op.responseType.name
                      if ( resVar == "void" ) {
                        resVar = ""
                      }
                    } else {
                      resVar = "responseVar"
                    }
                    snippet += "( ${1:" + reqVar + "} )( ${2:" + resVar + "} )"
                  } else {
                    //is a OneWay operation
                    if ( is_defined( op.requestType.name ) ) {
                      notificationVar = op.requestType.name
                    } else {
                      notificationVar = "notification"
                    }

                    snippet = "( ${1:" + notificationVar + "} )"
                  }

                  //build the completionItem
                  portFound = true
                  completionItem << {
                    label = label
                    kind = kind
                    insertTextFormat = 2
                    insertText = snippet
                  }
                  completionRes.items[#completionRes.items] << completionItem

                }
              }
            }
          }
        }
      if ( !foundPort ) {
        completionRes.items = void
      }
      valueToPrettyString@StringUtils( completionRes )( s )
      println@Console( s )(  )
      println@Console( "Sending completion Item to the client" )()
  } ]

  [ hover( hoverReq )( hoverResp ) {
      hoverResp = void
      println@Console( "hover req received.." )()
      textDocUri -> hoverReq.textDocument.uri
      getDocument@Utils( textDocUri )( document )

      line = document.lines[hoverReq.position.line]
      program -> document.jolieProgram
      trim@StringUtils( line )( trimmedLine )
      trimmedLine.regex = "([A-z]+)@([A-z]+)\\(.*"
      //.group[1] is operaion name, .group[2] port name
      find@StringUtils( trimmedLine )( findRes )
      if ( findRes == 0 ) {
        trimmedLine.regex = "\\[? ?( ?[A-z]+ ?)\\( ?[A-z]* ?\\)\\(? ?[A-z]* ?\\)? ?\\]? ?\\{?"
        //in this case, we have only
        find@StringUtils( trimmedLine )( findRes )
      }

      //if we found somenthing, we have to send a hover item, otherwise void
      if ( findRes == 1 ) {
        // portName might NOT be defined
        portName -> findRes.group[2]
        operationName -> findRes.group[1]
        undef( trimmedLine.regex )
        hoverInfo = "```jolie\n" + operationName + "@"
        if ( is_defined( portName ) ) {
          hoverInfo += portName
        }

        for ( port in program.port ) {

          if ( is_defined( portName ) ) {
            ifGuard = port.name == portName && is_defined( port.interface )

          } else {
            ifGuard = is_defined( port.interface )
          }

          if ( ifGuard ) {
            for ( iFace in port.interface ) {
              if ( is_defined( iFace.operation ) ) {
                for ( op in iFace.operation ) {
                  if ( op.name == operationName ) {
                    if ( !is_defined( portName ) ) {
                      hoverInfo += port.name
                    }
                    reqType = op.requestType.name
                    reqTypeCode = op.requestType.code
                    resType = ""
                    resTypeCode = ""
                    if ( is_defined( op.responseType ) ) {
                      resType = op.responseType.name
                      resTypeCode = op.responseType.code
                    }
                  }
                }
              }
            }
          }
        }

        hoverInfo += "( " + reqType + " )"
        //build the info
        if ( resType != "" ) {
          //the operation is a RR
          hoverInfo += "( " + resType + " )"
        }

        hoverInfo += "\n```\n*Request type*: \n" + reqTypeCode
        if ( resTypeCode != "" ) {
          hoverInfo += "\n\n*Response type*: \n" + resTypeCode
        }

        //setting the content of the response
        hoverResp.contents << {
          kind = "markdown"
          value = hoverInfo
        }

        //computing and setting the range
        length@StringUtils( line )( endCharPos )
        line.word = trimmedLine
        indexOf@StringUtils( line )( startChar )

        hoverResp.range << {
          start << {
            line = hoverReq.position.line
            character = startChar
          }
          end << {
            line = hoverReq.position.line
            character = endCharPos
          }
        }
      }
  } ]

  [ signatureHelp( txtDocPositionParams )( signatureHelp ) {
      textDocUri -> txtDocPositionParams.textDocument.uri
      position -> txtDocPositionParams.position

  } ]
}
