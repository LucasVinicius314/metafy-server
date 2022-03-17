import * as jwt from 'jsonwebtoken'

import { Socket, Server as socketIo } from 'socket.io'

import { Models } from './sequelize'
import { Op } from 'sequelize'
import { Server } from 'http'
import { Models as _Models } from '../typescript'
import { matches } from '../utils/validation'

type Clients = {
  [type: number]: Socket
}

const clients: Clients = {}

export const useSocket = (server: Server) => {
  const io = new socketIo(server)

  io.on('connection', (socket) => {
    console.log('Socket client connected')

    const token = socket.request.headers.authorization
    const decoded = jwt.verify(token, process.env.SECRET) as Omit<
      _Models.User,
      'password'
    >

    clients[decoded.id] = socket

    useMessage(socket, decoded)
  })
}

type MessageParams = {
  chatId: number
  content: string
}

const useMessage = (socket: Socket, user: Omit<_Models.User, 'password'>) => {
  socket.on('send_message', async (params: MessageParams) => {
    console.log('message event')
    try {
      matches(params.content, 'string', 'Invalid content', {
        minLength: 1,
        maxLength: 255,
      })
    } catch (error) {
      console.log(error)
      return // void next(new HttpException(400, error))
    }

    try {
      if (
        (await Models.Chat.findOne({
          where: {
            id: params.chatId,
            [Op.or]: [{ user1Id: user.id }, { user2Id: user.id }],
          },
        })) === null
      ) {
        throw 'Invalid chat'
      }

      const message = await Models.Message.create({
        content: params.content,
        chatId: params.chatId,
        userId: user.id,
      })

      const recipients = (((await Models.Chat.findAll({
        where: {
          id: params.chatId,
        },
        include: [
          {
            model: Models.User,
            as: 'user1',
            foreignKey: 'user1Id',
            attributes: {
              exclude: ['password', 'email'],
            },
          },
          {
            model: Models.User,
            as: 'user2',
            foreignKey: 'user2Id',
            attributes: {
              exclude: ['password', 'email'],
            },
          },
        ],
      })) as unknown) as (_Models.Chat & {
        user1: Omit<Omit<_Models.User, 'password'>, 'email'>
        user2: Omit<Omit<_Models.User, 'password'>, 'email'>
      })[]).map((v) => ({
        createdAt: v.createdAt,
        id: v.id,
        updatedAt: v.updatedAt,
        user: v.user1.id === user.id ? v.user2 : v.user1,
        user1Id: v.user1Id,
        user2Id: v.user2Id,
      }))

      recipients.forEach((r) => {
        clients[r.user.id].emit('new_message', message)
      })

      socket.emit('new_message', message)

      // socket.emit('message_sent', {
      //   message: 'Message sent',
      // })
    } catch (error) {
      console.log(error)
      // next(new HttpException(400, 'Invalid data'))
    }
  })
}
