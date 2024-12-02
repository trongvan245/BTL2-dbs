import { Request, Response } from 'express'
import db from '~/dbs/initDatabase'
class HoadonController {
  static async getAllHoadon(req: Request, res: Response) {
    const hoadon = await db.query('SELECT ngaytao,tongtien,ghichu, P.hoten as nguoithanhtoan, N.hoten as thungan FROM HOA_DON H JOIN PHU_HUYNH P ON H.CCCD_PH = P.CCCD JOIN NHAN_VIEN N ON N.CCCD = H.CCCD_TN;')
    res.status(200).json(hoadon.rows)
  }

  static async getHoadon(req: Request, res: Response) {
    const mahoadon = req.params.mahoadon
    if (!mahoadon) {
      return res.status(400).json({ message: 'Thiếu mã hóa đơn' })
    }

    const hoadon = await db.query('SELECT * FROM HOA_DON WHERE MAHOADON = $1;', [mahoadon])
    if (hoadon.rows.length === 0) {
      return res.status(404).json({ message: 'Không tìm thấy hóa đơn' })
    }
    const masobkb = hoadon.rows[0].maso_bkb

    // SELECT * FROM SO_LUONG_THUOC S JOIN THUOC T ON S.MASO_TH = T.MASO  WHERE S.MASO_BKB = '1446b778-b4a0-47a8-a7fa-a5caa1f37bf3'
    // SELECT L.MADICHVU , ngaythuchien, chuandoan, ketluan, ten, GIACA, MOTA  FROM LAN_THUC_HIEN_DICH_VU L JOIN DICH_VU_KHAM D ON L.MADICHVU = D.MADICHVU WHERE L.MASO_BKB =  '1446b778-b4a0-47a8-a7fa-a5caa1f37bf3'
    const donthuoc = await db.query(
      'SELECT *,s.soluong*t.giaca FROM SO_LUONG_THUOC S JOIN THUOC T ON S.MASO_TH = T.MASO  WHERE S.MASO_BKB = $1;',
      [masobkb]
    )

    const giacathuoc = await db.query(
      'SELECT sum(s.soluong*t.giaca) FROM SO_LUONG_THUOC S JOIN THUOC T ON S.MASO_TH = T.MASO  WHERE S.MASO_BKB = $1;',
      [masobkb]
    )
    console.log(giacathuoc.rows[0].sum)

    const lanthuchiendichvu = await db.query(
      'SELECT L.MADICHVU , ngaythuchien, chuandoan, ketluan, ten, GIACA, MOTA  FROM LAN_THUC_HIEN_DICH_VU L JOIN DICH_VU_KHAM D ON L.MADICHVU = D.MADICHVU WHERE L.MASO_BKB = $1;',
      [masobkb]
    )

    const giacadichvu = await db.query(
      'SELECT sum(giaca) FROM LAN_THUC_HIEN_DICH_VU L JOIN DICH_VU_KHAM D ON L.MADICHVU = D.MADICHVU WHERE L.MASO_BKB = $1;',
      [masobkb]
    )

    console.log(giacadichvu.rows[0].sum)

    res.status(200).json({
      hoadon: hoadon.rows[0],
      donthuoc: donthuoc.rows,
      lanthuchiendichvu: lanthuchiendichvu.rows
    })
  }
  //router.post('/add', asyncHandler(HoadonController.addHoadon))
  static async addHoadon(req: Request, res: Response) {
    const { maso_bkb, ghichu, cccd_ph, cccd_tn, trangthai } = req.body

    // Validate required fields
    if (!maso_bkb || !cccd_ph || !cccd_tn || !trangthai) {
      return res.status(400).json({ message: 'Thiếu các trường bắt buộc' })
    }
    const result = await db.query(
      'INSERT INTO HOA_DON (MASO_BKB, GHICHU, CCCD_PH, CCCD_TN, TRANGTHAI) VALUES ($1, $2, $3, $4, $5) RETURNING *;',
      [maso_bkb, ghichu, cccd_ph, cccd_tn, trangthai]
    )
    if (result.rows.length === 0) {
      // If no rows are returned
      return res.status(500).json({ message: 'Failed to insert data', data: result })
    }

    const hoadon = await db.query('SELECT * FROM HOA_DON WHERE MAHOADON = $1;', [result.rows[0].mahoadon])

    res.status(201).json({
      message: 'Thêm hóa đơn thành công',
      data: hoadon.rows[0]
    })
  }
  // router.put('/update', asyncHandler(HoadonController.updateHoadon))
  static async updateHoadon(req: Request, res: Response) {
    const { mahoadon, tongtien, ghichu } = req.body

    // Validate required fields
    if (!mahoadon) {
      return res.status(400).json({ message: 'Thiếu trường bắt buộc: mã hóa đơn' })
    }

    const query = `
        UPDATE HOA_DON
        SET TONGTIEN = COALESCE($2, TONGTIEN),
            GHICHU = COALESCE($3, GHICHU)
        WHERE MAHOADON = $1
        RETURNING *;
      `

    const values = [mahoadon, tongtien, ghichu]
    const result = await db.query(query, values)

    if (result.rowCount === 0) {
      return res.status(404).json({ message: 'Không tìm thấy hóa đơn' })
    }

    res.status(200).json({
      message: 'Cập nhật hóa đơn thành công',
      data: result.rows[0]
    })
  }

  static async getSumFeeInDateRange(req: Request, res: Response) {
    const { from, to } = req.query
    console.log(from, to)
    try {
      const fee = await db.query('SELECT tinh_tonghoadon_trong_thoigian($1, $2);', [from, to])
      return res.status(200).json({ total_fee: fee.rows[0].tinh_tonghoadon_trong_thoigian })
    } catch (error) {
      return res.status(400).json({ message: 'Something went wrong', error })
    }
  }

  static async getAllFee(req: Request, res: Response) {
    const { from, to } = req.query
    console.log(from, to)
    try {
      const fee = await db.query('SELECT * FROM get_hoadon_in_day_range($1, $2);', [from, to])
      return res.status(200).json({ rows: fee.rows })
    } catch (error) {
      return res.status(400).json({ message: 'Something went wrong', error })
    }
  }
}
export default HoadonController
