import { HttpException } from '../../exceptions/httpexception'
import { Models } from '../../services/sequelize'
import { Router } from 'express'

const router = Router()

router.post('/profile', async (req, res, next) => {
  const id = req.body.id

  try {
    const user = await Models.User.findOne({
      attributes: ['createdAt', 'updatedAt', 'id', 'username'],
      where: {
        id: id,
      },
    })

    res.json(user)
  } catch (error) {
    next(new HttpException(400, 'Invalid data'))
  }
})

export { router as userRouter }
