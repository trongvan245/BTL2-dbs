import express from 'express'
import { asyncHandler } from '../utils'
import StatisticController from '../controller/statistic.controller'

const router = express.Router()
router.get('/getbuoikhambenhbacsi', asyncHandler(StatisticController.getBuoikhambenhBacsi))
router.get('/getchildrencost/:cccd', asyncHandler(StatisticController.get_sum_fee_with_child))

export default router
