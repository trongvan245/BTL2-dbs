import { Request, Response } from 'express'
import db from '~/dbs/initDatabase'
class BacSiController {
  static async getBKBByDay(req: Request, res: Response) {
    const { cccd, from, to } = req.body
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
}

export default BacSiController
