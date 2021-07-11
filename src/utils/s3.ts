import { S3 } from 'aws-sdk'

type Params = {
  body: S3.Body
  key: string
}

export const uploadFile = async ({ key, body }: Params) => {
  await new S3()
    .upload({
      Bucket: process.env.S3_BUCKET_NAME,
      Key: key,
      Body: body,
      ACL: 'public-read',
    })
    .promise()
}
