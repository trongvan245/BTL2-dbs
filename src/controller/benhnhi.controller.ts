import { Request, Response } from 'express'
import db from '../dbs/initDatabase'; // Assuming the correct relative path to the initDatabase module

class BenhnhiController {
  // router.get('/', asyncHandler(BenhnhiController.getAllBenhnhi))
  // Get all Benh Nhi records
  static async getAllBenhnhi(req: Request, res: Response) {
    try {
      const benhnhi = await db.query('SELECT * FROM BENH_NHI');
      return res.status(200).json(benhnhi.rows);
    } catch (err) {
      const error = err as Error;
      return res.status(500).json({ message: 'Error retrieving Benh Nhi', error: error.message })
    }
  }

  // router.get('/:maso', asyncHandler(BenhnhiController.getBenhnhiByMaso))
  // Get a single Benh Nhi by its MASO
  static async getBenhnhiByMaso(req: Request, res: Response) {
    const { maso } = req.params
    if (!maso) {
      return res.status(400).json({ message: 'Missing Benh Nhi maso' })
    }
    try {
      const benhnhi = await db.query('SELECT * FROM BENH_NHI WHERE MASO = $1;', [maso]);
      if (benhnhi.rows.length === 0) {
        return res.status(404).json({ message: 'Benh Nhi not found' });
      }
      return res.status(200).json(benhnhi.rows[0]);
    } catch (err) {
      const error = err as Error;
      return res.status(500).json({ message: 'Error retrieving Benh Nhi', error: error.message })
    }
  }

  // router.get('/phuhuynh/:cccd', asyncHandler(BenhnhiController.getBenhnhiByCCCD))
  // Get Benh Nhi records by Phu Huynh CCCD
  static async getBenhnhiByCCCD(req: Request, res: Response) {
    const { cccd } = req.params;
    if (!cccd) {
      return res.status(400).json({ message: 'Missing CCCD phu huynh cua Benh Nhi' });
    }
    try {
      const benhnhi = await db.query(
        'SELECT * FROM GIAM_HO G JOIN BENH_NHI B ON G.MASO_BN = B.MASO WHERE G.CCCD = $1;',
        [cccd]
      );
      return res.status(200).json(benhnhi.rows);
    } catch (err) {
      const error = err as Error;
      return res.status(500).json({ message: 'Error retrieving patients', error: error.message })
    }
  }

  //router.post('/add', asyncHandler(BenhnhiController.addBenhnhi))
  // Add a new Benh Nhi
  static async addBenhnhi(req: Request, res: Response) {
    const { hoten, ngaysinh, gioitinh, chieucao, cannang, tiensubenh, masobhyt, cccd, quanhe } = req.body
    if (!hoten || !ngaysinh || !chieucao || !cannang || !cccd || !quanhe) {
      return res.status(400).json({ message: 'Missing required fields' });
    }
    try {
      // Call InsertBenhNhi procedure
      var result = await db.query(
        `CALL InsertBenhNhi($1, $2, $3, $4, $5, $6, $7, NULL);`,
        [hoten, ngaysinh, gioitinh, chieucao, cannang, tiensubenh, masobhyt]
      );

      // Add guardian relationship
      console.log(result);
      const maso_bn = result.rows[0].p_maso;
      
      await db.query(
        'CALL InsertGiamHo($1, $2, $3);',
        [cccd, maso_bn, quanhe]
      );

      res.status(201).json({
        message: 'Benh Nhi added successfully',
        data: { maso_bn, hoten, quanhe, phuhuynh_cccd: cccd }
      });
    } catch (err) {
      const error = err as Error;
      return res.status(500).json({ 
        message: 'Error adding Benh Nhi', 
        error: error.message 
      })
    }
  }

  // router.put('/update', asyncHandler(BenhnhiController.updateBenhnhi))
  static async updateBenhnhi(req: Request, res: Response) {
    const { maso, hoten, ngaysinh, gioitinh, chieucao, cannang, tiensubenh, masobhyt } = req.body
    if (!maso) {
      return res.status(400).json({ message: 'Missing required fields' })
    }
    try {
      // Call UpdateBenhNhi procedure
      await db.query(
        `CALL UpdateBenhNhi($1, $2, $3, $4, $5, $6, $7, $8);`,
        [maso, hoten, ngaysinh, gioitinh, chieucao, cannang, tiensubenh, masobhyt]
      );

      return res.status(200).json({ message: 'Benh Nhi updated successfully' });
    } catch (err) {
      const error = err as Error;
      return res.status(500).json({ message: 'Error updating Benh Nhi', error: error.message });
    }
  }

  // router.delete('/delete', asyncHandler(BenhnhiController.deleteBenhnhi))
  static async deleteBenhnhi(req: Request, res: Response) {
    const { maso } = req.body
    if (!maso) {
      return res.status(400).json({ message: 'Missing maso Benh Nhi' })
    }
    try {
      // Call DeleteBenhNhi procedure
      const result = await db.query(`CALL DeleteBenhNhi($1);`, [maso]);
      return res.status(200).json({
        message: 'Benh Nhi deleted successfully',
        data: result.rows[0]
      })
    } catch (err) {
      const error = err as Error;
      return res.status(500).json({ message: 'Error deleting Benh Nhi', error: error.message });
    }
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
