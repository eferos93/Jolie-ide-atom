const cp = require('child_process')
//const req = require('request')
const fs = require('fs')
const net = require('net')
const path = require('path')
const {shell} = require('electron')
const {AutoLanguageClient, DownloadFile} = require('atom-languageclient')

const serverLauncher = path.join(__dirname, '..', 'server.ol')

class JolieLanguageClient extends AutoLanguageClient {
  /*
  @override
  */
  getGrammarScopes () { return [ 'source.jolie' ] }
  /*
  @override
  */
  getLanguageName () { return 'Jolie' }
  /*
  @override
  */
  getServerName () { return 'jolie-lang-server' }

  /*
  provideAutocomplete() {
    const provide = super.provideAutocomplete()
    provide.inclusionPriority = atom.config.get('ide-php.autocompletePriority') === 'lower' ? 2 : 1
    provide.suggestionPriority = atom.config.get('ide-php.autocompletePriority') === 'lower' ? 1 : 2
    return provide
  }
  */

  /*
  onDidConvertAutocomplete(completionItem, suggestion, request) {
    if (/<[a-z][\s\S]*>/i.test(suggestion.description)) {
      suggestion.descriptionMarkdown = suggestion.description.replace(/\n/g, '');
    }
  }
  */

 /*
  @override
  */
  startServerProcess () {
    atom.notifications.addError('Start Server process')
    this.socket = net.connect({port: 8090, host: 'localhost'})
    return this.spawnServerWithSocket()
    //const serverHome = path.join(__dirname, '..', 'server.ol')
    //return this.spawnServerWithSocket();
    //return this.getOrInstallServer(serverHome).then(() =>
      //this.getConnectionType() === 'socket' ? this.spawnServerWithSocket() : this.spawnServer()
  }

  spawnServerWithSocket () {
    atom.notifications.addError('spawn server with socket')
    return new Promise((resolve, reject) => {
      let childProcess
      //const server = net.createServer(socket => {
        // When the language server connects, grab socket, stop listening and resolve
        //this.socket = 8090
        //atom.notifications.addError("Ciao2")
        //server.close()
        
      //})
      //server.listen(0, '127.0.0.1', () => {
        // Once we have a port assigned spawn the Language Server with the port
        atom.notifications.addError('Chi di lo fardo scorbin scorbinaio del fardo ')
        childProcess = this.spawnServer([serverLauncher])
        resolve(childProcess)
        atom.notifications.addError("Ciao3");
        //childProcess = this.spawnServer([`--tcp=127.0.0.1:${server.address().port}`])
      //})
    })
  }

/*
  downloadPHP () {
    shell.openExternal('https://secure.php.net/downloads.php')
  }
*/

  spawnServer (extraArgs) {
      const command = 'jolie'
      const serverHome = path.join(__dirname, '..')
      //this.logger.debug(`starting "${command} ${args.join(' ')}"`)
      const childProcess = cp.spawn(command, extraArgs, { cwd: serverHome })
      atom.notifications.addError('Chi di lo fardo scorbin scorbinaio del fardo pt 2')
      this.captureServerErrors(childProcess)
      childProcess.on("error", err => {
        atom.notifications.addError('IDE-Jolie error. '+err)
      })
      /*childProcess.on("close", (exitCode, signal) => {
        if(exitCode != 0 && exitCode != null) {
          atom.notifications.addError('IDE-Jolie stopped unexpectedly.'+exitCode)
          atom.notifications.addWarning(this.processStdErr)
        }
      })*/
      childProcess.on("message", (mess) => {
        atom.notifications.addError(mess);
      })
      
      childProcess.on('exit', exitCode => {
        if (exitCode != 0 && exitCode != null) {
          atom.notifications.addError('IDE-Jolie language server stopped unexpectedly.', {
            dismissable: true,
            description: this.processStdErr != null ? `<code>${this.processStdErr}</code>` : `Exit code ${exitCode}`
          })
        }
      })
      return childProcess
    }

  /*openPackageSettings() {
    atom.workspace.open('atom://config/packages/ide-php')
  }*/

  
  /*getConnectionType() {
    const configConnectionType = atom.config.get('ide-php.connectionType')
    switch (configConnectionType) {
      case 'auto':    return process.platform === 'win32' ? 'socket' : 'stdio';
      case 'socket':  return 'socket';
      case 'stdio':   return 'stdio';
      default:
        atom.notifications.addWarning('Invalid connection type setting', {
          dismissable: true,
          buttons: [ { text: 'Set Connection Type', onDidClick: () => this.openPackageSettings() } ],
          description: 'The connection type setting should be set to "auto", "socket" or "stdio". "auto" is "socket" on Windows and "stdio" on other platforms.'
        })
    }
  }*/

  /*fileExists (path) {
    return new Promise((resolve, reject) => {
      fs.access(path, fs.R_OK, error => {
        resolve(!error || error.code !== 'ENOENT')
      })
    })
  }

  deleteFileIfExists (path) {
    return new Promise((resolve, reject) => {
      fs.unlink(path, error => {
        if (error && error.code !== 'ENOENT') { reject(error) } else { resolve() }
      })
    })
  }*/
}

module.exports = new JolieLanguageClient()
