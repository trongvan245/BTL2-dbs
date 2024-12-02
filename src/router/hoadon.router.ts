import express from 'express'
import { asyncHandler } from '../utils'
import HoadonController from '../controller/hoadon.controller'

const router = express.Router()
router.get('/', asyncHandler(HoadonController.getAllHoadon))
router.get('/:mahoadon', asyncHandler(HoadonController.getHoadon))
router.post('/add', asyncHandler(HoadonController.addHoadon))
router.put('/update', asyncHandler(HoadonController.updateHoadon))

export default router
