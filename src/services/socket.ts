import * as jwt from 'jsonwebtoken'

import { Socket, Server as socketIo } from 'socket.io'

import { Models } from '../typescript'
import { Server } from 'http'

type Clients = {
  [type: number]: Socket
}

export const useSocket = (server: Server) => {
  const io = new socketIo(server)
  const clients: Clients = {}
  io.on('connection', (socket) => {
    console.log('Socket client connected')
    const token = socket.request.headers.authorization
    const decoded = jwt.verify(token, process.env.SECRET) as Models.User
    clients[decoded.id] = socket
    socket.on('message', (params) => {
      console.log('message event')
    })
  })
}
