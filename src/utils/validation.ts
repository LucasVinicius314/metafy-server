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
  options.maxLength = options.maxLength || Infinity
  options.minLength = options.minLength || 0

  if (typeof value === type) {
  } else {
    throw message
  }
}

export { matches }
