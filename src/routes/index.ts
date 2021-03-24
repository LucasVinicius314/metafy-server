import { Router } from 'express'
import { authRouter } from './auth'
import { errorHandler } from '../middleware/error'
import { userRouter } from './user'
import { validationHandler } from '../middleware/jwt'

const router = Router()

// open routes

router.use(authRouter)

// protected routes

router.use(validationHandler)

// error

router.use(errorHandler)

router.use(userRouter)

export { router }
