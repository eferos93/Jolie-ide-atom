include "console.iol"
include "ls_jolie.iol"
include "exec.iol"
include "file.iol"
include "string_utils.iol"

execution{ concurrent }

inputPort SyntaxChecker {
  Location: "local"
  Protocol: soap
  Interfaces: SyntaxCheckerInterface
}

main {
  syntaxCheck( code )( syntaxCheckResult ) {
    file.filename = new + ".ol"
    file.content = code
    writeFile@File( file )()
    cmd = "jolie"
    cmd.args[0] = "--check"
    cmd.args[1] = file.filename
    cmd.stdOutConsoleEnable = true
    cmd.waitFor = 1
    exec@Exec( cmd )( result )
    valueToPrettyString@StringUtils( result )( syntaxCheckResult )
  }
}
