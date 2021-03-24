import * as dotenv from 'dotenv'
import * as jwt from 'jsonwebtoken'

import { HttpException } from '../exceptions/httpexception'
import { RequestHandler } from 'express'

dotenv.config()

const validationHandler: RequestHandler = (req, res, next) => {
  try {
    const token = req.headers.authorization
    const decoded = jwt.verify(token, process.env.SECRET)
    // @ts-ignore
    req.user = decoded
    next()
  } catch (error) {
    next(new HttpException(401, 'Invalid access token'))
  }
}

export { validationHandler }
