import express from 'express'
import { asyncHandler } from '../utils'
import BuoikhambenhController from '../controller/buoikhambenh.controller'

const router = express.Router()
router.get('/:maso', asyncHandler(BuoikhambenhController.getBuoikhambenhById))
router.post('/add', asyncHandler(BuoikhambenhController.addBuoikhambenh))
router.put('/update', asyncHandler(BuoikhambenhController.updateBuoikhambenh))

export default router
