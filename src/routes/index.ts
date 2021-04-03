import { Router } from 'express'
import { authRouter } from './auth'
import { errorHandler } from '../middleware/error'
import { friendRequestRouter } from './friendrequest'
import { postRouter } from './post'
import { userRouter } from './user'
import { validationHandler } from '../middleware/jwt'

const router = Router()

// open routes

router.use('/user', authRouter)

// protected routes

router.use(validationHandler)

// error

router.use(errorHandler)

router.use('/user', userRouter)
router.use('/post', postRouter)
router.use('/friendrequest', friendRequestRouter)

export { router }
