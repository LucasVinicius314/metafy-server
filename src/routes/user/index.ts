import { Router } from 'express'

const router = Router()

router.post('/user/login', (req, res) => {
  res.json({ message: 'test' })
})

export { router as userRouter }
