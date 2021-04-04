import { HttpException } from '../../exceptions/httpexception'
import { Model } from 'sequelize'
import { Models } from '../../services/sequelize'
import { Router } from 'express'
import { Models as _Models } from '../../typescript'
import { matches } from '../../utils/validation'

export const postRouter = Router()

postRouter.post('/all', async (req, res, next) => {
  try {
    const posts = await Models.Post.findAll({
      include: {
        model: Models.User,
        attributes: {
          exclude: ['password', 'email'],
        },
      },
    })

    res.json(posts)
  } catch (error) {
    next(new HttpException(400, 'Invalid data'))
  }
})

postRouter.post('/create', async (req, res, next) => {
  const content = req.body.content

  try {
    matches(content, 'string', 'Invalid content')
  } catch (error) {
    return void next(new HttpException(400, error))
  }

  try {
    await Models.Post.create<Model<_Models.Post, {}>>({
      content: content,
      userId: req.user.id,
    })

    res.json({
      message: 'Post created',
    })
  } catch (error) {
    next(new HttpException(400, 'Invalid data'))
  }
})
