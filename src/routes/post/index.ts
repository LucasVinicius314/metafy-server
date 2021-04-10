import { Model, col, fn, literal } from 'sequelize'

import { HttpException } from '../../exceptions/httpexception'
import { Models } from '../../services/sequelize'
import { Router } from 'express'
import { Models as _Models } from '../../typescript'
import { matches } from '../../utils/validation'

export const postRouter = Router()

postRouter.post('/all', async (req, res, next) => {
  try {
    const posts = await Models.Post.findAll({
      group: 'id',
      order: [['createdAt', 'DESC']],
      include: [
        {
          model: Models.User,
          attributes: {
            exclude: ['password', 'email'],
          },
        },
        {
          model: Models.Like,
        },
        {
          model: Models.Comment,
          attributes: [],
        },
      ],
      attributes: {
        include: [
          [fn('COUNT', col('likes.id')), 'likeCount'],
          [fn('COUNT', col('comments.id')), 'commentCount'],
          [
            literal(
              `(select count(*) from likes lk where lk.postId = post.id and lk.userId = ${req.user.id})`
            ),
            'liked',
          ],
        ],
      },
    })

    res.json(posts)
  } catch (error) {
    console.log(error)
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

postRouter.post('/like', async (req, res, next) => {
  const id = req.body.id

  try {
    await Models.Like.create<Model<_Models.Like, {}>>({
      userId: req.user.id,
      postId: id,
    })

    res.json({
      message: 'Post liked',
    })
  } catch (error) {
    next(new HttpException(400, 'Invalid data'))
  }
})

postRouter.post('/unlike', async (req, res, next) => {
  const id = req.body.id

  try {
    await Models.Like.destroy({
      where: {
        userId: req.user.id,
        postId: id,
      },
    })

    res.json({
      message: 'Like removed',
    })
  } catch (error) {
    next(new HttpException(400, 'Invalid data'))
  }
})
