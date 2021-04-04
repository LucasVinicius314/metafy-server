import { Router } from 'express'
import { authRouter } from './auth'
import { errorHandler } from '../middleware/error'
import { friendRequestRouter } from './friendrequest'
import { friendRouter } from './friend'
import { pictureRouter } from './picture'
import { postRouter } from './post'
import { userRouter } from './user'
import { validationHandler } from '../middleware/jwt'

export const router = Router()

// open routes

router.use('/user', authRouter)

// protected routes

router.use(validationHandler)

router.use('/user', userRouter)
router.use('/post', postRouter)
router.use('/friendrequest', friendRequestRouter)
router.use('/friend', friendRouter)
router.use('/picture', pictureRouter)

// error

router.use(errorHandler)
