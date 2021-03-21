import * as jwt from 'jsonwebtoken'

import { RequestHandler } from 'express'

const useValidation: RequestHandler = (req, res, next) => {
  const decoded = req.headers.authorization
  console.log('auth: ', decoded)

  next()
}

export { useValidation }
