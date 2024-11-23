import { Request, Response } from 'express'
import db from '~/dbs/initDatabase'
class DonthuocController {
  // router.post('/add', asyncHandler(DonthuocController.addDonthuoc))
  static async addDonthuoc(req: Request, res: Response) {
    // Extract data from the request body
    const { maso_bkb, thoigianradon, ngaytaikham, loidan, maso_bn, cccd_bs, mahoadon } = req.body

    // Validate required fields
    if (!maso_bkb || !thoigianradon || !loidan || !maso_bn || !cccd_bs || !mahoadon) {
      return res.status(400).json({ message: 'Missing required fields' })
    }

    // SQL query to insert a new prescription into the DON_THUOC table
    const query = `
      INSERT INTO DON_THUOC (
        MASO_BKB,
        THOIGIANRADON,
        NGAYTAIKHAM,
        LOIDAN,
        MASO_BN,
        CCCD_BS,
        MAHOADON
      ) VALUES ($1, $2, $3, $4, $5, $6, $7) RETURNING *;
    `

    try {
      // Execute the query
      const result = await db.query(query, [maso_bkb, thoigianradon, ngaytaikham, loidan, maso_bn, cccd_bs, mahoadon])

      // Respond with the newly created prescription
      res.status(201).json({
        message: 'Prescription added successfully',
        data: result.rows[0]
      })
    } catch (error) {
      console.error('Error adding prescription:', error)
      res.status(500).json({ message: 'Internal Server Error' })
    }
  }
  // router.put('/update', asyncHandler(DonthuocController.updateDonthuoc))
  static async updateDonthuoc(req: Request, res: Response) {
    // Extract data from the request body
    const { maso_bkb, thoigianradon, ngaytaikham, loidan, maso_bn, cccd_bs, mahoadon } = req.body

    // Validate required fields
    if (!maso_bkb || !thoigianradon || !loidan || !maso_bn || !cccd_bs || !mahoadon) {
      return res.status(400).json({ message: 'Missing required fields' })
    }

    // SQL query to update the prescription
    const query = `
      UPDATE DON_THUOC
      SET
        NGAYTAIKHAM = $3,
        LOIDAN = $4,
        MASO_BN = $5,
        CCCD_BS = $6,
        MAHOADON = $7
      WHERE MASO_BKB = $1 AND THOIGIANRADON = $2
      RETURNING *;
    `

    try {
      // Execute the query
      const result = await db.query(query, [maso_bkb, thoigianradon, ngaytaikham, loidan, maso_bn, cccd_bs, mahoadon])

      // If no rows were updated, return an error
      if (result.rowCount === 0) {
        return res.status(404).json({ message: 'Prescription not found' })
      }

      // Respond with the updated prescription
      res.status(200).json({
        message: 'Prescription updated successfully',
        data: result.rows[0]
      })
    } catch (error) {
      console.error('Error updating prescription:', error)
      res.status(500).json({ message: 'Internal Server Error' })
    }
  }
}
export default DonthuocController
