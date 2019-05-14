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

type TextDocumentIdentifier: void {
  .uri: DocumentUri
}

type VersionedTextDocumentIdentifier: void {
  .uri: DocumentUri
  .version: int | void
}

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
    .willSaveWaitUntil?: bool
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
    .dynamicRegistration?: bool
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
    .dynamicRegistration?: bool
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

type InitializedParams: void

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

type DidOpenTextDocumentParams: void {
  .textDocument: TextDocumentItem
}

type TextDocumentItem: void {
  /**
	 * The text document's URI.
	 */
	.uri: DocumentUri
	/**
	 * The text document's language identifier.
	 */
	.languageId: string
	/**
	 * The version number of this document (it will increase after each
	 * change, including undo/redo).
	 */
	.version: int
	/**
	 * The content of the opened text document.
	 */
	.text: string
}

type DidChangeTextDocumentParams: void {
  /**
   * The document that did change. The version number points
   * to the version after all provided content changes have
   * been applied.
   */
  .textDocument: VersionedTextDocumentIdentifier //do
	/**
	 * The actual content changes. The content changes describe single state changes
	 * to the document. So if there are two content changes c1 and c2 for a document
	 * in state S then c1 move the document to S' and c2 to S''.
	 */
	.contentChanges[1,*]: TextDocumentContentChangeEvent
}

type TextDocumentContentChangeEvent: void {
  /**
	 * The range of the document that changed.
	 */
	.range?: Range
	/**
	 * The length of the range that got replaced.
	 */
	.rangeLength?: int
	/**
	 * The new text of the range/document.
	 */
	.text: string
}

type Range: void {
  .start: Position
  .end: Position
}

type Position: void {
  /**
	 * Line position in a document (zero-based).
	 */
	.line: int

	/**
	 * Character offset on a line in a document (zero-based). Assuming that the line is
	 * represented as a string, the `character` value represents the gap between the
	 * `character` and `character + 1`.
	 *
	 * If the character value is greater than the line length it defaults back to the
	 * line length.
	 */
	.character: int
}

type WillSaveTextDocumentParams: void {
  .textDocument: TextDocumentIdentifier
  .reason: int // 1=Manual, 2=afterDelay, 3=FocusOut
}

type WillSaveWaitUntilResponse: TextEdit | void //TextEdit[1,*]

type DidSaveTextDocumentParams: void {
  .textDocument: VersionedTextDocumentIdentifier
  .text?: string
}

type DidCloseTextDocumentParams: void {
  .textDocument: VersionedTextDocumentIdentifier
}

type TextEdit: void {
  .range: Range
  .newText: string
}

type TextDocumentPositionParams: void {
  .textDocument: TextDocumentIdentifier
  .position: Position
}

type CompletionParams: void {
  .textDocument: TextDocumentIdentifier
  .position: Position
  .context?: CompletionContext
}

type CompletionContext: void {
  /**
	 * How the completion was triggered.
   * CompletionTriggerKind: 1 = Invoked, 2 = TriggerCharacter,
   *                        3 = TriggerForIncompleteCompletions
	 */
	.triggerKind: int

	/**
	 * The trigger character (a single character) that has trigger code complete.
	 * Is undefined if `triggerKind !== CompletionTriggerKind.TriggerCharacter`
	 */
	.triggerCharacter?: string
}

type CompletionList: void {
  /**
	 * This list it not complete. Further typing should result in recomputing
	 * this list.
	 */
	.isIncomplete: bool

	/**
	 * The completion items.
	 */
	.items: CompletionItem
}

