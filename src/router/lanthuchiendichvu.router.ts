import express from 'express'
import { asyncHandler } from '../utils'
import LanthuchiendichvuController from '../controller/lanthuchiendichvu.controller'

const router = express.Router()
router.post('/add', asyncHandler(LanthuchiendichvuController.addLanthuchiendichvu))
router.put('/update', asyncHandler(LanthuchiendichvuController.updateLanthuchiendichvu))

export default router
