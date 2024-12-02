import express from 'express'
import { asyncHandler } from '../utils'
import BacSiController from '~/controller/bacsi.controller'
const router = express.Router()
router.post('/bkb', asyncHandler(BacSiController.getBKBByDay))
router.get('/', asyncHandler(BacSiController.getAllDoctors))

export default router
