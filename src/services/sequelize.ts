import * as dotenv from 'dotenv'

import { DataTypes, Sequelize } from 'sequelize'

dotenv.config()

const host = process.env.MYSQL_HOST
const port = process.env.MYSQL_PORT
const db = process.env.MYSQL_DB
const user = process.env.MYSQL_USER
const password = process.env.MYSQL_PASSWORD

const sequelize = new Sequelize(`mysql://${host}:${port}/${db}`, {
  username: user,
  password: password,
})

const Models = {}

export { sequelize, Models }
