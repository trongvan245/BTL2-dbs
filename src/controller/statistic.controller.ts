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

  static async getBuoikhambenhBacsi(req: Request, res: Response) {
    try {
      const { ngay, soluong } = req.query

      // Check if 'ngay' and 'soluong' are provided
      if (!ngay || !soluong) {
        return res.status(400).json({
          message: 'Cần truyền vào ngày khám và số lượng buổi khám bệnh.'
        })
      }

      // Query the database to get the doctor data for the specified date
      const result = await db.query('SELECT * FROM GET_BACSI_BUOIKHAM($1::DATE, $2::INT)', [ngay, soluong])

      // Return the data in Vietnamese
      if (result.rows.length > 0) {
        res.status(200).json({
          message: 'Danh sách bác sĩ buổi khám',
          data: result.rows
        })
      } else {
        res.status(404).json({
          message: 'Không có dữ liệu bác sĩ cho ngày này.'
        })
      }
    } catch (error) {
      console.error('Error fetching doctor data:', error)
      res.status(500).json({
        message: 'Có lỗi xảy ra khi lấy dữ liệu bác sĩ.'
      })
    }
  }
}

export default StatisticController
