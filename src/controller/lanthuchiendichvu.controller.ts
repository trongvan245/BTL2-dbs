import { Request, Response } from 'express'
import db from '~/dbs/initDatabase'
class LanthuchiendichvuController {
  // router.post('/add', asyncHandler(LanthuchiendichvuController.addLanthuchiendichvu))
  // Add a new record to LAN_THUC_HIEN_DICH_VU
  static async addLanthuchiendichvu(req: Request, res: Response) {
    const { chuandoan, ketluan, maso_bkb, madichvu } = req.body

    // Validate required fields
    if (!chuandoan || !ketluan || !maso_bkb || !madichvu) {
      return res.status(400).json({ message: 'Missing required fields' })
    }

    // Insert into LAN_THUC_HIEN_DICH_VU table
    const query = `
        INSERT INTO LAN_THUC_HIEN_DICH_VU (
          CHUANDOAN,
          KETLUAN,
          MASO_BKB,
          MADICHVU
        ) VALUES (
          $1, $2, $3, $4
        ) RETURNING *;
      `

    const result = await db.query(query, [chuandoan, ketluan, maso_bkb, madichvu])

    // Respond with the newly created record
    res.status(201).json({
      message: 'Service execution added successfully',
      data: result.rows[0]
    })
  }

  // router.put('/update', asyncHandler(LanthuchiendichvuController.updateDonthuoc))
  // Update an existing record in LAN_THUC_HIEN_DICH_VU
  static async updateLanthuchiendichvu(req: Request, res: Response) {
    const { maso, chuandoan, ketluan, maso_bkb, madichvu } = req.body

    // Validate required fields
    if (!maso || !chuandoan || !ketluan || !maso_bkb || !madichvu) {
      return res.status(400).json({ message: 'Missing required fields' })
    }

    // Update the LAN_THUC_HIEN_DICH_VU table
    const query = `
        UPDATE LAN_THUC_HIEN_DICH_VU
        SET 
          CHUANDOAN = $1,
          KETLUAN = $2,
          MASO_BKB = $3,
          MADICHVU = $4
        WHERE MASO = $5
        RETURNING *;
      `

    const result = await db.query(query, [chuandoan, ketluan, maso_bkb, madichvu, maso])

    // If no record is found to update
    if (result.rows.length === 0) {
      return res.status(404).json({ message: 'Record not found' })
    }

    // Respond with the updated record
    res.status(200).json({
      message: 'Service execution updated successfully',
      data: result.rows[0]
    })
  }
}
export default LanthuchiendichvuController
