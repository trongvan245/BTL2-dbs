import { Request, Response } from 'express'
import db from '~/dbs/initDatabase'
class BacSiController {
  static async getBKBByDay(req: Request, res: Response) {
    const { cccd, from, to } = req.body.params
    console.log(cccd, from, to)
    if (!cccd) {
      return res.status(400).json({ message: 'Missing maso' })
    }
    try {
      const bkb = await db.query('SELECT * FROM get_bkb_in_date_range($1, $2, $3);', [cccd, from, to])
      return res.status(200).json(bkb.rows)
    } catch (error) {
      return res.status(400).json({ message: 'Something went wrong', error })
    }
  }
  static async getAllDoctors(req: Request, res: Response) {
    try {
      const doctors = await db.query('SELECT NV.hoten, BS.chuyenkhoa, BS.bangcap FROM NHAN_VIEN NV, BAC_SI BS WHERE NV.CCCD = BS.CCCD');
      return res.status(200).json(doctors.rows);
  } catch (err) {
      const error = err as Error;
      return res.status(500).json({ message: 'Lỗi khi truy xuất danh sách bác sĩ', error: error.message })
  }
  }
}

export default BacSiController
