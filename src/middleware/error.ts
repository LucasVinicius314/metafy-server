import { ErrorRequestHandler } from 'express'
import { HttpException } from '../exceptions/httpexception'

const errorHandler: ErrorRequestHandler = (
  error: HttpException,
  req,
  res,
  next
) => {
  res.status(error.status).json({
    message: error.message,
  })
}

export { errorHandler }
