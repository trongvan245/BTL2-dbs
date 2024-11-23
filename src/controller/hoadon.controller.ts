import { Request, Response } from 'express'
import db from '~/dbs/initDatabase'
class HoadonController {
  //router.post('/add', asyncHandler(HoadonController.addHoadon))
  static async addHoadon(req: Request, res: Response) {
    const { maso_bkb, tongtien, ghichu, cccd_ph, cccd_tn } = req.body

    // Validate required fields
    if (!maso_bkb || !tongtien || !cccd_ph || !cccd_tn) {
      return res.status(400).json({ message: 'Missing required fields' })
    }
    const result = await db.query(
      'INSERT INTO HOA_DON (MASO_BKB, TONGTIEN, GHICHU, CCCD_PH, CCCD_TN) VALUES ($1, $2, $3, $4, $5) RETURNING *;',
      [maso_bkb, tongtien, ghichu, cccd_ph, cccd_tn]
    )

    res.status(201).json({
      message: 'Invoice added successfully',
      data: result.rows[0]
    })
  }
  // router.put('/update', asyncHandler(HoadonController.updateHoadon))
  static async updateHoadon(req: Request, res: Response) {
    const { mahoadon, tongtien, ghichu } = req.body

    // Validate required fields
    if (!mahoadon) {
      return res.status(400).json({ message: 'Missing required field: mahoadon' })
    }

    const query = `
        UPDATE HOA_DON
        SET TONGTIEN = COALESCE($2, TONGTIEN),
            GHICHU = COALESCE($3, GHICHU)
        WHERE MAHOADON = $1
        RETURNING *;
      `

    const values = [mahoadon, tongtien, ghichu]
    const result = await db.query(query, values)

    if (result.rowCount === 0) {
      return res.status(404).json({ message: 'Invoice not found' })
    }

    res.status(200).json({
      message: 'Invoice updated successfully',
      data: result.rows[0]
    })
  }
}
export default HoadonController
