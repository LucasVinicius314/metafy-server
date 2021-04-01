import { Model, Op } from 'sequelize'
import { Models, sequelize } from '../../services/sequelize'

import { HttpException } from '../../exceptions/httpexception'
import { Router } from 'express'
import { Success } from '../../responses/success'
import { Models as _Models } from '../../typescript'
import { matches } from '../../utils/validation'
import { sign } from '../../middleware/jwt'

const router = Router()

router.post('/user/login', async (req, res, next) => {
  const email = req.body.email
  const password = req.body.password

  try {
    const user = await Models.User.findOne({
      where: {
        [Op.and]: {
          email: email,
          password: password,
        },
      },
    })

    if (user) {
      res.json(new Success('User found'))
    } else {
      next(new HttpException(400, 'User not found'))
    }
  } catch (error) {
    next(new HttpException(400, 'Invalid login data'))
  }
})

router.post('/user/register', async (req, res, next) => {
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
      email,
      password,
      username,
    })

    res.setHeader('authorization', sign(user.get()))

    res.json(new Success('User created'))
  } catch (error) {
    next(new HttpException(400, 'Invalid data'))
  }
})

export { router as authRouter }
