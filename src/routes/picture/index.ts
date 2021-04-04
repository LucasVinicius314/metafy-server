import * as uniqId from 'uniqid'

import { HttpException } from '../../exceptions/httpexception'
import { Models } from '../../services/sequelize'
import { Router } from 'express'
import { UploadedFile } from 'express-fileupload'
import { sign } from '../../middleware/jwt'

export const pictureRouter = Router()

pictureRouter.post('/upload', async (req, res, next) => {
  const scope: 'profile' | 'cover' = req.body.scope
  const _file = req.files.image
  const file = Array.isArray(_file) ? _file[0] : _file

  try {
    const name = uniqId()

    const user = await Models.User.findOne({
      attributes: {
        exclude: ['password', 'email'],
      },
      where: {
        id: req.user.id,
      },
    })

    if (scope === 'profile') {
      user.update({ profilePicture: name })
    } else if (scope === 'cover') {
      user.update({ coverPicture: name })
    }

    await file.mv(`public/img/${name}`)

    res.json({
      message: 'Picture uploaded',
    })
  } catch (error) {
    next(new HttpException(400, 'Invalid data'))
  }
})

// pictureRouter.post('/validate', async (req, res, next) => {
//   try {
//     const user = await Models.User.findOne({
//       attributes: {
//         exclude: ['password'],
//       },
//       where: {
//         id: req.user.id,
//       },
//     })

//     res.setHeader('authorization', sign(user.get()))

//     res.json(user)
//   } catch (error) {
//     next(new HttpException(400, 'Invalid data'))
//   }
// })
