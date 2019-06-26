# Jolie Ide for Atom

A language client plug-in for atom + the language server written in Jolie

# Features so far working

* Text Synchronization
* Completion for operations/ports
* Diagnostics

# In progress

* signatureHelp

# Installation

Clone the repository inside your Atom's packages directory.
Dependencies will be installed automatically when launching atom

# Note:

* the socket is allocated statically by the client, check lib/main.js
* tested only in Linux environment
* Requires the last version of Jolie downloadable from the [Jolie rep](https://github.com/jolie/jolie)
