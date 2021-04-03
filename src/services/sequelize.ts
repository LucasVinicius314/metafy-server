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

const User = sequelize.define('user', {
  email: DataTypes.STRING,
  password: DataTypes.STRING,
  username: DataTypes.STRING,
})

const Post = sequelize.define('post', {
  content: DataTypes.TEXT,
  userId: DataTypes.INTEGER,
})

User.prototype.toJSON = function () {
  let values = Object.assign({}, this.get())
  delete values.password
  return values
}

User.hasMany(Post, { foreignKey: 'userId' })
Post.belongsTo(User, { foreignKey: 'userId' })

const Models = { User, Post }

export { sequelize, Models }
