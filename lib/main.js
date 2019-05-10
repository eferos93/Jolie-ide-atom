const cp = require('child_process')
const net = require('net')
const path = require('path')
//const {shell} = require('electron')
const {AutoLanguageClient, DownloadFile} = require('atom-languageclient')

const serverLauncher = path.join(__dirname, '..', 'server', 'server.ol')

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
   */
  activate() {
    if(process.env["JOLIE_HOME"] === undefined) {
      process.env["JOLIE_HOME"] = "/usr/lib/jolie"
      //TODO check if the OS is Linux or Windows
    }
    super.activate()
  }
 /**
  * @override
  * returns a promise of a child process
  * @returns {Promise<ChildProcessWithoutNullStreams>} promise of the child process (server)
  */
  startServerProcess () {
    /* if(process.env["JOLIE_HOME"] === undefined) {
      process.env["JOLIE_HOME"] = "/usr/lib/jolie"
      //TODO check if the OS is Linux or Windows
    } */
    //process.env["JOLIE_HOME"] = "/usr/lib/jolie"
    atom.notifications.addError('Start Server process')
    let tcpPort = 8080
    //let random = Math.floor(Math.random()*1000+10000)
    //we spawn the jolie process with the given port
    return this.spawnServer(tcpPort, ['--trace', '-C', `Location_JolieLS=\"socket://localhost:${tcpPort}\"`, serverLauncher]);
  }

  /**
   * this method will spawn a child process by running the command with the given args and define some event listeners
   * @param {[string]} extraArgs
   * @param {number} tcpPort
   * @returns {Promise<ChildProcessWithoutNullStreams>} returns the  promise  of Jolie child process
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
        this.deactivate()
      })

      childProcess.stdout.on("data", (mess) => {
        if ( String(mess).includes( "Jolie Language Server Started" ) ) {
          //if the jolie process has started, we connect the client to the socket and resolve the childProcess
          atom.notifications.addWarning("partitooooo")
          this.socket = net.createConnection( { port : tcpPort, host:'localhost' } )
          resolve(childProcess)
        } else {
          //otherwise, we just print the message
          console.log(String(mess));
        }
      })

      /*childProcess.stderr.on("data", (mess) => {
        console.log(" " + mess);
      })*/

      childProcess.on('exit', exitCode => {
        if (exitCode != 0 && exitCode != null) {
          atom.notifications.addError('IDE-Jolie language server stopped unexpectedly.', {
          dismissable: true,
          description: this.processStdErr != null ? `<code>${this.processStdErr}</code>` : `Exit code ${exitCode}`
          })
        }
        this.deactivate()
      })
      process.on("beforeExit", () => {
        console.log("chiudo i server")
        this.deactivate();
      })
      atom.notifications.addError('Fin qua ci siamo')
    })
  }
}

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
 
   /**
   * Atom, on startup, load first the extensions than the enviromental vars
   * @param {int} i counter 
   */
  /* tryStart(i) {
    if(i>0) {
      let temp = this
      setTimeout(function() {temp.tryStart(i-1)}, 1000)
    /* } else if (i<=0) {
      atom.motification.addError("Environmental var JOLIE_HOME not found, probably Jolie is not installed")
      this.deactivate() 
    } else {
      atom.notifications.addError('Start Server process')
      let tcpPort = 8080
      //let random = Math.floor(Math.random()*1000+10000)
      //we spawn the jolie process with the given port
      return this.spawnServer(tcpPort, ['--trace', '-C', `Location_JolieLS=\"socket://localhost:${tcpPort}\"`, serverLauncher]);
    }
  } */
  

module.exports = new JolieLanguageClient()
