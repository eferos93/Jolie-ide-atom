include "console.iol"
include "ls_jolie.iol"
include "string_utils.iol"
/*
 * The main aim of this service is to keep saved
 * in global.textDocument all the documents open
 * and keep them updated. The type of global.textDocument
 * is TextDocument and it is defined in types.iol
 */
execution{ concurrent }

constants {
  INTEGER_MAX_VALUE = 2147483647
}

inputPort Utils {
  Location: "local://Utils"
  Interfaces: UtilsInterface
}

outputPort JavaServiceInspector {
  Interfaces: InspectorInterface
}

outputPort Client {
  location: "local://Client"
  Interfaces: ServerToClient
}

embedded {
  Java: "lspservices.Inspector" in JavaServiceInspector
}

define inspect
{
  scope( inspection ) {
    saveProgram = true
    install( default =>
                stderr = inspection.default
                stderr.regex =  "\\s*(.+):\\s*(\\d+):\\s*(error|warning)\\s*:\\s*(.+)"
                find@StringUtils( stderr )( matchRes )
                valueToPrettyString@StringUtils( matchRes )( str )
                println@Console( str )(  )
                //getting the uri of the document to be checked
                //have to do this because the inspector, when returning an error,
                //returns an uri that looks the following:
                // /home/eferos93/.atom/packages/Jolie-ide-atom/server/file:/home/eferos93/.atom/packages/Jolie-ide-atom/server/utils.ol
                //same was with jolie --check
                indexOfReq = matchRes.group[1]
                indexOfReq.word = "file:"
                indexOf@StringUtils( indexOfReq )( indexOfRes )
                subStrReq = matchRes.group[1]
                subStrReq.begin = indexOfRes + 5
                length@StringUtils( matchRes.group[1] )( subStrReq.end )
                substring@StringUtils( subStrReq )( documentUri )//line
                //line
                l = int( matchRes.group[2] )
                //severity
                sev -> matchRes.group[3]
                //TODO alwayes return error, never happend to get a warning
                //but this a problem of the jolie parser
                if ( sev == "error" ) {
                  s = 1
                }

                diagnosticParams << {
                  uri = documentUri
                  diagnostics << {
                    range << {
                      start << {
                        line = l-1
                        character = INTEGER_MAX_VALUE
                      }
                      end << {
                        line = l-1
                        character = INTEGER_MAX_VALUE
                      }
                    }
                    severity = s
                    source = "jolie"
                    message = matchRes.group[4]
                  }
                }
                publishDiagnostics@Client( diagnosticParams )

                saveProgram = false
    )

    inspectionReq << {
      filename = uri
      source = docText
    }
    inspectProgram@JavaServiceInspector( inspectionReq )( inspectionRes )
  }

}


init {
  println@Console( "Utils Service started" )(  )
}

main {
  [ insertNewDocument( newDoc ) ] {
      docText -> newDoc.textDocument.text
      uri -> newDoc.textDocument.uri
      version -> newDoc.textDocument.version
      splitReq = docText
      splitReq.regex = "\n"
      split@StringUtils( splitReq )( splitRes )
      for ( line in splitRes.result ) {
        doc.lines[#doc.lines] = line
      }

      inspect

      if ( saveProgram ) {
        doc.jolieProgram << inspectionRes
        diagnosticParams << {
          uri = uri
          diagnostics = void
        }
        publishDiagnostics@Client( diagnosticParams )
      }

      doc << {
        uri = uri
        source = docText
        version = version
      }

      global.textDocument[#global.textDocument] << doc
  }

  [ updateDocument( txtDocModifications ) ] {
      docText -> txtDocModifications.text
      uri -> txtDocModifications.uri
      newVersion -> txtDocModifications.version
      docsSaved -> global.textDocument
      found = false
      for ( i = 0, i < #docsSaved && !found, i++ ) {
        if ( docsSaved[i].uri == uri ) {
          found = true
          indexDoc = i
        }
      }
      //TODO is found == false, throw ex (should never happen though)
      if ( found && docsSaved[indexDoc].version < newVersion ) {
        splitReq = docText
        splitReq.regex = "\n"
        split@StringUtils( splitReq )( splitRes )
        for ( line in splitRes.result ) {
          doc.lines[#doc.lines] = line
        }

        inspect

        if ( saveProgram ) {
          doc.jolieProgram << inspectionRes
          diagnosticParams << {
            uri = uri
            diagnostics = void
          }
          publishDiagnostics@Client( diagnosticParams )
        }

        doc << {
          source = docText
          version = newVersion
        }

        docsSaved[indexDoc] << doc
      } else {
        inspect

        if ( saveProgram ) {
          doc.jolieProgram << inspectionRes
          diagnosticParams << {
            uri = uri
            diagnostics = void
          }
          publishDiagnostics@Client( diagnosticParams )
        }
      }
  }

  [ deleteDocument( txtDocParams ) ] {
      uri -> txtDocParams.textDocument.uri
      docsSaved -> global.textDocument
      keepRunning = true
      for ( i = 0, i < #docsSaved && keepRunning, i++ ) {
        if ( uri == docsSaved[i].uri ) {
          undef( docsSaved[i] )
          keepRunning = false
        }
      }
  }

  [ getDocument( uri )( txtDocument ) {
      docsSaved -> global.textDocument
      found = false
      for ( i = 0, i < #docsSaved && !found, i++ ) {
        if ( docsSaved[i].uri == uri ) {
          txtDocument << docsSaved[i]
          found = true
        }
      }

      if ( !found ) {
        //TODO if found == false throw exception
        println@Console( "doc not found!!!" )()
      }


  } ]
}
