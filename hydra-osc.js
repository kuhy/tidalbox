const OSC = require('osc-js')

const config = {
    receiver: 'ws',
    udpServer: {
      host: 'localhost',
      port: 41234,
      exclusive: false
    },
    udpClient: {
      host: 'localhost',
      port: 41235
    },
    wsServer: {
      host: '0.0.0.0',
      port: 8080
    }
  }
const osc = new OSC({ plugin: new OSC.BridgePlugin(config) })

osc.open()

console.log('osc client running on port', config.udpClient.port)
console.log('osc server running on port', config.udpServer.port)
console.log('websocket server running on port', config.wsServer.port)
