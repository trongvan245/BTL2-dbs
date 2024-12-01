import express from 'express'
import { asyncHandler } from '../utils'
import DichvukhamController from '../controller/dichvukham.controller'

const router = express.Router()
router.get('/', asyncHandler(DichvukhamController.getAllServices))
router.post('/add', asyncHandler(DichvukhamController.addService))
router.put('/update', asyncHandler(DichvukhamController.updateService))

export default router
