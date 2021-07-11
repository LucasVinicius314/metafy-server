import * as uniqId from 'uniqid'

import { HttpException } from '../../exceptions/httpexception'
import { Models } from '../../services/sequelize'
import { Router } from 'express'
import { uploadFile } from '../../utils/s3'

export const pictureRouter = Router()

pictureRouter.post('/upload', async (req, res, next) => {
  try {
    const scope: 'profile' | 'cover' = req.body.scope
    const _file = req.files.image
    const file = Array.isArray(_file) ? _file[0] : _file

    const user = await Models.User.findOne({
      attributes: {
        exclude: ['password', 'email'],
      },
      where: {
        id: req.user.id,
      },
    })

    const name = uniqId()

    if (scope === 'profile') {
      user.update({ profilePicture: name })
    } else if (scope === 'cover') {
      user.update({ coverPicture: name })
    } else {
      throw 'Invalid scope'
    }

    await uploadFile({ body: file, key: name })

    res.json({
      message: 'Picture uploaded',
    })
  } catch (error) {
    next(new HttpException(400, 'Invalid data'))
  }
})
