declare global {
  namespace Express {
    interface Request {
      user: Models.User
    }
  }
  namespace NodeJS {
    interface ProcessEnv {
      NODE_ENV: 'development' | 'production'
      PORT?: string
      MYSQL_HOST: string
      MYSQL_PORT: string
      MYSQL_DB: string
      MYSQL_USER: string
      MYSQL_PASSWORD: string
      SECRET: string
      AWS_ACCESS_KEY_ID: string
      AWS_SECRET_ACCESS_KEY: string
      S3_BUCKET_NAME: string
    }
  }
}

export namespace Models {
  export type User = {
    id: number
    email: string
    password: string
    username: string
    updatedAt: Date
    createdAt: Date
  }
  export type Post = {
    id: number
    userId: number
    content: string
    updatedAt: Date
    createdAt: Date
  }
  export type FriendRequest = {
    id: number
    requesterId: number
    requesteeId: number
    updatedAt: Date
    createdAt: Date
  }
  export type Friend = {
    id: number
    user1Id: number
    user2Id: number
    updatedAt: Date
    createdAt: Date
  }
  export type Like = {
    id: number
    userId: number
    postId: number
    updatedAt: Date
    createdAt: Date
  }
  export type Chat = {
    id: number
    user1Id: number
    user2Id: number
    updatedAt: Date
    createdAt: Date
  }
  export type Message = {
    id: number
    content: string
    chatId: number
    userId: number
    updatedAt: Date
    createdAt: Date
  }
}
