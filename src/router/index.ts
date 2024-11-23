import PhuhuynhRouter from './phuhuynh.router'
import BenhnhiRouter from './benhnhi.router'
import { Router } from 'express'
const router = Router()

router.use('/phuhuynh', PhuhuynhRouter)
router.use('/benhnhi', BenhnhiRouter)

export default router
