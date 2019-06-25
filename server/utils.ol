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

inputPort Utils {
  Location: "local://Utils"
  Interfaces: UtilsInterface
}

outputPort JavaServiceInspector {
  Interfaces: InspectorInterface
}

embedded {
  Java: "lspservices.Inspector" in JavaServiceInspector
}

define inspect
{
  scope( a ) {
    saveProgram = true
    install( default =>
                //valueToPrettyString@StringUtils( a )( s )
                println@Console( "ERROR" )()
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
      }

      doc << {
        uri = uri
        source = docText
        version = version
      }

      global.textDocument[#global.textDocument] << doc

  }

  [ updateDocument( txtDocModifications ) ] {
      docText -> txtDocModifications.contentChanges[0].text[0]
      uri -> txtDocModifications.textDocument.uri
      newVersion -> txtDocModifications.textDocument.version
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
        println@Console( "document found" )()
        splitReq = docText
        splitReq.regex = "\n"
        split@StringUtils( splitReq )( splitRes )
        for ( line in splitRes.result ) {
          doc.lines[#doc.lines] = line
        }

        inspect

        if ( saveProgram ) {
          doc.jolieProgram << inspectionRes
        }

        doc << {
          source = docText
          version = newVersion
        }

        docsSaved[indexDoc] << doc
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
