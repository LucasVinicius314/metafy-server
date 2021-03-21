import { Router } from 'express'
import { useValidation } from '../middleware/jwt'
import { userRouter } from './user'

const router = Router()

// open routes

// router.use()

// protected routes

router.use(useValidation)

router.use(userRouter)

export { router }
