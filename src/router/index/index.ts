import PhuhuynhRouter from '../phuhuynh.router'
import BenhnhiRouter from '../benhnhi.router'
import BuoikhambenhRouter from '../buoikhambenh.router'
import DonthuocRouter from '../donthuoc.router'
import LanthuchiendicvuRouter from '../lanthuchiendichvu.router'
import HoadonRouter from '../hoadon.router'
import BACSIRouter from '../bacsi.router'
import DichvukhamRouter from '../dichvukham.router'
import SoluongthuocRouter from '../soluongthuoc.router'
import { Router } from 'express'
import db from '../../dbs/initDatabase'
const router = Router()

router.use('/phuhuynh', PhuhuynhRouter)
router.use('/benhnhi', BenhnhiRouter)
router.use('/buoikhambenh', BuoikhambenhRouter)
router.use('/donthuoc', DonthuocRouter)
router.use('/lanthuchiendichvu', LanthuchiendicvuRouter)
router.use('/hoadon', HoadonRouter)
router.use('/bacsi', BACSIRouter)
router.use('/dichvukham', DichvukhamRouter)
router.use('/soluongthuoc', SoluongthuocRouter)

// Run query at the front end
router.post('/query', async (req, res) => {
  const { query } = req.body
  try {
    const result = await db.query(query)
    res.status(200).json(result.rows)
  } catch (error) {
    console.error('Error running query:', error)
    res.status(500).json({ message: 'Error running query', error })
  }
})

export default router
