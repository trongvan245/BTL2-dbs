import { Request, Response } from 'express'
import db from '~/dbs/initDatabase'
class DonthuocController {
  // router.post('/add', asyncHandler(DonthuocController.addDonthuoc))
  static async addDonthuoc(req: Request, res: Response) {
    // Extract data from the request body
    const { maso_bkb, thoigianradon, ngaytaikham, loidan, cccd_bs } = req.body

    // Validate required fields
    if (!maso_bkb || !thoigianradon || !loidan || !cccd_bs) {
      return res.status(400).json({ message: 'Missing required fields' })
    }

    // SQL query to insert a new prescription into the DON_THUOC table
    const query = `
      INSERT INTO DON_THUOC (
        MASO_BKB,
        THOIGIANRADON,
        NGAYTAIKHAM,
        LOIDAN,
        CCCD_BS
      ) VALUES ($1, $2, $3, $4, $5) RETURNING *;
    `

    const result = await db.query(query, [maso_bkb, thoigianradon, ngaytaikham, loidan, cccd_bs])

    // Respond with the newly created prescription
    res.status(201).json({
      message: 'Prescription added successfully',
      data: result.rows[0]
    })
  }
  // router.put('/update', asyncHandler(DonthuocController.updateDonthuoc))
  static async updateDonthuoc(req: Request, res: Response) {
    // Extract data from the request body
    const { maso_bkb, thoigianradon, ngaytaikham, loidan, cccd_bs } = req.body

    // Validate required fields
    if (!maso_bkb || !thoigianradon || !loidan || !cccd_bs) {
      return res.status(400).json({ message: 'Missing required fields' })
    }

    // SQL query to update the prescription
    const query = `
      UPDATE DON_THUOC
      SET
        NGAYTAIKHAM = $3,
        LOIDAN = $4,
        CCCD_BS = $5
      WHERE MASO_BKB = $1 AND THOIGIANRADON = $2
      RETURNING *;
    `

    // Execute the query
    const result = await db.query(query, [maso_bkb, thoigianradon, ngaytaikham, loidan, cccd_bs])

    // If no rows were updated, return an error
    if (result.rowCount === 0) {
      return res.status(404).json({ message: 'Prescription not found' })
    }

    // Respond with the updated prescription
    res.status(200).json({
      message: 'Prescription updated successfully',
      data: result.rows[0]
    })
  }
}
export default DonthuocController
