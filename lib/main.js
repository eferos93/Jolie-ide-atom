const cp = require('child_process')
//const fs = require('fs')
const net = require('net')
const path = require('path')
const {shell} = require('electron')
const {AutoLanguageClient, DownloadFile} = require('atom-languageclient')

const serverLauncher = path.join(__dirname, '..', 'server.ol')

class JolieLanguageClient extends AutoLanguageClient {

  /**
   * @override
   */
  getGrammarScopes () { return [ 'source.jolie' ] }

  /**
   * @override
   */
  getLanguageName () { return 'Jolie' }

  /**
   * @override
   */
  getServerName () { return 'jolie-lang-server' }

 /**
  * @override
  * returns a promise of a child process
  * @returns {Promise<ChildProcess>} promise of the child process (server)
  */
  startServerProcess () {
      atom.notifications.addError('Start Server process')
      let tcpPort = 8080
      atom.notifications.addWarning(" "+tcpPort);
      //we spawn the jolie process with the given port

      return this.spawnServer(tcpPort, ['--trace', '-C', `Location_JolieLS=\"socket://localhost:${tcpPort}\"`, serverLauncher]);
      //once spawned, we connect the client to the socket and then resolve the child process
  }

  /**
   * this method will spawn a child process by running the command with the given args and define some event listeners
   * @param {[string]} extraArgs 
   * @returns {ChildProcessWithoutNullStreams} returns the Jolie child process
   */
  spawnServer (tcpPort, extraArgs) {
    return new Promise((resolve, reject) => {
    const command = 'jolie'
    const serverHome = path.join(__dirname, '..')
    //this.logger.debug(`starting "${command} ${args.join(' ')}"`)
    const childProcess = cp.spawn(command, extraArgs, { cwd: serverHome })
    // EVENT LISTENERS
    this.captureServerErrors(childProcess)
    childProcess.on("error", err => {
      atom.notifications.addError('IDE-Jolie error. '+err)
    })

    //do we really this event listener?
    childProcess.stdout.on("data", (mess) => {
      if ( String(mess).trim().includes( "Started" ) ) {
        //if the jolie process has started, we resolve the childProcess
        //this.socket = net.createConnection( { port : tcpPort } )
        console.log("partitoooooooooooooooooo")
        atom.notifications.addWarning("partitooooo")
        this.socket = net.createConnection( { port : tcpPort, host:'localhost' } )
        resolve(childProcess)
      } else {
        //otherwise we reject it
        //error(Error("Something went wrong..."))
        console.log(" " + mess);
      }
     })

     childProcess.stderr.on("data", (mess) => {
      console.log(" " + mess);
     })

    childProcess.on('exit', exitCode => {
      if (exitCode != 0 && exitCode != null) 
        atom.notifications.addError('IDE-Jolie language server stopped unexpectedly.', {
        dismissable: true,
        description: this.processStdErr != null ? `<code>${this.processStdErr}</code>` : `Exit code ${exitCode}`
        })
    })
    atom.notifications.addError('Fin qua ci siamo 2')
  });
  }
}

 /*  spawnServerWithSocket () {
    //return new Promise((resolve, reject) => {
      //let childProcess
       const server = net.createServer(socket => {
        // When the language server connects, grab socket, stop listening and resolve
        this.socket = socket
        atom.notifications.addWarning("Ciaoooooone")
        server.close()
        resolve(childProcess)
      }) 
      //server.listen(0, 'localhost', () => {
        let port = 8080
        atom.notifications.addWarning(" "+port);
        // Once we have a port assigned spawn the Language Server with the port
        console.log(`Location_JolieSP=\"socket://localhost:${port}\"`)
        return this.spawnServer(['--trace', '-C', `Location_JolieLS=\"socket://localhost:${port}\"`, serverLauncher], port);
        //childProcess = this.spawnServer([serverLauncher, "hola"])
      //})
    //})
  } */

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


module.exports = new JolieLanguageClient()
