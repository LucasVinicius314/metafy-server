import { HttpException } from '../../exceptions/httpexception'
import { Models } from '../../services/sequelize'
import { Router } from 'express'
import { sign } from '../../middleware/jwt'

export const userRouter = Router()

userRouter.post('/profile', async (req, res, next) => {
  const id = req.body.id

  try {
    const user = await Models.User.findOne({
      attributes: {
        exclude: ['password', 'email'],
      },
      where: {
        id: id,
      },
    })

    res.json(user)
  } catch (error) {
    next(new HttpException(400, 'Invalid data'))
  }
})

userRouter.post('/validate', async (req, res, next) => {
  try {
    const user = await Models.User.findOne({
      attributes: {
        exclude: ['password', 'email'],
      },
      where: {
        id: req.user.id,
      },
    })

    res.setHeader('authorization', sign(user.get()))

    res.json(user)
  } catch (error) {
    next(new HttpException(400, 'Invalid data'))
  }
})
