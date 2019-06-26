# Jolie Ide for Atom

A language client plug-in for atom + the language server written in Jolie

# Features working

* Text Synchronization
* Completion for operations/ports
* Diagnostics

# In progress

* signatureHelp

# Installation

Clone the repository inside your Atom's packages directory.
Dependencies will be installed automatically when launching atom, if not, open
a terminal in the jolie-ide-atom directory and run *apm install*

# Note:

* the socket is allocated statically by the client, check lib/main.js
* tested only in Linux environment
* Requires the last version of Jolie. Download and install at https://github.com/jolie/jolie
