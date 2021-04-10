import { Model, col, fn, literal } from 'sequelize'

import { HttpException } from '../../exceptions/httpexception'
import { Models } from '../../services/sequelize'
import { Router } from 'express'
import { Models as _Models } from '../../typescript'
import { matches } from '../../utils/validation'

export const commentRouter = Router()

commentRouter.post('/all', async (req, res, next) => {
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

commentRouter.post('/create', async (req, res, next) => {
  const content = req.body.content
  const postId = req.body.postId

  try {
    matches(content, 'string', 'Invalid content', {
      minLength: 1,
      maxLength: 255,
    })
  } catch (error) {
    return void next(new HttpException(400, error))
  }

  try {
    await Models.Comment.create({
      content: content,
      postId: postId,
      userId: req.user.id,
    })

    res.json({
      message: 'Comment added',
    })
  } catch (error) {
    console.log(error)
    next(new HttpException(400, 'Invalid data'))
  }
})

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

commentRouter.post('/delete', async (req, res, next) => {
  const id = req.body.id

  try {
    await Models.Comment.destroy({
      where: {
        id: id,
        userId: req.user.id,
      },
    })

    res.json({
      message: 'Comment deleted',
    })
  } catch (error) {
    next(new HttpException(400, 'Invalid data'))
  }
})
