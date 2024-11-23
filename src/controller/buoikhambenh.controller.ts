import { Request, Response } from 'express'
import db from '~/dbs/initDatabase'

class BuoiKhamBenhController {
  //router.post('/add', asyncHandler(BuoikhambenhController.addBuoikhambenh))
  static async addBuoikhambenh(req: Request, res: Response) {
    // Extract data from request body
    const { taikham, trangthai, huyetap, nhietdo, chandoan, ketluan, maso_bn, cccd_bs } = req.body

    // Validate required fields
    if (!taikham || !trangthai || !huyetap || !nhietdo || !chandoan || !ketluan || !maso_bn || !cccd_bs) {
      return res.status(400).json({ message: 'Missing required fields' })
    }

    // Insert into the BUOI_KHAM_BENH table
    const query = `
            INSERT INTO BUOI_KHAM_BENH (
              TAIKHAM,
              TRANGTHAI,
              HUYETAP,
              NHIETDO,
              CHANDOAN,
              KETLUAN,
              MASO_BN,
              CCCD_BS
            ) VALUES (
              $1, $2, $3, $4, $5, $6, $7, $8
            ) RETURNING *;
          `

    // Execute the query
    const result = await db.query(query, [taikham, trangthai, huyetap, nhietdo, chandoan, ketluan, maso_bn, cccd_bs])

    // Respond with the newly created record
    res.status(201).json({
      message: 'Medical appointment added successfully',
      data: result.rows[0]
    })
  }
  //router.put('/update', asyncHandler(BuoikhambenhController.updateBuoikhambenh))
  static async updateBuoikhambenh(req: Request, res: Response) {
    const { maso, taikham, trangthai, huyetap, nhietdo, chandoan, ketluan, maso_bn, cccd_bs } = req.body

    if (!maso) {
      return res.status(400).json({ message: 'Missing required fields' })
    }

    const query = `
            UPDATE BUOI_KHAM_BENH
            SET TAIKHAM = $1, TRANGTHAI = $2, HUYETAP = $3, NHIETDO = $4, CHANDOAN = $5, KETLUAN = $6, MASO_BN = $7, CCCD_BS = $8
            WHERE MASO = $9
            RETURNING *;
          `
    const result = await db.query(query, [
      taikham,
      trangthai,
      huyetap,
      nhietdo,
      chandoan,
      ketluan,
      maso_bn,
      cccd_bs,
      maso
    ])

    res.status(200).json({
      message: 'Medical appointment updated successfully',
      data: result.rows[0]
    })
  }
}

export default BuoiKhamBenhController
