import * as dotenv from 'dotenv'

import { DataTypes, Sequelize } from 'sequelize'

dotenv.config()

const host = process.env.MYSQL_HOST
const port = process.env.MYSQL_PORT
const db = process.env.MYSQL_DB
const user = process.env.MYSQL_USER
const password = process.env.MYSQL_PASSWORD

export const sequelize = new Sequelize(`mysql://${host}:${port}/${db}`, {
  username: user,
  password: password,
})

const User = sequelize.define('user', {
  coverPicture: DataTypes.STRING,
  email: DataTypes.STRING,
  password: DataTypes.STRING(256),
  profilePicture: DataTypes.STRING,
  username: DataTypes.STRING,
})

const Post = sequelize.define('post', {
  content: DataTypes.TEXT,
  userId: DataTypes.INTEGER,
})

const FriendRequest = sequelize.define('friendrequest', {
  requesterId: DataTypes.INTEGER,
  requesteeId: DataTypes.INTEGER,
})

const Friend = sequelize.define('friend', {
  user1Id: DataTypes.INTEGER,
  user2Id: DataTypes.INTEGER,
})

User.prototype.toJSON = function () {
  let values = Object.assign({}, this.get())
  delete values.password
  return values
}

// User -> post

User.hasMany(Post, { foreignKey: 'userId' })
Post.belongsTo(User, { foreignKey: 'userId' })

// User -> FriendRequest

User.hasMany(FriendRequest, { foreignKey: 'requesterId' })
FriendRequest.belongsTo(User, {
  foreignKey: 'requesterId',
  as: 'requesterUser',
})
User.hasMany(FriendRequest, { foreignKey: 'requesteeId' })
FriendRequest.belongsTo(User, {
  foreignKey: 'requesteeId',
  as: 'requesteeUser',
})

// User -> Friend

User.hasMany(Friend, { foreignKey: 'user1Id' })
Friend.belongsTo(User, { foreignKey: 'user1Id', as: 'user1' })
User.hasMany(Friend, { foreignKey: 'user2Id' })
Friend.belongsTo(User, { foreignKey: 'user2Id', as: 'user2' })

export const Models = { User, Post, FriendRequest, Friend }
