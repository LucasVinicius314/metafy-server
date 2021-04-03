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

router.post('/pending', async (req, res, next) => {
  try {
    const pending = await Models.FriendRequest.findAll({
      where: {
        requesteeId: req.user.id,
      },
      include: [
        {
          model: Models.User,
          as: 'requesterUser',
          foreignKey: 'requesterId',
          attributes: {
            exclude: ['password'],
          },
          where: {},
        },
        {
          model: Models.User,
          as: 'requesteeUser',
          foreignKey: 'requesteeId',
          attributes: {
            exclude: ['password'],
          },
          where: {},
        },
      ],
    })

    console.log(pending)
    res.json(pending)
  } catch (error) {
    console.log(error)
    next(new HttpException(400, 'Invalid data'))
  }
})

router.post('/sent', async (req, res, next) => {
  try {
    const sent = await Models.FriendRequest.findAll({
      where: {
        requesterId: req.user.id,
      },
      include: [
        {
          model: Models.User,
          as: 'requesterUser',
          foreignKey: 'requesterId',
          attributes: {
            exclude: ['password'],
          },
          where: {},
        },
        {
          model: Models.User,
          as: 'requesteeUser',
          foreignKey: 'requesteeId',
          attributes: {
            exclude: ['password'],
          },
          where: {},
        },
      ],
    })

    res.json(sent)
  } catch (error) {
    next(new HttpException(400, 'Invalid data'))
  }
})

export { router as friendRequestRouter }
