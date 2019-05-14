type InitializeParams: void {
  .processId: int | void
  .rootPath?: string | void
  .rootUri: DocumentUri | void
  .initializationOptions?: undefined
  .capabilities: ClientCapabilities
  .trace?: string // "off" | "messages" | "verbose"
  .workspaceFolders*: WorkspaceFolder | void
}

type WorkspaceFolder: void {
  .uri: string
  .name: string
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

type ResourceOperationKind: string //namespace
type FailureHandlingKind: string //namespace
type MarkupKind: string //namespace
type SymbolKind: int //namespace
type CompletionItemKind: int // namespace
type CodeActionKind: string //namespace

type TextDocumentClientCapabilities: void {
  .synchronization?: void {
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
    .dynamicRegistration?: bool
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
  .textDocumentSync?: TextDocumentSyncOptions | int
  .hoverProvider?: bool
  .completionProvider?: CompletionOptions
  .signatureHelpProvider?: SignatureHelpOptions
  .definitionProvider?: bool
  .typeDefinitionProvider?: undefined //do vedi specifiche
  .implementationProvider?: undefined //do vedi specifiche
  .referenceProvider?: undefined //do see specification
  .documentHighlightProvider?: bool
  .documentSymbolProvider?: bool
  .codeActionProvider?: CodeLensOptions
  .documentFormattingProvider?: bool
  .documentRangeFormattingProvider?: bool
  .documentOnTypeFormattingProvider?: DocumentOnTypeFormattingOptions
  .renameProvider?: bool | RenameOptions
  .documentLinkProvider?: DocumentLinkOptions
  .colorProvider?: undefined //do see specification
  .foldingRangeProvider?: undefined //do see specification
  .declarationProvider?: undefined //see specification
  .executeCommandProvider?: ExecuteCommandOptions
  .workspace?: void {
    .workspaceFolders?: void {
      .supported?: bool
      .changeNotifications?: string | bool
    }
  }
  .experimental?: undefined
}

type ExecuteCommandOptions: void {
  /**
   * The commands to be executed on the server
   */
  .commands[1,*]: string
}

type DocumentLinkOptions: void {
  /**
	 * Document links have a resolve provider as well.
	 */
	.resolveProvider?: bool
}

type RenameOptions: void {
  /**
   * Renames should be checked and tested before being executed.
   */
  .prepareProvider?: bool
}

type DocumentOnTypeFormattingOptions: void {
  /**
   * A character on which formatting should be triggered, like `}`.
   */
  .firstTriggerCharacter: string
  /**
   * More trigger characters.
   */
  .moreTriggerCharacter*: string
}

type CodeLensOptions: void {
  /**
	 * Code lens has a resolve provider as well.
	 */
   .resolveProvider?: bool
}
type SignatureHelpOptions: void {
  /**
   * The characters that trigger signature help
   * automatically.
   */
  .triggerCharacters*: string
}

type CompletionOptions: void {
  /**
	 * The server provides support to resolve additional
	 * information for a completion item.
	 */
   .resolveProvider?: bool
	/**
	 * The characters that trigger completion automatically.
	 */
   .triggerCharacters*: string
}

type TextDocumentSyncOptions: void {
  /**
	 * Open and close notifications are sent to the server. If omitted open close notification should not
	 * be sent.
	 */
  .openClose?: bool
  /**
	 * Change notifications are sent to the server. See TextDocumentSyncKind.None, TextDocumentSyncKind.Full
	 * and TextDocumentSyncKind.Incremental. If omitted it defaults to TextDocumentSyncKind.None.
	 */
  .change?: int
  /**
	 * If present will save notifications are sent to the server. If omitted the notification should not be
	 * sent.
	 */
  .willSave?: bool
	/**
	 * If present will save wait until requests are sent to the server. If omitted the request should not be
	 * sent.
	 */
	.willSaveWaitUntil?: bool
	/**
	 * If present save notifications are sent to the server. If omitted the notification should not be
	 * sent.
	 */
  .save?: SaveOptions
}

type SaveOptions: void {
  .includeText?: bool
}
