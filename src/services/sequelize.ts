import * as dotenv from 'dotenv'

import { DataTypes, Sequelize } from 'sequelize'

dotenv.config()

const databaseUrl = process.env.DATABASE_URL

export const sequelize = new Sequelize(databaseUrl, { dialect: 'postgres' })

const User = sequelize.define('user', {
  coverPicture: {
    type: DataTypes.STRING,
    defaultValue: 'default-cover',
    allowNull: false,
  },
  email: DataTypes.STRING,
  password: DataTypes.STRING(256),
  profilePicture: {
    type: DataTypes.STRING,
    defaultValue: 'default-user',
    allowNull: false,
  },
  username: DataTypes.STRING,
})

const Post = sequelize.define('post', {
  content: DataTypes.TEXT,
  userId: DataTypes.INTEGER,
})

const FriendRequest = sequelize.define('friendrequest', {
  requesteeId: DataTypes.INTEGER,
  requesterId: DataTypes.INTEGER,
})

const Friend = sequelize.define('friend', {
  user1Id: DataTypes.INTEGER,
  user2Id: DataTypes.INTEGER,
})

const Like = sequelize.define('like', {
  postId: DataTypes.INTEGER,
  userId: DataTypes.INTEGER,
})

const Comment = sequelize.define('comment', {
  content: DataTypes.STRING,
  postId: DataTypes.INTEGER,
  userId: DataTypes.INTEGER,
})

const Chat = sequelize.define('chat', {
  user1Id: DataTypes.INTEGER,
  user2Id: DataTypes.INTEGER,
})

const Message = sequelize.define('message', {
  chatId: DataTypes.INTEGER,
  content: DataTypes.STRING,
  userId: DataTypes.INTEGER,
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

// Post -> Like

Post.hasMany(Like, { foreignKey: 'postId' })
Like.belongsTo(Post, { foreignKey: 'postId' })

// User -> Like

User.hasMany(Like, { foreignKey: 'userId' })
Like.belongsTo(User, { foreignKey: 'userId' })

// Post -> Comment

Post.hasMany(Comment, { foreignKey: 'postId' })
Comment.belongsTo(Post, { foreignKey: 'postId' })

// User -> Comment

User.hasMany(Comment, { foreignKey: 'userId' })
Comment.belongsTo(User, { foreignKey: 'userId' })

// User -> Chat

User.hasMany(Chat, { foreignKey: 'user1Id' })
Chat.belongsTo(User, { foreignKey: 'user1Id', as: 'user1' })
User.hasMany(Chat, { foreignKey: 'user2Id' })
Chat.belongsTo(User, { foreignKey: 'user2Id', as: 'user2' })

// Chat -> Message

Chat.hasMany(Message, { foreignKey: 'chatId' })
Message.belongsTo(Chat, { foreignKey: 'chatId' })

// User -> Message

User.hasMany(Message, { foreignKey: 'userId' })
Message.belongsTo(User, { foreignKey: 'userId' })

export const Models = {
  User,
  Post,
  FriendRequest,
  Friend,
  Like,
  Comment,
  Chat,
  Message,
}
