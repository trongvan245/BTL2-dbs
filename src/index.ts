import express from 'express'
import { config } from 'dotenv'

config()
const app = express()
const PORT = process.env.PORT || 4000
app.get('/hello', (req, res) => {
  res.send('Hello World!')
})

app.listen(PORT, () => {
  console.log(`App is running on port ${PORT}`)
})
