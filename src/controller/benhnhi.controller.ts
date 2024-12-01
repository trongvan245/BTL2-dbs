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
      return res.status(500).json({ message: 'Lỗi khi lấy danh sách Bệnh Nhi', error: error.message })
    }
  }

  // router.get('/:maso', asyncHandler(BenhnhiController.getBenhnhiByMaso))
  // Get a single Benh Nhi by its MASO
  static async getBenhnhiByMaso(req: Request, res: Response) {
    const { maso } = req.params
    if (!maso) {
      return res.status(400).json({ message: 'Thiếu mã số Bệnh Nhi' })
    }
    try {
      const benhnhi = await db.query('SELECT * FROM BENH_NHI WHERE MASO = $1;', [maso]);
      if (benhnhi.rows.length === 0) {
        return res.status(404).json({ message: 'Không tìm thấy Bệnh Nhi' });
      }
      return res.status(200).json(benhnhi.rows[0]);
    } catch (err) {
      const error = err as Error;
      return res.status(500).json({ message: 'Lỗi khi lấy thông tin Bệnh Nhi', error: error.message })
    }
  }

  // router.get('/phuhuynh/:cccd', asyncHandler(BenhnhiController.getBenhnhiByCCCD))
  // Get Benh Nhi records by Phu Huynh CCCD
  static async getBenhnhiByCCCD(req: Request, res: Response) {
    const { cccd } = req.params;
    if (!cccd) {
      return res.status(400).json({ message: 'Thiếu CCCD phụ huynh của Bệnh Nhi' });
    }
    try {
      const benhnhi = await db.query(
        'SELECT * FROM GIAM_HO G JOIN BENH_NHI B ON G.MASO_BN = B.MASO WHERE G.CCCD = $1;',
        [cccd]
      );
      return res.status(200).json(benhnhi.rows);
    } catch (err) {
      const error = err as Error;
      return res.status(500).json({ message: 'Lỗi khi lấy danh sách Bệnh Nhi', error: error.message })
    }
  }

  //router.post('/add', asyncHandler(BenhnhiController.addBenhnhi))
  // Add a new Benh Nhi
  static async addBenhnhi(req: Request, res: Response) {
    const { hoten, ngaysinh, gioitinh, chieucao, cannang, tiensubenh, masobhyt, cccd, quanhe } = req.body
    if (!hoten || !ngaysinh || !chieucao || !cannang || !cccd || !quanhe) {
      return res.status(400).json({ message: 'Thiếu thông tin bắt buộc' });
    }
    try {
      // Call InsertBenhNhi procedure
      var result = await db.query(
        `CALL InsertBenhNhi($1, $2, $3, $4, $5, $6, $7, NULL);`,
        [hoten, ngaysinh, gioitinh, chieucao, cannang, tiensubenh, masobhyt]
      );

      // Add guardian relationship
      const maso_bn = result.rows[0].p_maso;
      
      await db.query(
        'CALL InsertGiamHo($1, $2, $3);',
        [cccd, maso_bn, quanhe]
      );

      res.status(201).json({
        message: 'Thêm Bệnh Nhi thành công',
        data: { maso_bn, hoten, quanhe, phuhuynh_cccd: cccd }
      });
    } catch (err) {
      const error = err as Error;
      return res.status(500).json({ 
        message: 'Lỗi khi thêm Bệnh Nhi', 
        error: error.message 
      })
    }
  }

  // router.put('/update', asyncHandler(BenhnhiController.updateBenhnhi))
  static async updateBenhnhi(req: Request, res: Response) {
    const { maso, hoten, ngaysinh, gioitinh, chieucao, cannang, tiensubenh, masobhyt } = req.body
    if (!maso) {
      return res.status(400).json({ message: 'Thiếu thông tin bắt buộc' })
    }
    try {
      // Call UpdateBenhNhi procedure
      await db.query(
        `CALL UpdateBenhNhi($1, $2, $3, $4, $5, $6, $7, $8);`,
        [maso, hoten, ngaysinh, gioitinh, chieucao, cannang, tiensubenh, masobhyt]
      );

      return res.status(200).json({ message: 'Cập nhật Bệnh Nhi thành công' });
    } catch (err) {
      const error = err as Error;
      return res.status(500).json({ message: 'Lỗi khi cập nhật Bệnh Nhi', error: error.message });
    }
  }

  // router.delete('/delete', asyncHandler(BenhnhiController.deleteBenhnhi))
  static async deleteBenhnhi(req: Request, res: Response) {
    const { maso } = req.body
    if (!maso) {
      return res.status(400).json({ message: 'Thiếu mã số Bệnh Nhi' })
    }
    try {
      // Call DeleteBenhNhi procedure
      const result = await db.query(`CALL DeleteBenhNhi($1);`, [maso]);
      return res.status(200).json({
        message: 'Xóa Bệnh Nhi thành công',
        data: result.rows[0]
      })
    } catch (err) {
      const error = err as Error;
      return res.status(500).json({ message: 'Lỗi khi xóa Bệnh Nhi', error: error.message });
    }
  }

  static async getPillsByMaso(req: Request, res: Response) {
    const { maso } = req.params
    if (!maso) {
      return res.status(400).json({ message: 'Thiếu mã số' })
    }
    // console.log(maso)
    try {
      const pills = await db.query('SELECT * FROM get_pills_for_child($1::uuid);', [maso])
      return res.status(200).json({ pills: pills.rows })
    } catch (error) {
      // console.log(error)
      // console.log((error as any).error)
      return res.status(400).json({ message: 'Có lỗi xảy ra', error })
    }
  }
}

export default BenhnhiController
