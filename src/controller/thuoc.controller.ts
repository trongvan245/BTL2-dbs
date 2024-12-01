import { Request, Response } from 'express'
import { console } from 'inspector';
import db from '~/dbs/initDatabase'
class ThuocController {
    // router.get('/', asyncHandler(ThuocController.getAllDrugs))
    static async getAllDrugs(req: Request, res: Response) {
        try {
            const services = await db.query('SELECT * FROM THUOC');
            return res.status(200).json(services.rows);
        } catch (err) {
            const error = err as Error;
            return res.status(500).json({ message: 'Error retrieving Dich vu kham', error: error.message })
        }
    }


  // router.post('/add', asyncHandler(ThuocController.addDrug))
  static async addDrug(req: Request, res: Response) {
    // Extract data from the request body
    const { ten, dang, giaca } = req.body

    // Validate required fields
    if (!ten  || !dang || !giaca) {
      return res.status(400).json({ message: 'Missing required fields' })
    }
    try {
      const query = `
        CALL InsertThuoc ($1, $2, $3, NULL);
      `
      const result = await db.query(query, [ten, dang, giaca])

      return res.status(201).json({
        message: 'The drug is added successfully',
        data: result.rows[0] // MASO thuoc
      })
    } catch (err) {
      const error = err as Error;
      return res.status(500).json({ message: 'Error adding drug', error: error.message });
    }
  }
  // router.put('/update', asyncHandler(ThuocController.updateDrug))
  static async updateDrug(req: Request, res: Response) {
    const { maso, ten, dang, giaca } = req.body

    if (!maso) {
      return res.status(400).json({ message: 'Missing Drug ID field' })
    }
  
    try {
      const query = `
        CALL UpdateThuoc ($1, $2, $3, $4);
      `
      await db.query(query, [maso, ten, dang, giaca])
      return res.status(200).json({ message: 'Drug updated successfully' });
    } catch (err) {
      const error = err as Error;
      return res.status(500).json({ message: 'Error updating drug', error: error.message });
    }

  }

  // router.delete('/delete', asyncHandler(ThuocController.deleteDrug))
  static async deleteDrug(req: Request, res: Response) {
    const { maso } = req.body
    console.log(maso)
    if (!maso) {
      return res.status(400).json({ message: 'Missing Drug ID' })
    }
    try {
      const result = await db.query(`CALL DeleteThuoc($1);`, [maso]);
      return res.status(200).json({
        message: 'Drug deleted successfully',
        data: result.rows[0]
      })
    } catch (err) {
      const error = err as Error;
      return res.status(500).json({ message: 'Error deleting Drug', error: error.message });
    }
  }
}
export default ThuocController
