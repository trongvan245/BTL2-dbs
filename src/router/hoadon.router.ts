import express from 'express'
import { asyncHandler } from '../utils'
import HoadonController from '../controller/hoadon.controller'

const router = express.Router()
router.get('/sumhoadon', asyncHandler(HoadonController.getSumFeeInDateRange))
router.get('/all', asyncHandler(HoadonController.getAllFee))
router.get('/:mahoadon', asyncHandler(HoadonController.getHoadon))
router.post('/add', asyncHandler(HoadonController.addHoadon))
router.put('/update', asyncHandler(HoadonController.updateHoadon))

export default router