type CompletionItem: void {
  /**
	 * The label of this completion item. By default
	 * also the text that is inserted when selecting
	 * this completion.
	 */
	.label: string

	/**
	 * The kind of this completion item. Based of the kind
	 * an icon is chosen by the editor. The standardized set
	 * of available values is defined in `CompletionItemKind`.
	 */
	.kind?: int

	/**
	 * A human-readable string with additional information
	 * about this item, like type or symbol information.
	 */
	.detail?: string

	/**
	 * A human-readable string that represents a doc-comment.
	 */
	.documentation?: string | MarkupContent

	/**
	 * Indicates if this item is deprecated.
	 */
	.deprecated?: bool

	/**
	 * Select this item when showing.
	 *
	 * *Note* that only one completion item can be selected and that the
	 * tool / client decides which item that is. The rule is that the *first*
	 * item of those that match best is selected.
	 */
	.preselect?: bool

	/**
	 * A string that should be used when comparing this item
	 * with other items. When `falsy` the label is used.
	 */
	.sortText?: string

	/**
	 * A string that should be used when filtering a set of
	 * completion items. When `falsy` the label is used.
	 */
	.filterText?: string

	/**
	 * A string that should be inserted into a document when selecting
	 * this completion. When `falsy` the label is used.
	 *
	 * The `insertText` is subject to interpretation by the client side.
	 * Some tools might not take the string literally. For example
	 * VS Code when code complete is requested in this example `con<cursor position>`
	 * and a completion item with an `insertText` of `console` is provided it
	 * will only insert `sole`. Therefore it is recommended to use `textEdit` instead
	 * since it avoids additional client side interpretation.
	 *
	 * @deprecated Use textEdit instead.
	 */
	.insertText?: string

	/**
	 * The format of the insert text. The format applies to both the `insertText` property
	 * and the `newText` property of a provided `textEdit`.
	 */
	.insertTextFormat?: int //namespace: 1 = plainText, 2 = Snippet

	/**
	 * An edit which is applied to a document when selecting this completion. When an edit is provided the value of
	 * `insertText` is ignored.
	 *
	 * *Note:* The range of the edit must be a single line range and it must contain the position at which completion
	 * has been requested.
	 */
	.textEdit?: TextEdit

	/**
	 * An optional array of additional text edits that are applied when
	 * selecting this completion. Edits must not overlap (including the same insert position)
	 * with the main edit nor with themselves.
	 *
	 * Additional text edits should be used to change text unrelated to the current cursor position
	 * (for example adding an import statement at the top of the file if the completion item will
	 * insert an unqualified type).
	 */
	.additionalTextEdits?: TextEdit

	/**
	 * An optional set of characters that when pressed while this completion is active will accept it first and
	 * then type that character. *Note* that all commit characters should have `length=1` and that superfluous
	 * characters will be ignored.
	 */
	.commitCharacters*: string

	/**
	 * An optional command that is executed *after* inserting this completion. *Note* that
	 * additional modifications to the current document should be described with the
	 * additionalTextEdits-property.
	 */
	.command?: Command

	/**
	 * A data entry field that is preserved on a completion item between
	 * a completion and a completion resolve request.
	 */
	.data?: any
}

/**
 * A `MarkupContent` literal represents a string value which content is interpreted base on its
 * kind flag. Currently the protocol supports `plaintext` and `markdown` as markup kinds.
 *
 * If the kind is `markdown` then the value can contain fenced code blocks like in GitHub issues.
 * See https://help.github.com/articles/creating-and-highlighting-code-blocks/#syntax-highlighting
 *
 * Here is an example how such a string can be constructed using JavaScript / TypeScript:
 * ```typescript
 * let markdown: MarkdownContent = {
 *  kind: MarkupKind.Markdown,
 *	value: [
 *		'# Header',
 *		'Some text',
 *		'```typescript',
 *		'someCode();',
 *		'```'
 *	].join('\n')
 * };
 * ```
 *
 * *Please Note* that clients might sanitize the return markdown. A client could decide to
 * remove HTML from the markdown to avoid script execution.
 */
type MarkupContent: void {
  .kind: undefined
  .value: string
}

type Command: void {
  .title: string
  .command: string
  .arguments*: undefined
}

type CompletionResult: CompletionItem | CompletionList | void //CompletionItem[1,*]

type DidChangeWatchedFilesParams: void {
  .changes[1,*]: FileEvent
}

type FileEvent: void {
  .uri: DocumentUri
  /**
   * 1 = created, 2 = Changed, 3 = Deleted
   */
  .type: int
}

type DidChangeWorkspaceFoldersParams: void {
  .event: WorkspaceFolderChangeEvent
}

type WorkspaceFolderChangeEvent: void {
  .added[1,*]: WorkspaceFolder
  .removed[1,*]: WorkspaceFolder
}

type DidChangeConfigurationParams: void {
  .settings: undefined
}

type WorkspaceSymbolParams: void {
  .query: string
}

type SymbolInformation: void | void {
  /**
	 * The name of this symbol.
	 */
	.name: string
	/**
	 * The kind of this symbol.
	 */
	.kind: int
	/**
	 * Indicates if this symbol is deprecated.
	 */
	.deprecated?: bool
	/**
	 * The location of this symbol. The location's range is used by a tool
	 * to reveal the location in the editor. If the symbol is selected in the
	 * tool the range's start information is used to position the cursor. So
	 * the range usually spans more then the actual symbol's name and does
	 * normally include things like visibility modifiers.
	 *
	 * The range doesn't have to denote a node range in the sense of a abstract
	 * syntax tree. It can therefore not be used to re-construct a hierarchy of
	 * the symbols.
	 */
	.location: Location

	/**
	 * The name of the symbol containing this symbol. This information is for
	 * user interface purposes (e.g. to render a qualifier in the user interface
	 * if necessary). It can't be used to re-infer a hierarchy for the document
	 * symbols.
	 */
	.containerName?: string
}

type Location: void {
  .uri: DocumentUri
  .range: Range
}

type ExecuteCommandParams: void {
  .command: string
  .arguments*: undefined
}

type ExecuteCommandResult: undefined
