export class Success {
  status: number
  message: string
  constructor(message: string) {
    this.status = 200
    this.message = message
  }
}
