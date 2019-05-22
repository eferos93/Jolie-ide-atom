include "console.ol"

interface TreeInterface {
  RequestResponse:
    insert( undefined )( Tree ),
    delete( undefined )( Tree )
}

type Tree: Node {
  .node[1,2]: Node | Tree
}

type Node {
  .doc: TextDocumentItem
}

inputPort TreeUtils {
  Location: "local"
  Protocol: soap
  Interfaces: TreeInterface
}

main {
  insert()()
}
