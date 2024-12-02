import express from 'express'
import { asyncHandler } from '../utils'
import StatisticController from '../controller/statistic.controller'

const router = express.Router()
router.get('/getchildrentcost/:cccd', asyncHandler(StatisticController.getChildrentCostByParent))
router.get('/getbuoikhambenhbacsi', asyncHandler(StatisticController.getBuoikhambenhBacsi))

export default router
