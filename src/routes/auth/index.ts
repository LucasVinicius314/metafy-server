import { Models, sequelize } from '../../services/sequelize'

import { HttpException } from '../../exceptions/httpexception'
import { Op } from 'sequelize'
import { Router } from 'express'
import { Success } from '../../responses/success'
import { matches } from '../../utils/validation'

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
    matches(email, 'string', 'Invalid email')
    matches(password, 'string', 'Invalid password')
    matches(username, 'string', 'Invalid username')
  } catch (error) {
    next(new HttpException(400, error))
  }

  try {
    await Models.User.create({
      email,
      password,
      username,
    })

    res.json(new Success('User created'))
  } catch (error) {
    next(new HttpException(400, 'Invalid data'))
  }
})

export { router as authRouter }
