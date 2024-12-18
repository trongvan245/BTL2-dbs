import { Request, Response } from 'express'
import db from '~/dbs/initDatabase'
class DichvukhamController {
  // router.get('/', asyncHandler(DichvukhamController.getAllServices))
  static async getAllServices(req: Request, res: Response) {
    try {
      const services = await db.query('SELECT * FROM DICH_VU_KHAM')
      return res.status(200).json(services.rows)
    } catch (err) {
      const error = err as Error
      return res.status(500).json({ message: 'Lỗi khi lấy dịch vụ khám', error: error.message })
    }
  }

  // router.post('/add', asyncHandler(DichvukhamController.addService))
  static async addService(req: Request, res: Response) {
    // Extract data from the request body
    const { ten, giaca, mota } = req.body

    // Validate required fields
    if (!ten || !giaca || !mota) {
      return res.status(400).json({ message: 'Thiếu các trường bắt buộc' })
    }
    try {
      const query = `
        INSERT INTO DICH_VU_KHAM (TEN, GIACA, MOTA)  VALUES ($1, $2, $3) RETURNING *;
      `
      const result = await db.query(query, [ten, giaca, mota])

      res.status(201).json({
        message: 'Thêm dịch vụ thành công',
        data: result.rows[0]
      })
    } catch (err) {
      const error = err as Error
      return res.status(500).json({
        message: 'Lỗi khi thêm dịch vụ',
        error: error.message
      })
    }
  }
  // router.put('/update', asyncHandler(DichvukhamController.updateService))
  static async updateService(req: Request, res: Response) {
    const { madichvu, ten, giaca, mota } = req.body

    if (!madichvu) {
      return res.status(400).json({ message: 'Thiếu mã dịch vụ' })
    }
    if (!ten || !giaca || !mota) {
      return res.status(400).json({ message: 'Thiếu các trường bắt buộc' })
    }

    try {
      const query = `
        UPDATE DICH_VU_KHAM
        SET
          TEN = $2,
          GIACA = $3,
          MOTA = $4
        WHERE MADICHVU = $1
        RETURNING *;
      `

      const result = await db.query(query, [madichvu, ten, giaca, mota])

      if (result.rowCount === 0) {
        return res.status(404).json({ message: 'Không tìm thấy mã dịch vụ' })
      }

      res.status(200).json({
        message: 'Cập nhật dịch vụ thành công',
        data: result.rows[0]
      })
    } catch (err) {
      const error = err as Error
      return res.status(500).json({ message: 'Lỗi khi cập nhật dịch vụ', error: error.message })
    }
  }
}
export default DichvukhamController
