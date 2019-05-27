include "console.iol"
include "ls_jolie.iol"
include "exec.iol"
include "file.iol"
include "string_utils.iol"

execution{ concurrent }

inputPort SyntaxChecker {
  Location: "local"
  Interfaces: SyntaxCheckerInterface
}

main {
  syntaxCheck( code )( syntaxCheckResult ) {
    messageRegex = "\s*(?<file>.+):\s*(?<line>\d+):\s*(?<type>error|warning)\s*:\s*(?<message>.+)"
    file.filename = new + ".ol"
    file.content = code
    writeFile@File( file )()
    cmd = "jolie"
    cmd.args[0] = "--check"
    cmd.args[1] = file.filename
    cmd.stdOutConsoleEnable = true
    cmd.waitFor = 1
    exec@Exec( cmd )( result )
    delete@File( file.filename )()
    if ( result.exiCode != 0 ) {
      matchReq = result.stderr
      matchReq.regex = messageRegex
      match@StringUtils( matchReq )( matchRes )
    }
    valueToPrettyString@StringUtils( matchRes )( syntaxCheckResult )
  }
}
