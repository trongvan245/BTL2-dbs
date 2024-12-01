import express from 'express'
import { asyncHandler } from '../utils'
import ThuocController from '../controller/thuoc.controller'

const router = express.Router()
router.get('/', asyncHandler(ThuocController.getAllDrugs))
router.post('/add', asyncHandler(ThuocController.addDrug))
router.put('/update', asyncHandler(ThuocController.updateDrug))
router.delete('/delete', asyncHandler(ThuocController.deleteDrug))

export default router
