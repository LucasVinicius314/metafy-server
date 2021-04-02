import * as cors from 'cors'
import * as dotenv from 'dotenv'
import * as express from 'express'

import { Models, sequelize } from './services/sequelize'

import { json } from 'body-parser'
import { router } from './routes'

dotenv.config()

const setup = async () => {
  await sequelize
    .authenticate()
    .then(() => console.log('Database auth ok'))
    .catch(console.log)

  await sequelize
    .sync({ alter: true, force: false })
    .then(() => console.log('Database sync ok'))
    .catch(console.log)

  const app = express()

  app.use(cors())
  app.use(json())
  app.use('/api/', router)

  app.listen(process.env.PORT, () => {
    console.log(`Listening on port ${process.env.PORT}`)
  })
}

setup()
