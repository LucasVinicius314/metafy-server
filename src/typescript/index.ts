declare global {
  namespace Express {
    interface Request {
      user: Models.User
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
}
