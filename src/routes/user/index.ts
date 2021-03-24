import { Router } from 'express'

const router = Router()

router.post('/user/test', (req, res) => {
  res.json({ message: 'test' })
})

export { router as userRouter }
