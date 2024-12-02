import { Request, Response } from 'express'
import db from '~/dbs/initDatabase'

class BuoiKhamBenhController {
  //router.get('/', asyncHandler(BuoikhambenhController.getAllBuoikhambenh))
  static async getAllBuoikhambenh(req: Request, res: Response) {
    const query = 'SELECT * FROM BUOI_KHAM_BENH;'
    const result = await db.query(query)
    res.status(200).json(result.rows)
  }
  //router.get('/benhnhi/:maso', asyncHandler(BuoikhambenhController.getBuoikhambenhByBenhnhi))
  static async getBuoikhambenhByBenhnhi(req: Request, res: Response) {
    const maso = req.params.maso
    if (!maso) {
      return res.status(400).json({ message: 'Thiếu mã số' })
    }
    const query = 'SELECT * FROM BUOI_KHAM_BENH WHERE MASO_BN = $1;'
    const result = await db.query(query, [maso])
    res.status(200).json(result.rows)
  }
  //router.get('/phuhuynh/:maso', asyncHandler(BuoikhambenhController.getBuoikhambenhBymaso))
  static async getBuoikhambenhById(req: Request, res: Response) {
    const maso = req.params.maso
    //console.log(maso)
    if (!maso) {
      return res.status(400).json({ message: 'Thiếu mã số' })
    }
    const query = 'SELECT * FROM BUOI_KHAM_BENH B JOIN BAC_SI BS ON B.cccd_bs = BS.CCCD  WHERE MASO = $1;'
    const result = await db.query(query, [maso])

    const donthuoc = await db.query(
      'SELECT *,s.soluong*t.giaca FROM SO_LUONG_THUOC S JOIN THUOC T ON S.MASO_TH = T.MASO  WHERE S.MASO_BKB = $1;',
      [maso]
    )

    const lanthuchiendichvu = await db.query(
      'SELECT L.MADICHVU , ngaythuchien, chuandoan, ketluan, ten, GIACA, MOTA  FROM LAN_THUC_HIEN_DICH_VU L JOIN DICH_VU_KHAM D ON L.MADICHVU = D.MADICHVU WHERE L.MASO_BKB = $1;',
      [maso]
    )

    const hoadon = await db.query('SELECT * FROM HOA_DON WHERE MASO_BKB = $1;', [maso])

    console.log(result.rows[0])

    res.status(200).json({
      buoikhambenh: result.rows[0],
      donthuoc: donthuoc.rows,
      lanthuchiendichvu: lanthuchiendichvu.rows,
      hoadon: hoadon.rows.length > 0 ? hoadon.rows[0] : null
    })
  }

  //router.post('/add', asyncHandler(BuoikhambenhController.addBuoikhambenh))
  static async addBuoikhambenh(req: Request, res: Response) {
    // Extract data from request body
    const { taikham, trangthai, huyetap, nhietdo, chandoan, ketluan, maso_bn, cccd_bs } = req.body

    // Validate required fields
    if (!taikham || !trangthai || !huyetap || !nhietdo || !chandoan || !ketluan || !maso_bn || !cccd_bs) {
      return res.status(400).json({ message: 'Thiếu các trường bắt buộc' })
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
              cccd_bs
            ) VALUES (
              $1, $2, $3, $4, $5, $6, $7, $8
            ) RETURNING *;
          `

    // Execute the query
    const result = await db.query(query, [taikham, trangthai, huyetap, nhietdo, chandoan, ketluan, maso_bn, cccd_bs])

    // Respond with the newly created record
    res.status(201).json({
      message: 'Thêm buổi khám bệnh thành công',
      data: result.rows[0]
    })
  }
  //router.put('/update', asyncHandler(BuoikhambenhController.updateBuoikhambenh))
  static async updateBuoikhambenh(req: Request, res: Response) {
    const { maso, taikham, trangthai, huyetap, nhietdo, chandoan, ketluan, maso_bn, cccd_bs } = req.body

    if (!maso) {
      return res.status(400).json({ message: 'Thiếu các trường bắt buộc' })
    }

    const query = `
            UPDATE BUOI_KHAM_BENH
            SET TAIKHAM = $1, TRANGTHAI = $2, HUYETAP = $3, NHIETDO = $4, CHANDOAN = $5, KETLUAN = $6, MASO_BN = $7, cccd_bs = $8
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
      message: 'Cập nhật buổi khám bệnh thành công',
      data: result.rows[0]
    })
  }

  static async getFeeInDateRange(req: Request, res: Response) {
    const { from, to } = req.query
    console.log(from, to)
    try {
      const fee = await db.query('SELECT tinh_tonghoadon_trong_thoigian($1, $2);', [from, to])
      return res.status(200).json({ total_fee: fee.rows[0].tinh_tonghoadon_trong_thoigian })
    } catch (error) {
      return res.status(400).json({ message: 'Có lỗi xảy ra', error })
    }
  }
}

export default BuoiKhamBenhController
