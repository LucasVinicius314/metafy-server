type Matches = (
  value: any,
  type: Types,
  message: string,
  options?: Options
) => void

type Options = {
  minLength?: number
  maxLength?: number
  email?: boolean
}

type Types = 'string' | 'number'

const matches: Matches = (value, type, message, options) => {
  options = options || {}
  options.email = options.email || false
  options.maxLength = options.maxLength || 20
  options.minLength = options.minLength || 4

  if (typeof value === type) {
    if (type === 'string') {
      if ((value as string).length < options.minLength) {
        throw message
      }
      if ((value as string).length > options.maxLength) {
        throw message
      }
    } else {
      throw message
    }
  } else {
    throw message
  }
}

export { matches }
