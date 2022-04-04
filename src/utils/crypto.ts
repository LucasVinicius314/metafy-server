import * as Crypto from 'crypto'

export const sha256 = (input: string) => {
  return Crypto.createHash('sha256').update(input).digest('base64')
}

export const sha256Safe = (input: string) => {
  return Crypto.createHash('sha256')
    .update(input)
    .digest('base64')
    .replace(/\+/g, '-')
    .replace(/\//g, '_')
    .replace(/=/, '0')
}
