const cp = require('child_process')
const net = require('net')
const path = require('path')
const {AutoLanguageClient, DownloadFile} = require('atom-languageclient')
const FreePort = require('find-free-port')

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
  getServerName () { return 'jolie-ide' }

 /**
  * @override
  * returns a promise of a child process
  * @returns {Promise<ChildProcessWithoutNullStreams>} promise of the child process (server)
  */
  startServerProcess () {
    if(process.env["JOLIE_HOME"] === undefined) {
      process.env["JOLIE_HOME"] = "/usr/lib/jolie"
      //TODO check if the OS is Linux or Windows
    }
    atom.config.set('core.debugLSP', true)
    atom.notifications.addError('Start Server process')
    const tcpPort = 8080
   /*  FreePort(8000, function(err, freePort, temp){
      if(err) {
        throw(err)
      }
      tcpPort = freePort
      console.log(tcpPort)
      return temp.spawnServer(tcpPort, ['-C', `Location_JolieLS=\"socket://localhost:${tcpPort}\"`, serverLauncher])
    }); */
/*     FreePort(8000).then((freePort) => {
      tcpPort = freePort
      return this.spawnServer(tcpPort, ['-C', `Location_JolieLS=\"socket://localhost:${tcpPort}\"`, serverLauncher])
    }) */
    /* server.listen(0, '127.0.0.1', () => {
      tcpPort = server.address().port
      console.log(tcpPort + " first")
      server.close()
      return this.spawnServer(tcpPort, ['-C', `Location_JolieLS=\"socket://localhost:${tcpPort}\"`, serverLauncher])
    }) */
    //console.log(tcpPort + " second")
    //let random = Math.floor(Math.random()*1000+10000)
    //we spawn the jolie process with the given port
    return this.spawnServer(tcpPort, ['-C', `Location_JolieLS=\"socket://localhost:${tcpPort}\"`, serverLauncher])
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
      const serverHome = path.join(__dirname, '..', 'server')
      this.logger.debug(`starting "${command} ${extraArgs.join(' ')}"`)
      const childProcess = cp.spawn(command, extraArgs, { cwd: serverHome })

      // EVENT LISTENERS
      this.captureServerErrors(childProcess)

      childProcess.stdout.on('data', (mess) => {
        const message = String(mess)
        if ( message.includes( "Jolie-IDE Server Started" ) ) {
          //if the jolie process has started, we connect the client to the socket and resolve the childProcess
          atom.notifications.addInfo("Partiamo")
          this.socket = net.createConnection( { port : tcpPort, host:'localhost' } )
          resolve(childProcess)
        }
        console.log(message);
      })

      childProcess.on('exit', exitCode => {
        if (exitCode != 0 && exitCode != null)
          atom.notifications.addError('IDE-Jolie language server stopped unexpectedly.', {
            dismissable: true,
            description: this.processStdErr != null ? `<code>${this.processStdErr}</code>` : `Exit code ${exitCode}`
          })
      })

      //sometimes, the childProcess doesn't stop running when we close the server
      process.on("beforeExit", () => {
        childProcess.kill("-9")
      })
    })
  }

  /**
   * @override
   */
  deactivate() {
    let deactivate = super.deactivate();
    let cancel = new Promise((resolve, _reject) => {
      deactivate.then((_result) => {
        resolve();
      })
    });

    return Promise.race([deactivate, this.createTimeoutPromise(2000, cancel)])
  }

  createTimeoutPromise(milliseconds, cancelPromise) {
    let cancel = false;
    cancelPromise.then((_result) => {
      cancel = true;
    })

    return new Promise((resolve, reject) => {
      let timeout = setTimeout(() => {
        clearTimeout(timeout)

        if (cancel !== true) {
          this.logger.error(`Server failed to shutdown in ${milliseconds}ms, forcing termination`);
          resolve();
        } else {
          reject();
        }
      }, milliseconds)
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
