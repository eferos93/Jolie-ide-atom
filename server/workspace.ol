execution{ concurrent }

inputPort WorkspaceInput {
  Location: "local"
  Interfaces: WorkspaceInterface
}

init {
  println@Console( "workspace running" )()
}

main {
  [ didChangeWatchedFiles( notification ) ] {
    println@( "Received didChangedWatchedFiles" )()
  }
}
