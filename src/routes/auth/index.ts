import { Model, Op } from 'sequelize'

import { HttpException } from '../../exceptions/httpexception'
import { Models } from '../../services/sequelize'
import { Router } from 'express'
import { Models as _Models } from '../../typescript'
import { matches } from '../../utils/validation'
import { sha256 } from '../../utils/crypto'
import { sign } from '../../middleware/jwt'

export const authRouter = Router()

authRouter.post('/login', async (req, res, next) => {
  const email = req.body.email
  const password = req.body.password

  try {
    const user = await Models.User.findOne({
      attributes: {
        exclude: ['password'],
      },
      where: {
        [Op.and]: {
          email: email,
          password: sha256(password),
        },
      },
    })

    if (user) {
      res.setHeader('authorization', sign(user.get()))

      res.json(user)
    } else {
      next(new HttpException(400, 'User not found'))
    }
  } catch (error) {
    next(new HttpException(400, 'Invalid login data'))
  }
})

authRouter.post('/register', async (req, res, next) => {
  const email = req.body.email
  const password = req.body.password
  const username = req.body.username

  try {
    matches(username, 'string', 'Invalid username')
    matches(email, 'string', 'Invalid email')
    matches(password, 'string', 'Invalid password')
  } catch (error) {
    return void next(new HttpException(400, error))
  }

  try {
    const user = await Models.User.create<Model<_Models.User, {}>>({
      email: email,
      password: sha256(password),
      username: username,
    })

    res.setHeader('authorization', sign(user.get()))

    res.json(user)
  } catch (error) {
    console.log(error)
    next(new HttpException(400, 'Invalid data'))
  }
})
