import { Request, Response } from 'express'
import { console } from 'inspector'
import db from '~/dbs/initDatabase'
class StatisticController {
  static async get_sum_fee_with_child(req: Request, res: Response) {
    const { cccd } = req.params
    if (!cccd) {
      return res.status(400).json({ message: 'Thiếu CCCD' })
    }
    const result = await db.query('SELECT * FROM get_sum_fee_for_child($1)', [cccd])
    console.log(result.rows)

    return res.status(200).json({ message: 'OK', data: result.rows })
  }
}
export default StatisticController
