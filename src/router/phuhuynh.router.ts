import express from 'express'
import { asyncHandler } from '../utils'
import PhuhuynhController from '../controller/phuhuynh.controller'

const router = express.Router()
router.get('/', asyncHandler(PhuhuynhController.getAllPhuhuynh))
router.get('/:cccd', asyncHandler(PhuhuynhController.getPhuhuynhByCCCD))
router.post('/add', asyncHandler(PhuhuynhController.addPhuhuynh))
router.put('/update', asyncHandler(PhuhuynhController.updatePhuhuynh))
router.delete('/delete', asyncHandler(PhuhuynhController.deletePhuhuynh))
router.get('/benhnhi/:cccd', asyncHandler(PhuhuynhController.getBenhnhiByCCCD))
export default router
