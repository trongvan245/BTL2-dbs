import { Request, Response } from 'express'
import db from '~/dbs/initDatabase'
class BenhnhiController {
  // router.get('/', asyncHandler(BenhnhiController.getAllBenhnhi))
  static async getAllBenhnhi(req: Request, res: Response) {
    const benhnhi = await db.query('SELECT * FROM BENH_NHI')
    return res.status(200).json(benhnhi.rows)
  }

  // router.get('/:maso', asyncHandler(BenhnhiController.getBenhnhiByMaso))
  static async getBenhnhiByMaso(req: Request, res: Response) {
    const { maso } = req.params
    if (!maso) {
      return res.status(400).json({ message: 'Missing maso' })
    }
    const benhnhi = await db.query('SELECT * FROM BENH_NHI WHERE MASO = $1;', [maso])
    return res.status(200).json(benhnhi.rows)
  }

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
    console.log({ hoten, ngaysinh, gioitinh, chieucao, cannang, bmi, tiensubenh, masobhyt, cccd, quanhe })
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

  static async getPillsByMaso(req: Request, res: Response) {
    const { maso } = req.params
    if (!maso) {
      return res.status(400).json({ message: 'Missing maso' })
    }
    // console.log(maso)
    try {
      const pills = await db.query('SELECT * FROM get_pills_for_child($1::uuid);', [maso])
      return res.status(200).json({ pills: pills.rows })
    } catch (error) {
      // console.log(error)
      // console.log((error as any).error)
      return res.status(400).json({ message: 'Something went wrong', error })
    }
  }
}

export default BenhnhiController
