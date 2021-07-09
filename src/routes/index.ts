import { Router } from 'express'
import { authRouter } from './auth'
import { chatRouter } from './chat'
import { commentRouter } from './comment'
import { errorHandler } from '../middleware/error'
import { friendRequestRouter } from './friendrequest'
import { friendRouter } from './friend'
import { messageRouter } from './message'
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
router.use('/comment', commentRouter)
router.use('/chat', chatRouter)
router.use('/message', messageRouter)

// error

router.use(errorHandler)
