import { S3 } from 'aws-sdk'

type Params = {
  body: S3.Body
  key: string
  scope: string
  id: string
}

export const uploadFile = async ({ key, body, scope, id }: Params) => {
  await new S3()
    .upload({
      Bucket: process.env.S3_BUCKET_NAME,
      Key: key,
      Body: body,
      ACL: 'public-read',
      Metadata: { scope, id },
    })
    .promise()
}
