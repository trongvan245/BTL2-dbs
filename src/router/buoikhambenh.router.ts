import express from 'express'
import { asyncHandler } from '../utils'
import BuoikhambenhController from '../controller/buoikhambenh.controller'

const router = express.Router()
router.post('/add', asyncHandler(BuoikhambenhController.addBuoikhambenh))
router.put('/update', asyncHandler(BuoikhambenhController.updateBuoikhambenh))

export default router
