import { Request, Response } from 'express'
import db from '~/dbs/initDatabase'

class StatisticController {
  static async getChildrentCostByParent(req: Request, res: Response) {
    const { cccd } = req.params
    if (!cccd) {
      return res.status(400).json({ message: 'Thiếu CCCD phụ huynh của Bệnh Nhi' })
    }

    // Query your database or external service here
    try {
      const result = await db.query('SELECT * FROM calculate_patient_costs($1)', [cccd])
      res.json(result.rows) // Assuming you're using PostgreSQL
    } catch (error) {
      console.error(error)
      res.status(500).json({ message: 'Error fetching patient data' })
    }
  }
}

export default StatisticController
