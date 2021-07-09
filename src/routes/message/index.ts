import { Model, Op, col, fn, literal } from 'sequelize'

import { HttpException } from '../../exceptions/httpexception'
import { Models } from '../../services/sequelize'
import { Router } from 'express'
import { Models as _Models } from '../../typescript'
import { matches } from '../../utils/validation'

export const messageRouter = Router()

messageRouter.post('/all', async (req, res, next) => {
  const id = req.body.id

  try {
    const comments = await Models.Comment.findAll({
      where: {
        postId: id,
      },
      include: [
        {
          model: Models.User,
          attributes: {
            exclude: ['password', 'email'],
          },
        },
      ],
    })

    res.json(comments)
  } catch (error) {
    console.log(error)
    next(new HttpException(400, 'Invalid data'))
  }
})

// messageRouter.post('/send', async (req, res, next) => {
//   const content = req.body.content
//   const chatId = req.body.chatId

//   try {
//     matches(content, 'string', 'Invalid content', {
//       minLength: 1,
//       maxLength: 255,
//     })
//   } catch (error) {
//     return void next(new HttpException(400, error))
//   }

//   try {
//     if (
//       (await Models.Chat.findOne({
//         where: {
//           id: chatId,
//           [Op.or]: [{ user1Id: req.user.id }, { user2Id: req.user.id }],
//         },
//       })) === null
//     ) {
//       throw 'Invalid chat'
//     }

//     await Models.Message.create({
//       content: content,
//       chatId: chatId,
//       userId: req.user.id,
//     })

//     res.json({
//       message: 'Message sent',
//     })
//   } catch (error) {
//     console.log(error)
//     next(new HttpException(400, 'Invalid data'))
//   }
// })

// commentRouter.post('/like', async (req, res, next) => {
//   const id = req.body.id

//   try {
//     await Models.Like.create<Model<_Models.Like, {}>>({
//       userId: req.user.id,
//       postId: id,
//     })

//     res.json({
//       message: 'Post liked',
//     })
//   } catch (error) {
//     next(new HttpException(400, 'Invalid data'))
//   }
// })

// messageRouter.post('/delete', async (req, res, next) => {
//   const id = req.body.id

//   try {
//     await Models.Comment.destroy({
//       where: {
//         id: id,
//         userId: req.user.id,
//       },
//     })

//     res.json({
//       message: 'Comment deleted',
//     })
//   } catch (error) {
//     next(new HttpException(400, 'Invalid data'))
//   }
// })
