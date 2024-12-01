import express from 'express'
import { asyncHandler } from '../utils'
import SoluongthuocController from '../controller/soluongthuoc.controller'

const router = express.Router()
router.post('/add', asyncHandler(SoluongthuocController.addSoluongthuoc))
router.put('/update', asyncHandler(SoluongthuocController.updateSoluongthuoc))

export default router
