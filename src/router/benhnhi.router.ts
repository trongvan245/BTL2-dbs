import express from 'express'
import { asyncHandler } from '../utils'
import BenhnhiController from '../controller/benhnhi.controller'

const router = express.Router()
router.get('/', asyncHandler(BenhnhiController.getAllBenhnhi))
router.get('/:maso', asyncHandler(BenhnhiController.getBenhnhiByMaso))
router.get('/phuhuynh/:cccd', asyncHandler(BenhnhiController.getBenhnhiByCCCD))
router.post('/add', asyncHandler(BenhnhiController.addBenhnhi))
router.put('/update', asyncHandler(BenhnhiController.updateBenhnhi))
router.delete('/delete', asyncHandler(BenhnhiController.deleteBenhnhi))

export default router
