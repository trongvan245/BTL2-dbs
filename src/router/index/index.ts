import PhuhuynhRouter from '../phuhuynh.router'
import BenhnhiRouter from '../benhnhi.router'
import BuoikhambenhRouter from '../buoikhambenh.router'
import DonthuocRouter from '../donthuoc.router'
import LanthuchiendicvuRouter from '../lanthuchiendichvu.router'
import HoadonRouter from '../hoadon.router'
import { Router } from 'express'
const router = Router()

router.use('/phuhuynh', PhuhuynhRouter)
router.use('/benhnhi', BenhnhiRouter)
router.use('/buoikhambenh', BuoikhambenhRouter)
router.use('/donthuoc', DonthuocRouter)
router.use('/lanthuchiendichvu', LanthuchiendicvuRouter)
router.use('/hoadon', HoadonRouter)

export default router
