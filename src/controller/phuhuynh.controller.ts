import { Request, Response } from 'express'

class PhuhuynhController {
  // router.post("/add", asyncHandler(async (req, res) => {}));
  static async addPhuhuynh(req: Request, res: Response) {
    // Destructure the data from the request body
    const { CCCD, HOTEN, SDT, SONHA, TENDUONG, PHUONG, HUYEN, TINH } = req.body

    // Basic validation (you can add more checks here)
    if (!CCCD || !HOTEN || !SDT || !HUYEN || !TINH) {
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
      const result = await pool.query(query, [CCCD, HOTEN, SDT, SONHA, TENDUONG, PHUONG, HUYEN, TINH])

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
  // router.delete("/delete", asyncHandler(async (req, res) => {}));
}
