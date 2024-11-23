import express from 'express'
import { asyncHandler } from '../utils'
import PhuhuynhController from '../controller/phuhuynh.controller'

const router = express.Router()
router.post('/add', asyncHandler(PhuhuynhController.addPhuhuynh))
router.put('/update', asyncHandler(PhuhuynhController.updatePhuhuynh))
router.delete('/delete', asyncHandler(PhuhuynhController.deletePhuhuynh))

export default router
