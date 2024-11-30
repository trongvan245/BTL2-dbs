import express from 'express'
import { asyncHandler } from '../utils'
import BacSiController from '~/controller/bacsi.controller'
const router = express.Router()
router.get('/bkb', asyncHandler(BacSiController.getBKBByDay))

export default router
