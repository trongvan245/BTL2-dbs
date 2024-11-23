import PhuhuynhRouter from '../phuhuynh.router'
import BenhnhiRouter from '../benhnhi.router'
import BuoikhambenhRouter from '../buoikhambenh.router'
import { Router } from 'express'
const router = Router()

router.use('/phuhuynh', PhuhuynhRouter)
router.use('/benhnhi', BenhnhiRouter)
router.use('/buoikhambenh', BuoikhambenhRouter)

export default router
