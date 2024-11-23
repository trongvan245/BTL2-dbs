import express from 'express'
import { asyncHandler } from '../utils'
import DonthuocController from '../controller/donthuoc.controller'

const router = express.Router()
router.post('/add', asyncHandler(DonthuocController.addDonthuoc))
router.put('/update', asyncHandler(DonthuocController.updateDonthuoc))

export default router
