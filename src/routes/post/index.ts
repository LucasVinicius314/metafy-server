import { Model, Op } from 'sequelize'
import { Models, sequelize } from '../../services/sequelize'

import { HttpException } from '../../exceptions/httpexception'
import { Router } from 'express'
import { Success } from '../../responses/success'
import { Models as _Models } from '../../typescript'
import { matches } from '../../utils/validation'
import { sign } from '../../middleware/jwt'

const router = Router()

router.post('/all', async (req, res, next) => {
  try {
    const posts = await Models.Post.findAll({
      include: [Models.User],
    })

    console.log(posts)

    res.json(posts)
  } catch (error) {
    next(new HttpException(400, 'Invalid login data'))
  }
})

router.post('/create', async (req, res, next) => {
  const content = req.body.content

  try {
    matches(content, 'string', 'Invalid content')
  } catch (error) {
    return void next(new HttpException(400, error))
  }

  try {
    const post = await Models.Post.create<Model<_Models.Post, {}>>({
      content,
      userId: req.user.id,
    })

    res.json({
      message: 'Post created',
      // content: post.getDataValue('content'),
      // createdAt: post.getDataValue('createdAt'),
      // id: post.getDataValue('id'),
      // updatedAt: post.getDataValue('updatedAt'),
      // userId: post.getDataValue('userId'),
    })
  } catch (error) {
    next(new HttpException(400, 'Invalid data'))
  }
})

export { router as postRouter }
