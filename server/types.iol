type InitializeParams: void {
  .processId: int | void
  .rootPath?: string | void
  .rootUri: DocumentUri | void
  .initializationOptions?: undefined
  .capabilities: ClientCapabilities
  .trace?: "off" | "messages" | "verbose"
  .workspaceFolders*: WorkspaceFolder | void
}

type DocumentUri: string

type ClientCapabilities: void {
  .workspace?: WorkspaceClientCapabilities
  .textDocument?: TextDocumentClientCapabilities
  .experimental?: undefined
}

type WorkspaceClientCapabilities: void {
  .applyEdit?: bool
  .workspaceEdit?: void {
    .documentChanges?: bool
    .resourceOperations*: ResourceOperationKind
    .failureHandling?: FailureHandlingKind
  }
  .didChangeConfiguration?: void {
    .dynamicRegistration?: bool
  }
  .didChangeWatchedFiles?: void {
    .dynamicRegistration?: bool
  }
  .symbol?: void {
    .dynamicRegistration?: bool
    .symbolKind?: void {
      .valueSet*: SymbolKind
    }
  }
  .executeCommand?: void {
    .dynamicRegistration?: bool
  }
  .workspaceFolders?: bool
  .configuration?: bool
}

type ResourceOperationsKind: string //namespace
type FailureHandlingKind: string //namespace
type MarkupKind: string //namespace
type SymbolKind: int //namespace
type CompletionItemKind: int // namespace
type CodeActionKind: string //namespace

type TextDocumentClientCapabilities: void {
  .synchronization?: {
    .dynamicRegistration?: bool
    .willSave?: bool
    .willSaveUntil?: bool
    .didSave?: bool
  }
  .completion?: void {
    .dynamicRegistration?: bool
    .completionItem?: void {
      .snippetSupport?: bool
      .commitCharactersSupport?: bool
      .documentationFormat*: MarkupKind
      .deprecatedSupport?: bool
      .preselectSupport?: bool
    }
    .completionItemKind?: void {
      .valueSet*: CompletionItemKind
    }
    .contextSupport?: bool
  }
  .hover?: void {
    .dynamicRegistration?: bool
    .contentFormat*: MarkupKind
  }
  .signatureHelp?: void {
    .dynamicRegistration?: bool
    .signatureInformation?: void {
      .documentFormat*: MarkupKind
      .parameterInformation?: void {
        .labelOffsetSupport?: bool
      }
    }
  }
  .references?: void {
    .dynamicRegistration?: void
  }
  .documentHighlight?: void {
    .dynamicRegistration?: bool
  }
  .documentSymbol?: void {
    .dynamicRegistration?: bool
    .symbolKind?: void {
      .valueSet*: SymbolKind
    }
    .hierarchicalDocumentSymbolSupport?: bool
  }
  .formatting?: void {
    .dynamicRegistration?: bool
  }
  .rangeFormatting?: void {
    .dynamicRegistration?: bool
  }
  .onTypeFormatting?: void {
    .dynamicRegistration?: bool
  }
  .declaration?: void {
    .dynamicRegistration?: bool
    .linkSupport?: bool
  }
  .definition?: void {
    .dynamicRegistration?: bool
    .linkSupport?: bool
  }
  .typeDefinition?: void {
    .dynamicRegistration?: bool
    .linkSupport?: bool
  }
  .implementation?: void {
    .dynamicRegistration:? bool
    .linkSupport?: bool
  }
  .codeAction?: void {
    .dynamicRegistration?: bool
    .codeActionLiteralSupport?: void {
      .codeActionKind: void {
        .valueSet[1,*]: CodeActionKind
      }
    }
  }
  .codeLens?: void {
    .dynamicRegistration?: bool
  }
  .documentLink?: void {
    .dynamicRegistration?: void
  }
  .rename?: void {
    .dynamicRegistration?: bool
    .prepareSupport?: bool
  }
  .publishDiagnostics?: void {
    .relatedInformation?: bool
  }
  .foldingRange?: void {
    .dynamicRegistration?: bool
    .rangeLimit?: int
    .lineFoldingOnly?: bool
  }
}

type InitializeResult: void {
  .capabilities: ServerCapabilities
}

type ServerCapabilities: void {
  .textDocumentSync?: TextDocumentSyncOptions | int //do
  .hoverProvider?: bool
  .completionProvider?: CompletionOptions //do
  .signatureHelpProvider?: SignatureHelpProvider //do
  .definitionProvider?: bool
  .typeDefinitionProvider?: bool //do vedi specifiche
  .implementationProvider?: bool //do vedi specifiche
  .referenceProvider?: bool //do see specification
  .documentHighlightProvider?: bool
  .documentSymbolProvider?: bool
  .codeActionProvider?: CodeLensOptions //do
  .documentFormattingProvider?: bool
  .documentRangeFormattingProvider?: bool
  .documentOnTypeFormattingProvider?: DocumentOnTypeFormattingOptions //do
  .renameProvider?: bool | RenameOptions //do
  .documentLinkProvider?: DocumentLinkOptions //do
  .colorProvider?: bool | ColorProviderOptions //do see specification
  .foldingRangeProvider?: bool | FoldingRangeProviderOptions //do see specification
  .declarationProvider?: bool //see specification
  .executeCommandProvider?: ExecuteCommandOptions //do
  .workspace?: void {
    .workspaceFolders?: void {
      .supported?: bool
      .changeNotifications?: string | bool
    }
  }
  .experimental?: undefined
}
