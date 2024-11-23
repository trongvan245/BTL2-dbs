import { Request, Response } from 'express'
import db from '~/dbs/initDatabase'
class PhuhuynhController {
  // router.post("/add", asyncHandler(async (req, res) => {}));
  static async addPhuhuynh(req: Request, res: Response) {
    // Destructure the data from the request body
    const { cccd, hoten, sdt, sonha, tenduong, phuong, huyen, tinh } = req.body

    // Basic validation (you can add more checks here)
    if (!cccd || !hoten || !sdt || !huyen || !tinh) {
      return res.status(400).json({ message: 'Missing required fields' })
    }

    // SQL query to insert the new data into the PHU_HUYNH table
    const query = `
      INSERT INTO PHU_HUYNH (CCCD, HOTEN, SDT, SONHA, TENDUONG, PHUONG, HUYEN, TINH)
      VALUES ($1, $2, $3, $4, $5, $6, $7, $8)
      RETURNING *;
    `

    try {
      // Execute the query with the values
      const result = await db.query(query, [cccd, hoten, sdt, sonha, tenduong, phuong, huyen, tinh])

      // Respond with the newly created record
      res.status(201).json({
        message: 'Phu Huynh added successfully',
        data: result.rows[0]
      })
    } catch (error) {
      console.error('Error inserting Phu Huynh:', error)
      res.status(500).json({ message: 'Error adding Phu Huynh', error })
    }
  }
  // router.put("/update", asyncHandler(async (req, res) => {}));
  static async updatePhuhuynh(req: Request, res: Response) {
    // Destructure the data from the request body
    const { cccd, hoten, sdt, sonha, tenduong, phuong, huyen, tinh } = req.body

    // Basic validation (you can add more checks here)
    if (!cccd) {
      return res.status(400).json({ message: 'Missing required fields' })
    }

    // SQL query to update the data in the PHU_HUYNH table
    const query = `
      UPDATE PHU_HUYNH
      SET HOTEN = $1, SDT = $2, SONHA = $3, TENDUONG = $4, PHUONG = $5, HUYEN = $6, TINH = $7
      WHERE CCCD = $8
      RETURNING *;
    `

    try {
      // Execute the query with the values
      const result = await db.query(query, [hoten, sdt, sonha, tenduong, phuong, huyen, tinh, cccd])

      // Respond with the updated record
      res.status(200).json({
        message: 'Phu Huynh updated successfully',
        data: result.rows[0]
      })
    } catch (error) {
      console.error('Error updating Phu Huynh:', error)
      res.status(500).json({ message: 'Error updating Phu Huynh', error })
    }
  }
  // router.delete("/delete", asyncHandler(async (req, res) => {}));
  static async deletePhuhuynh(req: Request, res: Response) {
    // Destructure the CCCD from the request body
    const { cccd } = req.body

    // Basic validation (you can add more checks here)
    if (!cccd) {
      return res.status(400).json({ message: 'Missing required fields' })
    }

    const phuhuynh = await db.query('SELECT * FROM PHU_HUYNH WHERE CCCD = $1', [cccd])
    if (phuhuynh.rows.length === 0) {
      return res.status(404).json({ message: 'Phu Huynh not found' })
    }

    // SQL query to delete the data from the PHU_HUYNH table
    const query = `
        DELETE FROM PHU_HUYNH
        WHERE CCCD = $1
        RETURNING *;
        `
    try {
      // Execute the query with the values
      const result = await db.query(query, [cccd])

      // Respond with the deleted record
      res.status(200).json({
        message: 'Phu Huynh deleted successfully',
        data: result.rows[0]
      })
    } catch (error) {
      console.error('Error deleting Phu Huynh:', error)
      res.status(500).json({ message: 'Error deleting Phu Huynh', error })
    }
  }
}

export default PhuhuynhController
