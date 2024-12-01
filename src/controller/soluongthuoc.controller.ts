import { Request, Response } from 'express'
import db from '~/dbs/initDatabase'

class SoluongthuocController {
  /**
   * Add a new entry to the SO_LUONG_THUOC table
   */
  static async addSoluongthuoc(req: Request, res: Response) {
    const { MASO_BKB, MASO_TH, SOLUONG, CACHSD } = req.body

    if (!MASO_BKB || !MASO_TH || !SOLUONG || !CACHSD) {
      return res.status(400).json({ message: 'Tất cả các trường là bắt buộc.' })
    }

    if (SOLUONG <= 0) {
      return res.status(400).json({ message: 'Số lượng phải lớn hơn 0.' })
    }

    const query = `
        INSERT INTO SO_LUONG_THUOC (MASO_BKB, MASO_TH, SOLUONG, CACHSD)
        VALUES ($1, $2, $3, $4)
        RETURNING *;
      `
    const result = await db.query(query, [MASO_BKB, MASO_TH, SOLUONG, CACHSD])
    res.status(201).json({
      message: 'Soluongthuoc added successfully',
      data: result.rows[0]
    })
  }

  /**
   * Update an entry in the SO_LUONG_THUOC table
   */
  static async updateSoluongthuoc(req: Request, res: Response) {
    const { MASO_BKB, MASO_TH, SOLUONG, CACHSD } = req.body

    if (!MASO_BKB || !MASO_TH || (!SOLUONG && !CACHSD)) {
      return res
        .status(400)
        .json({ message: 'MASO_BKB, MASO_TH và ít nhất một trường cập nhật (SOLUONG hoặc CACHSD) là bắt buộc.' })
    }

    const updates: string[] = []
    const params: any[] = []

    if (SOLUONG !== undefined) {
      if (SOLUONG <= 0) {
        return res.status(400).json({ message: 'Số lượng phải lớn hơn 0.' })
      }
      updates.push(`SOLUONG = $${updates.length + 1}`)
      params.push(SOLUONG)
    }

    if (CACHSD !== undefined) {
      updates.push(`CACHSD = $${updates.length + 1}`)
      params.push(CACHSD)
    }

    const query = `
        UPDATE SO_LUONG_THUOC
        SET ${updates.join(', ')}
        WHERE MASO_BKB = $${updates.length + 1} AND MASO_TH = $${updates.length + 2}
      `
    params.push(MASO_BKB, MASO_TH)

    const result = await db.query(query, params)

    if (result.rowCount === 0) {
      return res.status(404).json({ message: 'Không tìm thấy bản ghi.' })
    }

    return res.status(200).json(result.rows[0])
  }
}

export default SoluongthuocController
