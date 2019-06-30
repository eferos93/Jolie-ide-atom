include "console.iol"
include "ls_jolie.iol"
include "string_utils.iol"
include "runtime.iol"
include "exec.iol"
include "file.iol"

/*
 * Service that handles all the textDocument/ messages sent from the client
 */
execution{ concurrent }

constants {
  INTEGER_MAX_VALUE = 2147483647,
  REQUEST_VAR = "requestVar",
  RESPONSE_VAR = "responseVar",
  NOTIFICATION = "notification",
  NATIVE_TYPE_VOID = "void",
  REQUEST_TYPE = "Request Type",
  RESPONSE_TYPE = "Response Type",
  HOVER_MARKUP_KIND_MARKWDOWN = "markdown",
  HOVER_MARKUP_KIND_PLAIN = "plaintext"

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


/*
 * @author Eros Fabrici
 */
init {
  println@Console( "txtDoc running" )()
}

main {

  [ didOpen( notification ) ]  {
      println@Console( "didOpen received" )()
      insertNewDocument@Utils( notification )
      doc.path = notification.textDocument.uri
      //syntaxCheck@SyntaxChecker( doc )
  }

  /*
   * Message sent from the L.C. when saving a document
   * Type: DidSaveTextDocumentParams, see types.iol
   */
  [ didChange( notification ) ] {
      println@Console( "didChange received " )()

      docModifications << {
        text = notification.contentChanges[0].text
        version = notification.textDocument.version
        uri = notification.textDocument.uri
      }

      updateDocument@Utils( docModifications )
  }

  [ willSave( notification ) ] {
    //never received a willSave message though
    println@Console( "willSave received" )()
  }

  /*
   * Messsage sent from the L.C. when saving a document
   * Type: DidSaveTextDocumentParams, see types.iol
   */
  [ didSave( notification ) ] {
      println@Console( "didSave message received" )()
      //didSave message contains only the version and the uri of the doc
      //not the text! Therefore I get the document saved in the memory to get the text
      //the text found will match the actual text just saved in the file as
      //before this we surely received a didChange with the updated text
      getDocument@Utils( notification.textDocument.uri )( textDocument )
      docModifications << {
        text = textDocument.source
        version = notification.textDocument.version
        uri = notification.textDocument.uri
      }
      updateDocument@Utils( docModifications )
  }

  /*
   * Message sent from the L.C. when closing a doc
   * Type: DidCloseTextDocumentParams, see types.iol
   */
  [ didClose( notification ) ] {
      println@Console( "didClose received" )()
      deleteDocument@Utils( notification )

  }

  /*
   * RR sent sent from the client when requesting a completion
   * works for anything callable
   * @Request: CompetionParams, see types.iol
   * @Response: CompletionResult, see types.iol
   */
  [ completion( completionParams )( completionRes ) {
      println@Console( "Completion Req Received" )()
      completionRes.isIncomplete = false
      txtDocUri -> completionParams.textDocument.uri
      position -> completionParams.position

      if ( is_defined( completionParams.context ) ) {
        context -> completionParams.context
      }

      getDocument@Utils( txtDocUri )( document )
      //character that triggered the completion (@)
      //might be not defined
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
                  undef( temp )
                  if ( operationFound ) {
                    label = snippet = op.name + "@" + port.name
                    kind = 2 //method
                  }

                } else {
                  //@ triggered the completion
                  operationFound = ( op.name == operationNameTrimmed )
                  snippet = label = port.name
                  kind = 7
                }


                if ( operationFound ) {
                  //build the rest of the snippet to be sent
                  if ( is_defined( op.responseType ) ) {
                    //is a reqRes operation

                    if ( is_defined( op.requestType.name ) ) {
                      reqVar = op.requestType.name
                    } else {
                      reqVar = REQUEST_VAR
                    }

                    if ( is_defined( op.responseType.name ) ) {
                      resVar = op.responseType.name
                      if ( resVar == NATIVE_TYPE_VOID ) {
                        resVar = ""
                      }
                    } else {
                      resVar = RESPONSE_VAR
                    }
                    snippet += "( ${1:" + reqVar + "} )( ${2:" + resVar + "} )"
                  } else {
                    //is a OneWay operation
                    if ( is_defined( op.requestType.name ) ) {
                      notificationVar = op.requestType.name
                    } else {
                      notificationVar = NOTIFICATION
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
      }

      if ( !foundPort ) {
        completionRes.items = void
      }
      println@Console( "Sending completion Item to the client" )()
  } ]

  /*
   * RR sent sent from the client when requesting a hover
   * @Request: TextDocumentPositionParams, see types.iol
   * @Response: HoverResult, see types.iol
   */
  [ hover( hoverReq )( hoverResp ) {
      hoverResp = void
      println@Console( "hover req received.." )()
      textDocUri -> hoverReq.textDocument.uri
      getDocument@Utils( textDocUri )( document )

      line = document.lines[hoverReq.position.line]
      program -> document.jolieProgram
      trim@StringUtils( line )( trimmedLine )
      //regex that identifies a message sending to a port
      trimmedLine.regex = "([A-z]+)@([A-z]+)\\(.*"
      //.group[1] is operaion name, .group[2] port name
      find@StringUtils( trimmedLine )( findRes )
      if ( findRes == 0 ) {
        trimmedLine.regex = "\\[? ?( ?[A-z]+ ?)\\( ?[A-z]* ?\\)\\(? ?[A-z]* ?\\)? ?\\]? ?\\{?"
        //in this case, we have only group[1] as op name
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
            //we do not know the port name, so we search for each port we have
            //in the program
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

                    reqType -> op.requestType.name
                    reqTypeCode -> op.requestType.code

                    if ( is_defined( op.responseType ) ) {
                      resType -> op.responseType.name
                      resTypeCode -> op.responseType.code
                    } else {
                      resType = ""
                      resTypeCode = ""
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

        hoverInfo += "\n```\n*" + REQUEST_TYPE + "*: \n" + reqTypeCode
        if ( resTypeCode != "" ) {
          hoverInfo += "\n\n*" + RESPONSE_TYPE + "*: \n" + resTypeCode
        }

        //setting the content of the response
        hoverResp.contents << {
          kind = HOVER_MARKUP_KIND_MARKWDOWN
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
      //TODO, not finished, buggy, needs refactor
      println@Console( "signatureHelp Message Received" )(  )
      signatureHelp = void
      textDocUri -> txtDocPositionParams.textDocument.uri
      position -> txtDocPositionParams.position
      getDocument@Utils( textDocUri )( document )
      line = document.lines[position.line]
      program -> document.jolieProgram
      trim@StringUtils( line )( trimmedLine )
      trimmedLine.regex = "([A-z]+)@([A-z]+)"
      find@StringUtils( trimmedLine )( matchRes )
      valueToPrettyString@StringUtils( matchRes )( s )
      println@Console( s )(  )

      if ( matchRes == 0 ) {
        trimmedLine.regex = "\\[?([A-z]+)"
        find@StringUtils( trimmedLine )( matchRes )
        valueToPrettyString@StringUtils( matchRes )( s )
        println@Console( s )(  )
        if ( matchRes == 1 ) {
          opName -> matchRes.group[1]
          portName -> matchRes.group[2]

          if ( is_defined( portName ) ) {
            label = opName
          } else {
            label = opName + "@" + portName
          }
        }
      } else {
        opName -> matchRes.group[1]
        portName -> matchRes.group[2]
        label = opName + "@" + portName
      }
      // if we had a match
      foundSomething = false
      if ( matchRes == 1 ) {
          for ( port in program ) {

            if ( is_defined( portName ) ) {
              ifGuard = ( port.name == portName ) && is_defined( port.interface )
              foundSomething = true
            } else {
              ifGuard = is_defined( port.interface )
            }

            if ( ifGuard ) {
              for ( iFace in port.interface ) {
                if ( op.name == opName ) {
                  foundSomething = true
                  opRequestType = op.requestType.name

                  if ( is_defined( op.responseType ) ) {
                    opResponseType = op.responseType.name
                  }


                }
              }
            }
          }

          parametersLabel = opRequestType + " " + opResponseType
          if ( foundSomething ) {
            signatureHelp << {
              signatures << {
                label = label
                parameters << {
                  label = parametersLabel
                }
              }
            }
          }
        }

        valueToPrettyString@StringUtils( signatureHelp )( s )
        println@Console( s )(  )

      } ]
}
