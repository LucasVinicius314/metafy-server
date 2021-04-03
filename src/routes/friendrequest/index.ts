import { HttpException } from '../../exceptions/httpexception'
import { Model } from 'sequelize/types'
import { Models } from '../../services/sequelize'
import { Router } from 'express'
import { Models as _Models } from '../../typescript'

const router = Router()

router.post('/send', async (req, res, next) => {
  const requesteeId = req.body.requesteeId

  try {
  } catch (error) {
    return void next(new HttpException(400, error))
  }

  try {
    await Models.FriendRequest.create<Model<_Models.FriendRequest, {}>>({
      requesterId: req.user.id,
      requesteeId: requesteeId,
    })

    res.json({
      message: 'Request sent',
    })
  } catch (error) {
    console.log(error)
    next(new HttpException(400, 'Invalid data'))
  }
})

export { router as friendRequestRouter }
