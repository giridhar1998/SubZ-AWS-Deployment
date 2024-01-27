import express from 'express'
import dotenv from 'dotenv'
import colors from 'colors'
import morgan from 'morgan'
import { notFound, errorHandler } from './middleware/errorMiddleware.js'
import connectDB from './config/db.js'
import cors from 'cors'

import productRoutes from './routes/productRoutes.js'

dotenv.config()

connectDB()

const app = express()

app.use(cors())
app.use(express.json())

app.use(morgan('combined'))

app.use('/api/products', productRoutes)

const __dirname = path.resolve();

const cacheTime = 8640000 * 30;

app.use('/api/products/upload', uploadRoutes);
app.use('/api/products/uploads', express.static(path.join(__dirname, '/uploads'), { maxAge: cacheTime }));

app.use(notFound)
app.use(errorHandler)

const PORT = process.env.PORT || 8003

app.listen(
  PORT,
  console.log(
    `Server running in ${process.env.NODE_ENV} mode on port ${PORT}`.yellow.bold
  )
)
