import { Request, Response } from 'express'
import db from '~/dbs/initDatabase'
class BenhnhiController {
  // router.get('/phuhuynh/:cccd', asyncHandler(BenhnhiController.getBenhnhiByCCCD))
  static async getBenhnhiByCCCD(req: Request, res: Response) {
    const { cccd } = req.params
    if (!cccd) {
      return res.status(400).json({ message: 'Missing cccd' })
    }
    const benhnhi = await db.query('SELECT * FROM GIAM_HO G JOIN BENH_NHI B ON G.MASO_BN = B.MASO WHERE G.CCCD = $1;', [
      cccd
    ])

    return res.status(200).json(benhnhi.rows)
  }
  //router.post('/add', asyncHandler(BenhnhiController.addBenhnhi))
  static async addBenhnhi(req: Request, res: Response) {
    // Destructure the data from the request body
    const { hoten, ngaysinh, gioitinh, chieucao, cannang, bmi, tiensubenh, masobhyt, cccd, quanhe } = req.body

    // Basic validation (you can add more checks here)
    if (!hoten || !ngaysinh || !chieucao || !cannang || !masobhyt || !cccd || !quanhe) {
      return res.status(400).json({ message: 'Missing required fields' })
    }

    // SQL query to insert the new data into the BENH_NHI table
    const query = `
      INSERT INTO BENH_NHI (HOTEN, NGAYSINH, GIOITINH, CHIEUCAO, CANNANG, BMI, TIENSUBENH, MASOBHYT)
      VALUES ($1, $2, $3, $4, $5, $6, $7, $8)
      RETURNING *;
    `

    // Execute the query with the values
    const result = await db.query(query, [hoten, ngaysinh, gioitinh, chieucao, cannang, bmi, tiensubenh, masobhyt])

    const quanheResult = await db.query(
      'INSERT INTO GIAM_HO (CCCD, MASO_BN, QUANHE) VALUES ($1, $2, $3) RETURNING *;',
      [cccd, result.rows[0].maso, quanhe]
    )

    // Respond with the newly created record
    res.status(201).json({
      message: 'Benh Nhi added successfully',
      data: { ...result.rows[0], quanhe, phuhuynh_cccd: cccd }
    })
  }
  // router.put('/update', asyncHandler(BenhnhiController.updateBenhnhi))

  static async updateBenhnhi(req: Request, res: Response) {
    // Destructure the data from the request body
    const { maso, hoten, ngaysinh, gioitinh, chieucao, cannang, bmi, tiensubenh, masobhyt } = req.body

    // Basic validation (you can add more checks here)
    if (!maso) {
      return res.status(400).json({ message: 'Missing required fields' })
    }

    // SQL query to update the data in the BENH_NHI table
    const query = `
      UPDATE BENH_NHI
      SET HOTEN = $1, NGAYSINH = $2, GIOITINH = $3, CHIEUCAO = $4, CANNANG = $5, BMI = $6, TIENSUBENH = $7, MASOBHYT = $8
      WHERE MASO = $9
      RETURNING *;
    `

    // Execute the query with the values
    const result = await db.query(query, [
      hoten,
      ngaysinh,
      gioitinh,
      chieucao,
      cannang,
      bmi,
      tiensubenh,
      masobhyt,
      maso
    ])

    // Respond with the updated record
    res.status(200).json({
      message: 'Benh Nhi updated successfully',
      data: result.rows[0]
    })
  }

  // router.delete('/delete', asyncHandler(BenhnhiController.deleteBenhnhi))
  static async deleteBenhnhi(req: Request, res: Response) {
    // Destructure the data from the request body
    const { maso } = req.body

    // Basic validation (you can add more checks here)
    if (!maso) {
      return res.status(400).json({ message: 'Missing required fields' })
    }

    const deletew = await db.query('SELECT * FROM GIAM_HO WHERE MASO_BN = $1', [maso])
    if (deletew.rows.length === 0) {
      return res.status(400).json({ message: 'Benh Nhi not found' })
    }
    const quanhe = await db.query('DELETE FROM GIAM_HO WHERE MASO_BN = $1', [maso])

    // SQL query to delete the data in the BENH_NHI table
    const query = `
        DELETE FROM BENH_NHI
        WHERE MASO = $1
        RETURNING *;
        `
    // Execute the query with the values
    const result = await db.query(query, [maso])

    // Respond with the deleted record
    res.status(200).json({
      message: 'Benh Nhi deleted successfully',
      data: result.rows[0]
    })
  }
}

export default BenhnhiController
