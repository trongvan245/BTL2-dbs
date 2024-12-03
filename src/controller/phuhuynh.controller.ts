import { Request, Response } from 'express'
import db from '~/dbs/initDatabase'
class PhuhuynhController {
  //   router.get('/', asyncHandler(PhuhuynhController.getAllPhuhuynh))
  static async getAllPhuhuynh(req: Request, res: Response) {
    const query = 'SELECT * FROM PHU_HUYNH;'
    const result = await db.query(query)

    res.status(200).json(result.rows)
  }

  // router.get('/:cccd', asyncHandler(PhuhuynhController.getPhuhuynhByCCCD))
  static async getPhuhuynhByCCCD(req: Request, res: Response) {
    const { cccd } = req.params
    if (!cccd) {
      return res.status(400).json({ message: 'Thiếu CCCD' })
    }
    const phuhuynh = await db.query('SELECT * FROM PHU_HUYNH WHERE CCCD = $1;', [cccd])

    return res.status(200).json(phuhuynh.rows)
  }

  // router.post("/add", asyncHandler(async (req, res) => {}));
  static async addPhuhuynh(req: Request, res: Response) {
    // Destructure the data from the request body
    const { cccd, hoten, sdt, sonha, tenduong, phuong, huyen, tinh } = req.body

    // Basic validation (you can add more checks here)
    if (!cccd || !hoten || !sdt || !huyen || !tinh) {
      return res.status(400).json({ message: 'Thiếu thông tin bắt buộc' })
    }

    // SQL query to insert the new data into the PHU_HUYNH table
    // const query = `
    //   INSERT INTO PHU_HUYNH (CCCD, HOTEN, SDT, SONHA, TENDUONG, PHUONG, HUYEN, TINH)
    //   VALUES ($1, $2, $3, $4, $5, $6, $7, $8)
    //   RETURNING *;
    // `
    const query = `
    CALL InsertPhuHuynh ($1, $2, $3, $4, $5, $6, $7, $8);
  `
    try {
      // Execute the query with the values
      const result = await db.query(query, [cccd, hoten, sdt, sonha, tenduong, phuong, huyen, tinh])

      // Respond with the newly created record
      res.status(201).json({
        message: 'Thêm Phụ Huynh thành công',
        data: { cccd, hoten, sdt, sonha, tenduong, phuong, huyen, tinh }
      })
    } catch (error) {
      console.error('Lỗi khi thêm Phụ Huynh:', error)
      res.status(500).json({ message: 'Lỗi khi thêm Phụ Huynh', error })
    }
  }
  // router.put("/update", asyncHandler(async (req, res) => {}));
  static async updatePhuhuynh(req: Request, res: Response) {
    // Destructure the data from the request body
    const { cccd, hoten, sdt, sonha, tenduong, phuong, huyen, tinh } = req.body

    // Basic validation (you can add more checks here)
    if (!cccd) {
      return res.status(400).json({ message: 'Thiếu thông tin bắt buộc' })
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
        message: 'Cập nhật Phụ Huynh thành công',
        data: result.rows[0]
      })
    } catch (error) {
      console.error('Lỗi khi cập nhật Phụ Huynh:', error)
      res.status(500).json({ message: 'Lỗi khi cập nhật Phụ Huynh', error })
    }
  }
  // router.delete("/delete", asyncHandler(async (req, res) => {}));
  static async deletePhuhuynh(req: Request, res: Response) {
    // Destructure the CCCD from the request body
    const { cccd } = req.body

    // Basic validation (you can add more checks here)
    if (!cccd) {
      return res.status(400).json({ message: 'Thiếu thông tin bắt buộc' })
    }

    const phuhuynh = await db.query('SELECT * FROM PHU_HUYNH WHERE CCCD = $1', [cccd])
    if (phuhuynh.rows.length === 0) {
      return res.status(404).json({ message: 'Không tìm thấy Phụ Huynh' })
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
        message: 'Xóa Phụ Huynh thành công',
        data: result.rows[0]
      })
    } catch (error) {
      console.error('Lỗi khi xóa Phụ Huynh:', error)
      res.status(500).json({ message: 'Lỗi khi xóa Phụ Huynh', error })
    }
  }

  static async getBenhnhiByCCCD(req: Request, res: Response) {
    const { cccd } = req.params

    if (!cccd) {
      return res.status(400).json({ message: 'Thiếu CCCD' })
    }
    const benhnhi = await db.query('SELECT * FROM GIAM_HO WHERE CCCD = $1;', [cccd])

    return res.status(200).json(benhnhi.rows)
  }

  static async get_sum_fee_with_child(req: Request, res: Response) {
    const { cccd } = req.params
    if (!cccd) {
      return res.status(400).json({ message: 'Thiếu CCCD' })
    }
    const result = await db.query('SELECT * FROM get_sum_fee_for_child($1)', [cccd])
    console.log(result)

    return res.status(200).json({ result })
  }

  static async getPendingFee(req: Request, res: Response) {
    const { cccd } = req.params
    if (!cccd) {
      return res.status(400).json({ message: 'Thiếu CCCD' })
    }
    const result = await db.query('SELECT calculate_pending_tongtien($1)', [cccd])
    const pending_fee = result.rows[0].calculate_pending_tongtien

    return res.status(200).json({ message: pending_fee })
  }

  static async getDoneFee(req: Request, res: Response) {
    //lol naming
    const { cccd } = req.params
    console.log(cccd)
    if (!cccd) {
      return res.status(400).json({ message: 'Thiếu CCCD' })
    }
    const result = await db.query('SELECT calculate_done_tongtien($1)', [cccd])
    const done_fee = result.rows[0].calculate_done_tongtien

    return res.status(200).json({ message: done_fee })
  }
}

export default PhuhuynhController
