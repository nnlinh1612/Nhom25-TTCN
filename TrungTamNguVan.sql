CREATE TABLE CHUC_VU (
    MaChucVu VARCHAR(8) PRIMARY KEY,
    TenChucVu NVARCHAR(20) NOT NULL
);

CREATE TABLE LOP_HOC (
    MaLop VARCHAR(8) PRIMARY KEY,
    TenLop NVARCHAR(150) NOT NULL,
    MoTa NVARCHAR(500) NOT NULL 
);

CREATE TABLE BAI_TEST (
    MaBaiTest VARCHAR(8) PRIMARY KEY,
    TenBaiTest NVARCHAR(150) NOT NULL,
    NoiDungDe NVARCHAR(MAX)
);

CREATE TABLE TAI_KHOAN (
    MaTK VARCHAR(8) PRIMARY KEY,
    MaChucVu VARCHAR(8) NOT NULL,
    HoTen NVARCHAR(50) NOT NULL,
    Email VARCHAR(100) NOT NULL,
    MatKhau VARCHAR(255) NOT NULL,
    TrangThai NVARCHAR(20) NOT NULL,
    FOREIGN KEY (MaChucVu) REFERENCES CHUC_VU(MaChucVu)
);

CREATE TABLE HOC_VIEN (
    MaHocVien VARCHAR(8) PRIMARY KEY,
    MaLop VARCHAR(8),
    TenHocVien NVARCHAR(50) NOT NULL,
    NgaySinh DATE NOT NULL,
    SDT VARCHAR(10) NOT NULL,
	FacebookID NVARCHAR(MAX),
    KhoiLop INT NOT NULL,
    TrangThai NVARCHAR(50) NOT NULL,
    FOREIGN KEY (MaLop) REFERENCES LOP_HOC(MaLop)
);

CREATE TABLE BUOI_HOC (
    MaBuoiHoc VARCHAR(8) PRIMARY KEY,
    MaLop VARCHAR(8) NOT NULL,
    NgayHoc DATE NOT NULL,
    FOREIGN KEY (MaLop) REFERENCES LOP_HOC(MaLop)
);

CREATE TABLE LICH_HOC (
    MaLich VARCHAR(8) PRIMARY KEY,
    MaLop VARCHAR(8) NOT NULL,
    Thu INT NOT NULL, 
    TenCa NVARCHAR(50) NOT NULL, 
    GioBatDau TIME,
    GioKetThuc TIME,
    CONSTRAINT FK_Lich_Lop FOREIGN KEY (MaLop) REFERENCES LOP_HOC(MaLop)
);

CREATE TABLE KHACH_HANG (
    MaKhachHang VARCHAR(8) PRIMARY KEY,
    MaHocVien VARCHAR(8),
    TenKhachHang NVARCHAR(50) NOT NULL,
    KhoiLop INT NOT NULL,
    SDT VARCHAR(10) NOT NULL,
	FacebookID NVARCHAR(MAX),
    NguonDen NVARCHAR(255) NOT NULL,
    TrangThai NVARCHAR(50) NOT NULL,
    NgayTiepNhan DATE DEFAULT GETDATE(), -- Đã sửa dấu ; thành dấu ,
    NgayDangKy DATE NULL,                -- Đã sửa dấu ; thành dấu ,
    FOREIGN KEY (MaHocVien) REFERENCES HOC_VIEN(MaHocVien)
);

CREATE TABLE BAI_LAM (
    MaBaiLam VARCHAR(8) PRIMARY KEY,
    MaBaiTest VARCHAR(8),
    MaHocVien VARCHAR(8),
    NgayLam DATE NOT NULL,
    NoiDungBaiLam NVARCHAR(MAX),
    FOREIGN KEY (MaBaiTest) REFERENCES BAI_TEST(MaBaiTest),
    FOREIGN KEY (MaHocVien) REFERENCES HOC_VIEN(MaHocVien)
);

CREATE TABLE KQ_HOC_TAP (
    MaKQHT VARCHAR(8) PRIMARY KEY,
    MaBuoiHoc VARCHAR(8) NOT NULL,
    MaHocVien VARCHAR(8) NOT NULL,
    DiemDanh NVARCHAR(50) NOT NULL,
    BTVN NVARCHAR(50) NOT NULL,
    DiemSo FLOAT NOT NULL,
    NhanXet NVARCHAR(500) NOT NULL,
    FOREIGN KEY (MaBuoiHoc) REFERENCES BUOI_HOC(MaBuoiHoc),
    FOREIGN KEY (MaHocVien) REFERENCES HOC_VIEN(MaHocVien)
);

CREATE TABLE CT_PHU_TRACH (
    MaTK VARCHAR(8),
    MaLop VARCHAR(8),
    VaiTro NVARCHAR(50) NOT NULL,
    NgayBatDauPT DATE NOT NULL,
    NgayKetThucPT DATE NOT NULL,
    PRIMARY KEY (MaTK, MaLop),
    FOREIGN KEY (MaTK) REFERENCES TAI_KHOAN(MaTK),
    FOREIGN KEY (MaLop) REFERENCES LOP_HOC(MaLop)
);

CREATE TABLE LOI_NHAC (
    Id INT PRIMARY KEY IDENTITY(1,1), 
    MaTK VARCHAR(8), 
    TieuDe NVARCHAR(200), 
    NoiDung NVARCHAR(MAX),
    HanChot DATETIME,
    MucDo NVARCHAR(50), 
    TrangThai BIT DEFAULT 0,
    CONSTRAINT FK_Loi_nhac FOREIGN KEY (MaTK) REFERENCES TAI_KHOAN(MaTK)
);

CREATE TABLE KQ_BAI_TEST (
    MaBaiLam VARCHAR(8),
    MaTK VARCHAR(8),
    NgayCham DATE NOT NULL,
    DiemTest FLOAT NOT NULL,
    NhanXet NVARCHAR(500) NOT NULL,
    GhiChu NVARCHAR(500) NOT NULL,
    PRIMARY KEY (MaBaiLam, MaTK),
    FOREIGN KEY (MaTK) REFERENCES TAI_KHOAN(MaTK),
    CONSTRAINT FK_KQ_Test FOREIGN KEY (MaBaiLam) REFERENCES BAI_LAM(MaBaiLam)
);

CREATE TABLE CANH_BAO (
    MaCanhBao VARCHAR(8) PRIMARY KEY,
    MaKQHT VARCHAR(8) NOT NULL,
    TieuDe NVARCHAR(100),
    NoiDungCB NVARCHAR(500) NOT NULL,
    HanChot DATETIME,
    MucDo NVARCHAR(50), 
    TrangThai BIT DEFAULT 0, -- Đã bổ sung dấu phẩy còn thiếu ở đây
    FOREIGN KEY (MaKQHT) REFERENCES KQ_HOC_TAP(MaKQHT)
);

CREATE TABLE LICH_SU_TUONG_TAC (
    MaTuongTac VARCHAR(8) PRIMARY KEY,
    MaTK VARCHAR(8),
    MaKhachHang VARCHAR(8),
    MaHocVien VARCHAR(8),
    NgayTuongTac DATE NOT NULL,
    NoiDung NVARCHAR(MAX) NOT NULL,
    LoaiTuongTac NVARCHAR(50) NOT NULL,
    FOREIGN KEY (MaTK) REFERENCES TAI_KHOAN(MaTK),
    FOREIGN KEY (MaKhachHang) REFERENCES KHACH_HANG(MaKhachHang),
    FOREIGN KEY (MaHocVien) REFERENCES HOC_VIEN(MaHocVien)
);

CREATE TABLE CT_XU_LY (
    MaTK VARCHAR(8),
    MaCanhBao VARCHAR(8),
    ThoiGian DATE NOT NULL,
    GhiChuXuLy NVARCHAR(200) NOT NULL,
    TrangThaiXuLy NVARCHAR(50) NOT NULL,
    PRIMARY KEY (MaTK, MaCanhBao),
    FOREIGN KEY (MaTK) REFERENCES TAI_KHOAN(MaTK),
    FOREIGN KEY (MaCanhBao) REFERENCES CANH_BAO(MaCanhBao)
);

-- CHÈN DỮ LIỆU
--CHỨC VỤ
INSERT INTO CHUC_VU VALUES ('CV001', N'Admin'), ('CV002', N'Sale'), ('CV003', N'CSKH'), ('CV004', N'Giáo viên'), ('CV005', N'Trợ giảng'), ('CV006', N'Quản lý');

--TÀI KHOẢN 
INSERT INTO TAI_KHOAN VALUES ('TK001', 'CV001', N'Nguyễn Ngọc Anh', 'admin@gmail.com', '$2a$11$faV/gy6x6DfViReSNG.hk.nOLfU9cAjnP95tFwQYWdPbC1k7GBnk2', N'Đã duyệt');
INSERT INTO TAI_KHOAN VALUES ('TK002', 'CV002', N'Nguyễn Nhật Linh', 'nnlinh1612@gmail.com', '$2a$11$faV/gy6x6DfViReSNG.hk.nOLfU9cAjnP95tFwQYWdPbC1k7GBnk2', N'Đã duyệt');
INSERT INTO TAI_KHOAN VALUES ('TK003', 'CV003', N'Trịnh Thị Tuyết Mai', 'tuyetmaiyt1@gmail.com', '$2a$11$faV/gy6x6DfViReSNG.hk.nOLfU9cAjnP95tFwQYWdPbC1k7GBnk2', N'Đã duyệt');
INSERT INTO TAI_KHOAN VALUES ('TK004', 'CV004', N'Ninh Phương Linh', 'nplinh0315@gmail.com', '$2a$11$faV/gy6x6DfViReSNG.hk.nOLfU9cAjnP95tFwQYWdPbC1k7GBnk2', N'Đã duyệt');
INSERT INTO TAI_KHOAN VALUES ('TK005', 'CV005', N'Phạm Thùy Trang', 'phamtrangwork940@gmail.com', '$2a$11$faV/gy6x6DfViReSNG.hk.nOLfU9cAjnP95tFwQYWdPbC1k7GBnk2', N'Đã duyệt');
INSERT INTO TAI_KHOAN VALUES ('TK006', 'CV006', N'Nguyễn Minh Ánh', 'minhanh@gmail.com', '$2a$11$faV/gy6x6DfViReSNG.hk.nOLfU9cAjnP95tFwQYWdPbC1k7GBnk2', N'Đã duyệt');
--TÀI KHOẢN MỚI
INSERT INTO TAI_KHOAN (MaTK, MaChucVu, HoTen, Email, MatKhau, TrangThai) VALUES 
-- 2 Sale
('TK007', 'CV002', N'Trần Thị Thu Hà', 'thuha.sale@gmail.com', '$2a$11$faV/gy6x6DfViReSNG.hk.nOLfU9cAjnP95tFwQYWdPbC1k7GBnk2', N'Đã duyệt'),
('TK008', 'CV002', N'Lê Minh Tuấn', 'minhtuan.sale@gmail.com', '$2a$11$faV/gy6x6DfViReSNG.hk.nOLfU9cAjnP95tFwQYWdPbC1k7GBnk2', N'Đã duyệt'),
-- 2 CSKH
('TK009', 'CV003', N'Đào Mai Anh', 'maianh.cskh@gmail.com', '$2a$11$faV/gy6x6DfViReSNG.hk.nOLfU9cAjnP95tFwQYWdPbC1k7GBnk2', N'Đã duyệt'),
('TK010', 'CV003', N'Vũ Trung Kiên', 'trungkien.cskh@gmail.com', '$2a$11$faV/gy6x6DfViReSNG.hk.nOLfU9cAjnP95tFwQYWdPbC1k7GBnk2', N'Đã duyệt'),
-- 3 Giáo viên
('TK011', 'CV004', N'Hoàng Thanh Trúc', 'thanhtruc.gv@gmail.com', '$2a$11$faV/gy6x6DfViReSNG.hk.nOLfU9cAjnP95tFwQYWdPbC1k7GBnk2', N'Đã duyệt'),
('TK012', 'CV004', N'Phạm Quang Dũng', 'quangdung.gv@gmail.com', '$2a$11$faV/gy6x6DfViReSNG.hk.nOLfU9cAjnP95tFwQYWdPbC1k7GBnk2', N'Đã duyệt'),
('TK013', 'CV004', N'Ngô Thị Bích Phượng', 'bichphuong.gv@gmail.com', '$2a$11$faV/gy6x6DfViReSNG.hk.nOLfU9cAjnP95tFwQYWdPbC1k7GBnk2', N'Đã duyệt'),
-- 3 Trợ giảng
('TK014', 'CV005', N'Bùi Tiến Đạt', 'tiendat.tg@gmail.com', '$2a$11$faV/gy6x6DfViReSNG.hk.nOLfU9cAjnP95tFwQYWdPbC1k7GBnk2', N'Đã duyệt'),
('TK015', 'CV005', N'Đỗ Hải Yến', 'haiyen.tg@gmail.com', '$2a$11$faV/gy6x6DfViReSNG.hk.nOLfU9cAjnP95tFwQYWdPbC1k7GBnk2', N'Đã duyệt'),
('TK016', 'CV005', N'Trương Công Tuấn', 'congtuan.tg@gmail.com', '$2a$11$faV/gy6x6DfViReSNG.hk.nOLfU9cAjnP95tFwQYWdPbC1k7GBnk2', N'Đã duyệt');

-- LÓP HỌC 
INSERT INTO LOP_HOC (MaLop, TenLop, MoTa) VALUES 
('LH001', N'Lớp 6 - Trung bình', N'Lớp dành cho học viên có học lực trung bình'), 
('LH002', N'Lớp 6 - Khá', N'Lớp dành cho học viên có học lực khá'), 
('LH003', N'Lớp 6 - Giỏi', N'Lớp dành cho học viên có học lực  giỏi'),
('LH004', N'Lớp 7 - Trung bình', N'Lớp dành cho học viên có học lực trung bình'), 
('LH005', N'Lớp 7 - Khá', N'Lớp dành cho học viên có học lực khá'), 
('LH006', N'Lớp 7 - Giỏi', N'Lớp dành cho học viên có học lực  giỏi'),
('LH007', N'Lớp 8 - Trung bình', N'Lớp dành cho học viên có học lực trung bình'), 
('LH008', N'Lớp 8 - Khá', N'Lớp dành cho học viên có học lực khá'), 
('LH009', N'Lớp 8 - Giỏi', N'Lớp dành cho học viên có học lực  giỏi'),
('LH010', N'Lớp 9 - Trung bình', N'Lớp dành cho học viên có học lực trung bình'), 
('LH011', N'Lớp 9 - Khá', N'Lớp dành cho học viên có học lực khá'), 
('LH012', N'Lớp 9 - Giỏi', N'Lớp dành cho học viên có học lực  giỏi'),
('LH013', N'Lớp 10 - Trung bình', N'Lớp dành cho học viên có học lực trung bình'), 
('LH014', N'Lớp 10 - Khá', N'Lớp dành cho học viên có học lực khá'), 
('LH015', N'Lớp 10 - Giỏi', N'Lớp dành cho học viên có học lực  giỏi'),
('LH016', N'Lớp 11 - Trung bình', N'Lớp dành cho học viên có học lực trung bình'), 
('LH017', N'Lớp 11 - Khá', N'Lớp dành cho học viên có học lực khá'), 
('LH018', N'Lớp 11 - Giỏi', N'Lớp dành cho học viên có học lực  giỏi'),
('LH019', N'Lớp 12 - Trung bình', N'Lớp dành cho học viên có học lực trung bình'), 
('LH020', N'Lớp 12 - Khá', N'Lớp dành cho học viên có học lực khá'), 
('LH021', N'Lớp 12 - Giỏi', N'Lớp dành cho học viên có học lực  giỏi');

-- LỊCH HỌC 
-- KHỐI 6
INSERT INTO LICH_HOC VALUES ('LC001', 'LH001', 2, N'Tối 1', '18:00', '19:30'), ('LC002','LH001', 5, N'Tối 1', '18:00', '19:30');
INSERT INTO LICH_HOC VALUES ('LC003','LH002', 2, N'Tối 2', '19:45', '21:15'), ('LC004', 'LH002', 5, N'Tối 2', '19:45', '21:15');
INSERT INTO LICH_HOC VALUES ('LC005','LH003', 7, N'Sáng 1', '08:00', '09:30'), ('LC006', 'LH003', 8, N'Sáng 1', '08:00', '09:30');

-- KHỐI 7
INSERT INTO LICH_HOC VALUES ('LC007', 'LH004', 3, N'Tối 1', '18:00', '19:30'), ('LC008', 'LH004', 6, N'Tối 1', '18:00', '19:30');
INSERT INTO LICH_HOC VALUES ('LC009', 'LH005', 3, N'Tối 2', '19:45', '21:15'), ('LC010', 'LH005', 6, N'Tối 2', '19:45', '21:15');
INSERT INTO LICH_HOC VALUES ('LC011','LH006', 7, N'Sáng 2', '09:45', '11:15'), ('LC012','LH006', 8, N'Sáng 2', '09:45', '11:15');

-- KHỐI 8
INSERT INTO LICH_HOC VALUES ('LC013','LH007', 4, N'Tối 1', '18:00', '19:30'), ('LC014','LH007', 2, N'Tối 1', '18:00', '19:30');
INSERT INTO LICH_HOC VALUES ('LC015','LH008', 4, N'Tối 2', '19:45', '21:15'), ('LC016','LH008', 2, N'Tối 2', '19:45', '21:15');
INSERT INTO LICH_HOC VALUES ('LC017','LH009', 7, N'Chiều 1', '14:00', '15:30'), ('LC018','LH009', 8, N'Chiều 1', '14:00', '15:30');

-- KHỐI 9
INSERT INTO LICH_HOC VALUES ('LC019','LH010', 5, N'Tối 1', '18:00', '19:30'), ('LC020','LH010', 3, N'Tối 1', '18:00', '19:30');
INSERT INTO LICH_HOC VALUES ('LC021','LH011', 5, N'Tối 2', '19:45', '21:15'), ('LC022','LH011', 3, N'Tối 2', '19:45', '21:15');
INSERT INTO LICH_HOC VALUES ('LC023','LH012', 7, N'Chiều 2', '15:45', '17:15'), ('LC024','LH012', 8, N'Chiều 2', '15:45', '17:15');

-- KHỐI 10
INSERT INTO LICH_HOC VALUES ('LC025','LH013', 6, N'Tối 1', '18:00', '19:30'), ('LC026','LH013', 4, N'Tối 1', '18:00', '19:30');
INSERT INTO LICH_HOC VALUES ('LC027','LH014', 6, N'Tối 2', '19:45', '21:15'), ('LC028','LH014', 4, N'Tối 2', '19:45', '21:15');
INSERT INTO LICH_HOC VALUES ('LC029','LH015', 8, N'Sáng 1', '08:00', '09:30'), ('LC030','LH015', 7, N'Tối 1', '18:00', '19:30');

-- KHỐI 11
INSERT INTO LICH_HOC VALUES ('LC031','LH016', 2, N'Tối 1', '18:00', '19:30'), ('LC032','LH016', 6, N'Tối 1', '18:00', '19:30');
INSERT INTO LICH_HOC VALUES ('LC033','LH017', 2, N'Tối 2', '19:45', '21:15'), ('LC034','LH017', 6, N'Tối 2', '19:45', '21:15');
INSERT INTO LICH_HOC VALUES ('LC035','LH018', 8, N'Sáng 2', '09:45', '11:15'), ('LC036','LH018', 7, N'Tối 2', '19:45', '21:15');

-- KHỐI 12
INSERT INTO LICH_HOC VALUES ('LC037','LH019', 3, N'Tối 1', '18:00', '19:30'), ('LC038','LH019', 8, N'Chiều 1', '14:00', '15:30');
INSERT INTO LICH_HOC VALUES ('LC039','LH020', 3, N'Tối 2', '19:45', '21:15'), ('LC040','LH020', 8, N'Chiều 2', '15:45', '17:15');
INSERT INTO LICH_HOC VALUES ('LC041','LH021', 7, N'Tối 1', '18:00', '19:30'), ('LC042','LH021', 8, N'Tối 1', '18:00', '19:30');

-- CT_PHU_TRACH;
INSERT INTO CT_PHU_TRACH (MaTK, MaLop, VaiTro, NgayBatDauPT, NgayKetThucPT) VALUES
-- 1. GIỮ NGUYÊN PHÂN CÔNG CHO GIÁO VIÊN & TRỢ GIẢNG CŨ (TK004, TK005)
-- Giáo viên: Ninh Phương Linh (TK004) - 3 lớp
('TK004', 'LH006', N'Giáo viên', '2025-08-15', '2026-05-31'), -- Lớp 7 Giỏi
('TK004', 'LH008', N'Giáo viên', '2025-08-15', '2026-05-31'), -- Lớp 8 Khá
('TK004', 'LH016', N'Giáo viên', '2025-08-15', '2026-05-31'), -- Lớp 11 Trung Bình

-- Trợ giảng: Phạm Thùy Trang (TK005) - 4 lớp
('TK005', 'LH004', N'Trợ giảng', '2025-08-15', '2026-05-31'), -- Lớp 7 Trung Bình 
('TK005', 'LH007', N'Trợ giảng', '2025-08-15', '2026-05-31'), -- Lớp 8 Trung Bình
('TK005', 'LH010', N'Trợ giảng', '2025-08-15', '2026-05-31'), -- Lớp 9 Trung Bình
('TK005', 'LH020', N'Trợ giảng', '2025-08-15', '2026-05-31'), -- Lớp 12 Khá

-- Giáo viên TK011 (Phụ trách Khối 6, 7, 8, 9)
('TK011', 'LH001', N'Giáo viên', '2025-08-15', '2026-05-31'), -- Lớp 6 TB
('TK011', 'LH002', N'Giáo viên', '2025-08-15', '2026-05-31'), -- Lớp 6 Khá
('TK011', 'LH004', N'Giáo viên', '2025-08-15', '2026-05-31'), -- Lớp 7 TB
('TK011', 'LH007', N'Giáo viên', '2025-08-15', '2026-05-31'), -- Lớp 8 TB
('TK011', 'LH011', N'Giáo viên', '2025-08-15', '2026-05-31'), -- Lớp 9 TB

-- Giáo viên TK012 (Phụ trách Khối 9, 10)
('TK012', 'LH010', N'Giáo viên', '2025-08-15', '2026-05-31'), -- Lớp 9 Khá
('TK012', 'LH012', N'Giáo viên', '2025-08-15', '2026-05-31'), -- Lớp 9 Giỏi
('TK012', 'LH013', N'Giáo viên', '2025-08-15', '2026-05-31'), -- Lớp 10 TB
('TK012', 'LH014', N'Giáo viên', '2025-08-15', '2026-05-31'), -- Lớp 10 Khá

-- Giáo viên TK013 (Phụ trách Khối 11, 12)
('TK013', 'LH017', N'Giáo viên', '2025-08-15', '2026-05-31'), -- Lớp 11 Khá
('TK013', 'LH019', N'Giáo viên', '2025-08-15', '2026-05-31'), -- Lớp 12 TB
('TK013', 'LH020', N'Giáo viên', '2025-08-15', '2026-05-31'), -- Lớp 12 Khá
('TK013', 'LH021', N'Giáo viên', '2025-08-15', '2026-05-31'), -- Lớp 12 Giỏi

-- Trợ giảng TK014 (Phụ trách Khối 6, 7, 8)
('TK014', 'LH001', N'Trợ giảng', '2025-08-15', '2026-05-31'),
('TK014', 'LH002', N'Trợ giảng', '2025-08-15', '2026-05-31'),
('TK014', 'LH006', N'Trợ giảng', '2025-08-15', '2026-05-31'),
('TK014', 'LH008', N'Trợ giảng', '2025-08-15', '2026-05-31'),

-- Trợ giảng TK015 (Phụ trách Khối 9, 10)
('TK015', 'LH011', N'Trợ giảng', '2025-08-15', '2026-05-31'),
('TK015', 'LH012', N'Trợ giảng', '2025-08-15', '2026-05-31'),
('TK015', 'LH013', N'Trợ giảng', '2025-08-15', '2026-05-31'),
('TK015', 'LH014', N'Trợ giảng', '2025-08-15', '2026-05-31'),

-- Trợ giảng TK016 (Phụ trách Khối 11, 12)
('TK016', 'LH016', N'Trợ giảng', '2025-08-15', '2026-05-31'),
('TK016', 'LH017', N'Trợ giảng', '2025-08-15', '2026-05-31'),
('TK016', 'LH019', N'Trợ giảng', '2025-08-15', '2026-05-31'),
('TK016', 'LH021', N'Trợ giảng', '2025-08-15', '2026-05-31');

-- 1. BẢNG HỌC VIÊN (205 học viên)
INSERT INTO HOC_VIEN (MaHocVien, MaLop, TenHocVien, NgaySinh, SDT, KhoiLop, TrangThai) VALUES
-- GIAI ĐOẠN 1: THÁNG 8 & 9/2025
('HV001', 'LH010', N'Nguyễn Thị Thu Hà', '2011-05-15', '0983646295', 9, N'Đang học'),
('HV002', 'LH019', N'Trần Hoàng Gia Bảo', '2008-12-05', '0912445566', 12, N'Đang học'),
('HV003', 'LH001', N'Lê Thị Ngọc Mai', '2014-08-20', '0975778899', 6, N'Đang học'),
('HV004', 'LH007', N'Phạm Đức Trung Kiên', '2012-02-28', '0904112244', 8, N'Đang học'),
('HV005', 'LH011', N'Đỗ Thị Thanh Thảo', '2011-10-10', '0936556677', 9, N'Đang học'),
('HV006', 'LH020', N'Hoàng Tuấn Dũng', '2008-05-12', '0988990011', 12, N'Đang học'),
('HV007', 'LH016', N'Vũ Ngọc Lan Anh', '2009-09-10', '0918223344', 11, N'Đang học'),
('HV008', 'LH013', N'Nguyễn Văn Tuấn Đạt', '2010-11-20', '0977445566', 10, N'Đang học'),
('HV009', 'LH012', N'Trần Thị Bích Ngọc', '2011-01-15', '0902667788', 9, N'Đang học'),
('HV010', 'LH021', N'Lê Quang Nhật Minh', '2008-03-25', '0945889900', 12, N'Đang học'),
('HV011', 'LH002', N'Phạm Phương Linh', '2014-07-30', '0989112255', 6, N'Đang học'),
('HV012', 'LH004', N'Đặng Trần Nam Khang', '2013-04-18', '0913334455', 7, N'Đang học'),
('HV013', 'LH010', N'Bùi Thị Hồng Nhung', '2011-08-08', '0974556677', 9, N'Đang học'),
('HV014', 'LH019', N'Nguyễn Đức Huy', '2008-12-12', '0908778899', 12, N'Đang học'),
('HV015', 'LH008', N'Trần Tuấn Phát', '2012-06-16', '0938990022', 8, N'Đang học'),
('HV016', 'LH017', N'Lê Thị Hương Giang', '2009-05-05', '0984113355', 11, N'Đang học'),
('HV017', 'LH011', N'Phạm Nguyễn Minh Quân', '2011-11-11', '0915335577', 9, N'Đang học'),
('HV018', 'LH020', N'Vũ Thị Cẩm Tú', '2008-01-20', '0978557799', 12, N'Đang học'),
('HV019', 'LH001', N'Hoàng Quốc Việt', '2014-09-02', '0903779911', 6, N'Đang học'),
('HV020', 'LH014', N'Nguyễn Lê Thu Hằng', '2010-12-25', '0942991133', 10, N'Đang học'),
('HV021', 'LH012', N'Trần Đăng Khoa', '2011-04-14', '0985114466', 9, N'Đang học'),
('HV022', 'LH021', N'Lê Minh Cường', '2008-07-27', '0914336688', 12, N'Đang học'),
('HV023', 'LH007', N'Phạm Thị Tuyết Mai', '2012-08-30', '0972558800', 8, N'Đang học'),
('HV024', 'LH006', N'Đỗ Trọng Hiếu', '2013-03-03', '0905770022', 7, N'Đang học'),
('HV025', 'LH010', N'Bùi Bích Tuyền', '2011-02-14', '0934992244', 9, N'Đang học'),
('HV026', 'LH019', N'Nguyễn Quang Hải', '2008-10-20', '0987115577', 12, N'Đang học'),
('HV027', 'LH002', N'Trần Thị Bích Thủy', '2014-09-09', '0916337799', 6, N'Đang học'),
('HV028', 'LH016', N'Lê Nguyễn Tuấn Kiệt', '2009-11-11', '0979559911', 11, N'Đang học'),
('HV029', 'LH011', N'Phạm Hải Đăng', '2011-01-01', '0906771133', 9, N'Đang học'),
('HV030', 'LH020', N'Vũ Phương Thảo', '2008-12-12', '0948993355', 12, N'Đang học'),
('HV031', 'LH001', N'Nguyễn Thị Thanh Trúc', '2014-06-06', '0982116688', 6, N'Đang học'),
('HV032', 'LH013', N'Trần Gia Khang', '2010-07-07', '0917338800', 10, N'Đang học'),
('HV033', 'LH012', N'Lê Thành Đạt', '2011-08-08', '0973550022', 9, N'Đang học'),
('HV034', 'LH021', N'Phạm Thị Thu Trang', '2008-04-04', '0907772244', 12, N'Đang học'),
('HV035', 'LH008', N'Hoàng Đình Trọng', '2012-02-22', '0935994466', 8, N'Đang học'),
('HV036', 'LH017', N'Nguyễn Ngọc Hân', '2009-05-05', '0986117788', 11, N'Đang học'),
('HV037', 'LH010', N'Trần Quốc Bảo', '2011-03-31', '0919339900', 9, N'Đang học'),
('HV038', 'LH019', N'Lê Thị Thúy Loan', '2008-09-24', '0976551133', 12, N'Đang học'),
('HV039', 'LH002', N'Phạm Văn Cường', '2014-10-10', '0909773355', 6, N'Đang học'),
('HV040', 'LH004', N'Đặng Quỳnh Anh', '2013-12-20', '0943995577', 7, N'Đang học'),
('HV041', 'LH011', N'Nguyễn Hải Đăng', '2011-07-15', '0932996688', 9, N'Đang học'),
('HV042', 'LH020', N'Trần Quỳnh Nhi', '2008-06-25', '0989119900', 12, N'Đang học'),
('HV043', 'LH007', N'Lê Thị Diễm Hương', '2012-03-12', '0914331122', 8, N'Đang học'),
('HV044', 'LH016', N'Phạm Tiến Phát', '2009-08-22', '0977553344', 11, N'Đang học'),
('HV045', 'LH012', N'Hoàng Lan Phương', '2011-01-30', '0905775566', 9, N'Đang học'),
('HV046', 'LH021', N'Nguyễn Đức Bình', '2008-04-18', '0944997788', 12, N'Đang học'),
('HV047', 'LH001', N'Trần Thị Ánh Tuyết', '2014-11-11', '0983110011', 6, N'Đang học'),
('HV048', 'LH014', N'Lê Thanh Hùng', '2010-09-09', '0918332233', 10, N'Đang học'),
('HV049', 'LH010', N'Phạm Minh Thắng', '2011-02-14', '0975554455', 9, N'Đang học'),
('HV050', 'LH019', N'Vũ Thị Hồng Ngọc', '2008-12-01', '0908776677', 12, N'Đang học'),
('HV051', 'LH008', N'Nguyễn Quang Lâm', '2012-07-07', '0936998899', 8, N'Đang học'),
('HV052', 'LH006', N'Trần Thị Thu Hiền', '2013-05-20', '0988111122', 7, N'Đang học'),
('HV053', 'LH011', N'Lê Nhật Nam', '2011-10-22', '0912333344', 9, N'Đang học'),
('HV054', 'LH020', N'Phạm Bảo Anh', '2008-04-15', '0974555566', 12, N'Đang học'),
('HV055', 'LH002', N'Đỗ Minh Quang', '2014-06-30', '0903777788', 6, N'Đang học'),
('HV056', 'LH017', N'Nguyễn Thị Thu Phương', '2009-03-08', '0947999900', 11, N'Đang học'),
('HV057', 'LH012', N'Trần Quốc Tuấn', '2011-08-18', '0985112233', 9, N'Đang học'),
('HV058', 'LH021', N'Lê Minh Khôi', '2008-01-01', '0915334455', 12, N'Đang học'),
('HV059', 'LH007', N'Phạm Nguyễn Tấn Phát', '2012-09-15', '0979556677', 8, N'Đang học'),
('HV060', 'LH013', N'Bùi Cẩm Ly', '2010-11-20', '0906778899', 10, N'Đang học'),
('HV061', 'LH010', N'Nguyễn Hữu Trí', '2011-10-10', '0931990011', 9, N'Đang học'),
('HV062', 'LH019', N'Trần Thảo My', '2008-05-25', '0982113355', 12, N'Đang học'),
('HV063', 'LH001', N'Lê Thị Bảo Châu', '2014-02-28', '0917335577', 6, N'Đang học'),
('HV064', 'LH004', N'Phạm Ngọc Trâm', '2013-12-15', '0973557799', 7, N'Đang học'),
('HV065', 'LH011', N'Hoàng Trí Dũng', '2011-04-30', '0907779911', 9, N'Đang học'),
('HV066', 'LH020', N'Nguyễn Lê Quốc Bảo', '2008-06-15', '0946991133', 12, N'Đang học'),
('HV067', 'LH008', N'Trần Thu Hảo', '2012-08-08', '0987114466', 8, N'Đang học'),
('HV068', 'LH016', N'Lê Tiến Đạt', '2009-02-14', '0913336688', 11, N'Đang học'),
('HV069', 'LH012', N'Phạm Thị Quỳnh Anh', '2011-10-25', '0978558800', 9, N'Đang học'),
('HV070', 'LH021', N'Vũ Ngọc Linh', '2008-07-20', '0904770022', 12, N'Đang học'),
('HV071', 'LH002', N'Nguyễn Thị Hồng Ngọc', '2014-12-25', '0939992244', 6, N'Đang học'),
('HV072', 'LH014', N'Trần Minh Luân', '2010-03-08', '0984115577', 10, N'Đang học'),
('HV073', 'LH010', N'Lê Hoài Nam', '2011-05-19', '0919337799', 9, N'Đang học'),
('HV074', 'LH019', N'Phạm Bảo Lâm', '2008-01-01', '0975559911', 12, N'Đang học'),
('HV075', 'LH007', N'Đỗ Mai Lan', '2012-09-30', '0908771133', 8, N'Đang học'),

-- GIAI ĐOẠN 2: THÁNG 10/2025 -> THÁNG 3/2026 (Có rải rác 18 HV Nghỉ học)
('HV076', 'LH017', N'Phạm Khắc Hiếu', '2009-04-20', '0977550022', 11, N'Đang học'),
('HV077', 'LH011', N'Hoàng Tuấn Anh', '2011-07-15', '0902772244', 9, N'Đang học'),
('HV078', 'LH020', N'Nguyễn Trần Nhật Minh', '2008-03-26', '0937994466', 12, N'Đang học'),
('HV079', 'LH001', N'Trần Ngọc Mai', '2014-10-18', '0988117788', 6, N'Đang học'),
('HV080', 'LH006', N'Lê Diễm Hằng', '2013-01-20', '0914339900', 7, N'Nghỉ học'), 
('HV081', 'LH012', N'Phạm Hữu Phát', '2011-06-12', '0979551133', 9, N'Đang học'),
('HV082', 'LH021', N'Vũ Phương Nga', '2008-12-05', '0905773355', 12, N'Đang học'),
('HV083', 'LH008', N'Nguyễn Quốc Việt', '2012-08-28', '0949995577', 8, N'Đang học'),
('HV084', 'LH013', N'Trần Gia Bảo', '2010-02-14', '0986118800', 10, N'Đang học'),
('HV085', 'LH010', N'Lê Bích Liên', '2011-09-02', '0915330022', 9, N'Nghỉ học'), 
('HV086', 'LH019', N'Phạm Đình Nguyên', '2008-11-15', '0972552244', 12, N'Đang học'),
('HV087', 'LH002', N'Đỗ Thanh Trúc', '2014-04-30', '0908774466', 6, N'Đang học'),
('HV088', 'LH016', N'Phạm Tiến Đạt', '2009-05-19', '0974553344', 11, N'Đang học'),
('HV089', 'LH011', N'Hoàng Cẩm Nhung', '2011-10-20', '0903775566', 9, N'Đang học'),
('HV090', 'LH020', N'Nguyễn Ngọc Yến Nhi', '2008-08-15', '0947997788', 12, N'Nghỉ học'), 
('HV091', 'LH007', N'Trần Minh Tâm', '2012-01-10', '0985110011', 8, N'Đang học'),
('HV092', 'LH004', N'Lê Quốc Thái', '2013-03-25', '0913332233', 7, N'Đang học'),
('HV093', 'LH012', N'Phạm Thị Mộng Cầm', '2011-07-07', '0979554455', 9, N'Đang học'),
('HV094', 'LH021', N'Vũ Thành Nam', '2008-11-20', '0906776677', 12, N'Đang học'),
('HV095', 'LH001', N'Nguyễn Bảo Ngọc', '2014-02-28', '0931998899', 6, N'Nghỉ học'), 
('HV096', 'LH014', N'Trần Anh Tuấn', '2010-12-12', '0982111122', 10, N'Đang học'),
('HV097', 'LH010', N'Lê Cát Tường', '2011-06-01', '0917333344', 9, N'Đang học'),
('HV098', 'LH019', N'Phạm Nguyễn Minh Quân', '2008-09-05', '0973555566', 12, N'Đang học'),
('HV099', 'LH008', N'Đặng Thanh Thủy', '2012-05-20', '0907777788', 8, N'Đang học'),
('HV100', 'LH017', N'Phạm Bích Tuyền', '2009-10-15', '0978556677', 11, N'Nghỉ học'), 
('HV101', 'LH011', N'Hoàng Tiến Đạt', '2011-04-10', '0904778899', 9, N'Đang học'),
('HV102', 'LH020', N'Nguyễn Thu Hằng', '2008-01-25', '0939990011', 12, N'Đang học'),
('HV103', 'LH002', N'Trần Quốc Hùng', '2014-08-08', '0984113355', 6, N'Đang học'),
('HV104', 'LH006', N'Lê Ngọc Hà', '2013-12-22', '0919335577', 7, N'Đang học'),
('HV105', 'LH012', N'Phạm Công Toản', '2011-03-15', '0975557799', 9, N'Nghỉ học'),
('HV106', 'LH021', N'Vũ Thị Hồng Loan', '2008-09-30', '0908779911', 12, N'Đang học'),
('HV107', 'LH007', N'Nguyễn Trọng Nghĩa', '2012-05-12', '0941991133', 8, N'Đang học'),
('HV108', 'LH013', N'Trần Thanh Huyền', '2010-10-20', '0983114466', 10, N'Đang học'),
('HV109', 'LH010', N'Lê Tuấn Vũ', '2011-02-14', '0912336688', 9, N'Đang học'),
('HV110', 'LH019', N'Phạm Mai Phương', '2008-07-07', '0971558800', 12, N'Nghỉ học'), 
('HV111', 'LH001', N'Đỗ Tiến Dũng', '2014-11-20', '0901770022', 6, N'Đang học'),
('HV112', 'LH016', N'Phạm Nguyễn Minh Khang', '2009-06-25', '0977559911', 11, N'Đang học'),
('HV113', 'LH011', N'Hoàng Thị Ngọc Ánh', '2011-01-01', '0905771133', 9, N'Đang học'),
('HV114', 'LH020', N'Nguyễn Đức Phát', '2008-09-10', '0944993355', 12, N'Đang học'),
('HV115', 'LH008', N'Trần Thị Bích Trâm', '2012-04-18', '0983116688', 8, N'Nghỉ học'),
('HV116', 'LH004', N'Lê Quang Huy', '2013-08-15', '0918338800', 7, N'Đang học'),
('HV117', 'LH012', N'Phạm Diệu Linh', '2011-12-05', '0975550022', 9, N'Đang học'),
('HV118', 'LH021', N'Vũ Minh Tuấn', '2008-03-20', '0908772244', 12, N'Đang học'),
('HV119', 'LH002', N'Nguyễn Lê Thu Uyên', '2014-10-10', '0936994466', 6, N'Đang học'),
('HV120', 'LH014', N'Trần Quốc Bảo', '2010-05-25', '0988117788', 10, N'Nghỉ học'), 
('HV121', 'LH010', N'Lê Thị Hương Giang', '2011-11-01', '0912339900', 9, N'Đang học'),
('HV122', 'LH019', N'Phạm Hoàng Nam', '2008-02-14', '0974551122', 12, N'Đang học'),
('HV123', 'LH007', N'Đặng Phương Thảo', '2012-07-20', '0903774455', 8, N'Đang học'),
('HV124', 'LH017', N'Nguyễn Thành Công', '2009-09-09', '0947996677', 11, N'Đang học'),
('HV125', 'LH011', N'Trần Ngọc Yến', '2011-04-30', '0985118899', 9, N'Đang học'),
('HV126', 'LH020', N'Lê Đăng Khoa', '2008-10-20', '0915330011', 12, N'Đang học'),
('HV127', 'LH001', N'Phạm Thị Thanh Bình', '2014-01-15', '0979552244', 6, N'Đang học'),
('HV128', 'LH006', N'Bùi Quang Dũng', '2013-06-05', '0906775566', 7, N'Đang học'),
('HV129', 'LH012', N'Nguyễn Hương Ly', '2011-11-11', '0931997788', 9, N'Đang học'),
('HV130', 'LH021', N'Trần Hữu Lộc', '2008-03-25', '0982110011', 12, N'Nghỉ học'), 
('HV131', 'LH008', N'Lê Bích Tuyền', '2012-08-20', '0917332233', 8, N'Đang học'),
('HV132', 'LH013', N'Phạm Trọng Đạt', '2010-01-01', '0973554455', 10, N'Đang học'),
('HV133', 'LH010', N'Hoàng Thị Tuyết', '2011-05-10', '0907776677', 9, N'Đang học'),
('HV134', 'LH019', N'Nguyễn Đức Vinh', '2008-12-15', '0946998899', 12, N'Đang học'),
('HV135', 'LH002', N'Trần Lan Phương', '2014-02-28', '0987111122', 6, N'Đang học'),
('HV136', 'LH016', N'Lê Thanh Sơn', '2009-07-20', '0913333344', 11, N'Đang học'),
('HV137', 'LH011', N'Phạm Nguyễn Minh Khôi', '2011-10-05', '0978555566', 9, N'Đang học'),
('HV138', 'LH020', N'Vũ Thùy Linh', '2008-04-14', '0904777788', 12, N'Đang học'),
('HV139', 'LH007', N'Nguyễn Gia Hưng', '2012-09-25', '0939999900', 8, N'Đang học'),
('HV140', 'LH004', N'Trần Bảo Ngọc', '2013-01-30', '0984112233', 7, N'Nghỉ học'), 
('HV141', 'LH012', N'Lê Minh Tuệ', '2011-06-15', '0919334455', 9, N'Đang học'),
('HV142', 'LH021', N'Phạm Hữu Bằng', '2008-11-20', '0975556677', 12, N'Đang học'),
('HV143', 'LH001', N'Đỗ Phương Anh', '2014-03-08', '0908778899', 6, N'Đang học'),
('HV144', 'LH014', N'Nguyễn Quang Tiến', '2010-08-10', '0941990011', 10, N'Đang học'),
('HV145', 'LH010', N'Trần Thị Cẩm Ly', '2011-01-25', '0983113355', 9, N'Đang học'),
('HV146', 'LH019', N'Lê Văn Khánh', '2008-05-19', '0912335577', 12, N'Đang học'),
('HV147', 'LH008', N'Phạm Nguyễn Minh Hằng', '2012-10-30', '0914336688', 8, N'Đang học'),
('HV148', 'LH017', N'Hoàng Bảo Châu', '2009-02-14', '0979558800', 11, N'Đang học'),
('HV149', 'LH011', N'Nguyễn Trọng Tấn', '2011-07-20', '0905770022', 9, N'Đang học'),
('HV150', 'LH020', N'Trần Thị Bích Ngọc', '2008-12-12', '0949992244', 12, N'Nghỉ học'),
('HV151', 'LH002', N'Lê Tấn Phát', '2014-09-02', '0986115577', 6, N'Đang học'),
('HV152', 'LH006', N'Phạm Thanh Thủy', '2013-04-18', '0915337799', 7, N'Đang học'),
('HV153', 'LH012', N'Vũ Ngọc Cường', '2011-08-25', '0972559911', 9, N'Đang học'),
('HV154', 'LH021', N'Nguyễn Mai Hương', '2008-01-10', '0908771133', 12, N'Đang học'),
('HV155', 'LH007', N'Trần Minh Khang', '2012-06-15', '0933993355', 8, N'Đang học'),
('HV156', 'LH013', N'Lê Phương Thảo', '2010-11-01', '0981116688', 10, N'Đang học'),
('HV157', 'LH010', N'Phạm Đức Trí', '2011-03-20', '0918338800', 9, N'Đang học'),
('HV158', 'LH019', N'Đặng Thanh Xuân', '2008-10-10', '0974550022', 12, N'Đang học'),
('HV159', 'LH001', N'Nguyễn Gia Huy', '2014-02-28', '0903772244', 6, N'Đang học'),
('HV160', 'LH016', N'Trần Cẩm Nhung', '2009-07-07', '0947995577', 11, N'Nghỉ học'),
('HV161', 'LH011', N'Lê Minh Châu', '2011-12-25', '0985117799', 9, N'Đang học'),
('HV162', 'LH020', N'Phạm Tiến Dũng', '2008-05-15', '0915339911', 12, N'Đang học'),
('HV163', 'LH008', N'Bùi Bích Phương', '2012-10-20', '0979551133', 8, N'Đang học'),
('HV164', 'LH004', N'Nguyễn Quang Minh', '2013-01-01', '0906774466', 7, N'Đang học'),
('HV165', 'LH012', N'Trần Ngọc Lan', '2011-08-10', '0931996688', 9, N'Đang học'),
('HV166', 'LH021', N'Lê Đức Phương', '2008-04-15', '0982119900', 12, N'Đang học'),
('HV167', 'LH002', N'Phạm Nguyễn Minh Quân', '2014-11-20', '0917331122', 6, N'Đang học'),
('HV168', 'LH014', N'Hoàng Yến Nhi', '2010-06-05', '0973553344', 10, N'Đang học'),
('HV169', 'LH010', N'Nguyễn Tấn Đạt', '2011-09-30', '0907775566', 9, N'Đang học'),
('HV170', 'LH019', N'Trần Thu Hà', '2008-02-14', '0946997788', 12, N'Nghỉ học'),
('HV171', 'LH007', N'Lê Quốc Bình', '2012-07-25', '0987110011', 8, N'Đang học'),
('HV172', 'LH017', N'Phạm Mai Lan', '2009-12-10', '0913332233', 11, N'Đang học'),
('HV173', 'LH011', N'Vũ Đình Khang', '2011-05-20', '0978554455', 9, N'Đang học'),
('HV174', 'LH020', N'Nguyễn Thanh Trúc', '2008-10-01', '0904776677', 12, N'Đang học'),
('HV175', 'LH001', N'Trần Gia Hưng', '2014-03-15', '0939998899', 6, N'Nghỉ học'),
('HV176', 'LH006', N'Lê Ngọc Điệp', '2013-08-20', '0984111122', 7, N'Đang học'),
('HV177', 'LH012', N'Phạm Trung Thành', '2011-01-25', '0919333344', 9, N'Đang học'),
('HV178', 'LH021', N'Đỗ Bích Thủy', '2008-06-30', '0975555566', 12, N'Đang học'),
('HV179', 'LH008', N'Nguyễn Hữu Tài', '2012-11-11', '0908777788', 8, N'Đang học'),
('HV180', 'LH013', N'Trần Thị Quỳnh', '2010-04-04', '0941999900', 10, N'Nghỉ học'), 
('HV181', 'LH010', N'Lê Minh Nhật', '2011-09-15', '0983112233', 9, N'Đang học'),
('HV182', 'LH019', N'Lê Thanh Bình', '2008-02-20', '0988113355', 12, N'Đang học'),
('HV183', 'LH002', N'Phạm Cẩm Nhung', '2014-07-25', '0914335577', 6, N'Đang học'),
('HV184', 'LH016', N'Hoàng Quốc Vượng', '2009-12-05', '0979557799', 11, N'Đang học'),
('HV185', 'LH011', N'Nguyễn Phương Ly', '2011-05-10', '0905779911', 9, N'Nghỉ học'), 
('HV186', 'LH020', N'Trần Khắc Việt', '2008-10-15', '0949991133', 12, N'Đang học'),
('HV187', 'LH007', N'Lê Hương Lan', '2012-03-20', '0986114466', 8, N'Đang học'),
('HV188', 'LH004', N'Phạm Đình Luật', '2013-08-08', '0915336688', 7, N'Đang học'),
('HV189', 'LH012', N'Vũ Thị Bích Phượng', '2011-01-25', '0972558800', 9, N'Nghỉ học'),
('HV190', 'LH021', N'Nguyễn Trung Kiên', '2008-06-10', '0908770022', 12, N'Đang học'),
('HV191', 'LH001', N'Trần Ngọc Diệp', '2014-11-15', '0933992244', 6, N'Đang học'),

-- GIAI ĐOẠN 3: THÁNG 4 & 5/2026 (Chờ xếp lớp & Bảo lưu)
-- 4 Học viên xin BẢO LƯU
('HV192', 'LH014', N'Lê Minh Trọng', '2010-04-20', '0981115577', 10, N'Bảo lưu'), 
('HV193', 'LH010', N'Phạm Nguyễn Minh Nguyệt', '2011-09-05', '0918337799', 9, N'Bảo lưu'),
('HV194', 'LH019', N'Đặng Tuấn Phát', '2008-02-14', '0975559911', 12, N'Bảo lưu'),
('HV195', 'LH008', N'Bùi Phương Thảo', '2012-07-30', '0904771133', 8, N'Bảo lưu'),

-- 10 Học viên mới đăng ký đang CHỜ XẾP LỚP (MaLop = NULL)
('HV196', NULL, N'Phạm Thị Mai', '2009-12-10', '0975550022', 11, N'Chờ xếp lớp'),
('HV197', NULL, N'Hoàng Trọng Nghĩa', '2011-05-25', '0908772244', 9, N'Chờ xếp lớp'),
('HV198', NULL, N'Nguyễn Yến Oanh', '2008-10-15', '0941994466', 12, N'Chờ xếp lớp'),
('HV199', NULL, N'Trần Minh Luân', '2014-03-08', '0983117788', 6, N'Chờ xếp lớp'),
('HV200', NULL, N'Lê Thu Phương', '2013-08-20', '0912339900', 7, N'Chờ xếp lớp'),
('HV201', NULL, N'Phạm Gia Khang', '2011-01-30', '0971551122', 9, N'Chờ xếp lớp'),
('HV202', NULL, N'Vũ Bích Hạnh', '2008-06-12', '0901774455', 12, N'Chờ xếp lớp'),
('HV203', NULL, N'Nguyễn Cẩm Tú', '2012-11-05', '0913333344', 8, N'Chờ xếp lớp'),
('HV204', NULL, N'Trần Quốc Hùng', '2009-04-18', '0978555566', 11, N'Chờ xếp lớp'),
('HV205', NULL, N'Lê Phương Thanh', '2011-09-22', '0904777788', 9, N'Chờ xếp lớp');


-- 2. BẢNG KHÁCH HÀNG (250 Khách hàng )
INSERT INTO KHACH_HANG (MaKhachHang, MaHocVien, TenKhachHang, KhoiLop, SDT, NguonDen, TrangThai, NgayTiepNhan, NgayDangKy) VALUES
('KH001', 'HV001', N'Nguyễn Thị Thu Hà', 9, '0983112233', N'Facebook', N'Đã đăng ký', '2025-08-01', '2025-08-03'),
('KH002', 'HV002', N'Trần Hoàng Gia Bảo', 12, '0912445566', N'Facebook', N'Đã đăng ký', '2025-08-01', '2025-08-04'),
('KH003', 'HV003', N'Lê Thị Ngọc Mai', 6, '0975778899', N'Giới thiệu', N'Đã đăng ký', '2025-08-02', '2025-08-05'),
('KH004', 'HV004', N'Phạm Đức Trung Kiên', 8, '0904112244', N'Website', N'Đã đăng ký', '2025-08-03', '2025-08-06'),
('KH005', 'HV005', N'Đỗ Thị Thanh Thảo', 9, '0936556677', N'Hotline', N'Đã đăng ký', '2025-08-03', '2025-08-07'),
('KH006', 'HV006', N'Hoàng Tuấn Dũng', 12, '0988990011', N'Facebook', N'Đã đăng ký', '2025-08-04', '2025-08-08'),
('KH007', 'HV007', N'Vũ Ngọc Lan Anh', 11, '0918223344', N'Giới thiệu', N'Đã đăng ký', '2025-08-04', '2025-08-09'),
('KH008', 'HV008', N'Nguyễn Văn Tuấn Đạt', 10, '0977445566', N'Website', N'Đã đăng ký', '2025-08-05', '2025-08-10'),
('KH009', 'HV009', N'Trần Thị Bích Ngọc', 9, '0902667788', N'Facebook', N'Đã đăng ký', '2025-08-05', '2025-08-11'),
('KH010', 'HV010', N'Lê Quang Nhật Minh', 12, '0945889900', N'Hotline', N'Đã đăng ký', '2025-08-06', '2025-08-12'),
('KH011', 'HV011', N'Phạm Phương Linh', 6, '0989112255', N'Facebook', N'Đã đăng ký', '2025-08-07', '2025-08-13'),
('KH012', 'HV012', N'Đặng Trần Nam Khang', 7, '0913334455', N'Giới thiệu', N'Đã đăng ký', '2025-08-07', '2025-08-14'),
('KH013', 'HV013', N'Bùi Thị Hồng Nhung', 9, '0974556677', N'Website', N'Đã đăng ký', '2025-08-08', '2025-08-15'),
('KH014', 'HV014', N'Nguyễn Đức Huy', 12, '0908778899', N'Facebook', N'Đã đăng ký', '2025-08-09', '2025-08-16'),
('KH015', 'HV015', N'Trần Tuấn Phát', 8, '0938990022', N'Hotline', N'Đã đăng ký', '2025-08-10', '2025-08-17'),
('KH016', 'HV016', N'Lê Thị Hương Giang', 11, '0984113355', N'Giới thiệu', N'Đã đăng ký', '2025-08-11', '2025-08-18'),
('KH017', 'HV017', N'Phạm Nguyễn Minh Quân', 9, '0915335577', N'Website', N'Đã đăng ký', '2025-08-11', '2025-08-19'),
('KH018', 'HV018', N'Vũ Thị Cẩm Tú', 12, '0978557799', N'Facebook', N'Đã đăng ký', '2025-08-12', '2025-08-20'),
('KH019', 'HV019', N'Hoàng Quốc Việt', 6, '0903779911', N'Facebook', N'Đã đăng ký', '2025-08-13', '2025-08-21'),
('KH020', 'HV020', N'Nguyễn Lê Thu Hằng', 10, '0942991133', N'Giới thiệu', N'Đã đăng ký', '2025-08-14', '2025-08-22'),
('KH021', 'HV021', N'Trần Đăng Khoa', 9, '0985114466', N'Website', N'Đã đăng ký', '2025-08-14', '2025-08-23'),
('KH022', 'HV022', N'Lê Minh Cường', 12, '0914336688', N'Hotline', N'Đã đăng ký', '2025-08-15', '2025-08-24'),
('KH023', 'HV023', N'Phạm Thị Tuyết Mai', 8, '0972558800', N'Facebook', N'Đã đăng ký', '2025-08-16', '2025-08-25'),
('KH024', 'HV024', N'Đỗ Trọng Hiếu', 7, '0905770022', N'Giới thiệu', N'Đã đăng ký', '2025-08-17', '2025-08-26'),
('KH025', 'HV025', N'Bùi Bích Tuyền', 9, '0934992244', N'Website', N'Đã đăng ký', '2025-08-17', '2025-08-27'),
('KH026', 'HV026', N'Nguyễn Quang Hải', 12, '0987115577', N'Facebook', N'Đã đăng ký', '2025-08-18', '2025-08-28'),
('KH027', 'HV027', N'Trần Thị Bích Thủy', 6, '0916337799', N'Facebook', N'Đã đăng ký', '2025-08-19', '2025-08-29'),
('KH028', 'HV028', N'Lê Nguyễn Tuấn Kiệt', 11, '0979559911', N'Giới thiệu', N'Đã đăng ký', '2025-08-20', '2025-08-30'),
('KH029', 'HV029', N'Phạm Hải Đăng', 9, '0906771133', N'Website', N'Đã đăng ký', '2025-08-21', '2025-08-31'),
('KH030', 'HV030', N'Vũ Phương Thảo', 12, '0948993355', N'Hotline', N'Đã đăng ký', '2025-08-21', '2025-08-31'),
('KH031', 'HV031', N'Nguyễn Thị Thanh Trúc', 6, '0982116688', N'Facebook', N'Đã đăng ký', '2025-08-22', '2025-08-31'),
('KH032', 'HV032', N'Trần Gia Khang', 10, '0917338800', N'Giới thiệu', N'Đã đăng ký', '2025-08-23', '2025-08-31'),
('KH033', 'HV033', N'Lê Thành Đạt', 9, '0973550022', N'Website', N'Đã đăng ký', '2025-08-24', '2025-08-31'),
('KH034', 'HV034', N'Phạm Thị Thu Trang', 12, '0907772244', N'Facebook', N'Đã đăng ký', '2025-08-25', '2025-08-31'),
('KH035', 'HV035', N'Hoàng Đình Trọng', 8, '0935994466', N'Hotline', N'Đã đăng ký', '2025-08-25', '2025-08-31'),
('KH036', 'HV036', N'Nguyễn Ngọc Hân', 11, '0986117788', N'Giới thiệu', N'Đã đăng ký', '2025-08-26', '2025-08-31'),
('KH037', 'HV037', N'Trần Quốc Bảo', 9, '0919339900', N'Website', N'Đã đăng ký', '2025-08-27', '2025-08-31'),
('KH038', 'HV038', N'Lê Thị Thúy Loan', 12, '0976551133', N'Facebook', N'Đã đăng ký', '2025-08-27', '2025-08-31'),
('KH039', 'HV039', N'Phạm Văn Cường', 6, '0909773355', N'Facebook', N'Đã đăng ký', '2025-08-28', '2025-08-31'),
('KH040', 'HV040', N'Đặng Quỳnh Anh', 7, '0943995577', N'Giới thiệu', N'Đã đăng ký', '2025-08-28', '2025-08-31'),
('KH041', NULL, N'Nguyễn Trọng Đại', 9, '0981118800', N'Website', N'Không đăng ký', '2025-08-10', NULL),
('KH042', NULL, N'Trần Thị Phương Liên', 12, '0911330022', N'Hotline', N'Không đăng ký', '2025-08-15', NULL),
('KH043', NULL, N'Lê Việt Hoàng', 8, '0971552244', N'Facebook', N'Không đăng ký', '2025-08-22', NULL),
('KH044', NULL, N'Phạm Bích Ngọc', 10, '0901774466', N'Giới thiệu', N'Không đăng ký', '2025-08-26', NULL),

('KH045', 'HV041', N'Nguyễn Hải Đăng', 9, '0932996688', N'Facebook', N'Đã đăng ký', '2025-09-04', '2025-09-06'),
('KH046', 'HV042', N'Trần Quỳnh Nhi', 12, '0989119900', N'Website', N'Đã đăng ký', '2025-09-04', '2025-09-07'),
('KH047', 'HV043', N'Lê Thị Diễm Hương', 10, '0914331122', N'Facebook', N'Đã đăng ký', '2025-09-05', '2025-09-08'),
('KH048', 'HV044', N'Phạm Tiến Phát', 9, '0977553344', N'Hotline', N'Đã đăng ký', '2025-09-05', '2025-09-09'),
('KH049', 'HV045', N'Hoàng Lan Phương', 12, '0905775566', N'Giới thiệu', N'Đã đăng ký', '2025-09-06', '2025-09-10'),
('KH050', 'HV046', N'Nguyễn Đức Bình', 6, '0944997788', N'Website', N'Đã đăng ký', '2025-09-07', '2025-09-11'),
('KH051', 'HV047', N'Trần Thị Ánh Tuyết', 8, '0983110011', N'Facebook', N'Đã đăng ký', '2025-09-08', '2025-09-12'),
('KH052', 'HV048', N'Lê Thanh Hùng', 11, '0918332233', N'Facebook', N'Đã đăng ký', '2025-09-09', '2025-09-13'),
('KH053', 'HV049', N'Phạm Minh Thắng', 9, '0975554455', N'Giới thiệu', N'Đã đăng ký', '2025-09-09', '2025-09-14'),
('KH054', 'HV050', N'Vũ Thị Hồng Ngọc', 12, '0908776677', N'Website', N'Đã đăng ký', '2025-09-10', '2025-09-15'),
('KH055', 'HV051', N'Nguyễn Quang Lâm', 6, '0936998899', N'Hotline', N'Đã đăng ký', '2025-09-11', '2025-09-16'),
('KH056', 'HV052', N'Trần Thị Thu Hiền', 7, '0988111122', N'Facebook', N'Đã đăng ký', '2025-09-12', '2025-09-17'),
('KH057', 'HV053', N'Lê Nhật Nam', 9, '0912333344', N'Giới thiệu', N'Đã đăng ký', '2025-09-13', '2025-09-18'),
('KH058', 'HV054', N'Phạm Bảo Anh', 12, '0974555566', N'Website', N'Đã đăng ký', '2025-09-14', '2025-09-19'),
('KH059', 'HV055', N'Đỗ Minh Quang', 6, '0903777788', N'Facebook', N'Đã đăng ký', '2025-09-15', '2025-09-20'),
('KH060', 'HV056', N'Nguyễn Thị Thu Phương', 11, '0947999900', N'Facebook', N'Đã đăng ký', '2025-09-16', '2025-09-21'),
('KH061', 'HV057', N'Trần Quốc Tuấn', 9, '0985112233', N'Giới thiệu', N'Đã đăng ký', '2025-09-17', '2025-09-22'),
('KH062', 'HV058', N'Lê Minh Khôi', 12, '0915334455', N'Website', N'Đã đăng ký', '2025-09-17', '2025-09-23'),
('KH063', 'HV059', N'Phạm Nguyễn Tấn Phát', 8, '0979556677', N'Hotline', N'Đã đăng ký', '2025-09-18', '2025-09-24'),
('KH064', 'HV060', N'Bùi Cẩm Ly', 10, '0906778899', N'Facebook', N'Đã đăng ký', '2025-09-19', '2025-09-25'),
('KH065', 'HV061', N'Nguyễn Hữu Trí', 9, '0931990011', N'Giới thiệu', N'Đã đăng ký', '2025-09-20', '2025-09-26'),
('KH066', 'HV062', N'Trần Thảo My', 12, '0982113355', N'Website', N'Đã đăng ký', '2025-09-21', '2025-09-27'),
('KH067', 'HV063', N'Lê Thị Bảo Châu', 6, '0917335577', N'Facebook', N'Đã đăng ký', '2025-09-22', '2025-09-28'),
('KH068', 'HV064', N'Phạm Ngọc Trâm', 7, '0973557799', N'Facebook', N'Đã đăng ký', '2025-09-23', '2025-09-29'),
('KH069', 'HV065', N'Hoàng Trí Dũng', 9, '0907779911', N'Giới thiệu', N'Đã đăng ký', '2025-09-24', '2025-09-30'),
('KH070', 'HV066', N'Nguyễn Lê Quốc Bảo', 12, '0946991133', N'Website', N'Đã đăng ký', '2025-09-25', '2025-10-01'),
('KH071', 'HV067', N'Trần Thu Hảo', 8, '0987114466', N'Hotline', N'Đã đăng ký', '2025-09-25', '2025-10-02'),
('KH072', 'HV068', N'Lê Tiến Đạt', 11, '0913336688', N'Facebook', N'Đã đăng ký', '2025-09-26', '2025-10-03'),
('KH073', 'HV069', N'Phạm Thị Quỳnh Anh', 9, '0978558800', N'Giới thiệu', N'Đã đăng ký', '2025-09-27', '2025-10-04'),
('KH074', 'HV070', N'Vũ Ngọc Linh', 12, '0904770022', N'Website', N'Đã đăng ký', '2025-09-28', '2025-10-05'),
('KH075', 'HV071', N'Nguyễn Thị Hồng Ngọc', 6, '0939992244', N'Facebook', N'Đã đăng ký', '2025-09-29', '2025-10-06'),
('KH076', 'HV072', N'Trần Minh Luân', 10, '0984115577', N'Facebook', N'Đã đăng ký', '2025-09-29', '2025-10-06'),
('KH077', 'HV073', N'Lê Hoài Nam', 9, '0919337799', N'Giới thiệu', N'Đã đăng ký', '2025-09-30', '2025-10-06'),
('KH078', 'HV074', N'Phạm Bảo Lâm', 12, '0975559911', N'Website', N'Đã đăng ký', '2025-09-30', '2025-10-06'),
('KH079', 'HV075', N'Đỗ Mai Lan', 8, '0908771133', N'Hotline', N'Đã đăng ký', '2025-09-30', '2025-10-06'),
('KH080', NULL, N'Nguyễn Cảnh Toàn', 11, '0941993355', N'Facebook', N'Không đăng ký', '2025-09-08', NULL),
('KH081', NULL, N'Trần Thu Thảo', 9, '0983116688', N'Giới thiệu', N'Không đăng ký', '2025-09-16', NULL),
('KH082', NULL, N'Lê Minh Khoa', 12, '0912338800', N'Website', N'Không đăng ký', '2025-09-25', NULL),

('KH083', 'HV076', N'Phạm Khắc Hiếu', 6, '0977550022', N'Facebook', N'Đã đăng ký', '2025-10-05', '2025-10-08'),
('KH084', 'HV077', N'Hoàng Tuấn Anh', 8, '0902772244', N'Facebook', N'Đã đăng ký', '2025-10-06', '2025-10-09'),
('KH085', 'HV078', N'Nguyễn Trần Nhật Minh', 11, '0937994466', N'Giới thiệu', N'Đã đăng ký', '2025-10-08', '2025-10-11'),
('KH086', 'HV079', N'Trần Ngọc Mai', 9, '0988117788', N'Website', N'Đã đăng ký', '2025-10-10', '2025-10-13'),
('KH087', 'HV080', N'Lê Diễm Hằng', 7, '0914339900', N'Hotline', N'Đã đăng ký', '2025-10-12', '2025-10-15'),
('KH088', 'HV081', N'Phạm Hữu Phát', 9, '0979551133', N'Facebook', N'Đã đăng ký', '2025-10-15', '2025-10-18'),
('KH089', 'HV082', N'Vũ Phương Nga', 8, '0905773355', N'Giới thiệu', N'Đã đăng ký', '2025-10-17', '2025-10-20'),
('KH090', 'HV083', N'Nguyễn Quốc Việt', 9, '0949995577', N'Website', N'Đã đăng ký', '2025-10-19', '2025-10-22'),
('KH091', 'HV084', N'Trần Gia Bảo', 12, '0986118800', N'Facebook', N'Đã đăng ký', '2025-10-20', '2025-10-23'),
('KH092', 'HV085', N'Lê Bích Liên', 6, '0915330022', N'Facebook', N'Đã đăng ký', '2025-10-22', '2025-10-25'),
('KH093', 'HV086', N'Phạm Đình Nguyên', 9, '0972552244', N'Giới thiệu', N'Đã đăng ký', '2025-10-23', '2025-10-26'),
('KH094', 'HV087', N'Đỗ Thanh Trúc', 12, '0908774466', N'Website', N'Đã đăng ký', '2025-10-25', '2025-10-28'),
('KH095', NULL, N'Nguyễn Hùng Dũng', 8, '0933996688', N'Hotline', N'Không đăng ký', '2025-10-11', NULL),
('KH096', NULL, N'Trần Phương Lan', 11, '0981119900', N'Facebook', N'Không đăng ký', '2025-10-18', NULL),
('KH097', NULL, N'Lê Quang Huy', 9, '0918331122', N'Giới thiệu', N'Không đăng ký', '2025-10-24', NULL),

('KH098', 'HV088', N'Phạm Tiến Đạt', 9, '0974553344', N'Website', N'Đã đăng ký', '2025-11-05', '2025-11-08'),
('KH099', 'HV089', N'Hoàng Cẩm Nhung', 12, '0903775566', N'Facebook', N'Đã đăng ký', '2025-11-07', '2025-11-10'),
('KH100', 'HV090', N'Nguyễn Ngọc Yến Nhi', 9, '0947997788', N'Facebook', N'Đã đăng ký', '2025-11-09', '2025-11-12'),
('KH101', 'HV091', N'Trần Minh Tâm', 9, '0985110011', N'Giới thiệu', N'Đã đăng ký', '2025-11-11', '2025-11-14'),
('KH102', 'HV092', N'Lê Quốc Thái', 12, '0913332233', N'Website', N'Đã đăng ký', '2025-11-13', '2025-11-16'),
('KH103', 'HV093', N'Phạm Thị Mộng Cầm', 6, '0979554455', N'Hotline', N'Đã đăng ký', '2025-11-15', '2025-11-18'),
('KH104', 'HV094', N'Vũ Thành Nam', 8, '0906776677', N'Facebook', N'Đã đăng ký', '2025-11-17', '2025-11-20'),
('KH105', 'HV095', N'Nguyễn Bảo Ngọc', 11, '0931998899', N'Giới thiệu', N'Đã đăng ký', '2025-11-19', '2025-11-22'),
('KH106', 'HV096', N'Trần Anh Tuấn', 10, '0982111122', N'Website', N'Đã đăng ký', '2025-11-20', '2025-11-23'),
('KH107', 'HV097', N'Lê Cát Tường', 7, '0917333344', N'Facebook', N'Đã đăng ký', '2025-11-22', '2025-11-25'),
('KH108', 'HV098', N'Phạm Nguyễn Minh Quân', 9, '0973555566', N'Facebook', N'Đã đăng ký', '2025-11-24', '2025-11-27'),
('KH109', 'HV099', N'Đặng Thanh Thủy', 12, '0907777788', N'Giới thiệu', N'Đã đăng ký', '2025-11-25', '2025-11-28'),
('KH110', NULL, N'Nguyễn Duy Khánh', 6, '0946999900', N'Website', N'Không đăng ký', '2025-11-06', NULL),
('KH111', NULL, N'Trần Yến Nhi', 8, '0987112233', N'Hotline', N'Không đăng ký', '2025-11-14', NULL),
('KH112', NULL, N'Lê Minh Trí', 9, '0913334455', N'Facebook', N'Không đăng ký', '2025-11-21', NULL),

('KH113', 'HV100', N'Phạm Bích Tuyền', 11, '0978556677', N'Giới thiệu', N'Đã đăng ký', '2025-12-05', '2025-12-08'),
('KH114', 'HV101', N'Hoàng Tiến Đạt', 9, '0904778899', N'Website', N'Đã đăng ký', '2025-12-07', '2025-12-10'),
('KH115', 'HV102', N'Nguyễn Thu Hằng', 12, '0939990011', N'Facebook', N'Đã đăng ký', '2025-12-08', '2025-12-11'),
('KH116', 'HV103', N'Trần Quốc Hùng', 6, '0984113355', N'Facebook', N'Đã đăng ký', '2025-12-10', '2025-12-13'),
('KH117', 'HV104', N'Lê Ngọc Hà', 7, '0919335577', N'Giới thiệu', N'Đã đăng ký', '2025-12-12', '2025-12-15'),
('KH118', 'HV105', N'Phạm Công Toản', 9, '0975557799', N'Website', N'Đã đăng ký', '2025-12-14', '2025-12-17'),
('KH119', 'HV106', N'Vũ Thị Hồng Loan', 12, '0908779911', N'Hotline', N'Đã đăng ký', '2025-12-15', '2025-12-18'),
('KH120', 'HV107', N'Nguyễn Trọng Nghĩa', 8, '0941991133', N'Facebook', N'Đã đăng ký', '2025-12-17', '2025-12-20'),
('KH121', 'HV108', N'Trần Thanh Huyền', 11, '0983114466', N'Giới thiệu', N'Đã đăng ký', '2025-12-19', '2025-12-22'),
('KH122', 'HV109', N'Lê Tuấn Vũ', 9, '0912336688', N'Website', N'Đã đăng ký', '2025-12-21', '2025-12-24'),
('KH123', 'HV110', N'Phạm Mai Phương', 12, '0971558800', N'Facebook', N'Đã đăng ký', '2025-12-23', '2025-12-26'),
('KH124', 'HV111', N'Đỗ Tiến Dũng', 6, '0901770022', N'Facebook', N'Đã đăng ký', '2025-12-25', '2025-12-28'),
('KH125', NULL, N'Nguyễn Thúy Hạnh', 10, '0932992244', N'Giới thiệu', N'Không đăng ký', '2025-12-09', NULL),
('KH126', NULL, N'Trần Thành Công', 9, '0989115577', N'Website', N'Không đăng ký', '2025-12-16', NULL),
('KH127', NULL, N'Lê Bảo Ngọc', 12, '0914337799', N'Hotline', N'Không đăng ký', '2025-12-22', NULL),

('KH128', 'HV112', N'Phạm Nguyễn Minh Khang', 11, '0977559911', N'Facebook', N'Đã đăng ký', '2026-01-03', '2026-01-06'),
('KH129', 'HV113', N'Hoàng Thị Ngọc Ánh', 9, '0905771133', N'Giới thiệu', N'Đã đăng ký', '2026-01-04', '2026-01-07'),
('KH130', 'HV114', N'Nguyễn Đức Phát', 12, '0944993355', N'Website', N'Đã đăng ký', '2026-01-05', '2026-01-08'),
('KH131', 'HV115', N'Trần Thị Bích Trâm', 6, '0983116688', N'Facebook', N'Đã đăng ký', '2026-01-06', '2026-01-09'),
('KH132', 'HV116', N'Lê Quang Huy', 9, '0918338800', N'Facebook', N'Đã đăng ký', '2026-01-07', '2026-01-10'),
('KH133', 'HV117', N'Phạm Diệu Linh', 12, '0975550022', N'Giới thiệu', N'Đã đăng ký', '2026-01-08', '2026-01-11'),
('KH134', 'HV118', N'Vũ Minh Tuấn', 9, '0908772244', N'Website', N'Đã đăng ký', '2026-01-08', '2026-01-11'),
('KH135', 'HV119', N'Nguyễn Lê Thu Uyên', 12, '0936994466', N'Hotline', N'Đã đăng ký', '2026-01-09', '2026-01-12'),
('KH136', 'HV120', N'Trần Quốc Bảo', 8, '0988117788', N'Facebook', N'Đã đăng ký', '2026-01-10', '2026-01-13'),
('KH137', 'HV121', N'Lê Thị Hương Giang', 9, '0912339900', N'Giới thiệu', N'Đã đăng ký', '2026-01-11', '2026-01-14'),
('KH138', 'HV122', N'Phạm Hoàng Nam', 12, '0974551122', N'Website', N'Đã đăng ký', '2026-01-12', '2026-01-15'),
('KH139', 'HV123', N'Đặng Phương Thảo', 6, '0903774455', N'Facebook', N'Đã đăng ký', '2026-01-12', '2026-01-15'),
('KH140', 'HV124', N'Nguyễn Thành Công', 8, '0947996677', N'Facebook', N'Đã đăng ký', '2026-01-13', '2026-01-16'),
('KH141', 'HV125', N'Trần Ngọc Yến', 9, '0985118899', N'Giới thiệu', N'Đã đăng ký', '2026-01-14', '2026-01-17'),
('KH142', 'HV126', N'Lê Đăng Khoa', 12, '0915330011', N'Website', N'Đã đăng ký', '2026-01-15', '2026-01-18'),
('KH143', 'HV127', N'Phạm Thị Thanh Bình', 6, '0979552244', N'Hotline', N'Đã đăng ký', '2026-01-16', '2026-01-19'),
('KH144', 'HV128', N'Bùi Quang Dũng', 7, '0906775566', N'Facebook', N'Đã đăng ký', '2026-01-17', '2026-01-20'),
('KH145', 'HV129', N'Nguyễn Hương Ly', 9, '0931997788', N'Giới thiệu', N'Đã đăng ký', '2026-01-17', '2026-01-20'),
('KH146', 'HV130', N'Trần Hữu Lộc', 12, '0982110011', N'Website', N'Đã đăng ký', '2026-01-18', '2026-01-21'),
('KH147', 'HV131', N'Lê Bích Tuyền', 8, '0917332233', N'Facebook', N'Đã đăng ký', '2026-01-19', '2026-01-22'),
('KH148', 'HV132', N'Phạm Trọng Đạt', 11, '0973554455', N'Facebook', N'Đã đăng ký', '2026-01-20', '2026-01-23'),
('KH149', 'HV133', N'Hoàng Thị Tuyết', 10, '0907776677', N'Giới thiệu', N'Đã đăng ký', '2026-01-20', '2026-01-23'),
('KH150', 'HV134', N'Nguyễn Đức Vinh', 9, '0946998899', N'Website', N'Đã đăng ký', '2026-01-21', '2026-01-24'),
('KH151', 'HV135', N'Trần Lan Phương', 12, '0987111122', N'Hotline', N'Đã đăng ký', '2026-01-22', '2026-01-25'),
('KH152', 'HV136', N'Lê Thanh Sơn', 6, '0913333344', N'Facebook', N'Đã đăng ký', '2026-01-23', '2026-01-26'),
('KH153', 'HV137', N'Phạm Nguyễn Minh Khôi', 8, '0978555566', N'Giới thiệu', N'Đã đăng ký', '2026-01-23', '2026-01-26'),
('KH154', 'HV138', N'Vũ Thùy Linh', 11, '0904777788', N'Website', N'Đã đăng ký', '2026-01-24', '2026-01-27'),
('KH155', 'HV139', N'Nguyễn Gia Hưng', 9, '0939999900', N'Facebook', N'Đã đăng ký', '2026-01-25', '2026-01-28'),
('KH156', 'HV140', N'Trần Bảo Ngọc', 12, '0984112233', N'Facebook', N'Đã đăng ký', '2026-01-25', '2026-01-28'),
('KH157', 'HV141', N'Lê Minh Tuệ', 6, '0919334455', N'Giới thiệu', N'Đã đăng ký', '2026-01-26', '2026-01-29'),
('KH158', 'HV142', N'Phạm Hữu Bằng', 8, '0975556677', N'Website', N'Đã đăng ký', '2026-01-26', '2026-01-29'),
('KH159', 'HV143', N'Đỗ Phương Anh', 9, '0908778899', N'Hotline', N'Đã đăng ký', '2026-01-27', '2026-01-30'),
('KH160', 'HV144', N'Nguyễn Quang Tiến', 10, '0941990011', N'Facebook', N'Đã đăng ký', '2026-01-28', '2026-01-31'),
('KH161', 'HV145', N'Trần Thị Cẩm Ly', 9, '0983113355', N'Giới thiệu', N'Đã đăng ký', '2026-01-28', '2026-01-31'),
('KH162', 'HV146', N'Lê Văn Khánh', 12, '0912335577', N'Website', N'Đã đăng ký', '2026-01-28', '2026-01-31'),
('KH163', NULL, N'Phạm Hoàng Mai', 6, '0971557799', N'Facebook', N'Không đăng ký', '2026-01-10', NULL),
('KH164', NULL, N'Bùi Thanh Tuấn', 7, '0901779911', N'Giới thiệu', N'Không đăng ký', '2026-01-14', NULL),
('KH165', NULL, N'Nguyễn Phương Vy', 9, '0937991133', N'Website', N'Không đăng ký', '2026-01-20', NULL),
('KH166', NULL, N'Trần Quốc An', 12, '0988114466', N'Hotline', N'Không đăng ký', '2026-01-26', NULL),

('KH167', 'HV147', N'Phạm Nguyễn Minh Hằng', 9, '0914336688', N'Facebook', N'Đã đăng ký', '2026-02-02', '2026-02-05'),
('KH168', 'HV148', N'Hoàng Bảo Châu', 11, '0979558800', N'Facebook', N'Đã đăng ký', '2026-02-02', '2026-02-05'),
('KH169', 'HV149', N'Nguyễn Trọng Tấn', 6, '0905770022', N'Giới thiệu', N'Đã đăng ký', '2026-02-03', '2026-02-06'),
('KH170', 'HV150', N'Trần Thị Bích Ngọc', 9, '0949992244', N'Website', N'Đã đăng ký', '2026-02-03', '2026-02-06'),
('KH171', 'HV151', N'Lê Tấn Phát', 12, '0986115577', N'Hotline', N'Đã đăng ký', '2026-02-04', '2026-02-07'),
('KH172', 'HV152', N'Phạm Thanh Thủy', 7, '0915337799', N'Facebook', N'Đã đăng ký', '2026-02-04', '2026-02-07'),
('KH173', 'HV153', N'Vũ Ngọc Cường', 9, '0972559911', N'Giới thiệu', N'Đã đăng ký', '2026-02-05', '2026-02-08'),
('KH174', 'HV154', N'Nguyễn Mai Hương', 12, '0908771133', N'Website', N'Đã đăng ký', '2026-02-05', '2026-02-08'),
('KH175', 'HV155', N'Trần Minh Khang', 8, '0933993355', N'Facebook', N'Đã đăng ký', '2026-02-06', '2026-02-09'),
('KH176', 'HV156', N'Lê Phương Thảo', 10, '0981116688', N'Facebook', N'Đã đăng ký', '2026-02-06', '2026-02-09'),
('KH177', 'HV157', N'Phạm Đức Trí', 9, '0918338800', N'Giới thiệu', N'Đã đăng ký', '2026-02-07', '2026-02-10'),
('KH178', 'HV158', N'Đặng Thanh Xuân', 12, '0974550022', N'Website', N'Đã đăng ký', '2026-02-07', '2026-02-10'),
('KH179', 'HV159', N'Nguyễn Gia Huy', 6, '0903772244', N'Hotline', N'Đã đăng ký', '2026-02-08', '2026-02-11'),
('KH180', 'HV160', N'Trần Cẩm Nhung', 11, '0947995577', N'Facebook', N'Đã đăng ký', '2026-02-08', '2026-02-11'),
('KH181', 'HV161', N'Lê Minh Châu', 9, '0985117799', N'Giới thiệu', N'Đã đăng ký', '2026-02-09', '2026-02-12'),
('KH182', 'HV162', N'Phạm Tiến Dũng', 12, '0915339911', N'Website', N'Đã đăng ký', '2026-02-09', '2026-02-12'),
('KH183', 'HV163', N'Bùi Bích Phương', 10, '0979551133', N'Facebook', N'Đã đăng ký', '2026-02-10', '2026-02-13'),
('KH184', 'HV164', N'Nguyễn Quang Minh', 9, '0906774466', N'Facebook', N'Đã đăng ký', '2026-02-10', '2026-02-13'),
('KH185', 'HV165', N'Trần Ngọc Lan', 12, '0931996688', N'Giới thiệu', N'Đã đăng ký', '2026-02-11', '2026-02-14'),
('KH186', 'HV166', N'Lê Đức Phương', 6, '0982119900', N'Website', N'Đã đăng ký', '2026-02-11', '2026-02-14'),
('KH187', 'HV167', N'Phạm Nguyễn Minh Quân', 8, '0917331122', N'Hotline', N'Đã đăng ký', '2026-02-12', '2026-02-14'),
('KH188', 'HV168', N'Hoàng Yến Nhi', 11, '0973553344', N'Facebook', N'Đã đăng ký', '2026-02-12', '2026-02-14'),
('KH189', 'HV169', N'Nguyễn Tấn Đạt', 9, '0907775566', N'Giới thiệu', N'Đã đăng ký', '2026-02-13', '2026-02-14'),
('KH190', 'HV170', N'Trần Thu Hà', 12, '0946997788', N'Website', N'Đã đăng ký', '2026-02-13', '2026-02-14'),
('KH191', 'HV171', N'Lê Quốc Bình', 8, '0987110011', N'Facebook', N'Đã đăng ký', '2026-02-14', '2026-02-15'),
('KH192', 'HV172', N'Phạm Mai Lan', 11, '0913332233', N'Facebook', N'Đã đăng ký', '2026-02-14', '2026-02-15'),
('KH193', 'HV173', N'Vũ Đình Khang', 9, '0978554455', N'Giới thiệu', N'Đã đăng ký', '2026-02-22', '2026-02-25'),
('KH194', 'HV174', N'Nguyễn Thanh Trúc', 12, '0904776677', N'Website', N'Đã đăng ký', '2026-02-22', '2026-02-25'),
('KH195', 'HV175', N'Trần Gia Hưng', 6, '0939998899', N'Hotline', N'Đã đăng ký', '2026-02-23', '2026-02-26'),
('KH196', 'HV176', N'Lê Ngọc Điệp', 9, '0984111122', N'Facebook', N'Đã đăng ký', '2026-02-23', '2026-02-26'),
('KH197', 'HV177', N'Phạm Trung Thành', 12, '0919333344', N'Giới thiệu', N'Đã đăng ký', '2026-02-24', '2026-02-27'),
('KH198', 'HV178', N'Đỗ Bích Thủy', 9, '0975555566', N'Website', N'Đã đăng ký', '2026-02-24', '2026-02-27'),
('KH199', 'HV179', N'Nguyễn Hữu Tài', 8, '0908777788', N'Facebook', N'Đã đăng ký', '2026-02-25', '2026-02-28'),
('KH200', 'HV180', N'Trần Thị Quỳnh', 10, '0941999900', N'Facebook', N'Đã đăng ký', '2026-02-25', '2026-02-28'),
('KH201', 'HV181', N'Lê Minh Nhật', 9, '0983112233', N'Giới thiệu', N'Đã đăng ký', '2026-02-26', '2026-02-28'),
('KH202', NULL, N'Phạm Nguyễn Minh Nhật', 12, '0912334455', N'Website', N'Không đăng ký', '2026-02-05', NULL),
('KH203', NULL, N'Bùi Thị Thu Hà', 6, '0971556677', N'Hotline', N'Không đăng ký', '2026-02-12', NULL),
('KH204', NULL, N'Nguyễn Công Phương', 7, '0901778899', N'Facebook', N'Không đăng ký', '2026-02-24', NULL),
('KH205', NULL, N'Trần Ngọc Anh', 9, '0937990011', N'Giới thiệu', N'Không đăng ký', '2026-02-27', NULL),

('KH206', 'HV182', N'Lê Thanh Bình', 9, '0988113355', N'Website', N'Đã đăng ký', '2026-03-05', '2026-03-08'),
('KH207', 'HV183', N'Phạm Cẩm Nhung', 6, '0914335577', N'Facebook', N'Đã đăng ký', '2026-03-06', '2026-03-09'),
('KH208', 'HV184', N'Hoàng Quốc Vượng', 11, '0979557799', N'Facebook', N'Đã đăng ký', '2026-03-08', '2026-03-11'),
('KH209', 'HV185', N'Nguyễn Phương Ly', 9, '0905779911', N'Giới thiệu', N'Đã đăng ký', '2026-03-09', '2026-03-12'),
('KH210', 'HV186', N'Trần Khắc Việt', 12, '0949991133', N'Website', N'Đã đăng ký', '2026-03-11', '2026-03-14'),
('KH211', 'HV187', N'Lê Hương Lan', 8, '0986114466', N'Hotline', N'Đã đăng ký', '2026-03-12', '2026-03-15'),
('KH212', 'HV188', N'Phạm Đình Luật', 7, '0915336688', N'Facebook', N'Đã đăng ký', '2026-03-14', '2026-03-17'),
('KH213', 'HV189', N'Vũ Thị Bích Phượng', 9, '0972558800', N'Giới thiệu', N'Đã đăng ký', '2026-03-15', '2026-03-18'),
('KH214', 'HV190', N'Nguyễn Trung Kiên', 12, '0908770022', N'Website', N'Đã đăng ký', '2026-03-17', '2026-03-20'),
('KH215', 'HV191', N'Trần Ngọc Diệp', 6, '0933992244', N'Facebook', N'Đã đăng ký', '2026-03-18', '2026-03-21'),
('KH216', 'HV192', N'Lê Minh Trọng', 11, '0981115577', N'Facebook', N'Đã đăng ký', '2026-03-20', '2026-03-23'),
('KH217', 'HV193', N'Phạm Nguyễn Minh Nguyệt', 10, '0918337799', N'Giới thiệu', N'Đã đăng ký', '2026-03-21', '2026-03-24'),
('KH218', 'HV194', N'Đặng Tuấn Phát', 9, '0975559911', N'Website', N'Đã đăng ký', '2026-03-23', '2026-03-26'),
('KH219', 'HV195', N'Bùi Phương Thảo', 12, '0904771133', N'Hotline', N'Đã đăng ký', '2026-03-25', '2026-03-28'),
('KH220', NULL, N'Nguyễn Quang Huy', 6, '0939993355', N'Facebook', N'Không đăng ký', '2026-03-07', NULL),
('KH221', NULL, N'Trần Tuyết Mai', 9, '0984116688', N'Giới thiệu', N'Không đăng ký', '2026-03-13', NULL),
('KH222', NULL, N'Lê Đức Tâm', 12, '0919338800', N'Website', N'Không đăng ký', '2026-03-22', NULL),

('KH223', 'HV196', N'Phạm Thị Mai', 11, '0975550022', N'Facebook', N'Đã đăng ký', '2026-04-02', '2026-04-05'),
('KH224', 'HV197', N'Hoàng Trọng Nghĩa', 9, '0908772244', N'Facebook', N'Đã đăng ký', '2026-04-05', '2026-04-08'),
('KH225', 'HV198', N'Nguyễn Yến Oanh', 12, '0941994466', N'Giới thiệu', N'Đã đăng ký', '2026-04-08', '2026-04-11'),
('KH226', 'HV199', N'Trần Minh Luân', 6, '0983117788', N'Website', N'Đã đăng ký', '2026-04-12', '2026-04-15'),
('KH227', 'HV200', N'Lê Thu Phương', 7, '0912339900', N'Hotline', N'Đã đăng ký', '2026-04-15', '2026-04-18'),
('KH228', 'HV201', N'Phạm Gia Khang', 9, '0971551122', N'Facebook', N'Đã đăng ký', '2026-04-19', '2026-04-22'),
('KH229', 'HV202', N'Vũ Bích Hạnh', 12, '0901774455', N'Giới thiệu', N'Đã đăng ký', '2026-04-22', '2026-04-25'),
('KH230', NULL, N'Nguyễn Đăng Khoa', 8, '0937996677', N'Website', N'Không đăng ký', '2026-04-06', NULL),
('KH231', NULL, N'Trần Ngọc Thủy', 11, '0988118899', N'Facebook', N'Không đăng ký', '2026-04-17', NULL),
('KH232', NULL, N'Lê Minh Quân', 9, '0913330011', N'Facebook', N'Quan tâm', '2026-04-03', NULL),
('KH233', NULL, N'Phạm Nguyễn Minh Trang', 12, '0979552244', N'Giới thiệu', N'Quan tâm', '2026-04-07', NULL),
('KH234', NULL, N'Đặng Tuấn Hưng', 6, '0906775566', N'Website', N'Quan tâm', '2026-04-10', NULL),
('KH235', NULL, N'Bùi Phương Liên', 8, '0931997788', N'Hotline', N'Quan tâm', '2026-04-14', NULL),
('KH236', NULL, N'Nguyễn Quang Đạt', 9, '0982110011', N'Facebook', N'Quan tâm', '2026-04-18', NULL),
('KH237', NULL, N'Trần Bích Hường', 12, '0917332233', N'Giới thiệu', N'Quan tâm', '2026-04-21', NULL),
('KH238', NULL, N'Lê Trung Sơn', 10, '0973554455', N'Website', N'Quan tâm', '2026-04-24', NULL),
('KH239', NULL, N'Phạm Ngọc Yến', 9, '0907776677', N'Facebook', N'Quan tâm', '2026-04-26', NULL),
('KH240', NULL, N'Hoàng Trí Thành', 12, '0946998899', N'Facebook', N'Quan tâm', '2026-04-27', NULL),
('KH241', NULL, N'Vũ Nguyễn Minh Châu', 6, '0987111122', N'Giới thiệu', N'Quan tâm', '2026-04-28', NULL),

('KH242', 'HV203', N'Nguyễn Cẩm Tú', 8, '0913333344', N'Website', N'Đã đăng ký', '2026-05-02', '2026-05-05'),
('KH243', 'HV204', N'Trần Quốc Hùng', 11, '0978555566', N'Hotline', N'Đã đăng ký', '2026-05-04', '2026-05-07'),
('KH244', 'HV205', N'Lê Phương Thanh', 9, '0904777788', N'Facebook', N'Đã đăng ký', '2026-05-06', '2026-05-09'),
('KH245', NULL, N'Phạm Đăng Hải', 12, '0939999900', N'Giới thiệu', N'Không đăng ký', '2026-05-03', NULL),
('KH246', NULL, N'Đỗ Minh Cường', 6, '0984112233', N'Website', N'Quan tâm', '2026-05-04', NULL),
('KH247', NULL, N'Nguyễn Hà Giang', 8, '0919334455', N'Facebook', N'Quan tâm', '2026-05-05', NULL),
('KH248', NULL, N'Trần Tuấn Tú', 9, '0975556677', N'Facebook', N'Quan tâm', '2026-05-07', NULL),
('KH249', NULL, N'Lê Bích Ngọc', 12, '0908778899', N'Giới thiệu', N'Quan tâm', '2026-05-08', NULL),
('KH250', NULL, N'Phạm Nguyễn Tấn Dũng', 10, '0941990011', N'Website', N'Quan tâm', '2026-05-09', NULL);
 

-- BUỔI HỌC
INSERT INTO BUOI_HOC (MaBuoiHoc, MaLop, NgayHoc) VALUES
-- LH010, LH011 (Khối 9 - Học Tối Thứ 3, Thứ 5)
('LH010_01','LH010','2026-03-03'), ('LH010_02','LH010','2026-03-05'), ('LH010_03','LH010','2026-03-10'), ('LH010_04','LH010','2026-03-12'),
('LH010_05','LH010','2026-03-17'), ('LH010_06','LH010','2026-03-19'), ('LH010_07','LH010','2026-03-24'), ('LH010_08','LH010','2026-03-26'),
('LH010_09','LH010','2026-03-31'), ('LH010_10','LH010','2026-04-02'), ('LH010_11','LH010','2026-04-07'), ('LH010_12','LH010','2026-04-09'),
('LH010_13','LH010','2026-04-14'), ('LH010_14','LH010','2026-04-16'), ('LH010_15','LH010','2026-04-21'), ('LH010_16','LH010','2026-04-23'),
('LH010_17','LH010','2026-04-28'), /* Nghỉ 30/4 */                 ('LH010_18','LH010','2026-05-05'), ('LH010_19','LH010','2026-05-07'),
('LH010_20','LH010','2026-05-12'), ('LH010_21','LH010','2026-05-14'),

('LH011_01','LH011','2026-03-03'), ('LH011_02','LH011','2026-03-05'), ('LH011_03','LH011','2026-03-10'), ('LH011_04','LH011','2026-03-12'),
('LH011_05','LH011','2026-03-17'), ('LH011_06','LH011','2026-03-19'), ('LH011_07','LH011','2026-03-24'), ('LH011_08','LH011','2026-03-26'),
('LH011_09','LH011','2026-03-31'), ('LH011_10','LH011','2026-04-02'), ('LH011_11','LH011','2026-04-07'), ('LH011_12','LH011','2026-04-09'),
('LH011_13','LH011','2026-04-14'), ('LH011_14','LH011','2026-04-16'), ('LH011_15','LH011','2026-04-21'), ('LH011_16','LH011','2026-04-23'),
('LH011_17','LH011','2026-04-28'), /* Nghỉ 30/4 */                 ('LH011_18','LH011','2026-05-05'), ('LH011_19','LH011','2026-05-07'),
('LH011_20','LH011','2026-05-12'), ('LH011_21','LH011','2026-05-14'),

-- LH019, LH020 (Khối 12 - Học Tối Thứ 3, Chiều CN)
('LH019_01','LH019','2026-03-01'), ('LH019_02','LH019','2026-03-03'), ('LH019_03','LH019','2026-03-08'), ('LH019_04','LH019','2026-03-10'),
('LH019_05','LH019','2026-03-15'), ('LH019_06','LH019','2026-03-17'), ('LH019_07','LH019','2026-03-22'), ('LH019_08','LH019','2026-03-24'),
('LH019_09','LH019','2026-03-29'), ('LH019_10','LH019','2026-03-31'), ('LH019_11','LH019','2026-04-05'), ('LH019_12','LH019','2026-04-07'),
('LH019_13','LH019','2026-04-12'), ('LH019_14','LH019','2026-04-14'), ('LH019_15','LH019','2026-04-19'), ('LH019_16','LH019','2026-04-21'),
/* Nghỉ Giỗ tổ 26/4 */             ('LH019_17','LH019','2026-04-28'), ('LH019_18','LH019','2026-05-03'), ('LH019_19','LH019','2026-05-05'),
('LH019_20','LH019','2026-05-10'), ('LH019_21','LH019','2026-05-12'), ('LH019_22','LH019','2026-05-17'),

('LH020_01','LH020','2026-03-01'), ('LH020_02','LH020','2026-03-03'), ('LH020_03','LH020','2026-03-08'), ('LH020_04','LH020','2026-03-10'),
('LH020_05','LH020','2026-03-15'), ('LH020_06','LH020','2026-03-17'), ('LH020_07','LH020','2026-03-22'), ('LH020_08','LH020','2026-03-24'),
('LH020_09','LH020','2026-03-29'), ('LH020_10','LH020','2026-03-31'), ('LH020_11','LH020','2026-04-05'), ('LH020_12','LH020','2026-04-07'),
('LH020_13','LH020','2026-04-12'), ('LH020_14','LH020','2026-04-14'), ('LH020_15','LH020','2026-04-19'), ('LH020_16','LH020','2026-04-21'),
/* Nghỉ Giỗ tổ 26/4 */             ('LH020_17','LH020','2026-04-28'), ('LH020_18','LH020','2026-05-03'), ('LH020_19','LH020','2026-05-05'),
('LH020_20','LH020','2026-05-10'), ('LH020_21','LH020','2026-05-12'), ('LH020_22','LH020','2026-05-17'),

-- LH001, LH002 (Khối 6 - Học Tối Thứ 2, Thứ 5)
('LH001_01','LH001','2026-03-02'), ('LH001_02','LH001','2026-03-05'), ('LH001_03','LH001','2026-03-09'), ('LH001_04','LH001','2026-03-12'),
('LH001_05','LH001','2026-03-16'), ('LH001_06','LH001','2026-03-19'), ('LH001_07','LH001','2026-03-23'), ('LH001_08','LH001','2026-03-26'),
('LH001_09','LH001','2026-03-30'), ('LH001_10','LH001','2026-04-02'), ('LH001_11','LH001','2026-04-06'), ('LH001_12','LH001','2026-04-09'),
('LH001_13','LH001','2026-04-13'), ('LH001_14','LH001','2026-04-16'), ('LH001_15','LH001','2026-04-20'), ('LH001_16','LH001','2026-04-23'),
('LH001_17','LH001','2026-04-27'), /* Nghỉ 30/4 */                 ('LH001_18','LH001','2026-05-04'), ('LH001_19','LH001','2026-05-07'),
('LH001_20','LH001','2026-05-11'), ('LH001_21','LH001','2026-05-14'),

('LH002_01','LH002','2026-03-02'), ('LH002_02','LH002','2026-03-05'), ('LH002_03','LH002','2026-03-09'), ('LH002_04','LH002','2026-03-12'),
('LH002_05','LH002','2026-03-16'), ('LH002_06','LH002','2026-03-19'), ('LH002_07','LH002','2026-03-23'), ('LH002_08','LH002','2026-03-26'),
('LH002_09','LH002','2026-03-30'), ('LH002_10','LH002','2026-04-02'), ('LH002_11','LH002','2026-04-06'), ('LH002_12','LH002','2026-04-09'),
('LH002_13','LH002','2026-04-13'), ('LH002_14','LH002','2026-04-16'), ('LH002_15','LH002','2026-04-20'), ('LH002_16','LH002','2026-04-23'),
('LH002_17','LH002','2026-04-27'), /* Nghỉ 30/4 */                 ('LH002_18','LH002','2026-05-04'), ('LH002_19','LH002','2026-05-07'),
('LH002_20','LH002','2026-05-11'), ('LH002_21','LH002','2026-05-14'),

-- LH007 (Khối 8 - Học Tối Thứ 2, Thứ 4)
('LH007_01','LH007','2026-03-02'), ('LH007_02','LH007','2026-03-04'), ('LH007_03','LH007','2026-03-09'), ('LH007_04','LH007','2026-03-11'),
('LH007_05','LH007','2026-03-16'), ('LH007_06','LH007','2026-03-18'), ('LH007_07','LH007','2026-03-23'), ('LH007_08','LH007','2026-03-25'),
('LH007_09','LH007','2026-03-30'), ('LH007_10','LH007','2026-04-01'), ('LH007_11','LH007','2026-04-06'), ('LH007_12','LH007','2026-04-08'),
('LH007_13','LH007','2026-04-13'), ('LH007_14','LH007','2026-04-15'), ('LH007_15','LH007','2026-04-20'), ('LH007_16','LH007','2026-04-22'),
('LH007_17','LH007','2026-04-27'), ('LH007_18','LH007','2026-04-29'), ('LH007_19','LH007','2026-05-04'), ('LH007_20','LH007','2026-05-06'),
('LH007_21','LH007','2026-05-11'), ('LH007_22','LH007','2026-05-13'),

-- LH017 (Khối 11 - Học Tối Thứ 2, Thứ 6)
('LH017_01','LH017','2026-03-02'), ('LH017_02','LH017','2026-03-06'), ('LH017_03','LH017','2026-03-09'), ('LH017_04','LH017','2026-03-13'),
('LH017_05','LH017','2026-03-16'), ('LH017_06','LH017','2026-03-20'), ('LH017_07','LH017','2026-03-23'), ('LH017_08','LH017','2026-03-27'),
('LH017_09','LH017','2026-03-30'), ('LH017_10','LH017','2026-04-03'), ('LH017_11','LH017','2026-04-06'), ('LH017_12','LH017','2026-04-10'),
('LH017_13','LH017','2026-04-13'), ('LH017_14','LH017','2026-04-17'), ('LH017_15','LH017','2026-04-20'), ('LH017_16','LH017','2026-04-24'),
('LH017_17','LH017','2026-04-27'), /* Nghỉ 1/5 */                  ('LH017_18','LH017','2026-05-04'), ('LH017_19','LH017','2026-05-08'),
('LH017_20','LH017','2026-05-11'), ('LH017_21','LH017','2026-05-15'),

-- LH013, LH014 (Khối 10 - Học Tối Thứ 4, Thứ 6)

('LH013_01','LH013','2026-03-04'), ('LH013_02','LH013','2026-03-06'), ('LH013_03','LH013','2026-03-11'), ('LH013_04','LH013','2026-03-13'),
('LH013_05','LH013','2026-03-18'), ('LH013_06','LH013','2026-03-20'), ('LH013_07','LH013','2026-03-25'), ('LH013_08','LH013','2026-03-27'),
('LH013_09','LH013','2026-04-01'), ('LH013_10','LH013','2026-04-03'), ('LH013_11','LH013','2026-04-08'), ('LH013_12','LH013','2026-04-10'),
('LH013_13','LH013','2026-04-15'), ('LH013_14','LH013','2026-04-17'), ('LH013_15','LH013','2026-04-22'), ('LH013_16','LH013','2026-04-24'),
('LH013_17','LH013','2026-04-29'), /* Nghỉ 1/5 */                  ('LH013_18','LH013','2026-05-06'), ('LH013_19','LH013','2026-05-08'),
('LH013_20','LH013','2026-05-13'), ('LH013_21','LH013','2026-05-15'),

('LH014_01','LH014','2026-03-04'), ('LH014_02','LH014','2026-03-06'), ('LH014_03','LH014','2026-03-11'), ('LH014_04','LH014','2026-03-13'),
('LH014_05','LH014','2026-03-18'), ('LH014_06','LH014','2026-03-20'), ('LH014_07','LH014','2026-03-25'), ('LH014_08','LH014','2026-03-27'),
('LH014_09','LH014','2026-04-01'), ('LH014_10','LH014','2026-04-03'), ('LH014_11','LH014','2026-04-08'), ('LH014_12','LH014','2026-04-10'),
('LH014_13','LH014','2026-04-15'), ('LH014_14','LH014','2026-04-17'), ('LH014_15','LH014','2026-04-22'), ('LH014_16','LH014','2026-04-24'),
('LH014_17','LH014','2026-04-29'), /* Nghỉ 1/5 */                  ('LH014_18','LH014','2026-05-06'), ('LH014_19','LH014','2026-05-08'),
('LH014_20','LH014','2026-05-13'), ('LH014_21','LH014','2026-05-15'),


-- LH004 (Khối 7 - Học Tối Thứ 3, Thứ 6)
('LH004_01','LH004','2026-03-03'), ('LH004_02','LH004','2026-03-06'), ('LH004_03','LH004','2026-03-10'), ('LH004_04','LH004','2026-03-13'),
('LH004_05','LH004','2026-03-17'), ('LH004_06','LH004','2026-03-20'), ('LH004_07','LH004','2026-03-24'), ('LH004_08','LH004','2026-03-27'),
('LH004_09','LH004','2026-03-31'), ('LH004_10','LH004','2026-04-03'), ('LH004_11','LH004','2026-04-07'), ('LH004_12','LH004','2026-04-10'),
('LH004_13','LH004','2026-04-14'), ('LH004_14','LH004','2026-04-17'), ('LH004_15','LH004','2026-04-21'), ('LH004_16','LH004','2026-04-24'),
('LH004_17','LH004','2026-04-28'), /* Nghỉ 1/5 */                  ('LH004_18','LH004','2026-05-05'), ('LH004_19','LH004','2026-05-08'),
('LH004_20','LH004','2026-05-12'), ('LH004_21','LH004','2026-05-15'),

-- LH012, LH021 (Khối 9 & 12 Giỏi - Học Thứ 7, CN)
('LH012_01','LH012','2026-03-01'), ('LH012_02','LH012','2026-03-07'), ('LH012_03','LH012','2026-03-08'), ('LH012_04','LH012','2026-03-14'),
('LH012_05','LH012','2026-03-15'), ('LH012_06','LH012','2026-03-21'), ('LH012_07','LH012','2026-03-22'), ('LH012_08','LH012','2026-03-28'),
('LH012_09','LH012','2026-03-29'), ('LH012_10','LH012','2026-04-04'), ('LH012_11','LH012','2026-04-05'), ('LH012_12','LH012','2026-04-11'),
('LH012_13','LH012','2026-04-12'), ('LH012_14','LH012','2026-04-18'), ('LH012_15','LH012','2026-04-19'), ('LH012_16','LH012','2026-04-25'),
/* Nghỉ Giỗ tổ 26/4 */             ('LH012_17','LH012','2026-05-02'), ('LH012_18','LH012','2026-05-03'), ('LH012_19','LH012','2026-05-09'),
('LH012_20','LH012','2026-05-10'), ('LH012_21','LH012','2026-05-16'), ('LH012_22','LH012','2026-05-17'),

('LH021_01','LH021','2026-03-01'), ('LH021_02','LH021','2026-03-07'), ('LH021_03','LH021','2026-03-08'), ('LH021_04','LH021','2026-03-14'),
('LH021_05','LH021','2026-03-15'), ('LH021_06','LH021','2026-03-21'), ('LH021_07','LH021','2026-03-22'), ('LH021_08','LH021','2026-03-28'),
('LH021_09','LH021','2026-03-29'), ('LH021_10','LH021','2026-04-04'), ('LH021_11','LH021','2026-04-05'), ('LH021_12','LH021','2026-04-11'),
('LH021_13','LH021','2026-04-12'), ('LH021_14','LH021','2026-04-18'), ('LH021_15','LH021','2026-04-19'), ('LH021_16','LH021','2026-04-25'),
/* Nghỉ Giỗ tổ 26/4 */             ('LH021_17','LH021','2026-05-02'), ('LH021_18','LH021','2026-05-03'), ('LH021_19','LH021','2026-05-09'),
('LH021_20','LH021','2026-05-10'), ('LH021_21','LH021','2026-05-16'), ('LH021_22','LH021','2026-05-17');

-- LỚP LH016 (Lịch học: Thứ 2 và Thứ 6)
-- Đã trừ Tết, nghỉ bù Giỗ Tổ (Thứ 2 - 27/04), nghỉ Quốc tế Lao động (Thứ 6 - 01/05)
INSERT INTO BUOI_HOC (MaBuoiHoc, MaLop, NgayHoc) VALUES 
('LH016_01', 'LH016', '2026-01-02'), ('LH016_02', 'LH016', '2026-01-05'),
('LH016_03', 'LH016', '2026-01-09'), ('LH016_04', 'LH016', '2026-01-12'),
('LH016_05', 'LH016', '2026-01-16'), ('LH016_06', 'LH016', '2026-01-19'),
('LH016_07', 'LH016', '2026-01-23'), ('LH016_08', 'LH016', '2026-01-26'),
('LH016_09', 'LH016', '2026-01-30'), ('LH016_10', 'LH016', '2026-02-02'),
('LH016_11', 'LH016', '2026-02-06'), ('LH016_12', 'LH016', '2026-02-09'),
('LH016_13', 'LH016', '2026-02-27'), ('LH016_14', 'LH016', '2026-03-02'),
('LH016_15', 'LH016', '2026-03-06'), ('LH016_16', 'LH016', '2026-03-09'),
('LH016_17', 'LH016', '2026-03-13'), ('LH016_18', 'LH016', '2026-03-16'),
('LH016_19', 'LH016', '2026-03-20'), ('LH016_20', 'LH016', '2026-03-23'),
('LH016_21', 'LH016', '2026-03-27'), ('LH016_22', 'LH016', '2026-03-30'),
('LH016_23', 'LH016', '2026-04-03'), ('LH016_24', 'LH016', '2026-04-06'),
('LH016_25', 'LH016', '2026-04-10'), ('LH016_26', 'LH016', '2026-04-13'),
('LH016_27', 'LH016', '2026-04-17'), ('LH016_28', 'LH016', '2026-04-20'),
('LH016_29', 'LH016', '2026-04-24'), ('LH016_30', 'LH016', '2026-05-04'),
('LH016_31', 'LH016', '2026-05-08'), ('LH016_32', 'LH016', '2026-05-11'),
('LH016_33', 'LH016', '2026-05-15');


-- LỚP LH008 (Lịch học: Thứ 2 và Thứ 4)
-- Đã trừ Tết, nghỉ bù Giỗ Tổ (Thứ 2 - 27/04)
INSERT INTO BUOI_HOC (MaBuoiHoc, MaLop, NgayHoc) VALUES 
('LH008_01', 'LH008', '2026-01-05'), ('LH008_02', 'LH008', '2026-01-07'),
('LH008_03', 'LH008', '2026-01-12'), ('LH008_04', 'LH008', '2026-01-14'),
('LH008_05', 'LH008', '2026-01-19'), ('LH008_06', 'LH008', '2026-01-21'),
('LH008_07', 'LH008', '2026-01-26'), ('LH008_08', 'LH008', '2026-01-28'),
('LH008_09', 'LH008', '2026-02-02'), ('LH008_10', 'LH008', '2026-02-04'),
('LH008_11', 'LH008', '2026-02-09'), ('LH008_12', 'LH008', '2026-02-11'),
('LH008_13', 'LH008', '2026-02-25'), ('LH008_14', 'LH008', '2026-03-02'),
('LH008_15', 'LH008', '2026-03-04'), ('LH008_16', 'LH008', '2026-03-09'),
('LH008_17', 'LH008', '2026-03-11'), ('LH008_18', 'LH008', '2026-03-16'),
('LH008_19', 'LH008', '2026-03-18'), ('LH008_20', 'LH008', '2026-03-23'),
('LH008_21', 'LH008', '2026-03-25'), ('LH008_22', 'LH008', '2026-03-30'),
('LH008_23', 'LH008', '2026-04-01'), ('LH008_24', 'LH008', '2026-04-06'),
('LH008_25', 'LH008', '2026-04-08'), ('LH008_26', 'LH008', '2026-04-13'),
('LH008_27', 'LH008', '2026-04-15'), ('LH008_28', 'LH008', '2026-04-20'),
('LH008_29', 'LH008', '2026-04-22'), ('LH008_30', 'LH008', '2026-04-29'),
('LH008_31', 'LH008', '2026-05-04'), ('LH008_32', 'LH008', '2026-05-06'),
('LH008_33', 'LH008', '2026-05-11'), ('LH008_34', 'LH008', '2026-05-13');

-- LỚP LH006 (Lịch học: Thứ 7 và Chủ Nhật)
-- Đã trừ Tết, nghỉ Giỗ Tổ Hùng Vương (Chủ Nhật - 26/04)
INSERT INTO BUOI_HOC (MaBuoiHoc, MaLop, NgayHoc) VALUES 
('LH006_01', 'LH006', '2026-01-03'), ('LH006_02', 'LH006', '2026-01-04'),
('LH006_03', 'LH006', '2026-01-10'), ('LH006_04', 'LH006', '2026-01-11'),
('LH006_05', 'LH006', '2026-01-17'), ('LH006_06', 'LH006', '2026-01-18'),
('LH006_07', 'LH006', '2026-01-24'), ('LH006_08', 'LH006', '2026-01-25'),
('LH006_09', 'LH006', '2026-01-31'), ('LH006_10', 'LH006', '2026-02-01'),
('LH006_11', 'LH006', '2026-02-07'), ('LH006_12', 'LH006', '2026-02-08'),
('LH006_13', 'LH006', '2026-02-28'), ('LH006_14', 'LH006', '2026-03-01'),
('LH006_15', 'LH006', '2026-03-07'), ('LH006_16', 'LH006', '2026-03-08'),
('LH006_17', 'LH006', '2026-03-14'), ('LH006_18', 'LH006', '2026-03-15'),
('LH006_19', 'LH006', '2026-03-21'), ('LH006_20', 'LH006', '2026-03-22'),
('LH006_21', 'LH006', '2026-03-28'), ('LH006_22', 'LH006', '2026-03-29'),
('LH006_23', 'LH006', '2026-04-04'), ('LH006_24', 'LH006', '2026-04-05'),
('LH006_25', 'LH006', '2026-04-11'), ('LH006_26', 'LH006', '2026-04-12'),
('LH006_27', 'LH006', '2026-04-18'), ('LH006_28', 'LH006', '2026-04-19'),
('LH006_29', 'LH006', '2026-04-25'), ('LH006_30', 'LH006', '2026-05-02'),
('LH006_31', 'LH006', '2026-05-03'), ('LH006_32', 'LH006', '2026-05-09'),
('LH006_33', 'LH006', '2026-05-10');

-- 3. ĐỔ DỮ LIỆU ĐIỂM SỐ KÍN 100% CÁC BUỔI CHO TỪNG HỌC SINH 
-- ĐỔ DỮ LIỆU KQ_HOC_TAP LỚP LH016 (MÔN NGỮ VĂN 11) - HỌC LỰC: TRUNG BÌNH
-- NHÓM 1: CÁC HỌC VIÊN HỌC TỪ ĐẦU (ĐĂNG KÝ TRONG NĂM 2025)
-- Học viên: HV007, HV028, HV044, HV068, HV088 (Học đủ 33 buổi)
INSERT INTO KQ_HOC_TAP (MaKQHT, MaBuoiHoc, MaHocVien, DiemDanh, BTVN, DiemSo, NhanXet) VALUES 
('K007B01','LH016_01','HV007',N'Có mặt',N'Đầy đủ',6.0,N'Hiểu bối cảnh Hai đứa trẻ nhưng chưa sâu.'),
('K007B02','LH016_02','HV007',N'Có mặt',N'Đầy đủ',5.5,N'Phân tích tâm lý nhân vật Liên còn lủng củng.'),
('K007B03','LH016_03','HV007',N'Có mặt',N'Đầy đủ',6.5,N'Nắm được giá trị hiện thực của Chí Phèo.'),
('K007B04','LH016_04','HV007',N'Vắng mặt',N'Không làm',0.0,N'Nghỉ học có phép.'),
('K007B05','LH016_05','HV007',N'Có mặt',N'Đầy đủ',5.0,N'Cảm thụ bài thơ Vội Vàng của Xuân Diệu chưa tốt.'),
('K007B06','LH016_06','HV007',N'Có mặt',N'Thiếu',5.5,N'Diễn đạt còn dùng văn nói nhiều.'),
('K007B07','LH016_07','HV007',N'Có mặt',N'Đầy đủ',6.0,N'Có chú ý nghe giảng phần thơ Tràng Giang.'),
('K007B08','LH016_08','HV007',N'Có mặt',N'Đầy đủ',6.5,N'Bài viết chữ Hán trong Chữ người tử tù khá rõ ý.'),
('K007B09','LH016_09','HV007',N'Vắng mặt',N'Không làm',0.0,N'Vắng không phép.'),
('K007B10','LH016_10','HV007',N'Có mặt',N'Đầy đủ',5.5,N'Mở bài còn rập khuôn, chưa sáng tạo.'),
('K007B11','LH016_11','HV007',N'Có mặt',N'Thiếu',5.0,N'Sai nhiều lỗi chính tả trong bài tự luận.'),
('K007B12','LH016_12','HV007',N'Có mặt',N'Đầy đủ',6.0,N'Nghị luận xã hội thiếu dẫn chứng thực tế.'),
('K007B13','LH016_13','HV007',N'Có mặt',N'Đầy đủ',6.5,N'Hiểu được bi kịch cự tuyệt quyền làm người.'),
('K007B14','LH016_14','HV007',N'Có mặt',N'Đầy đủ',5.5,N'Tóm tắt cốt truyện còn lan man.'),
('K007B15','LH016_15','HV007',N'Có mặt',N'Thiếu',5.0,N'Chưa nêu được vẻ đẹp thơ ca Hàn Mặc Tử.'),
('K007B16','LH016_16','HV007',N'Có mặt',N'Đầy đủ',6.0,N'Biết cách chia luận điểm nhưng chưa biết phân tích.'),
('K007B17','LH016_17','HV007',N'Vắng mặt',N'Không làm',0.0,N'Nghỉ học có báo phụ huynh.'),
('K007B18','LH016_18','HV007',N'Có mặt',N'Đầy đủ',5.5,N'Sử dụng từ ngữ còn nghèo nàn.'),
('K007B19','LH016_19','HV007',N'Có mặt',N'Đầy đủ',6.0,N'Bài làm sạch sẽ nhưng ý tứ chưa sâu.'),
('K007B20','LH016_20','HV007',N'Có mặt',N'Thiếu',5.0,N'Không thuộc thơ, cần về nhà ôn lại.'),
('K007B21','LH016_21','HV007',N'Có mặt',N'Đầy đủ',6.5,N'Có cố gắng trong phần liên hệ bản thân.'),
('K007B22','LH016_22','HV007',N'Có mặt',N'Đầy đủ',5.5,N'Thiếu phần kết bài do quản lý thời gian kém.'),
('K007B23','LH016_23','HV007',N'Có mặt',N'Đầy đủ',6.0,N'Đọc hiểu văn bản tốt, trả lời trắc nghiệm khá.'),
('K007B24','LH016_24','HV007',N'Có mặt',N'Thiếu',5.5,N'Chưa hiểu rõ nghệ thuật tương phản.'),
('K007B25','LH016_25','HV007',N'Vắng mặt',N'Không làm',0.0,N'Nghỉ ốm.'),
('K007B26','LH016_26','HV007',N'Có mặt',N'Đầy đủ',6.0,N'Bài viết có sự mạch lạc hơn các bài trước.'),
('K007B27','LH016_27','HV007',N'Có mặt',N'Đầy đủ',6.5,N'Phân tích chi tiết bát cháo hành khá tốt.'),
('K007B28','LH016_28','HV007',N'Có mặt',N'Đầy đủ',5.0,N'Cần rèn luyện thêm kỹ năng viết đoạn văn.'),
('K007B29','LH016_29','HV007',N'Có mặt',N'Thiếu',5.5,N'Làm bài đối phó, thiếu đầu tư.'),
('K007B30','LH016_30','HV007',N'Có mặt',N'Đầy đủ',6.0,N'Ôn tập tổng hợp đạt mức cơ bản.'),
('K007B31','LH016_31','HV007',N'Có mặt',N'Đầy đủ',6.5,N'Biết cách lập dàn ý trước khi viết.'),
('K007B32','LH016_32','HV007',N'Có mặt',N'Đầy đủ',5.5,N'Vẫn còn sai lỗi chính tả cơ bản.'),
('K007B33','LH016_33','HV007',N'Có mặt',N'Đầy đủ',6.0,N'Hoàn thành khóa học, đạt điểm sàn môn Văn.');

-- 1. HỌC VIÊN HV028 (Lê Nguyễn Tuấn Kiệt) - Yếu phần thơ, hành văn chưa mượt
INSERT INTO KQ_HOC_TAP (MaKQHT, MaBuoiHoc, MaHocVien, DiemDanh, BTVN, DiemSo, NhanXet) VALUES 
('K028B01','LH016_01','HV028',N'Có mặt',N'Đầy đủ',5.5,N'Còn bỡ ngỡ với cách tiếp cận văn bản lớp 11.'),
('K028B02','LH016_02','HV028',N'Có mặt',N'Đầy đủ',6.0,N'Nắm được cốt truyện Hai đứa trẻ nhưng chưa hiểu chất thơ trong tác phẩm.'),
('K028B03','LH016_03','HV028',N'Có mặt',N'Thiếu',5.0,N'Chưa thấy được sự quẩn quanh, bế tắc của phố huyện.'),
('K028B04','LH016_04','HV028',N'Vắng mặt',N'Không làm',0.0,N'Nghỉ học có báo trước.'),
('K028B05','LH016_05','HV028',N'Có mặt',N'Đầy đủ',6.5,N'Tiếp thu bài Chữ người tử tù khá tốt, hiểu vẻ đẹp Huấn Cao.'),
('K028B06','LH016_06','HV028',N'Có mặt',N'Đầy đủ',5.5,N'Mở bài còn rập khuôn, dùng văn mẫu nhiều.'),
('K028B07','LH016_07','HV028',N'Có mặt',N'Thiếu',6.0,N'Phân tích cảnh cho chữ thiếu các từ ngữ gợi hình.'),
('K028B08','LH016_08','HV028',N'Có mặt',N'Đầy đủ',5.5,N'Hiểu bi kịch của Chí Phèo nhưng hành văn còn lủng củng.'),
('K028B09','LH016_09','HV028',N'Có mặt',N'Đầy đủ',6.0,N'Biết cách so sánh với Lão Hạc nhưng chưa sâu.'),
('K028B10','LH016_10','HV028',N'Có mặt',N'Đầy đủ',6.5,N'Nhìn ra được chi tiết bát cháo hành có ý nghĩa nhân đạo sâu sắc.'),
('K028B11','LH016_11','HV028',N'Có mặt',N'Đầy đủ',5.0,N'Phần nghị luận xã hội xa rời thực tế.'),
('K028B12','LH016_12','HV028',N'Có mặt',N'Đầy đủ',5.5,N'Viết sai lỗi chính tả khá nhiều ở bài tự luận.'),
('K028B13','LH016_13','HV028',N'Có mặt',N'Đầy đủ',6.0,N'Có ý thức học bài nhưng vốn từ nghèo nàn.'),
('K028B14','LH016_14','HV028',N'Có mặt',N'Đầy đủ',5.5,N'Phân tích bài thơ Vội Vàng còn hời hợt.'),
('K028B15','LH016_15','HV028',N'Vắng mặt',N'Không làm',0.0,N'Vắng không phép.'),
('K028B16','LH016_16','HV028',N'Có mặt',N'Đầy đủ',5.0,N'Không thuộc thơ, không có dẫn chứng để phân tích.'),
('K028B17','LH016_17','HV028',N'Có mặt',N'Thiếu',6.0,N'Bước đầu hiểu được khái niệm Thơ Mới.'),
('K028B18','LH016_18','HV028',N'Có mặt',N'Đầy đủ',6.5,N'Đã biết cách chia luận điểm khi làm bài.'),
('K028B19','LH016_19','HV028',N'Có mặt',N'Đầy đủ',5.5,N'Phân tích Tràng Giang chưa toát lên nỗi sầu không gian.'),
('K028B20','LH016_20','HV028',N'Có mặt',N'Đầy đủ',6.0,N'Có sự tiến bộ trong việc dùng từ ghép, từ láy.'),
('K028B21','LH016_21','HV028',N'Có mặt',N'Thiếu',5.5,N'Bố cục bài viết còn lộn xộn, kết bài vội vàng.'),
('K028B22','LH016_22','HV028',N'Vắng mặt',N'Không làm',0.0,N'Nghỉ ốm.'),
('K028B23','LH016_23','HV028',N'Có mặt',N'Đầy đủ',6.5,N'Đọc hiểu văn bản khá tốt, trả lời đúng trọng tâm.'),
('K028B24','LH016_24','HV028',N'Có mặt',N'Đầy đủ',6.0,N'Hiểu nội dung bài Đây thôn Vĩ Dạ ở mức cơ bản.'),
('K028B25','LH016_25','HV028',N'Có mặt',N'Thiếu',5.0,N'Cảm thụ cái tôi trữ tình của Hàn Mặc Tử còn yếu.'),
('K028B26','LH016_26','HV028',N'Có mặt',N'Đầy đủ',5.5,N'Chỉ diễn xuôi lại câu thơ, chưa có kỹ năng bình thơ.'),
('K028B27','LH016_27','HV028',N'Có mặt',N'Đầy đủ',6.0,N'Ôn tập bài Từ ấy khá ổn, nắm được lý tưởng cộng sản.'),
('K028B28','LH016_28','HV028',N'Có mặt',N'Đầy đủ',6.5,N'Biết liên hệ với lòng yêu nước của giới trẻ hiện nay.'),
('K028B29','LH016_29','HV028',N'Vắng mặt',N'Không làm',0.0,N'Nghỉ có phép.'),
('K028B30','LH016_30','HV028',N'Có mặt',N'Thiếu',5.5,N'Kiến thức tiếng Việt cần được củng cố thêm.'),
('K028B31','LH016_31','HV028',N'Có mặt',N'Đầy đủ',6.0,N'Làm bài thi thử phân bổ thời gian hợp lý hơn.'),
('K028B32','LH016_32','HV028',N'Có mặt',N'Đầy đủ',6.0,N'Cần luyện tập thêm việc viết đoạn văn nghị luận.'),
('K028B33','LH016_33','HV028',N'Có mặt',N'Đầy đủ',6.5,N'Tổng kết khóa học đạt yêu cầu cơ bản, có tiến bộ nhẹ.');

-- 2. HỌC VIÊN HV044 (Phạm Tiến Phát) - Khá phần đọc hiểu, lập luận yếu, chữ viết xấu
INSERT INTO KQ_HOC_TAP (MaKQHT, MaBuoiHoc, MaHocVien, DiemDanh, BTVN, DiemSo, NhanXet) VALUES 
('K044B01','LH016_01','HV044',N'Có mặt',N'Đầy đủ',6.0,N'Tiếp thu bài nhanh nhưng lười ghi chép.'),
('K044B02','LH016_02','HV044',N'Có mặt',N'Thiếu',5.5,N'Hiểu bài Hai đứa trẻ nhưng bài tập về nhà làm cẩu thả.'),
('K044B03','LH016_03','HV044',N'Có mặt',N'Đầy đủ',6.5,N'Nhìn nhận chi tiết đoàn tàu rất có tư duy.'),
('K044B04','LH016_04','HV044',N'Có mặt',N'Đầy đủ',5.0,N'Chữ viết quá xấu, khó đọc, cần cải thiện ngay.'),
('K044B05','LH016_05','HV044',N'Có mặt',N'Thiếu',6.0,N'Lập luận trong bài Chữ người tử tù còn lỏng lẻo.'),
('K044B06','LH016_06','HV044',N'Có mặt',N'Đầy đủ',5.5,N'Đoạn văn bị thiếu liên kết, dùng sai quan hệ từ.'),
('K044B07','LH016_07','HV044',N'Vắng mặt',N'Không làm',0.0,N'Vắng học không phép.'),
('K044B08','LH016_08','HV044',N'Có mặt',N'Đầy đủ',6.5,N'Đọc hiểu phần truyện Chí Phèo rất tốt.'),
('K044B09','LH016_09','HV044',N'Có mặt',N'Đầy đủ',6.0,N'Phân tích quá trình lưu manh hóa còn thiếu ý.'),
('K044B10','LH016_10','HV044',N'Có mặt',N'Đầy đủ',5.5,N'Trình bày bài bẩn, gạch xóa nhiều lần.'),
('K044B11','LH016_11','HV044',N'Có mặt',N'Thiếu',6.0,N'Có ý tưởng hay cho bài nghị luận xã hội.'),
('K044B12','LH016_12','HV044',N'Có mặt',N'Đầy đủ',5.0,N'Thiếu hệ thống luận điểm rõ ràng khi viết bài.'),
('K044B13','LH016_13','HV044',N'Có mặt',N'Đầy đủ',6.5,N'Giải quyết các câu hỏi đọc hiểu trên lớp trọn vẹn.'),
('K044B14','LH016_14','HV044',N'Có mặt',N'Thiếu',5.5,N'Chưa cảm nhận được nhịp điệu của thơ Xuân Diệu.'),
('K044B15','LH016_15','HV044',N'Có mặt',N'Đầy đủ',6.0,N'Học thuộc bài Vội vàng nhưng phân tích chưa trúng.'),
('K044B16','LH016_16','HV044',N'Có mặt',N'Đầy đủ',6.0,N'Khắc phục được phần nào lỗi sai chính tả.'),
('K044B17','LH016_17','HV044',N'Có mặt',N'Đầy đủ',5.5,N'Cần đọc thêm sách tham khảo để tăng vốn từ.'),
('K044B18','LH016_18','HV044',N'Vắng mặt',N'Không làm',0.0,N'Nghỉ ốm.'),
('K044B19','LH016_19','HV044',N'Có mặt',N'Đầy đủ',6.5,N'Nắm bắt được âm hưởng cổ điển trong Tràng Giang.'),
('K044B20','LH016_20','HV044',N'Có mặt',N'Thiếu',6.0,N'Hiểu nội dung nhưng lười diễn đạt thành câu hoàn chỉnh.'),
('K044B21','LH016_21','HV044',N'Có mặt',N'Đầy đủ',5.0,N'Bài viết quá ngắn, không đạt yêu cầu về dung lượng.'),
('K044B22','LH016_22','HV044',N'Có mặt',N'Đầy đủ',5.5,N'Thiếu sự chuyển ý mượt mà giữa các khổ thơ.'),
('K044B23','LH016_23','HV044',N'Có mặt',N'Đầy đủ',6.5,N'Phát biểu hăng hái ở bài Đây thôn Vĩ Dạ.'),
('K044B24','LH016_24','HV044',N'Có mặt',N'Đầy đủ',6.0,N'Biết tìm các biện pháp tu từ nhưng chưa biết gọi tên.'),
('K044B25','LH016_25','HV044',N'Có mặt',N'Thiếu',5.5,N'Chỉ làm phần thân bài, bỏ trống mở bài và kết bài.'),
('K044B26','LH016_26','HV044',N'Có mặt',N'Đầy đủ',6.0,N'Hành văn có nét trưởng thành hơn.'),
('K044B27','LH016_27','HV044',N'Có mặt',N'Đầy đủ',6.5,N'Hiểu sâu sắc lý tưởng cách mạng trong bài Từ ấy.'),
('K044B28','LH016_28','HV044',N'Có mặt',N'Đầy đủ',6.0,N'Viết đoạn văn nghị luận 200 chữ đúng cấu trúc.'),
('K044B29','LH016_29','HV044',N'Có mặt',N'Thiếu',5.0,N'Làm sai trọng tâm đề bài trong phần thực hành.'),
('K044B30','LH016_30','HV044',N'Có mặt',N'Đầy đủ',6.0,N'Nhớ được hệ thống kiến thức trọng tâm kì 1.'),
('K044B31','LH016_31','HV044',N'Vắng mặt',N'Không làm',0.0,N'Xin phép nghỉ việc gia đình.'),
('K044B32','LH016_32','HV044',N'Có mặt',N'Đầy đủ',6.5,N'Bài thi thử làm khá tốt phần đọc hiểu.'),
('K044B33','LH016_33','HV044',N'Có mặt',N'Đầy đủ',6.0,N'Kết quả trung bình ổn, cần cải thiện phần viết luận.');

-- 3. HỌC VIÊN HV068 (Lê Tiến Đạt) - Lười làm bài tập, nắm lý thuyết cơ bản
INSERT INTO KQ_HOC_TAP (MaKQHT, MaBuoiHoc, MaHocVien, DiemDanh, BTVN, DiemSo, NhanXet) VALUES 
('K068B01','LH016_01','HV068',N'Có mặt',N'Thiếu',5.5,N'Vào lớp chú ý nghe giảng nhưng không làm bài về nhà.'),
('K068B02','LH016_02','HV068',N'Vắng mặt',N'Không làm',0.0,N'Vắng không phép.'),
('K068B03','LH016_03','HV068',N'Có mặt',N'Thiếu',5.0,N'Hiểu hời hợt về tác phẩm Hai đứa trẻ.'),
('K068B04','LH016_04','HV068',N'Có mặt',N'Đầy đủ',6.0,N'Đã chép bài đầy đủ, nhận thức được khung cảnh phố huyện.'),
('K068B05','LH016_05','HV068',N'Có mặt',N'Đầy đủ',6.5,N'Phân tích khá tốt nhân vật quản ngục trong Chữ người tử tù.'),
('K068B06','LH016_06','HV068',N'Có mặt',N'Thiếu',5.5,N'Lập luận còn non nớt, chưa bám sát văn bản.'),
('K068B07','LH016_07','HV068',N'Có mặt',N'Đầy đủ',6.0,N'Có cố gắng tự làm bài, hạn chế dùng văn mẫu.'),
('K068B08','LH016_08','HV068',N'Có mặt',N'Đầy đủ',5.5,N'Chưa phân tích được quá trình thức tỉnh của Chí Phèo.'),
('K068B09','LH016_09','HV068',N'Có mặt',N'Đầy đủ',6.5,N'Nắm được phong cách nghệ thuật của Nam Cao.'),
('K068B10','LH016_10','HV068',N'Vắng mặt',N'Không làm',0.0,N'Nghỉ học có báo trước.'),
('K068B11','LH016_11','HV068',N'Có mặt',N'Đầy đủ',5.0,N'Phần mở bài trực tiếp nhưng quá khô khan.'),
('K068B12','LH016_12','HV068',N'Có mặt',N'Thiếu',6.0,N'Lấy dẫn chứng nghị luận xã hội còn sáo rỗng.'),
('K068B13','LH016_13','HV068',N'Có mặt',N'Đầy đủ',5.5,N'Cách trình bày luận điểm chưa logic.'),
('K068B14','LH016_14','HV068',N'Có mặt',N'Đầy đủ',6.5,N'Hiểu được triết lý sống vội vàng của Xuân Diệu.'),
('K068B15','LH016_15','HV068',N'Có mặt',N'Thiếu',5.0,N'Phân tích thơ chủ yếu là diễn xuôi, thiếu nghệ thuật.'),
('K068B16','LH016_16','HV068',N'Có mặt',N'Đầy đủ',6.0,N'Biết phân tích một vài từ nhãn tự trong câu thơ.'),
('K068B17','LH016_17','HV068',N'Có mặt',N'Đầy đủ',5.5,N'Câu văn viết dài dòng, không có dấu câu phù hợp.'),
('K068B18','LH016_18','HV068',N'Có mặt',N'Đầy đủ',6.5,N'Làm bài kiểm tra có sự đầu tư, mạch lạc hơn.'),
('K068B19','LH016_19','HV068',N'Có mặt',N'Thiếu',5.5,N'Quên kiến thức về thể thơ thất ngôn.'),
('K068B20','LH016_20','HV068',N'Vắng mặt',N'Không làm',0.0,N'Nghỉ học có phép (báo ốm).'),
('K068B21','LH016_21','HV068',N'Có mặt',N'Đầy đủ',6.0,N'Hiểu bài Tràng Giang nhưng chưa biết cách làm bài.'),
('K068B22','LH016_22','HV068',N'Có mặt',N'Thiếu',5.0,N'Bài viết quá sơ sài, nộp bài sớm nhưng làm ẩu.'),
('K068B23','LH016_23','HV068',N'Có mặt',N'Đầy đủ',6.0,N'Đã xác định được các yếu tố tượng trưng trong bài thơ.'),
('K068B24','LH016_24','HV068',N'Có mặt',N'Đầy đủ',6.5,N'Phân tích cảnh bình minh trên sông Hương khá tinh tế.'),
('K068B25','LH016_25','HV068',N'Vắng mặt',N'Không làm',0.0,N'Nghỉ vì lý do cá nhân.'),
('K068B26','LH016_26','HV068',N'Có mặt',N'Đầy đủ',5.5,N'Còn bối rối khi gặp dạng đề phân tích nhân vật.'),
('K068B27','LH016_27','HV068',N'Có mặt',N'Đầy đủ',6.0,N'Học thuộc bài Từ ấy, nhưng viết luận chưa sâu.'),
('K068B28','LH016_28','HV068',N'Có mặt',N'Đầy đủ',6.5,N'Tích cực xây dựng bài khi ôn tập về Tố Hữu.'),
('K068B29','LH016_29','HV068',N'Có mặt',N'Thiếu',5.0,N'Cần thay đổi thái độ làm bài tập về nhà.'),
('K068B30','LH016_30','HV068',N'Có mặt',N'Đầy đủ',6.0,N'Hệ thống lại kiến thức cơ bản đủ để thi.'),
('K068B31','LH016_31','HV068',N'Có mặt',N'Đầy đủ',6.0,N'Biết phân tích yêu cầu đề bài trước khi viết.'),
('K068B32','LH016_32','HV068',N'Có mặt',N'Đầy đủ',5.5,N'Chưa có kĩ năng viết phần kết bài mở rộng.'),
('K068B33','LH016_33','HV068',N'Có mặt',N'Đầy đủ',6.5,N'Vượt qua kì kiểm tra, cần chăm chỉ hơn ở kì sau.');

-- 4. HỌC VIÊN HV088 (Phạm Tiến Đạt) - Chăm chỉ, nhưng thiếu sự nhạy cảm văn học
INSERT INTO KQ_HOC_TAP (MaKQHT, MaBuoiHoc, MaHocVien, DiemDanh, BTVN, DiemSo, NhanXet) VALUES 
('K088B01','LH016_01','HV088',N'Có mặt',N'Đầy đủ',6.5,N'Chăm chỉ ghi chép, nắm bắt nội dung tổng quan tốt.'),
('K088B02','LH016_02','HV088',N'Có mặt',N'Đầy đủ',6.0,N'Tóm tắt tác phẩm Hai đứa trẻ rất chi tiết.'),
('K088B03','LH016_03','HV088',N'Có mặt',N'Đầy đủ',5.5,N'Chưa cảm nhận được chất lãng mạn của Thạch Lam.'),
('K088B04','LH016_04','HV088',N'Có mặt',N'Đầy đủ',6.0,N'Bài viết rõ ràng, đủ 3 phần mở, thân, kết.'),
('K088B05','LH016_05','HV088',N'Có mặt',N'Đầy đủ',6.5,N'Hiểu tình huống truyện độc đáo trong Chữ người tử tù.'),
('K088B06','LH016_06','HV088',N'Có mặt',N'Đầy đủ',5.5,N'Văn phong mang tính chất liệt kê, chưa có sự bình luận.'),
('K088B07','LH016_07','HV088',N'Có mặt',N'Đầy đủ',5.0,N'Diễn đạt lặp từ nhiều, ý tứ rời rạc.'),
('K088B08','LH016_08','HV088',N'Có mặt',N'Đầy đủ',6.5,N'Phân tích ngoại hình Chí Phèo đầy đủ chi tiết.'),
('K088B09','LH016_09','HV088',N'Vắng mặt',N'Không làm',0.0,N'Nghỉ học có báo trước.'),
('K088B10','LH016_10','HV088',N'Có mặt',N'Đầy đủ',6.0,N'Xác định đúng ý nghĩa tiếng chửi của Chí Phèo.'),
('K088B11','LH016_11','HV088',N'Có mặt',N'Đầy đủ',6.5,N'Làm bài nghị luận xã hội về tình yêu thương con người rất tốt.'),
('K088B12','LH016_12','HV088',N'Có mặt',N'Đầy đủ',5.5,N'Chưa biết cách lật lại vấn đề trong nghị luận.'),
('K088B13','LH016_13','HV088',N'Có mặt',N'Thiếu',5.0,N'Mắc lỗi trình bày, chữ viết chưa cẩn thận ở bài luận ngắn.'),
('K088B14','LH016_14','HV088',N'Có mặt',N'Đầy đủ',6.0,N'Ghi nhớ kiến thức về phong trào Thơ mới.'),
('K088B15','LH016_15','HV088',N'Có mặt',N'Đầy đủ',6.5,N'Đọc thuộc bài Vội vàng, cảm thụ ở mức khá.'),
('K088B16','LH016_16','HV088',N'Có mặt',N'Đầy đủ',5.5,N'Chỉ bám vào nội dung, bỏ qua phân tích các biện pháp nghệ thuật.'),
('K088B17','LH016_17','HV088',N'Có mặt',N'Đầy đủ',6.0,N'Có cố gắng sử dụng các từ ngữ biểu cảm trong bài viết.'),
('K088B18','LH016_18','HV088',N'Có mặt',N'Đầy đủ',6.5,N'Bài viết chỉn chu, có dẫn chứng phong phú.'),
('K088B19','LH016_19','HV088',N'Có mặt',N'Đầy đủ',6.0,N'Hiểu nội dung Tràng Giang nhưng chưa cảm được nỗi sầu.'),
('K088B20','LH016_20','HV088',N'Có mặt',N'Đầy đủ',5.5,N'Phân tích các chi tiết còn rời rạc, chưa liên kết thành bức tranh chung.'),
('K088B21','LH016_21','HV088',N'Có mặt',N'Đầy đủ',5.0,N'Kết bài chung chung, thiếu điểm nhấn.'),
('K088B22','LH016_22','HV088',N'Có mặt',N'Đầy đủ',6.0,N'Có tìm hiểu trước thông tin về tác giả Hàn Mặc Tử.'),
('K088B23','LH016_23','HV088',N'Có mặt',N'Đầy đủ',6.5,N'Nêu bật được vẻ đẹp thiên nhiên trong Đây thôn Vĩ Dạ.'),
('K088B24','LH016_24','HV088',N'Có mặt',N'Đầy đủ',6.0,N'Hiểu về câu hỏi tu từ nhưng chưa chỉ ra tác dụng sâu sắc.'),
('K088B25','LH016_25','HV088',N'Có mặt',N'Đầy đủ',5.5,N'Cần mạnh dạn đưa cảm xúc cá nhân vào khi bình thơ.'),
('K088B26','LH016_26','HV088',N'Vắng mặt',N'Không làm',0.0,N'Xin nghỉ vì có việc gia đình.'),
('K088B27','LH016_27','HV088',N'Có mặt',N'Đầy đủ',6.0,N'Nắm vững thông điệp bài thơ Từ ấy.'),
('K088B28','LH016_28','HV088',N'Có mặt',N'Đầy đủ',6.5,N'Viết đoạn văn chứng minh lý tưởng sống khá tốt.'),
('K088B29','LH016_29','HV088',N'Có mặt',N'Đầy đủ',5.5,N'Mở rộng vấn đề nghị luận còn khiên cưỡng.'),
('K088B30','LH016_30','HV088',N'Có mặt',N'Đầy đủ',6.0,N'Ôn tập chăm chỉ, hệ thống sơ đồ tư duy rõ ràng.'),
('K088B31','LH016_31','HV088',N'Có mặt',N'Đầy đủ',6.5,N'Làm phần trắc nghiệm đọc hiểu chính xác cao.'),
('K088B32','LH016_32','HV088',N'Có mặt',N'Đầy đủ',6.0,N'Bài viết tự luận dài nhưng còn một số ý bị lặp lại.'),
('K088B33','LH016_33','HV088',N'Có mặt',N'Đầy đủ',6.5,N'Đạt kết quả khá tốt nhờ sự cần cù, thái độ học rất đáng khen.');

-- NHÓM 2: HỌC VIÊN ĐĂNG KÝ SAU - VÀO HỌC TRỄ
-- 1. HV112 (Đăng ký 06/01/2026 -> Bắt đầu từ Buổi 5 ngày 16/01/2026 đến Buổi 33)
-- Tổng số buổi: 29 buổi
INSERT INTO KQ_HOC_TAP (MaKQHT, MaBuoiHoc, MaHocVien, DiemDanh, BTVN, DiemSo, NhanXet) VALUES 
('K112B05','LH016_05','HV112',N'Có mặt',N'Đầy đủ',6.0,N'Buổi đầu hòa nhập tốt, nắm được kiến thức nền.'),
('K112B06','LH016_06','HV112',N'Có mặt',N'Thiếu',5.5,N'Phân tích thơ còn lúng túng.'),
('K112B07','LH016_07','HV112',N'Có mặt',N'Đầy đủ',6.5,N'Hiểu sâu sắc bi kịch của Chí Phèo.'),
('K112B08','LH016_08','HV112',N'Vắng mặt',N'Không làm',0.0,N'Nghỉ học có phép.'),
('K112B09','LH016_09','HV112',N'Có mặt',N'Đầy đủ',5.0,N'Nghị luận văn học chưa trúng trọng tâm.'),
('K112B10','LH016_10','HV112',N'Có mặt',N'Đầy đủ',6.0,N'Có cải thiện về cách phân tách đoạn văn.'),
('K112B11','LH016_11','HV112',N'Có mặt',N'Đầy đủ',6.0,N'Cần luyện chữ viết cẩn thận hơn.'),
('K112B12','LH016_12','HV112',N'Có mặt',N'Thiếu',5.5,N'Chưa học thuộc các câu thơ dẫn chứng.'),
('K112B13','LH016_13','HV112',N'Có mặt',N'Đầy đủ',6.5,N'Phát biểu xây dựng bài khá tích cực.'),
('K112B14','LH016_14','HV112',N'Có mặt',N'Đầy đủ',5.5,N'Tóm tắt bài Vội Vàng còn thiếu ý.'),
('K112B15','LH016_15','HV112',N'Vắng mặt',N'Không làm',0.0,N'Vắng không phép.'),
('K112B16','LH016_16','HV112',N'Có mặt',N'Đầy đủ',6.0,N'Đã biết cách liên hệ thực tế trong bài viết.'),
('K112B17','LH016_17','HV112',N'Có mặt',N'Đầy đủ',5.5,N'Cảm thụ bài thơ Tràng Giang còn hạn chế, chưa thấy được nỗi buồn nhân thế.'),
('K112B18','LH016_18','HV112',N'Có mặt',N'Thiếu',6.0,N'Trình bày sạch đẹp nhưng ý văn còn nông.'),
('K112B19','LH016_19','HV112',N'Có mặt',N'Đầy đủ',6.5,N'Bài viết có sự sáng tạo trong việc mở bài.'),
('K112B20','LH016_20','HV112',N'Vắng mặt',N'Không làm',0.0,N'Nghỉ ốm có báo phụ huynh.'),
('K112B21','LH016_21','HV112',N'Có mặt',N'Đầy đủ',5.0,N'Chưa phân tích được nghệ thuật lấy động tả tĩnh trong thơ.'),
('K112B22','LH016_22','HV112',N'Có mặt',N'Đầy đủ',5.5,N'Đã thuộc thơ Đây thôn Vĩ Dạ nhưng kỹ năng bình thơ kém.'),
('K112B23','LH016_23','HV112',N'Có mặt',N'Đầy đủ',6.0,N'Hiểu được nỗi niềm u uẩn của Hàn Mặc Tử.'),
('K112B24','LH016_24','HV112',N'Có mặt',N'Thiếu',6.5,N'Tích cực phát biểu, đóng góp ý kiến xây dựng bài trên lớp.'),
('K112B25','LH016_25','HV112',N'Có mặt',N'Đầy đủ',5.5,N'Lỗi lặp từ và sai ngữ pháp còn xuất hiện nhiều.'),
('K112B26','LH016_26','HV112',N'Có mặt',N'Đầy đủ',5.0,N'Nhầm lẫn kiến thức cơ bản về tác giả Tố Hữu.'),
('K112B27','LH016_27','HV112',N'Có mặt',N'Đầy đủ',6.0,N'Có tiến bộ trong việc lấy dẫn chứng thực tế cho bài làm.'),
('K112B28','LH016_28','HV112',N'Vắng mặt',N'Không làm',0.0,N'Vắng mặt có phép (việc gia đình).'),
('K112B29','LH016_29','HV112',N'Có mặt',N'Thiếu',6.5,N'Phân tích lý tưởng cách mạng trong Từ ấy khá tốt.'),
('K112B30','LH016_30','HV112',N'Có mặt',N'Đầy đủ',5.5,N'Thiếu kĩ năng tóm tắt và khái quát văn bản.'),
('K112B31','LH016_31','HV112',N'Có mặt',N'Đầy đủ',6.0,N'Bài kiểm tra thi thử hoàn thành đúng thời gian quy định.'),
('K112B32','LH016_32','HV112',N'Có mặt',N'Đầy đủ',6.5,N'Nắm chắc lý thuyết cơ bản để chuẩn bị thi.'),
('K112B33','LH016_33','HV112',N'Có mặt',N'Đầy đủ',6.5,N'Kết thúc khóa học khá ổn, có tiến bộ.');

-- 2. HV136 (Đăng ký 26/01/2026 -> Bắt đầu từ Buổi 10 ngày 02/02/2026 đến Buổi 33)
-- Tổng số buổi: 24 buổi
INSERT INTO KQ_HOC_TAP (MaKQHT, MaBuoiHoc, MaHocVien, DiemDanh, BTVN, DiemSo, NhanXet) VALUES 
('K136B10','LH016_10','HV136',N'Có mặt',N'Đầy đủ',5.5,N'Buổi đầu còn bỡ ngỡ với cách viết nghị luận.'),
('K136B11','LH016_11','HV136',N'Có mặt',N'Thiếu',5.0,N'Chữ viết rối, sai lỗi chính tả nhiều.'),
('K136B12','LH016_12','HV136',N'Có mặt',N'Đầy đủ',6.0,N'Nắm được tình huống truyện Chữ người tử tù.'),
('K136B13','LH016_13','HV136',N'Có mặt',N'Đầy đủ',6.5,N'Phân tích nhân vật Huấn Cao khá ổn.'),
('K136B14','LH016_14','HV136',N'Vắng mặt',N'Không làm',0.0,N'Nghỉ học có phép.'),
('K136B15','LH016_15','HV136',N'Có mặt',N'Đầy đủ',5.5,N'Cảm thụ thơ Đây thôn Vĩ Dạ còn mờ nhạt.'),
('K136B16','LH016_16','HV136',N'Có mặt',N'Thiếu',5.0,N'Vốn từ vựng để diễn đạt còn yếu.'),
('K136B17','LH016_17','HV136',N'Có mặt',N'Đầy đủ',6.0,N'Đã có ý thức làm bài tập đầy đủ.'),
('K136B18','LH016_18','HV136',N'Có mặt',N'Đầy đủ',5.5,N'Mở bài vòng vo, mất nhiều thời gian.'),
('K136B19','LH016_19','HV136',N'Vắng mặt',N'Không làm',0.0,N'Nghỉ ốm.'),
('K136B20','LH016_20','HV136',N'Có mặt',N'Thiếu',6.0,N'Nắm được ý nghĩa hình ảnh con thuyền trong Tràng Giang.'),
('K136B21','LH016_21','HV136',N'Có mặt',N'Đầy đủ',5.0,N'Khả năng cảm thụ văn học cần phải rèn luyện nhiều hơn.'),
('K136B22','LH016_22','HV136',N'Có mặt',N'Đầy đủ',6.5,N'Đã chịu khó đọc trước tác phẩm ở nhà trước khi lên lớp.'),
('K136B23','LH016_23','HV136',N'Có mặt',N'Thiếu',5.5,N'Đoạn văn phân tích khổ 1 Đây thôn Vĩ Dạ còn lủng củng.'),
('K136B24','LH016_24','HV136',N'Có mặt',N'Đầy đủ',6.0,N'Biết tìm ra các biện pháp tu từ trong bài nhưng chưa gọi đúng tên.'),
('K136B25','LH016_25','HV136',N'Có mặt',N'Đầy đủ',5.0,N'Sai kiến thức cơ bản về hoàn cảnh sáng tác của tác phẩm.'),
('K136B26','LH016_26','HV136',N'Vắng mặt',N'Không làm',0.0,N'Vắng học không phép.'),
('K136B27','LH016_27','HV136',N'Có mặt',N'Đầy đủ',6.5,N'Bài nghị luận xã hội về tuổi trẻ viết rất cảm xúc.'),
('K136B28','LH016_28','HV136',N'Có mặt',N'Đầy đủ',5.5,N'Kết bài cụt ngủn, chưa tóm lại được vấn đề nghị luận.'),
('K136B29','LH016_29','HV136',N'Có mặt',N'Thiếu',6.0,N'Đã biết phân chia hệ thống luận điểm rõ ràng hơn trước.'),
('K136B30','LH016_30','HV136',N'Có mặt',N'Đầy đủ',5.5,N'Ôn tập lý thuyết còn chậm, lười học thuộc dẫn chứng.'),
('K136B31','LH016_31','HV136',N'Có mặt',N'Đầy đủ',6.5,N'Hoàn thành bài thi thử với kết quả khả quan.'),
('K136B32','LH016_32','HV136',N'Có mặt',N'Đầy đủ',6.0,N'Có kỹ năng làm bài trắc nghiệm đọc hiểu tốt.'),
('K136B33','LH016_33','HV136',N'Có mặt',N'Đầy đủ',6.0,N'Cố gắng bám sát chương trình dù vào muộn.');

-- 3. HV160 (Đăng ký 11/02/2026 -> Nghỉ Tết -> Bắt đầu từ Buổi 13 ngày 27/02/2026)
-- Tổng số buổi: 21 buổi
INSERT INTO KQ_HOC_TAP (MaKQHT, MaBuoiHoc, MaHocVien, DiemDanh, BTVN, DiemSo, NhanXet) VALUES 
('K160B13','LH016_13','HV160',N'Có mặt',N'Đầy đủ',6.0,N'Vào sau Tết, bắt nhịp khá nhanh.'),
('K160B14','LH016_14','HV160',N'Có mặt',N'Thiếu',5.5,N'Chưa quen với cấu trúc bài luận văn học.'),
('K160B15','LH016_15','HV160',N'Có mặt',N'Đầy đủ',6.5,N'Phân tích chi tiết nghệ thuật khá nhạy bén.'),
('K160B16','LH016_16','HV160',N'Có mặt',N'Đầy đủ',6.0,N'Hiểu cốt truyện nhưng thiếu cảm xúc văn chương.'),
('K160B17','LH016_17','HV160',N'Vắng mặt',N'Không làm',0.0,N'Vắng không phép.'),
('K160B18','LH016_18','HV160',N'Có mặt',N'Đầy đủ',5.0,N'Làm bài kiểm tra lan man, không đúng trọng tâm.'),
('K160B19','LH016_19','HV160',N'Có mặt',N'Đầy đủ',5.5,N'Cần rèn luyện cách triển khai luận điểm.'),
('K160B20','LH016_20','HV160',N'Có mặt',N'Thiếu',6.0,N'Chú ý nghe giảng nhưng ít khi giơ tay phát biểu.'),
('K160B21','LH016_21','HV160',N'Vắng mặt',N'Không làm', 0.0,N'Nghỉ học có phép.'),
('K160B22','LH016_22','HV160',N'Có mặt',N'Đầy đủ',5.5,N'Cảm thụ bài Đây thôn Vĩ Dạ chưa thực sự sâu sắc.'),
('K160B23','LH016_23','HV160',N'Có mặt',N'Đầy đủ',6.5,N'Hiểu được nỗi cô đơn của nhân vật trữ tình trong bài thơ.'),
('K160B24','LH016_24','HV160',N'Có mặt',N'Thiếu',5.0,N'Bài viết bôi xóa nhiều, trình bày cẩu thả.'),
('K160B25','LH016_25','HV160',N'Có mặt',N'Đầy đủ',6.0,N'Có ý thức sửa chữa lỗi chính tả sau khi được giáo viên nhắc nhở.'),
('K160B26','LH016_26','HV160',N'Có mặt',N'Đầy đủ',5.5,N'Phân tích bài Từ ấy mới chỉ dừng lại ở mức diễn xuôi.'),
('K160B27','LH016_27','HV160',N'Có mặt',N'Đầy đủ',6.5,N'Phần liên hệ bản thân khá tự nhiên và mang tính thuyết phục.'),
('K160B28','LH016_28','HV160',N'Vắng mặt',N'Không làm',0.0,N'Nghỉ ốm.'),
('K160B29','LH016_29','HV160',N'Có mặt',N'Thiếu',5.0,N'Đoạn văn còn mắc nhiều lỗi viết câu cụt, câu què.'),
('K160B30','LH016_30','HV160',N'Có mặt',N'Đầy đủ',6.0,N'Ghi chép bài ôn tập cuối kỳ đầy đủ, hệ thống rõ ràng.'),
('K160B31','LH016_31','HV160',N'Có mặt',N'Đầy đủ',5.5,N'Làm bài kiểm tra còn để trống phần kết bài do thiếu thời gian.'),
('K160B32','LH016_32','HV160',N'Có mặt',N'Đầy đủ',6.5,N'Vận dụng tốt các thao tác lập luận giải thích và chứng minh.'),
('K160B33','LH016_33','HV160',N'Có mặt',N'Đầy đủ',6.5,N'Thái độ học tập tốt, đã bù đắp được phần kiến thức bị hổng.');

--4. HV184 (HOÀNG QUỐC VƯỢNG) (Bắt đầu học từ Buổi 19 (20/03/2026). Tổng số buổi: 15 buổi.)
INSERT INTO KQ_HOC_TAP (MaKQHT, MaBuoiHoc, MaHocVien, DiemDanh, BTVN, DiemSo, NhanXet) VALUES 
('K184B19', 'LH016_19', 'HV184', N'Có mặt', N'Đầy đủ', 5.5, N'Buổi đầu hòa nhập tốt, nhưng bắt nhịp phân tích thơ còn chậm.'),
('K184B20', 'LH016_20', 'HV184', N'Có mặt', N'Đầy đủ', 6.0, N'Đã làm quen được với cấu trúc bài văn nghị luận xã hội.'),
('K184B21', 'LH016_21', 'HV184', N'Có mặt', N'Thiếu', 5.0, N'Cảm thụ tác phẩm Vội Vàng còn mờ nhạt, thiếu cảm xúc.'),
('K184B22', 'LH016_22', 'HV184', N'Vắng mặt', N'Không làm', 0.0, N'Nghỉ học có báo trước với trung tâm.'),
('K184B23', 'LH016_23', 'HV184', N'Có mặt', N'Đầy đủ', 6.5, N'Phân tích chi tiết bát cháo hành khá đầy đủ và rõ ý.'),
('K184B24', 'LH016_24', 'HV184', N'Có mặt', N'Đầy đủ', 5.5, N'Thiếu dẫn chứng thực tế khi làm bài trên lớp.'),
('K184B25', 'LH016_25', 'HV184', N'Có mặt', N'Thiếu', 6.0, N'Biết cách mở bài gián tiếp nhưng hành văn còn lủng củng.'),
('K184B26', 'LH016_26', 'HV184', N'Có mặt', N'Đầy đủ', 5.0, N'Viết sai chính tả và dùng từ sai ngữ cảnh khá nhiều.'),
('K184B27', 'LH016_27', 'HV184', N'Có mặt', N'Đầy đủ', 6.5, N'Nắm bắt được giá trị nhân đạo cốt lõi của tác phẩm.'),
('K184B28', 'LH016_28', 'HV184', N'Vắng mặt', N'Không làm', 0.0, N'Vắng mặt không phép.'),
('K184B29', 'LH016_29', 'HV184', N'Có mặt', N'Đầy đủ', 5.5, N'Cần rèn luyện thêm cách phân đoạn trong bài văn dài.'),
('K184B30', 'LH016_30', 'HV184', N'Có mặt', N'Đầy đủ', 6.0, N'Ôn tập lý thuyết cuối kỳ ở mức cơ bản, cần thực hành thêm.'),
('K184B31', 'LH016_31', 'HV184', N'Có mặt', N'Thiếu', 6.0, N'Trình bày bài kiểm tra sạch sẽ, chữ viết gọn gàng.'),
('K184B32', 'LH016_32', 'HV184', N'Có mặt', N'Đầy đủ', 5.5, N'Lý lẽ phân tích chưa sâu, còn mang văn nói vào bài viết.'),
('K184B33', 'LH016_33', 'HV184', N'Có mặt', N'Đầy đủ', 6.5, N'Kết thúc khóa học ở mức trung bình khá, có cố gắng.');



-- ĐỔ DỮ LIỆU KQ_HOC_TAP LỚP LH008 (MÔN NGỮ VĂN 8) - HỌC LỰC: KHÁ (6.5 - 8.5)
-- NHÓM 1: HỌC TỪ ĐẦU (BUỔI 1: 05/01/2026 -> BUỔI 34: 13/05/2026)
-- 1. HV015 (Trần Tuấn Phát) --> Đủ 34 buổi
INSERT INTO KQ_HOC_TAP (MaKQHT, MaBuoiHoc, MaHocVien, DiemDanh, BTVN, DiemSo, NhanXet) VALUES 
('K015B01', 'LH008_01', 'HV015', N'Có mặt', N'Đầy đủ', 7.5, N'Cảm nhận tốt tâm trạng nhân vật trong "Tôi đi học".'),
('K015B02', 'LH008_02', 'HV015', N'Có mặt', N'Đầy đủ', 8.0, N'Hiểu được tình mẫu tử thiêng liêng qua đoạn trích "Trong lòng mẹ".'),
('K015B03', 'LH008_03', 'HV015', N'Có mặt', N'Thiếu', 6.5, N'Nắm được cốt truyện nhưng lười viết bài tập về nhà.'),
('K015B04', 'LH008_04', 'HV015', N'Vắng mặt', N'Không làm', 0.0, N'Nghỉ học có phép (việc gia đình).'),
('K015B05', 'LH008_05', 'HV015', N'Có mặt', N'Đầy đủ', 7.5, N'Phân tích được sức sống tiềm tàng của chị Dậu.'),
('K015B06', 'LH008_06', 'HV015', N'Có mặt', N'Đầy đủ', 8.0, N'Đánh giá đúng bản chất của tầng lớp thống trị.'),
('K015B07', 'LH008_07', 'HV015', N'Có mặt', N'Đầy đủ', 7.0, N'Cảm thụ nhân vật Lão Hạc khá tốt, nhưng diễn đạt chưa mượt.'),
('K015B08', 'LH008_08', 'HV015', N'Có mặt', N'Đầy đủ', 8.5, N'Bài viết có chiều sâu, hiểu được bi kịch của người nông dân.'),
('K015B09', 'LH008_09', 'HV015', N'Có mặt', N'Đầy đủ', 7.5, N'Đọc hiểu văn bản "Cô bé bán diêm" tốt, nêu được ý nghĩa.'),
('K015B10', 'LH008_10', 'HV015', N'Có mặt', N'Thiếu', 6.5, N'Phân tích hai nhân vật Đôn Ki-hô-tê và Xan-chô Pan-xa còn sơ sài.'),
('K015B11', 'LH008_11', 'HV015', N'Có mặt', N'Đầy đủ', 8.0, N'Làm rõ được nghệ thuật đảo ngược tình huống truyện.'),
('K015B12', 'LH008_12', 'HV015', N'Có mặt', N'Đầy đủ', 7.5, N'Hiểu giá trị nhân văn trong "Chiếc lá cuối cùng".'),
('K015B13', 'LH008_13', 'HV015', N'Có mặt', N'Đầy đủ', 8.0, N'Biết cách phân tích hình ảnh biểu tượng Hai cây phong.'),
('K015B14', 'LH008_14', 'HV015', N'Có mặt', N'Đầy đủ', 7.0, N'Nắm được đặc điểm của thể loại văn bản thông tin.'),
('K015B15', 'LH008_15', 'HV015', N'Vắng mặt', N'Không làm',0.0, N'Nghỉ học do ốm.'),
('K015B16', 'LH008_16', 'HV015', N'Có mặt', N'Đầy đủ', 7.5, N'Bước đầu cảm nhận được khí phách của Phan Bội Châu.'),
('K015B17', 'LH008_17', 'HV015', N'Có mặt', N'Đầy đủ', 8.0, N'Phân tích khẩu khí anh hùng trong "Đập đá ở Côn Lôn" rất hay.'),
('K015B18', 'LH008_18', 'HV015', N'Có mặt', N'Đầy đủ', 7.5, N'Thấy được niềm khao khát tự do qua bài thơ "Nhớ rừng".'),
('K015B19', 'LH008_19', 'HV015', N'Có mặt', N'Thiếu', 6.5, N'Chưa chú ý đến các biện pháp tu từ trong bài thơ.'),
('K015B20', 'LH008_20', 'HV015', N'Có mặt', N'Đầy đủ', 8.5, N'Phân tích cảnh ra khơi trong "Quê hương" rất sinh động.'),
('K015B21', 'LH008_21', 'HV015', N'Có mặt', N'Đầy đủ', 7.5, N'Nắm được tâm trạng ngột ngạt của Tố Hữu trong "Khi con tu hú".'),
('K015B22', 'LH008_22', 'HV015', N'Có mặt', N'Đầy đủ', 8.0, N'Hiểu được phong thái ung dung của Bác qua thơ.'),
('K015B23', 'LH008_23', 'HV015', N'Vắng mặt', N'Không làm', 0.0, N'Nghỉ học không phép.'),
('K015B24', 'LH008_24', 'HV015', N'Có mặt', N'Đầy đủ', 7.0, N'Còn lúng túng khi tiếp cận thể cáo, hịch.'),
('K015B25', 'LH008_25', 'HV015', N'Có mặt', N'Đầy đủ', 8.0, N'Phân tích "Chiếu dời đô" lập luận chặt chẽ.'),
('K015B26', 'LH008_26', 'HV015', N'Có mặt', N'Đầy đủ', 7.5, N'Hiểu được tinh thần yêu nước trong "Hịch tướng sĩ".'),
('K015B27', 'LH008_27', 'HV015', N'Có mặt', N'Thiếu', 6.5, N'Làm bài tự luận thiếu phần liên hệ thực tế.'),
('K015B28', 'LH008_28', 'HV015', N'Có mặt', N'Đầy đủ', 8.5, N'Khái quát tốt tư tưởng nhân nghĩa trong "Nước Đại Việt ta".'),
('K015B29', 'LH008_29', 'HV015', N'Có mặt', N'Đầy đủ', 8.0, N'Nghị luận sắc bén, luận điểm rõ ràng.'),
('K015B30', 'LH008_30', 'HV015', N'Có mặt', N'Đầy đủ', 7.5, N'Biết vận dụng các thao tác lập luận vào bài viết.'),
('K015B31', 'LH008_31', 'HV015', N'Có mặt', N'Đầy đủ', 7.0, N'Nắm vững kiến thức tiếng Việt học kì 2.'),
('K015B32', 'LH008_32', 'HV015', N'Có mặt', N'Đầy đủ', 8.0, N'Làm bài thi thử phân bổ thời gian hợp lý.'),
('K015B33', 'LH008_33', 'HV015', N'Có mặt', N'Đầy đủ', 7.5, N'Phần tập làm văn cấu trúc tốt, rõ 3 phần.'),
('K015B34', 'LH008_34', 'HV015', N'Có mặt', N'Đầy đủ', 8.5, N'Tổng kết khóa học xuất sắc, đạt chuẩn học sinh khá.');

-- 2. HV035 (Hoàng Đình Trọng) --> Học từ Buổi 1 (05/01/2026)
-- Tổng số buổi: 34

INSERT INTO KQ_HOC_TAP (MaKQHT, MaBuoiHoc, MaHocVien, DiemDanh, BTVN, DiemSo, NhanXet) VALUES 
('K035B01', 'LH008_01', 'HV035', N'Có mặt', N'Đầy đủ', 7.0, N'Hiểu được tâm trạng náo nức của nhân vật "tôi" trong ngày tựu trường.'),
('K035B02', 'LH008_02', 'HV035', N'Có mặt', N'Đầy đủ', 7.5, N'Phân tích sự tàn ác của bà cô trong đoạn trích "Trong lòng mẹ" khá tốt.'),
('K035B03', 'LH008_03', 'HV035', N'Có mặt', N'Thiếu', 6.5, N'Chưa hiểu rõ sức phản kháng mãnh liệt của chị Dậu.'),
('K035B04', 'LH008_04', 'HV035', N'Vắng mặt', N'Không làm', 0.0, N'Nghỉ học có báo phụ huynh.'),
('K035B05', 'LH008_05', 'HV035', N'Có mặt', N'Đầy đủ', 8.0, N'Cảm nhận được nhân cách cao đẹp của Lão Hạc qua cái chết dữ dội.'),
('K035B06', 'LH008_06', 'HV035', N'Có mặt', N'Đầy đủ', 7.5, N'Diễn đạt còn lặp từ khi phân tích tình cảnh nghèo đói của người nông dân.'),
('K035B07', 'LH008_07', 'HV035', N'Có mặt', N'Đầy đủ', 8.5, N'Hiểu được ý nghĩa nhân đạo sâu sắc trong "Cô bé bán diêm".'),
('K035B08', 'LH008_08', 'HV035', N'Có mặt', N'Thiếu', 7.0, N'Phân tích sự đối lập giữa Đôn Ki-hô-tê và Xan-chô Pan-xa còn chung chung.'),
('K035B09', 'LH008_09', 'HV035', N'Có mặt', N'Đầy đủ', 8.0, N'Thấy được sức mạnh của tình yêu thương qua "Chiếc lá cuối cùng".'),
('K035B10', 'LH008_10', 'HV035', N'Có mặt', N'Đầy đủ', 7.5, N'Nắm vững khái niệm về các loại từ ngữ địa phương và biệt ngữ xã hội.'),
('K035B11', 'LH008_11', 'HV035', N'Vắng mặt', N'Không làm', 0.0, N'Vắng học không phép.'),
('K035B12', 'LH008_12', 'HV035', N'Có mặt', N'Đầy đủ', 7.0, N'Tóm tắt "Hai cây phong" còn bỏ sót một vài chi tiết quan trọng.'),
('K035B13', 'LH008_13', 'HV035', N'Có mặt', N'Đầy đủ', 8.5, N'Làm bài nghị luận về tác hại của thuốc lá rất thuyết phục.'),
('K035B14', 'LH008_14', 'HV035', N'Có mặt', N'Đầy đủ', 7.5, N'Hiểu được thông điệp bảo vệ môi trường trong "Thông tin về Ngày Trái Đất".'),
('K035B15', 'LH008_15', 'HV035', N'Có mặt', N'Thiếu', 6.5, N'Lập luận trong bài văn thuyết minh còn yếu, thiếu số liệu.'),
('K035B16', 'LH008_16', 'HV035', N'Có mặt', N'Đầy đủ', 8.0, N'Phân tích khí phách người anh hùng trong "Đập đá ở Côn Lôn" rất hùng hồn.'),
('K035B17', 'LH008_17', 'HV035', N'Có mặt', N'Đầy đủ', 7.5, N'Cảm nhận được nỗi nhớ rừng da diết của chúa sơn lâm.'),
('K035B18', 'LH008_18', 'HV035', N'Có mặt', N'Đầy đủ', 8.5, N'Thương cảm sâu sắc trước sự suy tàn của Nho học qua bài "Ông đồ".'),
('K035B19', 'LH008_19', 'HV035', N'Vắng mặt', N'Không làm', 0.0, N'Nghỉ học do ốm.'),
('K035B20', 'LH008_20', 'HV035', N'Có mặt', N'Đầy đủ', 7.0, N'Phân tích bức tranh lao động trong "Quê hương" còn hời hợt.'),
('K035B21', 'LH008_21', 'HV035', N'Có mặt', N'Đầy đủ', 8.0, N'Thấy được tình yêu thiên nhiên và phong thái ung dung của Bác trong thơ.'),
('K035B22', 'LH008_22', 'HV035', N'Có mặt', N'Thiếu', 7.5, N'Chưa thuộc lòng bài thơ "Ngắm trăng" phần phiên âm.'),
('K035B23', 'LH008_23', 'HV035', N'Có mặt', N'Đầy đủ', 8.5, N'Hiểu ý nghĩa triết lý sâu xa trong bài thơ "Đi đường".'),
('K035B24', 'LH008_24', 'HV035', N'Có mặt', N'Đầy đủ', 7.5, N'Nắm vững đặc điểm của các kiểu câu trần thuật, nghi vấn.'),
('K035B25', 'LH008_25', 'HV035', N'Có mặt', N'Đầy đủ', 8.0, N'Phân tích tầm nhìn chiến lược của Lý Công Uẩn qua "Chiếu dời đô".'),
('K035B26', 'LH008_26', 'HV035', N'Có mặt', N'Đầy đủ', 7.0, N'Giọng văn phân tích "Hịch tướng sĩ" chưa đủ độ sắc sảo.'),
('K035B27', 'LH008_27', 'HV035', N'Vắng mặt', N'Không làm', 0.0, N'Nghỉ học việc gia đình.'),
('K035B28', 'LH008_28', 'HV035', N'Có mặt', N'Thiếu', 6.5, N'Chưa nhận thức đầy đủ về quan niệm quốc gia độc lập của Nguyễn Trãi.'),
('K035B29', 'LH008_29', 'HV035', N'Có mặt', N'Đầy đủ', 8.0, N'Đồng tình với phương pháp học tập đúng đắn trong "Bàn luận về phép học".'),
('K035B30', 'LH008_30', 'HV035', N'Có mặt', N'Đầy đủ', 8.5, N'Viết đoạn văn chứng minh tội ác của thực dân Pháp trong "Thuế máu" rất hay.'),
('K035B31', 'LH008_31', 'HV035', N'Có mặt', N'Đầy đủ', 7.5, N'Củng cố tốt kiến thức phần Hội thoại trong Tiếng Việt.'),
('K035B32', 'LH008_32', 'HV035', N'Có mặt', N'Đầy đủ', 8.0, N'Hoàn thành bài thi thử đúng thời gian, cấu trúc tốt.'),
('K035B33', 'LH008_33', 'HV035', N'Có mặt', N'Đầy đủ', 7.5, N'Phần nghị luận văn học cần luyện cách triển khai ý logic hơn.'),
('K035B34', 'LH008_34', 'HV035', N'Có mặt', N'Đầy đủ', 8.0, N'Hành trình học tập có nhiều cố gắng, vững kiến thức nền.');


-- 2. HV051 (Nguyễn Quang Lâm) --> Học từ Buổi 1 (05/01/2026)
-- Tổng số buổi: 34
INSERT INTO KQ_HOC_TAP (MaKQHT, MaBuoiHoc, MaHocVien, DiemDanh, BTVN, DiemSo, NhanXet) VALUES 
('K051B01', 'LH008_01', 'HV051', N'Có mặt', N'Đầy đủ', 7.5, N'Chú ý nghe giảng, tiếp thu tốt các hình ảnh so sánh trong "Tôi đi học".'),
('K051B02', 'LH008_02', 'HV051', N'Vắng mặt', N'Không làm', 0.0, N'Nghỉ học có báo phép.'),
('K051B03', 'LH008_03', 'HV051', N'Có mặt', N'Thiếu', 6.5, N'Thiếu kỹ năng tóm tắt truyện "Tức nước vỡ bờ".'),
('K051B04', 'LH008_04', 'HV051', N'Có mặt', N'Đầy đủ', 8.0, N'Hiểu sâu sắc tình cảnh khốn cùng của Lão Hạc.'),
('K051B05', 'LH008_05', 'HV051', N'Có mặt', N'Đầy đủ', 7.0, N'Chữ viết đôi chỗ khó nhìn, cần nắn nót hơn.'),
('K051B06', 'LH008_06', 'HV051', N'Có mặt', N'Đầy đủ', 8.5, N'Có sự nhạy cảm văn học khi phân tích ảo ảnh của cô bé bán diêm.'),
('K051B07', 'LH008_07', 'HV051', N'Có mặt', N'Đầy đủ', 7.5, N'Bài văn kể chuyện kết hợp miêu tả và biểu cảm khá mượt mà.'),
('K051B08', 'LH008_08', 'HV051', N'Có mặt', N'Thiếu', 7.0, N'Phân tích sự khác biệt giữa hai nhân vật Đôn Ki-hô-tê chưa đủ ý.'),
('K051B09', 'LH008_09', 'HV051', N'Có mặt', N'Đầy đủ', 8.0, N'Chỉ ra được ý nghĩa biểu tượng của kiệt tác chiếc lá cuối cùng.'),
('K051B10', 'LH008_10', 'HV051', N'Có mặt', N'Đầy đủ', 7.5, N'Nhận diện tốt các biện pháp tu từ trong văn bản.'),
('K051B11', 'LH008_11', 'HV051', N'Có mặt', N'Đầy đủ', 8.5, N'Tóm tắt "Hai cây phong" ngắn gọn, đủ chi tiết trọng tâm.'),
('K051B12', 'LH008_12', 'HV051', N'Vắng mặt', N'Không làm', 0.0, N'Vắng mặt không có lý do.'),
('K051B13', 'LH008_13', 'HV051', N'Có mặt', N'Đầy đủ', 7.0, N'Hiểu bài nhưng diễn đạt về "Bài toán dân số" còn hơi khô khan.'),
('K051B14', 'LH008_14', 'HV051', N'Có mặt', N'Đầy đủ', 7.5, N'Biết cách lập dàn ý cho một bài văn thuyết minh sự vật.'),
('K051B15', 'LH008_15', 'HV051', N'Có mặt', N'Thiếu', 6.5, N'Còn nhầm lẫn giữa văn thuyết minh và văn tự sự.'),
('K051B16', 'LH008_16', 'HV051', N'Có mặt', N'Đầy đủ', 8.0, N'Cảm nhận tốt khẩu khí ngang tàng trong thơ Phan Bội Châu.'),
('K051B17', 'LH008_17', 'HV051', N'Có mặt', N'Đầy đủ', 8.5, N'Phân tích nỗi đau mất tự do trong "Nhớ rừng" rất sắc sảo.'),
('K051B18', 'LH008_18', 'HV051', N'Có mặt', N'Đầy đủ', 7.5, N'Nắm được giá trị biểu cảm của bài thơ "Ông đồ".'),
('K051B19', 'LH008_19', 'HV051', N'Có mặt', N'Đầy đủ', 8.0, N'Đã thuộc thơ và biết dẫn chứng khi phân tích bài "Quê hương".'),
('K051B20', 'LH008_20', 'HV051', N'Vắng mặt', N'Không làm', 0.0, N'Nghỉ ốm.'),
('K051B21', 'LH008_21', 'HV051', N'Có mặt', N'Thiếu', 7.0, N'Chưa hiểu trọn vẹn chất thép và chất tình trong thơ Hồ Chí Minh.'),
('K051B22', 'LH008_22', 'HV051', N'Có mặt', N'Đầy đủ', 7.5, N'Phân tích bài "Ngắm trăng" cần mở rộng thêm về hoàn cảnh sáng tác.'),
('K051B23', 'LH008_23', 'HV051', N'Có mặt', N'Đầy đủ', 8.0, N'Viết đoạn văn nghị luận về tinh thần vượt khó rất hay.'),
('K051B24', 'LH008_24', 'HV051', N'Có mặt', N'Đầy đủ', 7.5, N'Sử dụng các kiểu câu cầu khiến, cảm thán linh hoạt.'),
('K051B25', 'LH008_25', 'HV051', N'Có mặt', N'Đầy đủ', 8.5, N'Hiểu được khát vọng độc lập, tự cường qua "Chiếu dời đô".'),
('K051B26', 'LH008_26', 'HV051', N'Có mặt', N'Thiếu', 6.5, N'Bài phân tích "Hịch tướng sĩ" thiếu tính chiến đấu trong giọng văn.'),
('K051B27', 'LH008_27', 'HV051', N'Có mặt', N'Đầy đủ', 8.0, N'Cảm thụ tốt tư tưởng nhân nghĩa của Nguyễn Trãi.'),
('K051B28', 'LH008_28', 'HV051', N'Có mặt', N'Đầy đủ', 7.5, N'Liên hệ thực tế bản thân ở phần kết bài khá tự nhiên.'),
('K051B29', 'LH008_29', 'HV051', N'Vắng mặt', N'Không làm', 0.0, N'Nghỉ học có báo trước.'),
('K051B30', 'LH008_30', 'HV051', N'Có mặt', N'Đầy đủ', 8.0, N'Bóc trần được nghệ thuật trào phúng trong "Thuế máu".'),
('K051B31', 'LH008_31', 'HV051', N'Có mặt', N'Đầy đủ', 7.5, N'Nắm vững các phép tu từ nói quá, nói giảm nói tránh.'),
('K051B32', 'LH008_32', 'HV051', N'Có mặt', N'Đầy đủ', 8.0, N'Hoàn thành bài kiểm tra cuối khóa với kiến thức chắc chắn.'),
('K051B33', 'LH008_33', 'HV051', N'Có mặt', N'Thiếu', 7.0, N'Cần ôn lại cách làm văn nghị luận chứng minh.'),
('K051B34', 'LH008_34', 'HV051', N'Có mặt', N'Đầy đủ', 8.5, N'Kỹ năng viết luận văn học đã tiến bộ rõ rệt.');


-- 3. HV067 (Trần Thu Hảo) - -> Học từ Buổi 1 (05/01/2026)
-- Tổng số buổi: 34
INSERT INTO KQ_HOC_TAP (MaKQHT, MaBuoiHoc, MaHocVien, DiemDanh, BTVN, DiemSo, NhanXet) VALUES 
('K067B01', 'LH008_01', 'HV067', N'Có mặt', N'Đầy đủ', 8.0, N'Hòa nhập tốt, nắm bắt nhanh cảm xúc trong "Tôi đi học".'),
('K067B02', 'LH008_02', 'HV067', N'Có mặt', N'Đầy đủ', 7.5, N'Bài tập về nhà làm chu đáo, trả lời đúng trọng tâm.'),
('K067B03', 'LH008_03', 'HV067', N'Có mặt', N'Đầy đủ', 8.5, N'Phân tích diễn biến tâm lý của chị Dậu rất lô-gic và chi tiết.'),
('K067B04', 'LH008_04', 'HV067', N'Vắng mặt', N'Không làm', 0.0, N'Vắng học không phép.'),
('K067B05', 'LH008_05', 'HV067', N'Có mặt', N'Đầy đủ', 7.0, N'Hiểu tác phẩm nhưng diễn đạt còn khô khan, thiếu cảm xúc.'),
('K067B06', 'LH008_06', 'HV067', N'Có mặt', N'Thiếu', 6.5, N'Chưa chuẩn bị kỹ bài viết về đoạn trích Lão Hạc.'),
('K067B07', 'LH008_07', 'HV067', N'Có mặt', N'Đầy đủ', 8.0, N'Cảm nhận tốt sự đối lập giữa thực tế và mộng tưởng của cô bé bán diêm.'),
('K067B08', 'LH008_08', 'HV067', N'Có mặt', N'Đầy đủ', 7.5, N'Văn phong nghị luận khá chặt chẽ, luận cứ rõ ràng.'),
('K067B09', 'LH008_09', 'HV067', N'Có mặt', N'Đầy đủ', 8.5, N'Chỉ ra được ý nghĩa nhân văn của bức tranh chiếc lá cuối cùng.'),
('K067B10', 'LH008_10', 'HV067', N'Có mặt', N'Thiếu', 7.0, N'Nắm vững lý thuyết trường từ vựng nhưng áp dụng thực hành chậm.'),
('K067B11', 'LH008_11', 'HV067', N'Có mặt', N'Đầy đủ', 8.0, N'Hiểu được mạch cảm xúc của người kể chuyện trong "Hai cây phong".'),
('K067B12', 'LH008_12', 'HV067', N'Vắng mặt', N'Không làm', 0.0, N'Nghỉ học có xin phép.'),
('K067B13', 'LH008_13', 'HV067', N'Có mặt', N'Đầy đủ', 7.5, N'Thấy rõ được tác hại của việc gia tăng dân số qua bài học.'),
('K067B14', 'LH008_14', 'HV067', N'Có mặt', N'Đầy đủ', 8.0, N'Bài viết văn thuyết minh trình bày khoa học, hệ thống tốt.'),
('K067B15', 'LH008_15', 'HV067', N'Có mặt', N'Thiếu', 6.5, N'Cần chú ý bổ sung yếu tố miêu tả vào bài văn thuyết minh.'),
('K067B16', 'LH008_16', 'HV067', N'Có mặt', N'Đầy đủ', 8.5, N'Phân tích thơ trung đại rất tốt, hiểu được bối cảnh lịch sử.'),
('K067B17', 'LH008_17', 'HV067', N'Có mặt', N'Đầy đủ', 7.5, N'Làm nổi bật được nghệ thuật tương phản trong bài "Nhớ rừng".'),
('K067B18', 'LH008_18', 'HV067', N'Có mặt', N'Đầy đủ', 8.0, N'Hiểu rõ sự mai một của nền học chữ Nho qua hình ảnh Ông đồ.'),
('K067B19', 'LH008_19', 'HV067', N'Vắng mặt', N'Không làm', 0.0, N'Nghỉ ốm.'),
('K067B20', 'LH008_20', 'HV067', N'Có mặt', N'Đầy đủ', 7.5, N'Chưa thấy được trọn vẹn tình yêu quê hương thiết tha của Tế Hanh.'),
('K067B21', 'LH008_21', 'HV067', N'Có mặt', N'Đầy đủ', 8.5, N'Phân tích phong thái ung dung, lạc quan của Bác Hồ rất hay.'),
('K067B22', 'LH008_22', 'HV067', N'Có mặt', N'Thiếu', 7.0, N'Thuộc thơ nhưng chưa biết mở rộng liên hệ với các tác phẩm khác.'),
('K067B23', 'LH008_23', 'HV067', N'Có mặt', N'Đầy đủ', 8.0, N'Nắm vững ý nghĩa biểu tượng của bài "Đi đường".'),
('K067B24', 'LH008_24', 'HV067', N'Có mặt', N'Đầy đủ', 7.5, N'Phân loại đúng các kiểu câu chia theo mục đích nói.'),
('K067B25', 'LH008_25', 'HV067', N'Có mặt', N'Đầy đủ', 8.5, N'Phân tích sức thuyết phục của nghệ thuật lập luận trong "Chiếu dời đô".'),
('K067B26', 'LH008_26', 'HV067', N'Có mặt', N'Đầy đủ', 8.0, N'Thể hiện được hào khí Đông A khi đọc và phân tích "Hịch tướng sĩ".'),
('K067B27', 'LH008_27', 'HV067', N'Có mặt', N'Thiếu', 6.5, N'Viết đoạn văn nghị luận chứng minh còn mắc lỗi lan man.'),
('K067B28', 'LH008_28', 'HV067', N'Có mặt', N'Đầy đủ', 7.5, N'Khái quát tốt giá trị nội dung của "Nước Đại Việt ta".'),
('K067B29', 'LH008_29', 'HV067', N'Vắng mặt', N'Không làm', 0.0, N'Nghỉ việc gia đình.'),
('K067B30', 'LH008_30', 'HV067', N'Có mặt', N'Đầy đủ', 8.0, N'Phân tích sự mỉa mai, châm biếm trong văn bản "Thuế máu".'),
('K067B31', 'LH008_31', 'HV067', N'Có mặt', N'Đầy đủ', 7.5, N'Ôn tập tốt phần tiếng Việt, làm bài tập ứng dụng đạt điểm cao.'),
('K067B32', 'LH008_32', 'HV067', N'Có mặt', N'Đầy đủ', 8.5, N'Bài thi thử đạt kết quả tốt, đặc biệt ở phần đọc hiểu.'),
('K067B33', 'LH008_33', 'HV067', N'Có mặt', N'Đầy đủ', 8.0, N'Tự tin trong việc triển khai luận điểm làm văn.'),
('K067B34', 'LH008_34', 'HV067', N'Có mặt', N'Đầy đủ', 8.0, N'Hoàn thành xuất sắc chương trình Ngữ Văn 8.');

-- 4. HV083 (Nguyễn Quốc Việt) --> Học từ Buổi 1 (05/01/2026)
-- Tổng số buổi: 34
INSERT INTO KQ_HOC_TAP (MaKQHT, MaBuoiHoc, MaHocVien, DiemDanh, BTVN, DiemSo, NhanXet) VALUES 
('K083B01', 'LH008_01', 'HV083', N'Có mặt', N'Đầy đủ', 7.0, N'Hăng hái phát biểu nhưng câu trả lời chưa trúng trọng tâm.'),
('K083B02', 'LH008_02', 'HV083', N'Có mặt', N'Đầy đủ', 7.5, N'Hiểu được nỗi đau của bé Hồng nhưng phân tích nghệ thuật còn sơ sài.'),
('K083B03', 'LH008_03', 'HV083', N'Vắng mặt', N'Không làm', 0.0, N'Nghỉ ốm.'),
('K083B04', 'LH008_04', 'HV083', N'Có mặt', N'Thiếu', 6.5, N'Chữ viết rất ẩu, thiếu ý thức làm bài tập về nhà.'),
('K083B05', 'LH008_05', 'HV083', N'Có mặt', N'Đầy đủ', 8.0, N'Đã biết cách chia bố cục khi phân tích nhân vật Lão Hạc.'),
('K083B06', 'LH008_06', 'HV083', N'Có mặt', N'Đầy đủ', 7.5, N'Lập luận ổn nhưng dùng từ ngữ còn mang tính chất văn nói.'),
('K083B07', 'LH008_07', 'HV083', N'Có mặt', N'Đầy đủ', 8.5, N'Có sự thấu cảm sâu sắc khi viết về "Cô bé bán diêm".'),
('K083B08', 'LH008_08', 'HV083', N'Có mặt', N'Đầy đủ', 8.0, N'Phân tích nhân vật phản diện khá sắc bén.'),
('K083B09', 'LH008_09', 'HV083', N'Có mặt', N'Thiếu', 7.0, N'Hiểu nội dung "Chiếc lá cuối cùng" nhưng tóm tắt quá dài dòng.'),
('K083B10', 'LH008_10', 'HV083', N'Vắng mặt', N'Không làm', 0.0, N'Nghỉ học có báo trước.'),
('K083B11', 'LH008_11', 'HV083', N'Có mặt', N'Đầy đủ', 7.5, N'Ghi chép bài đầy đủ, nhận diện được tình từ và thán từ.'),
('K083B12', 'LH008_12', 'HV083', N'Có mặt', N'Đầy đủ', 8.0, N'Bài văn biểu cảm về người thân có cảm xúc tự nhiên, chân thật.'),
('K083B13', 'LH008_13', 'HV083', N'Có mặt', N'Đầy đủ', 8.5, N'Nghị luận xã hội rất thực tế, đưa dẫn chứng phong phú.'),
('K083B14', 'LH008_14', 'HV083', N'Có mặt', N'Thiếu', 6.5, N'Thiếu sự rõ ràng trong việc xây dựng hệ thống luận điểm.'),
('K083B15', 'LH008_15', 'HV083', N'Có mặt', N'Đầy đủ', 7.5, N'Nắm vững phương pháp làm văn thuyết minh về một phương pháp.'),
('K083B16', 'LH008_16', 'HV083', N'Có mặt', N'Đầy đủ', 8.0, N'Cảm nhận được tinh thần xả thân vì nước trong thơ Phan Bội Châu.'),
('K083B17', 'LH008_17', 'HV083', N'Có mặt', N'Đầy đủ', 7.5, N'Làm rõ được bi kịch của chúa sơn lâm trong "Nhớ rừng".'),
('K083B18', 'LH008_18', 'HV083', N'Vắng mặt', N'Không làm', 0.0, N'Nghỉ việc gia đình.'),
('K083B19', 'LH008_19', 'HV083', N'Có mặt', N'Đầy đủ', 8.0, N'Biết cách phân tích hình ảnh thơ qua bài "Ông đồ".'),
('K083B20', 'LH008_20', 'HV083', N'Có mặt', N'Thiếu', 6.5, N'Cảm thụ thơ Tế Hanh chưa sâu, diễn đạt còn lủng củng.'),
('K083B21', 'LH008_21', 'HV083', N'Có mặt', N'Đầy đủ', 8.5, N'Có tiến bộ rõ rệt trong việc phân tích các tác phẩm của Bác Hồ.'),
('K083B22', 'LH008_22', 'HV083', N'Có mặt', N'Đầy đủ', 7.5, N'Thuộc lòng các bài thơ Đường luật, trả lời trắc nghiệm tốt.'),
('K083B23', 'LH008_23', 'HV083', N'Có mặt', N'Đầy đủ', 8.0, N'Viết đoạn văn chứng minh ý chí con người rất xuất sắc.'),
('K083B24', 'LH008_24', 'HV083', N'Có mặt', N'Thiếu', 7.0, N'Lỗi dùng từ sai ngữ cảnh trong bài tập tiếng Việt.'),
('K083B25', 'LH008_25', 'HV083', N'Có mặt', N'Đầy đủ', 8.5, N'Cảm nhận tốt giọng điệu trang trọng trong "Chiếu dời đô".'),
('K083B26', 'LH008_26', 'HV083', N'Có mặt', N'Đầy đủ', 8.0, N'Hành văn có sức thuyết phục khi phân tích "Hịch tướng sĩ".'),
('K083B27', 'LH008_27', 'HV083', N'Vắng mặt', N'Không làm', 0.0, N'Nghỉ ốm.'),
('K083B28', 'LH008_28', 'HV083', N'Có mặt', N'Đầy đủ', 7.5, N'Nắm được cốt lõi tư tưởng nhân nghĩa bảo vệ dân.'),
('K083B29', 'LH008_29', 'HV083', N'Có mặt', N'Thiếu', 6.5, N'Bỏ trống phần kết bài trong bài kiểm tra định kì.'),
('K083B30', 'LH008_30', 'HV083', N'Có mặt', N'Đầy đủ', 8.0, N'Học tập trung, nắm vững nghệ thuật trào phúng.'),
('K083B31', 'LH008_31', 'HV083', N'Có mặt', N'Đầy đủ', 7.5, N'Ôn tập tốt phần tiếng Việt, nắm chắc lý thuyết hội thoại.'),
('K083B32', 'LH008_32', 'HV083', N'Có mặt', N'Đầy đủ', 8.0, N'Bài thi thử làm phần đọc hiểu rất cẩn thận, chính xác.'),
('K083B33', 'LH008_33', 'HV083', N'Có mặt', N'Đầy đủ', 8.5, N'Tự tin trong cách hành văn, có tư duy phản biện.'),
('K083B34', 'LH008_34', 'HV083', N'Có mặt', N'Đầy đủ', 8.0, N'Khép lại khóa học với kết quả tốt, cần rèn thêm chữ viết.');

-- 5. HV099 (Đặng Thanh Thủy) - Đăng ký: 28/11/2025 -> Học từ Buổi 1 (05/01/2026)
-- Tổng số buổi: 34
INSERT INTO KQ_HOC_TAP (MaKQHT, MaBuoiHoc, MaHocVien, DiemDanh, BTVN, DiemSo, NhanXet) VALUES 
('K099B01', 'LH008_01', 'HV099', N'Có mặt', N'Đầy đủ', 8.0, N'Viết văn có cảm xúc, hiểu bài "Tôi đi học" sâu sắc.'),
('K099B02', 'LH008_02', 'HV099', N'Có mặt', N'Đầy đủ', 8.5, N'Phân tích tâm lý bé Hồng rất tinh tế, dùng từ chắt lọc.'),
('K099B03', 'LH008_03', 'HV099', N'Có mặt', N'Đầy đủ', 7.5, N'Tóm tắt "Tức nước vỡ bờ" tốt, thấy rõ sự phản kháng.'),
('K099B04', 'LH008_04', 'HV099', N'Có mặt', N'Thiếu', 7.0, N'Lười phát biểu trên lớp dù làm bài tập về nhà khá tốt.'),
('K099B05', 'LH008_05', 'HV099', N'Vắng mặt', N'Không làm', 0.0, N'Nghỉ học có báo phép.'),
('K099B06', 'LH008_06', 'HV099', N'Có mặt', N'Đầy đủ', 8.0, N'Thấy được vẻ đẹp nhân phẩm của Lão Hạc.'),
('K099B07', 'LH008_07', 'HV099', N'Có mặt', N'Đầy đủ', 8.5, N'Văn phong rất biểu cảm khi viết về "Cô bé bán diêm".'),
('K099B08', 'LH008_08', 'HV099', N'Có mặt', N'Đầy đủ', 7.5, N'Cảm nhận được sự hài hước và ý nghĩa trong truyện Đôn Ki-hô-tê.'),
('K099B09', 'LH008_09', 'HV099', N'Có mặt', N'Thiếu', 6.5, N'Chưa tập trung khi phân tích nghệ thuật đảo ngược tình huống.'),
('K099B10', 'LH008_10', 'HV099', N'Có mặt', N'Đầy đủ', 8.0, N'Hoàn thành xuất sắc các bài tập về từ tượng hình, tượng thanh.'),
('K099B11', 'LH008_11', 'HV099', N'Có mặt', N'Đầy đủ', 7.5, N'Hiểu được sự lãng mạn qua ngòi bút của Ai-tma-tốp.'),
('K099B12', 'LH008_12', 'HV099', N'Có mặt', N'Đầy đủ', 8.5, N'Sử dụng các biện pháp tu từ trong bài tự luận rất thành thạo.'),
('K099B13', 'LH008_13', 'HV099', N'Vắng mặt', N'Không làm', 0.0, N'Nghỉ ốm.'),
('K099B14', 'LH008_14', 'HV099', N'Có mặt', N'Đầy đủ', 7.0, N'Văn bản thuyết minh còn thiếu sự sinh động.'),
('K099B15', 'LH008_15', 'HV099', N'Có mặt', N'Thiếu', 6.5, N'Bố cục bài thuyết minh về di tích lịch sử chưa hợp lý.'),
('K099B16', 'LH008_16', 'HV099', N'Có mặt', N'Đầy đủ', 8.0, N'Hiểu được tâm thế của người chí sĩ yêu nước đầu thế kỷ XX.'),
('K099B17', 'LH008_17', 'HV099', N'Có mặt', N'Đầy đủ', 8.5, N'Phân tích nghệ thuật nhân hóa trong "Nhớ rừng" xuất sắc.'),
('K099B18', 'LH008_18', 'HV099', N'Có mặt', N'Đầy đủ', 7.5, N'Cảm nhận được nỗi ngậm ngùi của thi nhân trong bài "Ông đồ".'),
('K099B19', 'LH008_19', 'HV099', N'Vắng mặt', N'Không làm', 0.0, N'Vắng việc gia đình.'),
('K099B20', 'LH008_20', 'HV099', N'Có mặt', N'Đầy đủ', 8.0, N'Hiểu được giá trị biểu cảm của việc dùng từ láy trong "Quê hương".'),
('K099B21', 'LH008_21', 'HV099', N'Có mặt', N'Thiếu', 7.0, N'Chưa hiểu được hoàn cảnh sáng tác bài "Khi con tu hú".'),
('K099B22', 'LH008_22', 'HV099', N'Có mặt', N'Đầy đủ', 8.5, N'Phân tích bài "Ngắm trăng" làm nổi bật tâm hồn thi sĩ của Bác.'),
('K099B23', 'LH008_23', 'HV099', N'Có mặt', N'Đầy đủ', 8.0, N'Bài viết đoạn văn nghị luận có mở rộng và liên hệ sâu sắc.'),
('K099B24', 'LH008_24', 'HV099', N'Có mặt', N'Đầy đủ', 7.5, N'Xác định đúng hành động nói trong các ngữ liệu Tiếng Việt.'),
('K099B25', 'LH008_25', 'HV099', N'Có mặt', N'Thiếu', 6.5, N'Chưa nắm được cấu trúc của một bài Cáo hay Chiếu.'),
('K099B26', 'LH008_26', 'HV099', N'Có mặt', N'Đầy đủ', 8.0, N'Hiểu được tinh thần quyết chiến quyết thắng trong "Hịch tướng sĩ".'),
('K099B27', 'LH008_27', 'HV099', N'Có mặt', N'Đầy đủ', 8.5, N'Làm bài phân tích "Nước Đại Việt ta" với giọng điệu tự hào.'),
('K099B28', 'LH008_28', 'HV099', N'Vắng mặt', N'Không làm', 0.0, N'Nghỉ học có báo trước.'),
('K099B29', 'LH008_29', 'HV099', N'Có mặt', N'Đầy đủ', 7.5, N'Lập luận tốt nhưng còn thiếu dẫn chứng thực tế minh họa.'),
('K099B30', 'LH008_30', 'HV099', N'Có mặt', N'Đầy đủ', 8.0, N'Phân tích thủ pháp trào phúng sắc sảo, dùng từ chính xác.'),
('K099B31', 'LH008_31', 'HV099', N'Có mặt', N'Thiếu', 7.0, N'Cần rèn luyện thêm kỹ năng làm phần trắc nghiệm nhanh.'),
('K099B32', 'LH008_32', 'HV099', N'Có mặt', N'Đầy đủ', 8.5, N'Đạt điểm cao trong bài kiểm tra định kì, tự luận xuất sắc.'),
('K099B33', 'LH008_33', 'HV099', N'Có mặt', N'Đầy đủ', 8.0, N'Tích cực trong các tiết ôn tập tổng hợp.'),
('K099B34', 'LH008_34', 'HV099', N'Có mặt', N'Đầy đủ', 8.5, N'Hoàn thành khóa học đạt kết quả Giỏi/Khá cao.');


-- NHÓM 2: HỌC VIÊN VÀO TRỄ (TỪ BUỔI 5)
-- 2. HV115 (Trần Thị Bích Trâm) - Đăng ký: 09/01/2026 -> Bắt đầu học: 16/01/2026 (Buổi 5)
-- Tổng số buổi thực học: 30 buổi
INSERT INTO KQ_HOC_TAP (MaKQHT, MaBuoiHoc, MaHocVien, DiemDanh, BTVN, DiemSo, NhanXet) VALUES 
('K115B05', 'LH008_05', 'HV115', N'Có mặt', N'Đầy đủ', 7.0, N'Buổi đầu vào lớp tiếp thu bài "Tức nước vỡ bờ" khá nhanh.'),
('K115B06', 'LH008_06', 'HV115', N'Có mặt', N'Đầy đủ', 7.5, N'Có kĩ năng đọc hiểu tốt, phát biểu xây dựng bài.'),
('K115B07', 'LH008_07', 'HV115', N'Có mặt', N'Thiếu', 6.5, N'Chưa quen với khối lượng bài tập về nhà của trung tâm.'),
('K115B08', 'LH008_08', 'HV115', N'Có mặt', N'Đầy đủ', 8.0, N'Thương cảm sâu sắc trước số phận bi kịch của Lão Hạc.'),
('K115B09', 'LH008_09', 'HV115', N'Có mặt', N'Đầy đủ', 7.5, N'Hiểu được ý nghĩa những mộng tưởng của Cô bé bán diêm.'),
('K115B10', 'LH008_10', 'HV115', N'Vắng mặt', N'Không làm', 0.0, N'Nghỉ học có báo trước.'),
('K115B11', 'LH008_11', 'HV115', N'Có mặt', N'Đầy đủ', 8.0, N'Hành văn mạch lạc, chữ viết đẹp, trình bày sạch sẽ.'),
('K115B12', 'LH008_12', 'HV115', N'Có mặt', N'Đầy đủ', 8.5, N'Phân tích xuất sắc hình tượng chiếc lá cuối cùng.'),
('K115B13', 'LH008_13', 'HV115', N'Có mặt', N'Đầy đủ', 7.5, N'Hiểu được tình yêu quê hương qua tác phẩm Hai cây phong.'),
('K115B14', 'LH008_14', 'HV115', N'Có mặt', N'Thiếu', 6.5, N'Viết đoạn văn nghị luận còn thiếu liên kết câu.'),
('K115B15', 'LH008_15', 'HV115', N'Có mặt', N'Đầy đủ', 8.0, N'Nắm vững cách làm bài văn thuyết minh.'),
('K115B16', 'LH008_16', 'HV115', N'Có mặt', N'Đầy đủ', 7.0, N'Phân tích thơ còn hơi khô khan, nặng về diễn xuôi.'),
('K115B17', 'LH008_17', 'HV115', N'Có mặt', N'Đầy đủ', 7.5, N'Đã biết xác định các biện pháp tu từ trong thơ trung đại.'),
('K115B18', 'LH008_18', 'HV115', N'Có mặt', N'Đầy đủ', 8.0, N'Cảm nhận được khát vọng tự do mãnh liệt trong "Nhớ rừng".'),
('K115B19', 'LH008_19', 'HV115', N'Vắng mặt', N'Không làm', 0.0, N'Nghỉ ốm.'),
('K115B20', 'LH008_20', 'HV115', N'Có mặt', N'Đầy đủ', 8.5, N'Vận dụng từ láy rất linh hoạt trong bài tập làm văn.'),
('K115B21', 'LH008_21', 'HV115', N'Có mặt', N'Đầy đủ', 7.5, N'Tích cực trả lời các câu hỏi đọc hiểu trên lớp.'),
('K115B22', 'LH008_22', 'HV115', N'Có mặt', N'Đầy đủ', 7.0, N'Khả năng bình thơ cần trau chuốt ngôn từ hơn.'),
('K115B23', 'LH008_23', 'HV115', N'Có mặt', N'Thiếu', 6.5, N'Thiếu ý chính khi tóm tắt các văn bản nghị luận trung đại.'),
('K115B24', 'LH008_24', 'HV115', N'Có mặt', N'Đầy đủ', 8.0, N'Phân tích cấu trúc bài Hịch rất lô-gic và rõ ràng.'),
('K115B25', 'LH008_25', 'HV115', N'Có mặt', N'Đầy đủ', 7.5, N'Hiểu sâu sắc tư tưởng cốt lõi của Nguyễn Trãi.'),
('K115B26', 'LH008_26', 'HV115', N'Vắng mặt', N'Không làm', 0.0, N'Vắng học không phép.'),
('K115B27', 'LH008_27', 'HV115', N'Có mặt', N'Đầy đủ', 8.5, N'Làm bài "Bàn luận về phép học" có tính ứng dụng cao.'),
('K115B28', 'LH008_28', 'HV115', N'Có mặt', N'Đầy đủ', 8.0, N'Sử dụng dẫn chứng thực tế rất phù hợp và thuyết phục.'),
('K115B29', 'LH008_29', 'HV115', N'Có mặt', N'Thiếu', 7.0, N'Câu văn đôi chỗ còn cụt lủn, chưa đủ thành phần.'),
('K115B30', 'LH008_30', 'HV115', N'Có mặt', N'Đầy đủ', 7.5, N'Đã nắm được các kiểu câu trần thuật, nghi vấn, cảm thán.'),
('K115B31', 'LH008_31', 'HV115', N'Có mặt', N'Đầy đủ', 8.0, N'Bài thi thử làm rất tốt phần tự luận.'),
('K115B32', 'LH008_32', 'HV115', N'Có mặt', N'Đầy đủ', 7.5, N'Cần chú ý hơn lỗi dùng dấu câu trong đoạn văn.'),
('K115B33', 'LH008_33', 'HV115', N'Có mặt', N'Đầy đủ', 8.0, N'Thái độ học tập nghiêm túc trong các buổi ôn tập.'),
('K115B34', 'LH008_34', 'HV115', N'Có mặt', N'Đầy đủ', 8.5, N'Kết quả học tập tốt, bám sát chương trình vững vàng.');


-- 6. HV131 (Lê Bích Tuyền) - Đăng ký: 22/01/2026 -> Bắt đầu từ Buổi 9 (02/02/2026)
-- Tổng số buổi: 26 buổi
INSERT INTO KQ_HOC_TAP (MaKQHT, MaBuoiHoc, MaHocVien, DiemDanh, BTVN, DiemSo, NhanXet) VALUES 
('K131B09', 'LH008_09', 'HV131', N'Có mặt', N'Đầy đủ', 7.0, N'Vào học trễ nhưng nắm bắt nhanh ý nghĩa truyện "Chiếc lá cuối cùng".'),
('K131B10', 'LH008_10', 'HV131', N'Có mặt', N'Đầy đủ', 7.5, N'Hòa nhập tốt với tiến độ của lớp, làm bài tập đầy đủ.'),
('K131B11', 'LH008_11', 'HV131', N'Có mặt', N'Thiếu', 6.5, N'Chưa nắm vững lý thuyết từ ngữ địa phương.'),
('K131B12', 'LH008_12', 'HV131', N'Có mặt', N'Đầy đủ', 8.0, N'Cảm nhận được vẻ đẹp bức tranh thiên nhiên trong "Hai cây phong".'),
('K131B13', 'LH008_13', 'HV131', N'Vắng mặt', N'Không làm', 0.0, N'Nghỉ học có báo trước.'),
('K131B14', 'LH008_14', 'HV131', N'Có mặt', N'Đầy đủ', 7.5, N'Hiểu được cách thức làm bài văn thuyết minh sự vật.'),
('K131B15', 'LH008_15', 'HV131', N'Có mặt', N'Đầy đủ', 8.0, N'Trình bày bài văn thuyết minh mạch lạc, rõ ràng.'),
('K131B16', 'LH008_16', 'HV131', N'Có mặt', N'Đầy đủ', 8.5, N'Thấy rõ được cái tôi hào sảng của nhà chí sĩ yêu nước.'),
('K131B17', 'LH008_17', 'HV131', N'Có mặt', N'Thiếu', 7.0, N'Phân tích "Nhớ rừng" mới chỉ dừng ở mức diễn xuôi.'),
('K131B18', 'LH008_18', 'HV131', N'Có mặt', N'Đầy đủ', 8.0, N'Phân tích nghệ thuật điệp ngữ trong thơ Thơ Mới khá tốt.'),
('K131B19', 'LH008_19', 'HV131', N'Có mặt', N'Đầy đủ', 7.5, N'Cảm thụ tốt nỗi hoài cổ trong bài thơ "Ông đồ".'),
('K131B20', 'LH008_20', 'HV131', N'Vắng mặt', N'Không làm', 0.0, N'Vắng mặt không phép.'),
('K131B21', 'LH008_21', 'HV131', N'Có mặt', N'Đầy đủ', 8.5, N'Hiểu sâu sắc khát vọng tự do mãnh liệt trong thơ Tố Hữu.'),
('K131B22', 'LH008_22', 'HV131', N'Có mặt', N'Thiếu', 6.5, N'Bài văn biểu cảm chưa nêu bật được cảm xúc sâu sắc.'),
('K131B23', 'LH008_23', 'HV131', N'Có mặt', N'Đầy đủ', 8.0, N'Đã thuộc các bài thơ Đường luật, phân tích cấu trúc thơ tốt.'),
('K131B24', 'LH008_24', 'HV131', N'Có mặt', N'Đầy đủ', 7.5, N'Làm tốt các bài tập xác định hành động nói.'),
('K131B25', 'LH008_25', 'HV131', N'Có mặt', N'Đầy đủ', 8.5, N'Thấy được lập luận sắc sảo, thấu tình đạt lý trong "Chiếu dời đô".'),
('K131B26', 'LH008_26', 'HV131', N'Có mặt', N'Đầy đủ', 8.0, N'Giọng văn có khí thế khi viết về lòng yêu nước.'),
('K131B27', 'LH008_27', 'HV131', N'Vắng mặt', N'Không làm', 0.0, N'Nghỉ học có phép (báo ốm).'),
('K131B28', 'LH008_28', 'HV131', N'Có mặt', N'Thiếu', 7.0, N'Lỗi hành văn còn lủng củng ở phần thân bài.'),
('K131B29', 'LH008_29', 'HV131', N'Có mặt', N'Đầy đủ', 8.0, N'Phân tích đúng các luận điểm của tác giả về quan niệm học tập.'),
('K131B30', 'LH008_30', 'HV131', N'Có mặt', N'Đầy đủ', 8.5, N'Vận dụng tốt các dẫn chứng từ "Thuế máu" vào bài viết.'),
('K131B31', 'LH008_31', 'HV131', N'Có mặt', N'Đầy đủ', 7.5, N'Nắm vững phần Tiếng Việt để làm bài tổng ôn.'),
('K131B32', 'LH008_32', 'HV131', N'Có mặt', N'Đầy đủ', 8.0, N'Làm bài kiểm tra rất tập trung, phân chia thời gian hợp lý.'),
('K131B33', 'LH008_33', 'HV131', N'Có mặt', N'Đầy đủ', 8.5, N'Bài thi tự luận đạt điểm cao, có cách mở bài sáng tạo.'),
('K131B34', 'LH008_34', 'HV131', N'Có mặt', N'Đầy đủ', 8.0, N'Học tập nghiêm túc, đã theo kịp toàn bộ chương trình.');

-- NHÓM 3: HỌC VIÊN VÀO TRỄ (TỪ BUỔI 13 - SAU TẾT)
-- 3. HV147 (Phạm Nguyễn Minh Hằng) - Đăng ký: 05/02/2026 -> Học: 25/02/2026 (Buổi 13)
-- Tổng số buổi thực học: 22 buổi
INSERT INTO KQ_HOC_TAP (MaKQHT, MaBuoiHoc, MaHocVien, DiemDanh, BTVN, DiemSo, NhanXet) VALUES 
('K147B13', 'LH008_13', 'HV147', N'Có mặt', N'Đầy đủ', 6.5, N'Vào học sau Tết, còn bỡ ngỡ với phương pháp phân tích truyện.'),
('K147B14', 'LH008_14', 'HV147', N'Có mặt', N'Đầy đủ', 7.0, N'Nắm bắt nhanh thể loại văn thuyết minh.'),
('K147B15', 'LH008_15', 'HV147', N'Có mặt', N'Thiếu', 6.5, N'Bài tập làm văn lập dàn ý còn chung chung, thiếu chi tiết.'),
('K147B16', 'LH008_16', 'HV147', N'Có mặt', N'Đầy đủ', 7.5, N'Hiểu nội dung thơ trung đại nhưng chưa nắm được thi pháp.'),
('K147B17', 'LH008_17', 'HV147', N'Có mặt', N'Đầy đủ', 8.0, N'Có góc nhìn mới mẻ khi phân tích Đập đá ở Côn Lôn.'),
('K147B18', 'LH008_18', 'HV147', N'Vắng mặt', N'Không làm', 0.0, N'Nghỉ học có xin phép.'),
('K147B19', 'LH008_19', 'HV147', N'Có mặt', N'Đầy đủ', 7.0, N'Cảm thụ nghệ thuật thơ mới còn hạn chế.'),
('K147B20', 'LH008_20', 'HV147', N'Có mặt', N'Đầy đủ', 8.5, N'Phân tích bài Quê hương rất giàu cảm xúc, dồi dào ngôn từ.'),
('K147B21', 'LH008_21', 'HV147', N'Có mặt', N'Đầy đủ', 7.5, N'Sự chuyển ý giữa các khổ thơ trong bài viết rất tự nhiên.'),
('K147B22', 'LH008_22', 'HV147', N'Có mặt', N'Thiếu', 6.5, N'Chưa học thuộc thơ Bác, ảnh hưởng đến việc lấy dẫn chứng.'),
('K147B23', 'LH008_23', 'HV147', N'Có mặt', N'Đầy đủ', 8.0, N'Trình bày bài sạch đẹp, rõ ràng.'),
('K147B24', 'LH008_24', 'HV147', N'Vắng mặt', N'Không làm', 0.0, N'Nghỉ ốm.'),
('K147B25', 'LH008_25', 'HV147', N'Có mặt', N'Đầy đủ', 7.0, N'Lúng túng khi xác định các luận điểm trong Chiếu dời đô.'),
('K147B26', 'LH008_26', 'HV147', N'Có mặt', N'Đầy đủ', 7.5, N'Giọng văn có khí thế khi phân tích Hịch tướng sĩ.'),
('K147B27', 'LH008_27', 'HV147', N'Có mặt', N'Đầy đủ', 8.0, N'Nhận diện tốt các phương thức biểu đạt trong văn bản.'),
('K147B28', 'LH008_28', 'HV147', N'Có mặt', N'Thiếu', 6.5, N'Bài viết đoạn văn còn lặp từ.'),
('K147B29', 'LH008_29', 'HV147', N'Có mặt', N'Đầy đủ', 7.5, N'Làm rõ được sự xảo trá của thực dân Pháp trong Thuế máu.'),
('K147B30', 'LH008_30', 'HV147', N'Có mặt', N'Đầy đủ', 8.5, N'Hệ thống kiến thức ngữ pháp rất vững chắc.'),
('K147B31', 'LH008_31', 'HV147', N'Có mặt', N'Đầy đủ', 8.0, N'Làm bài kiểm tra rất tập trung, phân tích đề tốt.'),
('K147B32', 'LH008_32', 'HV147', N'Có mặt', N'Đầy đủ', 7.5, N'Phần mở bài trực tiếp hiệu quả, đi đúng trọng tâm.'),
('K147B33', 'LH008_33', 'HV147', N'Vắng mặt', N'Không làm', 0.0, N'Vắng học không phép.'),
('K147B34', 'LH008_34', 'HV147', N'Có mặt', N'Đầy đủ', 8.0, N'Hoàn thành chương trình tốt, hòa nhập rất nhanh.');

-- 7. HV163 (Bùi Bích Phương) - Đăng ký: 13/02/2026 -> Bắt đầu từ Buổi 13 (25/02/2026)
-- Tổng số buổi: 22 buổi

INSERT INTO KQ_HOC_TAP (MaKQHT, MaBuoiHoc, MaHocVien, DiemDanh, BTVN, DiemSo, NhanXet) VALUES 
('K163B13', 'LH008_13', 'HV163', N'Có mặt', N'Đầy đủ', 7.0, N'Buổi đầu vào học khá tập trung, nắm được nội dung văn bản nhật dụng.'),
('K163B14', 'LH008_14', 'HV163', N'Có mặt', N'Đầy đủ', 7.5, N'Biết cách phân biệt văn thuyết minh và văn tự sự.'),
('K163B15', 'LH008_15', 'HV163', N'Có mặt', N'Thiếu', 6.5, N'Bài lập dàn ý còn sơ sài, thiếu các luận điểm phụ.'),
('K163B16', 'LH008_16', 'HV163', N'Vắng mặt', N'Không làm', 0.0, N'Nghỉ học có báo trước.'),
('K163B17', 'LH008_17', 'HV163', N'Có mặt', N'Đầy đủ', 8.0, N'Phân tích tốt các biện pháp tu từ trong bài thơ "Nhớ rừng".'),
('K163B18', 'LH008_18', 'HV163', N'Có mặt', N'Đầy đủ', 7.5, N'Hiểu được hoàn cảnh sáng tác và tâm trạng tác giả trong "Ông đồ".'),
('K163B19', 'LH008_19', 'HV163', N'Có mặt', N'Đầy đủ', 8.5, N'Cảm thụ tốt bức tranh sinh hoạt lao động trong bài thơ "Quê hương".'),
('K163B20', 'LH008_20', 'HV163', N'Có mặt', N'Thiếu', 7.0, N'Chưa hiểu rõ giá trị biểu cảm của các từ ngữ gợi tả.'),
('K163B21', 'LH008_21', 'HV163', N'Có mặt', N'Đầy đủ', 8.0, N'Nắm vững được phong cách thơ Hồ Chí Minh.'),
('K163B22', 'LH008_22', 'HV163', N'Có mặt', N'Đầy đủ', 8.5, N'Bài viết đoạn văn cảm nhận về Bác rất tự nhiên, chân thành.'),
('K163B23', 'LH008_23', 'HV163', N'Vắng mặt', N'Không làm', 0.0, N'Vắng học không phép.'),
('K163B24', 'LH008_24', 'HV163', N'Có mặt', N'Đầy đủ', 7.5, N'Làm tốt bài tập về các kiểu câu chia theo mục đích nói.'),
('K163B25', 'LH008_25', 'HV163', N'Có mặt', N'Đầy đủ', 8.0, N'Cảm nhận được tầm vóc của một đấng minh quân qua "Chiếu dời đô".'),
('K163B26', 'LH008_26', 'HV163', N'Có mặt', N'Thiếu', 6.5, N'Lập luận trong bài phân tích "Hịch tướng sĩ" còn lỏng lẻo.'),
('K163B27', 'LH008_27', 'HV163', N'Có mặt', N'Đầy đủ', 7.5, N'Khắc phục được lỗi diễn đạt lủng củng ở bài trước.'),
('K163B28', 'LH008_28', 'HV163', N'Có mặt', N'Đầy đủ', 8.5, N'Hiểu sâu sắc chân lý độc lập chủ quyền trong "Nước Đại Việt ta".'),
('K163B29', 'LH008_29', 'HV163', N'Có mặt', N'Đầy đủ', 8.0, N'Đồng tình với phương pháp học "Học đi đôi với hành".'),
('K163B30', 'LH008_30', 'HV163', N'Có mặt', N'Thiếu', 7.0, N'Bài viết thiếu sự mở rộng liên hệ với thực tế giáo dục hiện nay.'),
('K163B31', 'LH008_31', 'HV163', N'Có mặt', N'Đầy đủ', 8.5, N'Làm rất tốt các dạng bài tập thực hành hội thoại.'),
('K163B32', 'LH008_32', 'HV163', N'Vắng mặt', N'Không làm', 0.0, N'Nghỉ học có báo phụ huynh.'),
('K163B33', 'LH008_33', 'HV163', N'Có mặt', N'Đầy đủ', 8.0, N'Hệ thống lại kiến thức khá tốt để chuẩn bị kiểm tra cuối kỳ.'),
('K163B34', 'LH008_34', 'HV163', N'Có mặt', N'Đầy đủ', 8.5, N'Đạt kết quả rất khả quan dù là học viên mới vào giữa khóa.');

-- 8. HV179 (Nguyễn Hữu Tài) - Đăng ký: 28/02/2026 -> Bắt đầu từ Buổi 16 (09/03/2026)
-- Tổng số buổi: 19 buổi
INSERT INTO KQ_HOC_TAP (MaKQHT, MaBuoiHoc, MaHocVien, DiemDanh, BTVN, DiemSo, NhanXet) VALUES 
('K179B16', 'LH008_16', 'HV179', N'Có mặt', N'Đầy đủ', 7.5, N'Buổi đầu làm quen với thơ Thơ Mới khá tốt, ghi chép đầy đủ.'),
('K179B17', 'LH008_17', 'HV179', N'Có mặt', N'Đầy đủ', 8.0, N'Phân tích được sự đối lập giữa hai cảnh tượng trong bài "Nhớ rừng".'),
('K179B18', 'LH008_18', 'HV179', N'Có mặt', N'Thiếu', 6.5, N'Còn lúng túng khi cảm thụ nghệ thuật tả cảnh ngụ tình.'),
('K179B19', 'LH008_19', 'HV179', N'Có mặt', N'Đầy đủ', 7.0, N'Cần chú ý cách diễn đạt, tránh dùng từ ngữ địa phương vào bài viết.'),
('K179B20', 'LH008_20', 'HV179', N'Vắng mặt', N'Không làm', 0.0, N'Nghỉ học có xin phép.'),
('K179B21', 'LH008_21', 'HV179', N'Có mặt', N'Đầy đủ', 8.0, N'Nắm bắt được tinh thần lạc quan trong thơ Hồ Chí Minh.'),
('K179B22', 'LH008_22', 'HV179', N'Có mặt', N'Đầy đủ', 8.5, N'Biết so sánh phong thái của Bác với các bậc tao nhân mặc khách xưa.'),
('K179B23', 'LH008_23', 'HV179', N'Có mặt', N'Thiếu', 7.0, N'Bài viết đoạn văn còn thiếu câu chủ đề ở đầu đoạn.'),
('K179B24', 'LH008_24', 'HV179', N'Có mặt', N'Đầy đủ', 8.0, N'Xác định đúng các hành động nói trong giao tiếp.'),
('K179B25', 'LH008_25', 'HV179', N'Có mặt', N'Đầy đủ', 8.5, N'Phân tích lập luận xuất sắc trong "Chiếu dời đô".'),
('K179B26', 'LH008_26', 'HV179', N'Có mặt', N'Thiếu', 6.5, N'Chưa hiểu được mục đích thực sự của "Hịch tướng sĩ".'),
('K179B27', 'LH008_27', 'HV179', N'Vắng mặt', N'Không làm', 0.0, N'Vắng mặt do ốm.'),
('K179B28', 'LH008_28', 'HV179', N'Có mặt', N'Đầy đủ', 8.0, N'Phân tích được tư tưởng nhân đạo sâu sắc của Nguyễn Trãi.'),
('K179B29', 'LH008_29', 'HV179', N'Có mặt', N'Đầy đủ', 7.5, N'Hiểu đúng đắn về mục đích của việc học qua văn bản trung đại.'),
('K179B30', 'LH008_30', 'HV179', N'Có mặt', N'Thiếu', 7.0, N'Thiếu sự đào sâu phân tích nghệ thuật trào phúng.'),
('K179B31', 'LH008_31', 'HV179', N'Có mặt', N'Đầy đủ', 8.5, N'Làm bài tổng ôn Tiếng Việt đạt kết quả gần như tuyệt đối.'),
('K179B32', 'LH008_32', 'HV179', N'Vắng mặt', N'Không làm', 0.0, N'Vắng học không phép.'),
('K179B33', 'LH008_33', 'HV179', N'Có mặt', N'Đầy đủ', 8.0, N'Hệ thống hóa kiến thức văn học tốt, tự tin bước vào kỳ thi.'),
('K179B34', 'LH008_34', 'HV179', N'Có mặt', N'Đầy đủ', 8.5, N'Vượt qua các bài kiểm tra cuối khóa xuất sắc.');

-- 4. HV195 (Bùi Phương Thảo) - Đăng ký: 28/03/2026 -> Học: 06/04/2026 (Buổi 24)
-- Tổng số buổi thực học: 11 buổi
INSERT INTO KQ_HOC_TAP (MaKQHT, MaBuoiHoc, MaHocVien, DiemDanh, BTVN, DiemSo, NhanXet) VALUES 
('K195B24', 'LH008_24', 'HV195', N'Có mặt', N'Đầy đủ', 7.5, N'Tiếp thu tốt mảng văn học trung đại ở buổi đầu.'),
('K195B25', 'LH008_25', 'HV195', N'Có mặt', N'Đầy đủ', 8.0, N'Phân tích được cấu trúc lập luận chặt chẽ của Lý Công Uẩn.'),
('K195B26', 'LH008_26', 'HV195', N'Có mặt', N'Thiếu', 6.5, N'Hiểu nội dung nhưng lười làm bài tập về nhà.'),
('K195B27', 'LH008_27', 'HV195', N'Vắng mặt', N'Không làm', 0.0, N'Nghỉ học có báo trước.'),
('K195B28', 'LH008_28', 'HV195', N'Có mặt', N'Đầy đủ', 8.5, N'Viết đoạn văn nghị luận chứng minh tư tưởng nhân nghĩa rất sâu sắc.'),
('K195B29', 'LH008_29', 'HV195', N'Có mặt', N'Đầy đủ', 7.0, N'Còn nhầm lẫn giữa luận điểm và luận cứ khi làm bài.'),
('K195B30', 'LH008_30', 'HV195', N'Có mặt', N'Đầy đủ', 7.5, N'Sử dụng các kiểu câu trong tiếng Việt khá chính xác.'),
('K195B31', 'LH008_31', 'HV195', N'Có mặt', N'Thiếu', 6.5, N'Cần rèn luyện thêm cách viết mở bài và kết bài mở rộng.'),
('K195B32', 'LH008_32', 'HV195', N'Có mặt', N'Đầy đủ', 8.0, N'Bài ôn tập cuối kỳ có sự chuẩn bị chu đáo, rõ ràng.'),
('K195B33', 'LH008_33', 'HV195', N'Có mặt', N'Đầy đủ', 7.5, N'Làm trắc nghiệm đọc hiểu chính xác, kỹ năng tốt.'),
('K195B34', 'LH008_34', 'HV195', N'Có mặt', N'Đầy đủ', 8.5, N'Tuy vào lớp trễ nhưng lực học rất khá, bắt nhịp xuất sắc.');



-- ĐỔ DỮ LIỆU KQ_HOC_TAP LỚP LH006 (MÔN NGỮ VĂN 7) - HỌC LỰC: GIỎI (>8.0)
-- Học viên: HV024, HV052, HV080, HV104, HV128, HV152, HV176
-- NHÓM 1: HỌC TỪ ĐẦU KHÓA (Buổi 1 đến Buổi 33)
-- 1. HV024 (Đỗ Trọng Hiếu) --> Học từ Buổi 1 (03/01/2026)

INSERT INTO KQ_HOC_TAP (MaKQHT, MaBuoiHoc, MaHocVien, DiemDanh, BTVN, DiemSo, NhanXet) VALUES 
('K024B01', 'LH006_01', 'HV024', N'Có mặt', N'Đầy đủ', 9.0, N'Cảm nhận sâu sắc tình mẫu tử thiêng liêng trong "Cổng trường mở ra".'),
('K024B02', 'LH006_02', 'HV024', N'Có mặt', N'Đầy đủ', 8.5, N'Viết đoạn văn biểu cảm về mẹ rất xúc động, hành văn mượt mà.'),
('K024B03', 'LH006_03', 'HV024', N'Có mặt', N'Đầy đủ', 9.5, N'Phân tích tâm lý nhân vật Thành và Thủy xuất sắc, logic.'),
('K024B04', 'LH006_04', 'HV024', N'Vắng mặt', N'Không làm', 0.0, N'Nghỉ học có báo trước.'),
('K024B05', 'LH006_05', 'HV024', N'Có mặt', N'Đầy đủ', 9.0, N'Thuộc các bài ca dao về tình cảm gia đình, phân tích tốt.'),
('K024B06', 'LH006_06', 'HV024', N'Có mặt', N'Đầy đủ', 8.5, N'Hiểu được nghệ thuật trào phúng trong ca dao châm biếm.'),
('K024B07', 'LH006_07', 'HV024', N'Có mặt', N'Đầy đủ', 9.5, N'Làm bài tự luận về tình yêu quê hương đất nước qua ca dao rất hay.'),
('K024B08', 'LH006_08', 'HV024', N'Có mặt', N'Đầy đủ', 9.0, N'Hệ thống từ ghép và từ láy đầy đủ, không sai sót.'),
('K024B09', 'LH006_09', 'HV024', N'Có mặt', N'Đầy đủ', 8.5, N'Nhận diện đại từ trong ngữ liệu chuẩn xác, nhanh nhạy.'),
('K024B10', 'LH006_10', 'HV024', N'Có mặt', N'Đầy đủ', 9.0, N'Thấy được hào khí dân tộc trong "Sông núi nước Nam".'),
('K024B11', 'LH006_11', 'HV024', N'Có mặt', N'Đầy đủ', 9.5, N'Cảm thụ tốt nỗi nhớ nước thương nhà qua "Qua Đèo Ngang".'),
('K024B12', 'LH006_12', 'HV024', N'Vắng mặt', N'Không làm', 0.0, N'Nghỉ ốm có phép.'),
('K024B13', 'LH006_13', 'HV024', N'Có mặt', N'Đầy đủ', 8.5, N'Phân tích nghệ thuật đối trong bài thơ "Bạn đến chơi nhà" rất sắc bén.'),
('K024B14', 'LH006_14', 'HV024', N'Có mặt', N'Đầy đủ', 9.0, N'Hiểu được vẻ đẹp tâm hồn của Bà Huyện Thanh Quan.'),
('K024B15', 'LH006_15', 'HV024', N'Có mặt', N'Đầy đủ', 9.5, N'Làm chủ được thể thơ Thất ngôn bát cú Đường luật.'),
('K024B16', 'LH006_16', 'HV024', N'Có mặt', N'Đầy đủ', 8.5, N'Phát hiện tốt các thành ngữ, tục ngữ dùng trong thơ trung đại.'),
('K024B17', 'LH006_17', 'HV024', N'Có mặt', N'Đầy đủ', 9.0, N'Bình luận bức tranh thiên nhiên trong "Cảnh khuya" rất sinh động.'),
('K024B18', 'LH006_18', 'HV024', N'Có mặt', N'Đầy đủ', 9.5, N'Hiểu sâu sắc tình yêu quê hương qua âm thanh "Tiếng gà trưa".'),
('K024B19', 'LH006_19', 'HV024', N'Có mặt', N'Đầy đủ', 8.5, N'Nắm vững khái niệm về Từ Hán Việt và sử dụng đúng ngữ cảnh.'),
('K024B20', 'LH006_20', 'HV024', N'Có mặt', N'Đầy đủ', 9.0, N'Biết cách chuyển đổi câu chủ động thành câu bị động thuần thục.'),
('K024B21', 'LH006_21', 'HV024', N'Có mặt', N'Đầy đủ', 9.0, N'Phân loại chính xác tục ngữ về thiên nhiên và lao động sản xuất.'),
('K024B22', 'LH006_22', 'HV024', N'Vắng mặt', N'Không làm', 0.0, N'Vắng mặt việc gia đình.'),
('K024B23', 'LH006_23', 'HV024', N'Có mặt', N'Đầy đủ', 9.5, N'Hiểu ý nghĩa triết lý nhân sinh qua tục ngữ về con người.'),
('K024B24', 'LH006_24', 'HV024', N'Có mặt', N'Đầy đủ', 8.5, N'Bước đầu làm quen và lập dàn ý tốt cho bài văn nghị luận.'),
('K024B25', 'LH006_25', 'HV024', N'Có mặt', N'Đầy đủ', 9.0, N'Đưa dẫn chứng cho bài "Tinh thần yêu nước của nhân dân ta" rất hay.'),
('K024B26', 'LH006_26', 'HV024', N'Có mặt', N'Đầy đủ', 9.5, N'Lập luận chứng minh "Đức tính giản dị của Bác Hồ" rất chặt chẽ.'),
('K024B27', 'LH006_27', 'HV024', N'Có mặt', N'Đầy đủ', 8.5, N'Nhận diện nhanh các câu rút gọn, câu đặc biệt trong văn bản.'),
('K024B28', 'LH006_28', 'HV024', N'Có mặt', N'Đầy đủ', 9.0, N'Cảm nhận được chiều sâu tư tưởng trong "Ý nghĩa văn chương".'),
('K024B29', 'LH006_29', 'HV024', N'Có mặt', N'Đầy đủ', 9.5, N'Bài viết nghị luận giải thích mạch lạc, luận cứ sáng rõ.'),
('K024B30', 'LH006_30', 'HV024', N'Có mặt', N'Đầy đủ', 9.0, N'Ôn tập ngữ pháp tiếng Việt kì 2 nắm bài cực kỳ chắc.'),
('K024B31', 'LH006_31', 'HV024', N'Có mặt', N'Đầy đủ', 8.5, N'Tốc độ làm bài trắc nghiệm đọc hiểu nhanh và chính xác.'),
('K024B32', 'LH006_32', 'HV024', N'Có mặt', N'Đầy đủ', 9.5, N'Hoàn thành xuất sắc bài thi thử với mở bài đầy sức hút.'),
('K024B33', 'LH006_33', 'HV024', N'Có mặt', N'Đầy đủ', 9.5, N'Tổng kết môn học đạt loại Giỏi, thái độ học tập gương mẫu.');


-- 2. HV052 (Trần Thị Thu Hiền) --> Học từ Buổi 1 (03/01/2026)

INSERT INTO KQ_HOC_TAP (MaKQHT, MaBuoiHoc, MaHocVien, DiemDanh, BTVN, DiemSo, NhanXet) VALUES 
('K052B01', 'LH006_01', 'HV052', N'Có mặt', N'Đầy đủ', 8.5, N'Văn phong nhẹ nhàng, đồng cảm tốt với cảm xúc tựu trường.'),
('K052B02', 'LH006_02', 'HV052', N'Có mặt', N'Đầy đủ', 9.0, N'Phân tích bức thư của người bố trong "Mẹ tôi" rất thấm thía.'),
('K052B03', 'LH006_03', 'HV052', N'Có mặt', N'Đầy đủ', 8.5, N'Làm nổi bật được nỗi đau chia li của hai anh em.'),
('K052B04', 'LH006_04', 'HV052', N'Có mặt', N'Đầy đủ', 9.5, N'Hoàn thành xuất sắc bài viết văn biểu cảm về sự vật.'),
('K052B05', 'LH006_05', 'HV052', N'Có mặt', N'Đầy đủ', 9.0, N'Phân tích nghệ thuật ẩn dụ trong ca dao rất chuẩn xác.'),
('K052B06', 'LH006_06', 'HV052', N'Vắng mặt', N'Không làm', 0.0, N'Xin phép nghỉ ốm.'),
('K052B07', 'LH006_07', 'HV052', N'Có mặt', N'Đầy đủ', 8.5, N'Diễn đạt tự nhiên, làm nổi bật được vẻ đẹp của ca dao Việt Nam.'),
('K052B08', 'LH006_08', 'HV052', N'Có mặt', N'Đầy đủ', 9.5, N'Tìm và phân tích tác dụng của từ láy rất chính xác.'),
('K052B09', 'LH006_09', 'HV052', N'Có mặt', N'Đầy đủ', 9.0, N'Biết vận dụng đại từ để tránh lặp từ trong đoạn văn.'),
('K052B10', 'LH006_10', 'HV052', N'Có mặt', N'Đầy đủ', 8.5, N'Hiểu sâu sắc bản tuyên ngôn độc lập đầu tiên của dân tộc.'),
('K052B11', 'LH006_11', 'HV052', N'Có mặt', N'Đầy đủ', 9.5, N'Phân tích cụm từ "Ta với ta" rất tinh tế, cảm xúc.'),
('K052B12', 'LH006_12', 'HV052', N'Có mặt', N'Đầy đủ', 9.0, N'Thấy được vẻ đẹp và thân phận người phụ nữ qua "Bánh trôi nước".'),
('K052B13', 'LH006_13', 'HV052', N'Có mặt', N'Đầy đủ', 8.5, N'Cảm nhận được tình bạn tri âm tri kỷ hiếm có trong thơ Nguyễn Khuyến.'),
('K052B14', 'LH006_14', 'HV052', N'Có mặt', N'Đầy đủ', 9.5, N'Có kĩ năng bình giảng thơ trung đại rất tốt.'),
('K052B15', 'LH006_15', 'HV052', N'Có mặt', N'Đầy đủ', 9.0, N'Viết đoạn văn mở rộng về tình bạn đạt điểm tối đa.'),
('K052B16', 'LH006_16', 'HV052', N'Vắng mặt', N'Không làm', 0.0, N'Vắng mặt có báo trước.'),
('K052B17', 'LH006_17', 'HV052', N'Có mặt', N'Đầy đủ', 8.5, N'Cảm nhận được phong thái ung dung của Bác qua bài "Cảnh khuya".'),
('K052B18', 'LH006_18', 'HV052', N'Có mặt', N'Đầy đủ', 9.0, N'Xác định đúng các biện pháp điệp ngữ trong "Tiếng gà trưa".'),
('K052B19', 'LH006_19', 'HV052', N'Có mặt', N'Đầy đủ', 8.5, N'Vận dụng thành thạo từ Hán Việt để tăng tính trang trọng cho bài viết.'),
('K052B20', 'LH006_20', 'HV052', N'Có mặt', N'Đầy đủ', 9.5, N'Làm tốt các bài tập chuyển đổi câu chủ động, bị động.'),
('K052B21', 'LH006_21', 'HV052', N'Có mặt', N'Đầy đủ', 9.0, N'Trình bày mạch lạc, giải nghĩa tục ngữ rất thấu đáo.'),
('K052B22', 'LH006_22', 'HV052', N'Có mặt', N'Đầy đủ', 8.5, N'Biết liên hệ tục ngữ với các câu ca dao có nội dung tương đồng.'),
('K052B23', 'LH006_23', 'HV052', N'Có mặt', N'Đầy đủ', 9.5, N'Bài viết đoạn văn về tình yêu thương con người rất xuất sắc.'),
('K052B24', 'LH006_24', 'HV052', N'Có mặt', N'Đầy đủ', 9.0, N'Nắm chắc cấu trúc của bài văn nghị luận chứng minh.'),
('K052B25', 'LH006_25', 'HV052', N'Có mặt', N'Đầy đủ', 8.5, N'Phân tích nghệ thuật liệt kê trong bài viết của Chủ tịch Hồ Chí Minh.'),
('K052B26', 'LH006_26', 'HV052', N'Có mặt', N'Đầy đủ', 9.5, N'Luận điểm trong bài nghị luận sắc bén, lập luận vững vàng.'),
('K052B27', 'LH006_27', 'HV052', N'Vắng mặt', N'Không làm', 0.0, N'Nghỉ việc gia đình.'),
('K052B28', 'LH006_28', 'HV052', N'Có mặt', N'Đầy đủ', 8.5, N'Hiểu đúng đắn về nguồn gốc cốt yếu của văn chương theo Hoài Thanh.'),
('K052B29', 'LH006_29', 'HV052', N'Có mặt', N'Đầy đủ', 9.0, N'Kỹ năng viết văn nghị luận giải thích đã hoàn thiện tốt.'),
('K052B30', 'LH006_30', 'HV052', N'Có mặt', N'Đầy đủ', 9.5, N'Làm đúng 100% các câu hỏi ngữ pháp Tiếng Việt.'),
('K052B31', 'LH006_31', 'HV052', N'Có mặt', N'Đầy đủ', 9.0, N'Đọc hiểu văn bản tốt, chọn lọc thông tin nhanh.'),
('K052B32', 'LH006_32', 'HV052', N'Có mặt', N'Đầy đủ', 9.5, N'Bài kiểm tra tổng hợp đạt kết quả Giỏi, câu từ trau chuốt.'),
('K052B33', 'LH006_33', 'HV052', N'Có mặt', N'Đầy đủ', 9.5, N'Kết thúc khóa học với thành tích cao, luôn chăm chỉ làm BTVN.');

-- 3. HV080 (Lê Diễm Hằng) - Đăng ký: 15/10/2025 -> Học từ Buổi 1 (03/01/2026)

INSERT INTO KQ_HOC_TAP (MaKQHT, MaBuoiHoc, MaHocVien, DiemDanh, BTVN, DiemSo, NhanXet) VALUES 
('K080B01', 'LH006_01', 'HV080', N'Có mặt', N'Đầy đủ', 8.5, N'Đọc hiểu văn bản sâu sắc, giọng văn có hồn.'),
('K080B02', 'LH006_02', 'HV080', N'Có mặt', N'Đầy đủ', 9.5, N'Cảm nhận được sự nghiêm khắc nhưng đầy yêu thương của người cha.'),
('K080B03', 'LH006_03', 'HV080', N'Có mặt', N'Đầy đủ', 9.0, N'Phân tích chi tiết búp bê vệ sĩ rất tinh tế.'),
('K080B04', 'LH006_04', 'HV080', N'Có mặt', N'Đầy đủ', 8.5, N'Viết văn biểu cảm tốt, tuy nhiên phần kết bài hơi ngắn.'),
('K080B05', 'LH006_05', 'HV080', N'Vắng mặt', N'Không làm', 0.0, N'Xin nghỉ ốm.'),
('K080B06', 'LH006_06', 'HV080', N'Có mặt', N'Đầy đủ', 9.5, N'Tìm được các câu ca dao cùng chủ đề phong phú.'),
('K080B07', 'LH006_07', 'HV080', N'Có mặt', N'Đầy đủ', 9.0, N'Giải thích rõ ràng các hình ảnh ẩn dụ: con cò, bến, thuyền.'),
('K080B08', 'LH006_08', 'HV080', N'Có mặt', N'Đầy đủ', 8.5, N'Hiểu và phân loại từ ghép chính phụ, đẳng lập chuẩn xác.'),
('K080B09', 'LH006_09', 'HV080', N'Có mặt', N'Đầy đủ', 9.5, N'Thực hành sử dụng đại từ trong viết đoạn văn rất linh hoạt.'),
('K080B10', 'LH006_10', 'HV080', N'Có mặt', N'Đầy đủ', 9.0, N'Nắm bắt được âm hưởng hào hùng của thơ trung đại.'),
('K080B11', 'LH006_11', 'HV080', N'Có mặt', N'Đầy đủ', 8.5, N'Thấy được thủ pháp tả cảnh ngụ tình xuất sắc của Bà Huyện Thanh Quan.'),
('K080B12', 'LH006_12', 'HV080', N'Có mặt', N'Đầy đủ', 9.5, N'Cảm nhận sắc sảo về ngôn ngữ đa nghĩa trong thơ Hồ Xuân Hương.'),
('K080B13', 'LH006_13', 'HV080', N'Có mặt', N'Đầy đủ', 9.0, N'Giọng văn phân tích có sự điềm đạm, suy tư sâu sắc.'),
('K080B14', 'LH006_14', 'HV080', N'Có mặt', N'Đầy đủ', 8.5, N'Biết so sánh sự khác nhau giữa tình bạn trong thơ xưa và nay.'),
('K080B15', 'LH006_15', 'HV080', N'Vắng mặt', N'Không làm', 0.0, N'Nghỉ học có báo phụ huynh.'),
('K080B16', 'LH006_16', 'HV080', N'Có mặt', N'Đầy đủ', 9.5, N'Làm bài tự luận phân tích thơ trung đại hoàn hảo, dẫn chứng tốt.'),
('K080B17', 'LH006_17', 'HV080', N'Có mặt', N'Đầy đủ', 9.0, N'Cảm thụ tốt sự hòa quyện giữa cảnh và tình trong thơ Bác.'),
('K080B18', 'LH006_18', 'HV080', N'Có mặt', N'Đầy đủ', 8.5, N'Tìm ra ý nghĩa biểu tượng của tiếng gà trưa trong thời chiến.'),
('K080B19', 'LH006_19', 'HV080', N'Có mặt', N'Đầy đủ', 9.5, N'Nắm rõ quy tắc tạo lập từ Hán Việt, giải nghĩa từ chuẩn.'),
('K080B20', 'LH006_20', 'HV080', N'Có mặt', N'Đầy đủ', 9.0, N'Làm bài tập chuyển đổi câu không mắc lỗi ngữ pháp.'),
('K080B21', 'LH006_21', 'HV080', N'Có mặt', N'Đầy đủ', 8.5, N'Tóm lược và đúc kết ý nghĩa triết lý của tục ngữ sắc sảo.'),
('K080B22', 'LH006_22', 'HV080', N'Có mặt', N'Đầy đủ', 9.5, N'Mở rộng vấn đề bàn luận về tục ngữ rất hay và thời sự.'),
('K080B23', 'LH006_23', 'HV080', N'Có mặt', N'Đầy đủ', 9.0, N'Đã biết cách sử dụng tục ngữ làm luận điểm cho bài văn.'),
('K080B24', 'LH006_24', 'HV080', N'Có mặt', N'Đầy đủ', 8.5, N'Trình bày bài văn nghị luận rõ ràng, sạch đẹp, đúng cấu trúc.'),
('K080B25', 'LH006_25', 'HV080', N'Có mặt', N'Đầy đủ', 9.5, N'Khẳng định được sức mạnh của lòng yêu nước qua lập luận.'),
('K080B26', 'LH006_26', 'HV080', N'Vắng mặt', N'Không làm', 0.0, N'Vắng mặt do việc cá nhân.'),
('K080B27', 'LH006_27', 'HV080', N'Có mặt', N'Đầy đủ', 9.0, N'Nắm chắc kỹ năng thêm trạng ngữ cho câu.'),
('K080B28', 'LH006_28', 'HV080', N'Có mặt', N'Đầy đủ', 8.5, N'Cảm nhận được giá trị thanh lọc tâm hồn của văn chương.'),
('K080B29', 'LH006_29', 'HV080', N'Có mặt', N'Đầy đủ', 9.5, N'Triển khai bài văn nghị luận giải thích với lý lẽ phong phú.'),
('K080B30', 'LH006_30', 'HV080', N'Có mặt', N'Đầy đủ', 9.0, N'Tích cực trong các bài tập ôn luyện lý thuyết Tiếng Việt.'),
('K080B31', 'LH006_31', 'HV080', N'Có mặt', N'Đầy đủ', 8.5, N'Làm bài trắc nghiệm cẩn thận, không sai sót.'),
('K080B32', 'LH006_32', 'HV080', N'Có mặt', N'Đầy đủ', 9.5, N'Kết bài thi thử rất ấn tượng, để lại dư âm sâu sắc.'),
('K080B33', 'LH006_33', 'HV080', N'Có mặt', N'Đầy đủ', 9.5, N'Một học viên xuất sắc, duy trì phong độ rất tốt suốt khóa học.');


-- 4. HV104 (Lê Ngọc Hà) --> Học từ Buổi 1 (03/01/2026)

INSERT INTO KQ_HOC_TAP (MaKQHT, MaBuoiHoc, MaHocVien, DiemDanh, BTVN, DiemSo, NhanXet) VALUES 
('K104B01', 'LH006_01', 'HV104', N'Có mặt', N'Đầy đủ', 9.0, N'Nắm vững nội dung văn bản nhật dụng, hăng hái phát biểu.'),
('K104B02', 'LH006_02', 'HV104', N'Có mặt', N'Đầy đủ', 9.5, N'Thấy được vai trò to lớn của nhà trường và gia đình.'),
('K104B03', 'LH006_03', 'HV104', N'Có mặt', N'Đầy đủ', 8.5, N'Bài viết có chiều sâu, đồng cảm với số phận trẻ thơ.'),
('K104B04', 'LH006_04', 'HV104', N'Có mặt', N'Đầy đủ', 9.0, N'Hành văn mạch lạc, vốn từ vựng biểu cảm phong phú.'),
('K104B05', 'LH006_05', 'HV104', N'Có mặt', N'Đầy đủ', 9.5, N'Phân tích ca dao rất mượt mà, hiểu rõ các biện pháp tu từ.'),
('K104B06', 'LH006_06', 'HV104', N'Có mặt', N'Đầy đủ', 8.5, N'Nắm được ý nghĩa phản kháng trong ca dao than thân.'),
('K104B07', 'LH006_07', 'HV104', N'Vắng mặt', N'Không làm', 0.0, N'Nghỉ học có báo phép.'),
('K104B08', 'LH006_08', 'HV104', N'Có mặt', N'Đầy đủ', 9.0, N'Hệ thống hóa kiến thức về cấu tạo từ xuất sắc.'),
('K104B09', 'LH006_09', 'HV104', N'Có mặt', N'Đầy đủ', 9.5, N'Giải bài tập nhanh, chính xác phần đại từ.'),
('K104B10', 'LH006_10', 'HV104', N'Có mặt', N'Đầy đủ', 8.5, N'Thấy được nhãn tự của bài thơ Sông núi nước Nam.'),
('K104B11', 'LH006_11', 'HV104', N'Có mặt', N'Đầy đủ', 9.0, N'Phân tích từ láy "lom khom", "lác đác" cực kỳ sinh động.'),
('K104B12', 'LH006_12', 'HV104', N'Có mặt', N'Đầy đủ', 9.5, N'Hiểu được thái độ mỉa mai, trào phúng ẩn sau Bánh trôi nước.'),
('K104B13', 'LH006_13', 'HV104', N'Có mặt', N'Đầy đủ', 8.5, N'Bình luận về cụm từ "Ta với ta" vô cùng sâu sắc.'),
('K104B14', 'LH006_14', 'HV104', N'Có mặt', N'Đầy đủ', 9.0, N'Học thuộc các bài thơ trung đại rất nhanh chóng.'),
('K104B15', 'LH006_15', 'HV104', N'Có mặt', N'Đầy đủ', 9.5, N'Làm bài kiểm tra 1 tiết đạt điểm xuất sắc phần tự luận.'),
('K104B16', 'LH006_16', 'HV104', N'Có mặt', N'Đầy đủ', 8.5, N'Chỉ ra được nét độc đáo trong các câu tục ngữ.'),
('K104B17', 'LH006_17', 'HV104', N'Vắng mặt', N'Không làm', 0.0, N'Nghỉ ốm.'),
('K104B18', 'LH006_18', 'HV104', N'Có mặt', N'Đầy đủ', 9.0, N'Cảm nhận được sự hy sinh thầm lặng của người bà.'),
('K104B19', 'LH006_19', 'HV104', N'Có mặt', N'Đầy đủ', 9.5, N'Có vốn từ Hán Việt tốt, ứng dụng vào viết văn trôi chảy.'),
('K104B20', 'LH006_20', 'HV104', N'Có mặt', N'Đầy đủ', 8.5, N'Nhận diện các kiểu câu chủ động, bị động chính xác 100%.'),
('K104B21', 'LH006_21', 'HV104', N'Có mặt', N'Đầy đủ', 9.0, N'Biết cách giải thích tục ngữ đen và nghĩa bóng.'),
('K104B22', 'LH006_22', 'HV104', N'Có mặt', N'Đầy đủ', 9.5, N'Vận dụng tục ngữ vào bài viết nghị luận xã hội linh hoạt.'),
('K104B23', 'LH006_23', 'HV104', N'Có mặt', N'Đầy đủ', 8.5, N'Đã phân biệt được ca dao và tục ngữ.'),
('K104B24', 'LH006_24', 'HV104', N'Có mặt', N'Đầy đủ', 9.0, N'Lập dàn ý bài văn nghị luận rất khoa học, đủ ý.'),
('K104B25', 'LH006_25', 'HV104', N'Vắng mặt', N'Không làm', 0.0, N'Vắng mặt có lý do chính đáng.'),
('K104B26', 'LH006_26', 'HV104', N'Có mặt', N'Đầy đủ', 9.5, N'Bài viết về Bác Hồ dạt dào cảm xúc, dẫn chứng sát thực.'),
('K104B27', 'LH006_27', 'HV104', N'Có mặt', N'Đầy đủ', 8.5, N'Hiểu và vận dụng tốt kỹ năng khôi phục câu rút gọn.'),
('K104B28', 'LH006_28', 'HV104', N'Có mặt', N'Đầy đủ', 9.0, N'Bàn luận về chức năng của văn chương rất thuyết phục.'),
('K104B29', 'LH006_29', 'HV104', N'Có mặt', N'Đầy đủ', 9.5, N'Có lập trường rõ ràng khi viết văn nghị luận chứng minh.'),
('K104B30', 'LH006_30', 'HV104', N'Có mặt', N'Đầy đủ', 9.0, N'Tổng ôn tiếng Việt, trả lời câu hỏi phản xạ nhanh.'),
('K104B31', 'LH006_31', 'HV104', N'Có mặt', N'Đầy đủ', 8.5, N'Phân tích ngữ liệu mới trong đề đọc hiểu rất thông minh.'),
('K104B32', 'LH006_32', 'HV104', N'Có mặt', N'Đầy đủ', 9.5, N'Bài thi thử làm tự luận xuất sắc, chữ viết đẹp.'),
('K104B33', 'LH006_33', 'HV104', N'Có mặt', N'Đầy đủ', 9.5, N'Luôn dẫn đầu lớp về kết quả học tập và thái độ.');


-- NHÓM 2: HỌC VIÊN VÀO TRỄ 
-- 5. HV128 (Bùi Quang Dũng) - Đăng ký: 20/01/2026 -> Học từ Buổi 9 (31/01/2026)
-- Tổng số buổi: 25 buổi
INSERT INTO KQ_HOC_TAP (MaKQHT, MaBuoiHoc, MaHocVien, DiemDanh, BTVN, DiemSo, NhanXet) VALUES 
('K128B09', 'LH006_09', 'HV128', N'Có mặt', N'Đầy đủ', 8.5, N'Buổi đầu vào lớp nắm bắt phần ngữ pháp tiếng Việt rất nhanh.'),
('K128B10', 'LH006_10', 'HV128', N'Có mặt', N'Đầy đủ', 9.0, N'Hiểu được âm hưởng tự hào dân tộc trong thơ trung đại.'),
('K128B11', 'LH006_11', 'HV128', N'Có mặt', N'Đầy đủ', 9.5, N'Phân tích bức tranh đèo Ngang với ngôn từ chắt lọc.'),
('K128B12', 'LH006_12', 'HV128', N'Có mặt', N'Đầy đủ', 8.5, N'Thấy được vẻ đẹp hình thể và phẩm chất của người phụ nữ xưa.'),
('K128B13', 'LH006_13', 'HV128', N'Có mặt', N'Đầy đủ', 9.0, N'Hòa nhập tốt, tích cực phát biểu thảo luận trên lớp.'),
('K128B14', 'LH006_14', 'HV128', N'Vắng mặt', N'Không làm', 0.0, N'Nghỉ học có báo phép.'),
('K128B15', 'LH006_15', 'HV128', N'Có mặt', N'Đầy đủ', 9.5, N'Làm bài tự luận phân tích thơ đạt điểm Giỏi.'),
('K128B16', 'LH006_16', 'HV128', N'Có mặt', N'Đầy đủ', 8.5, N'Biết rút ra những bài học đạo lý từ ca dao, tục ngữ.'),
('K128B17', 'LH006_17', 'HV128', N'Có mặt', N'Đầy đủ', 9.0, N'Chỉ ra được nét hiện đại đan xen cổ điển trong thơ Bác.'),
('K128B18', 'LH006_18', 'HV128', N'Có mặt', N'Đầy đủ', 9.5, N'Phân tích nghệ thuật điệp từ xuất sắc trong bài thơ.'),
('K128B19', 'LH006_19', 'HV128', N'Có mặt', N'Đầy đủ', 8.5, N'Khả năng giải nghĩa yếu tố Hán Việt khá chắc chắn.'),
('K128B20', 'LH006_20', 'HV128', N'Có mặt', N'Đầy đủ', 9.0, N'Làm chủ kiến thức chuyển đổi các kiểu câu ngữ pháp.'),
('K128B21', 'LH006_21', 'HV128', N'Vắng mặt', N'Không làm', 0.0, N'Nghỉ ốm.'),
('K128B22', 'LH006_22', 'HV128', N'Có mặt', N'Đầy đủ', 9.5, N'Vận dụng tục ngữ vào đoạn văn rất linh hoạt.'),
('K128B23', 'LH006_23', 'HV128', N'Có mặt', N'Đầy đủ', 8.5, N'Khái quát tốt giá trị triết lý của tục ngữ về con người.'),
('K128B24', 'LH006_24', 'HV128', N'Có mặt', N'Đầy đủ', 9.0, N'Có tư duy logic tốt khi lập dàn ý văn nghị luận.'),
('K128B25', 'LH006_25', 'HV128', N'Có mặt', N'Đầy đủ', 9.5, N'Lập luận sắc bén, luận cứ rõ ràng, văn phong mạnh mẽ.'),
('K128B26', 'LH006_26', 'HV128', N'Có mặt', N'Đầy đủ', 8.5, N'Thấy được sức thuyết phục trong nghệ thuật liệt kê của tác giả.'),
('K128B27', 'LH006_27', 'HV128', N'Có mặt', N'Đầy đủ', 9.0, N'Phân biệt rõ câu rút gọn và câu đặc biệt trong tiếng Việt.'),
('K128B28', 'LH006_28', 'HV128', N'Có mặt', N'Đầy đủ', 9.5, N'Luận điểm rõ ràng khi viết về nguồn gốc của văn chương.'),
('K128B29', 'LH006_29', 'HV128', N'Vắng mặt', N'Không làm', 0.0, N'Vắng mặt việc gia đình.'),
('K128B30', 'LH006_30', 'HV128', N'Có mặt', N'Đầy đủ', 8.5, N'Ôn tập lý thuyết hệ thống, có sơ đồ tư duy sáng tạo.'),
('K128B31', 'LH006_31', 'HV128', N'Có mặt', N'Đầy đủ', 9.0, N'Phần trắc nghiệm làm bài không sai câu nào.'),
('K128B32', 'LH006_32', 'HV128', N'Có mặt', N'Đầy đủ', 9.5, N'Bài thi thử làm rất tốt, cách hành văn có nét riêng.'),
('K128B33', 'LH006_33', 'HV128', N'Có mặt', N'Đầy đủ', 9.5, N'Vào học trễ nhưng bắt nhịp vô cùng tốt, đạt kết quả xuất sắc.');


-- 6. HV152 (Phạm Thanh Thủy) - Đăng ký: 07/02/2026 -> Học từ Buổi 13 (28/02/2026 - Sau Tết)
-- Tổng số buổi: 21 buổi
INSERT INTO KQ_HOC_TAP (MaKQHT, MaBuoiHoc, MaHocVien, DiemDanh, BTVN, DiemSo, NhanXet) VALUES 
('K152B13', 'LH006_13', 'HV152', N'Có mặt', N'Đầy đủ', 8.5, N'Hòa nhập sau Tết nhanh, cảm nhận tốt bài thơ Bạn đến chơi nhà.'),
('K152B14', 'LH006_14', 'HV152', N'Có mặt', N'Đầy đủ', 9.0, N'Phân tích được sự phá cách trong thơ Nguyễn Khuyến.'),
('K152B15', 'LH006_15', 'HV152', N'Có mặt', N'Đầy đủ', 9.5, N'Hiểu biết sâu rộng về bối cảnh văn học trung đại.'),
('K152B16', 'LH006_16', 'HV152', N'Vắng mặt', N'Không làm', 0.0, N'Nghỉ học có báo trước.'),
('K152B17', 'LH006_17', 'HV152', N'Có mặt', N'Đầy đủ', 8.5, N'Phân tích bức tranh thiên nhiên tuyệt đẹp trong "Cảnh khuya".'),
('K152B18', 'LH006_18', 'HV152', N'Có mặt', N'Đầy đủ', 9.0, N'Đồng cảm với tuổi thơ và tình yêu quê hương trong thơ Xuân Quỳnh.'),
('K152B19', 'LH006_19', 'HV152', N'Có mặt', N'Đầy đủ', 9.5, N'Nắm vững cách cấu tạo từ ghép Hán Việt chính phụ, đẳng lập.'),
('K152B20', 'LH006_20', 'HV152', N'Có mặt', N'Đầy đủ', 8.5, N'Thực hành chuyển đổi câu cực kỳ nhanh nhẹn.'),
('K152B21', 'LH006_21', 'HV152', N'Có mặt', N'Đầy đủ', 9.0, N'Cảm nhận được trí tuệ dân gian qua các câu tục ngữ.'),
('K152B22', 'LH006_22', 'HV152', N'Vắng mặt', N'Không làm', 0.0, N'Xin nghỉ ốm.'),
('K152B23', 'LH006_23', 'HV152', N'Có mặt', N'Đầy đủ', 9.5, N'Vận dụng thành ngữ, tục ngữ vào viết văn rất nhuần nhuyễn.'),
('K152B24', 'LH006_24', 'HV152', N'Có mặt', N'Đầy đủ', 8.5, N'Hiểu rõ các thao tác lập luận trong bài văn nghị luận.'),
('K152B25', 'LH006_25', 'HV152', N'Có mặt', N'Đầy đủ', 9.0, N'Bố cục bài viết rõ ràng, luận cứ sắc sảo.'),
('K152B26', 'LH006_26', 'HV152', N'Có mặt', N'Đầy đủ', 9.5, N'Nêu được những dẫn chứng lịch sử phong phú trong bài luận.'),
('K152B27', 'LH006_27', 'HV152', N'Có mặt', N'Đầy đủ', 8.5, N'Sử dụng tốt trạng ngữ để liên kết câu trong đoạn.'),
('K152B28', 'LH006_28', 'HV152', N'Có mặt', N'Đầy đủ', 9.0, N'Thấy được sức mạnh cảm hóa của văn chương đối với con người.'),
('K152B29', 'LH006_29', 'HV152', N'Có mặt', N'Đầy đủ', 9.5, N'Bài viết nghị luận giải thích mạch lạc, thấu tình đạt lý.'),
('K152B30', 'LH006_30', 'HV152', N'Có mặt', N'Đầy đủ', 8.5, N'Hệ thống từ vựng và ngữ pháp ôn tập kỹ lưỡng.'),
('K152B31', 'LH006_31', 'HV152', N'Vắng mặt', N'Không làm', 0.0, N'Vắng mặt có lý do cá nhân.'),
('K152B32', 'LH006_32', 'HV152', N'Có mặt', N'Đầy đủ', 9.5, N'Làm bài kiểm tra rất xuất sắc, điểm tự luận cao.'),
('K152B33', 'LH006_33', 'HV152', N'Có mặt', N'Đầy đủ', 9.0, N'Nỗ lực bù đắp kiến thức đầu khóa rất đáng khen, học lực Giỏi.');


-- 7. HV176 (Lê Ngọc Điệp) - Đăng ký: 26/02/2026 -> Học từ Buổi 15 (07/03/2026)
-- Tổng số buổi: 19 buổi

INSERT INTO KQ_HOC_TAP (MaKQHT, MaBuoiHoc, MaHocVien, DiemDanh, BTVN, DiemSo, NhanXet) VALUES 
('K176B15', 'LH006_15', 'HV176', N'Có mặt', N'Đầy đủ', 8.5, N'Bắt nhịp với kiến thức thơ trung đại tốt ở buổi đầu.'),
('K176B16', 'LH006_16', 'HV176', N'Có mặt', N'Đầy đủ', 9.0, N'Học thuộc các câu tục ngữ nhanh và hiểu nghĩa sâu sắc.'),
('K176B17', 'LH006_17', 'HV176', N'Có mặt', N'Đầy đủ', 9.5, N'Cảm nhận tinh tế chất thi sĩ và chiến sĩ trong thơ Bác.'),
('K176B18', 'LH006_18', 'HV176', N'Có mặt', N'Đầy đủ', 8.5, N'Phân tích khổ thơ cuối bài "Tiếng gà trưa" rất dạt dào cảm xúc.'),
('K176B19', 'LH006_19', 'HV176', N'Vắng mặt', N'Không làm', 0.0, N'Nghỉ học có báo trước.'),
('K176B20', 'LH006_20', 'HV176', N'Có mặt', N'Đầy đủ', 9.0, N'Làm bài tập phân loại câu chủ động bị động hoàn hảo.'),
('K176B21', 'LH006_21', 'HV176', N'Có mặt', N'Đầy đủ', 9.5, N'Biết sử dụng thành ngữ, tục ngữ để viết đoạn văn tự sự.'),
('K176B22', 'LH006_22', 'HV176', N'Có mặt', N'Đầy đủ', 8.5, N'Tìm ra được kinh nghiệm sống quý báu qua tục ngữ dân gian.'),
('K176B23', 'LH006_23', 'HV176', N'Có mặt', N'Đầy đủ', 9.0, N'Trình bày bài tập về nhà rõ ràng, chữ viết đẹp.'),
('K176B24', 'LH006_24', 'HV176', N'Có mặt', N'Đầy đủ', 9.5, N'Có lập trường rõ ràng khi tiếp cận dạng văn nghị luận.'),
('K176B25', 'LH006_25', 'HV176', N'Có mặt', N'Đầy đủ', 8.5, N'Phân tích nghệ thuật liệt kê trong bài viết rất thấu đáo.'),
('K176B26', 'LH006_26', 'HV176', N'Vắng mặt', N'Không làm', 0.0, N'Nghỉ ốm.'),
('K176B27', 'LH006_27', 'HV176', N'Có mặt', N'Đầy đủ', 9.0, N'Nắm chắc kiến thức câu rút gọn để vận dụng vào giao tiếp.'),
('K176B28', 'LH006_28', 'HV176', N'Có mặt', N'Đầy đủ', 9.5, N'Hiểu được thông điệp sâu xa mà Hoài Thanh gửi gắm.'),
('K176B29', 'LH006_29', 'HV176', N'Có mặt', N'Đầy đủ', 8.5, N'Dẫn chứng trong bài văn nghị luận rất thời sự, sát thực tế.'),
('K176B30', 'LH006_30', 'HV176', N'Có mặt', N'Đầy đủ', 9.0, N'Làm chủ được lý thuyết Tiếng Việt cuối kỳ.'),
('K176B31', 'LH006_31', 'HV176', N'Có mặt', N'Đầy đủ', 9.5, N'Kỹ năng trả lời đọc hiểu trắc nghiệm cực kì chính xác.'),
('K176B32', 'LH006_32', 'HV176', N'Có mặt', N'Đầy đủ', 9.5, N'Bài thi thử đạt điểm Giỏi xuất sắc phần nghị luận xã hội.'),
('K176B33', 'LH006_33', 'HV176', N'Có mặt', N'Đầy đủ', 9.0, N'Hòa nhập nhanh và theo kịp lớp, kết quả học tập đáng tự hào.');


INSERT INTO KQ_HOC_TAP (MaKQHT, MaBuoiHoc, MaHocVien, DiemDanh, BTVN, DiemSo, NhanXet) VALUES

-- 1. HV001 (LH010 - Lớp 9 Trung bình - 21 Buổi - ĐI ĐỦ) -> Điểm 5.5 - 6.5

('K001B01','LH010_01','HV001', N'Có mặt', N'Thiếu', 5.5, N'Chưa nắm vững cách phân tích tâm lý nhân vật.'), ('K001B02','LH010_02','HV001', N'Đi muộn', N'Đầy đủ', 6.0, N'Đi muộn 15p. Bài làm có tiến bộ.'), 
('K001B03','LH010_03','HV001', N'Có mặt', N'Đầy đủ', 6.0, N'Tập trung nghe giảng, làm bài khá.'), ('K001B04','LH010_04','HV001', N'Có mặt', N'Đầy đủ', 6.5, N'Có cố gắng trong phần nghị luận xã hội.'), 
('K001B05','LH010_05','HV001', N'Có mặt', N'Đầy đủ', 6.0, N'Cần chú ý cách chia đoạn văn hợp lý hơn.'), ('K001B06','LH010_06','HV001', N'Có mặt', N'Đầy đủ', 6.5, N'Đã biết cách mở bài gián tiếp.'), 
('K001B07','LH010_07','HV001', N'Đi muộn', N'Thiếu', 5.5, N'Hôm nay mất tập trung, không thuộc thơ.'), ('K001B08','LH010_08','HV001', N'Có mặt', N'Đầy đủ', 6.5, N'Làm bài kiểm tra 15 phút khá tốt.'), 
('K001B09','LH010_09','HV001', N'Có mặt', N'Đầy đủ', 6.0, N'Chữ viết cần cẩn thận hơn.'), ('K001B10','LH010_10','HV001', N'Có mặt', N'Đầy đủ', 6.5, N'Đã nắm được ý chính của văn bản.'), 
('K001B11','LH010_11','HV001', N'Có mặt', N'Đầy đủ', 6.0, N'Mở bài tốt nhưng thân bài lủng củng.'), ('K001B12','LH010_12','HV001', N'Có mặt', N'Đầy đủ', 6.5, N'Cần trau dồi thêm vốn từ vựng.'), 
('K001B13','LH010_13','HV001', N'Có mặt', N'Đầy đủ', 6.0, N'Đã cải thiện lỗi sai chính tả.'), ('K001B14','LH010_14','HV001', N'Có mặt', N'Đầy đủ', 6.5, N'Phong độ học tập ổn định.'), 
('K001B15','LH010_15','HV001', N'Có mặt', N'Thiếu', 5.5, N'Quên nộp vở soạn văn.'), ('K001B16','LH010_16','HV001', N'Có mặt', N'Đầy đủ', 6.0, N'Làm bài khá ổn định.'), 
('K001B17','LH010_17','HV001', N'Có mặt', N'Đầy đủ', 6.5, N'Hoàn thành đầy đủ bài tập ôn thi.'), ('K001B18','LH010_18','HV001', N'Có mặt', N'Đầy đủ', 6.5, N'Làm trắc nghiệm Đọc hiểu rất tốt.'), 
('K001B19','LH010_19','HV001', N'Có mặt', N'Đầy đủ', 6.0, N'Chú ý thời gian làm bài.'), ('K001B20','LH010_20','HV001', N'Có mặt', N'Đầy đủ', 6.5, N'Có sự tiến bộ rõ rệt ở phần kết bài.'), 
('K001B21','LH010_21','HV001', N'Có mặt', N'Đầy đủ', 6.5, N'Duy trì thái độ học tập rất tốt.'),


-- 2. HV002 (LH019 - Lớp 12 Trung bình - 22 Buổi - ĐI ĐỦ) -> Điểm 5.5 - 6.5

('K002B01','LH019_01','HV002', N'Có mặt', N'Đầy đủ', 6.0, N'Hiểu cốt truyện Vợ Nhặt nhưng diễn đạt lủng củng.'), ('K002B02','LH019_02','HV002', N'Có mặt', N'Thiếu', 5.5, N'Không làm phần đọc hiểu bài tập về nhà.'), 
('K002B03','LH019_03','HV002', N'Có mặt', N'Đầy đủ', 6.5, N'Tập trung nghe giảng, làm phần đọc hiểu khá tốt.'), ('K002B04','LH019_04','HV002', N'Có mặt', N'Đầy đủ', 6.5, N'Đã bắt nhịp được với cách phân tích hình tượng.'), 
('K002B05','LH019_05','HV002', N'Có mặt', N'Đầy đủ', 6.0, N'Phân tích chi tiết bát cháo hành còn hời hợt.'), ('K002B06','LH019_06','HV002', N'Có mặt', N'Đầy đủ', 6.5, N'Chữ viết sạch đẹp. Cố gắng phát biểu nhiều hơn.'), 
('K002B07','LH019_07','HV002', N'Có mặt', N'Đầy đủ', 6.5, N'Kỹ năng làm phần trắc nghiệm Đọc hiểu có cải thiện.'), ('K002B08','LH019_08','HV002', N'Đi muộn', N'Thiếu', 5.5, N'Vào lớp muộn, tẩy xóa bài nhiều.'), 
('K002B09','LH019_09','HV002', N'Có mặt', N'Đầy đủ', 6.0, N'Cần rèn luyện cách liên kết câu.'), ('K002B10','LH019_10','HV002', N'Có mặt', N'Đầy đủ', 6.5, N'Hiểu được tư tưởng cốt lõi của tác phẩm.'), 
('K002B11','LH019_11','HV002', N'Có mặt', N'Đầy đủ', 6.0, N'Phân tích còn lan man, chưa xoáy vào trọng tâm.'), ('K002B12','LH019_12','HV002', N'Có mặt', N'Đầy đủ', 6.5, N'Có tiến bộ, cần phát huy.'), 
('K002B13','LH019_13','HV002', N'Có mặt', N'Đầy đủ', 6.0, N'Bài tập về nhà làm cẩn thận.'), ('K002B14','LH019_14','HV002', N'Có mặt', N'Đầy đủ', 6.5, N'Đạt yêu cầu của bài kiểm tra.'), 
('K002B15','LH019_15','HV002', N'Có mặt', N'Thiếu', 5.5, N'Chưa thuộc lòng trích đoạn thơ.'), ('K002B16','LH019_16','HV002', N'Có mặt', N'Đầy đủ', 6.0, N'Dẫn chứng nghị luận xã hội tốt.'), 
('K002B17','LH019_17','HV002', N'Có mặt', N'Đầy đủ', 6.5, N'Làm bài đầy đủ, thái độ học nghiêm túc.'), ('K002B18','LH019_18','HV002', N'Có mặt', N'Đầy đủ', 6.5, N'Cần đọc thêm sách tham khảo để tăng vốn từ.'), 
('K002B19','LH019_19','HV002', N'Có mặt', N'Đầy đủ', 6.0, N'Đã cải thiện kỹ năng nhận biết thể thơ.'), ('K002B20','LH019_20','HV002', N'Có mặt', N'Đầy đủ', 6.5, N'Tự giác hoàn thành đề cương.'), 
('K002B21','LH019_21','HV002', N'Có mặt', N'Đầy đủ', 6.0, N'Chú ý trình bày rõ ràng hơn.'), ('K002B22','LH019_22','HV002', N'Có mặt', N'Đầy đủ', 6.5, N'Ổn định, sẵn sàng cho kì thi.'),


-- 3. HV003 (LH001 - Lớp 6 Trung bình - 21 Buổi - NGHỈ 2 BUỔI: 04, 06) -> Điểm 5.5 - 7.0

('K003B01','LH001_01','HV003', N'Có mặt', N'Đầy đủ', 6.5, N'Tóm tắt truyện Thánh Gióng tốt nhưng chưa nêu được ý nghĩa.'), ('K003B02','LH001_02','HV003', N'Có mặt', N'Đầy đủ', 7.0, N'Biết cách sử dụng phép nhân hóa trong văn miêu tả.'), 
('K003B03','LH001_03','HV003', N'Có mặt', N'Đầy đủ', 6.0, N'Bài viết hơi ngắn, chưa khai thác hết chi tiết.'), ('K003B04','LH001_04','HV003', N'Vắng', N'Không', 0.0, N'Nghỉ học do gia đình có việc bận.'), 
('K003B05','LH001_05','HV003', N'Có mặt', N'Đầy đủ', 6.5, N'Có tiến bộ trong việc sắp xếp ý, không bị lặp từ.'), ('K003B06','LH001_06','HV003', N'Vắng', N'Không', 0.0, N'Nghỉ học ốm xin phép.'), 
('K003B07','LH001_07','HV003', N'Đi muộn', N'Đầy đủ', 6.5, N'Vào lớp muộn nhưng rất chú ý lắng nghe cô giảng.'), ('K003B08','LH001_08','HV003', N'Có mặt', N'Đầy đủ', 7.0, N'Văn phong sáng tạo, biết đặt mình vào nhân vật.'), 
('K003B09','LH001_09','HV003', N'Có mặt', N'Đầy đủ', 6.5, N'Làm bài đầy đủ, chữ viết đẹp.'), ('K003B10','LH001_10','HV003', N'Có mặt', N'Thiếu', 5.5, N'Không làm phần bài tập tiếng việt.'), 
('K003B11','LH001_11','HV003', N'Có mặt', N'Đầy đủ', 6.5, N'Khắc phục được lỗi sai chính tả cơ bản.'), ('K003B12','LH001_12','HV003', N'Có mặt', N'Đầy đủ', 6.0, N'Cần đọc kĩ đề bài trước khi làm.'), 
('K003B13','LH001_13','HV003', N'Có mặt', N'Đầy đủ', 7.0, N'Miêu tả cảnh sinh động, có cảm xúc.'), ('K003B14','LH001_14','HV003', N'Có mặt', N'Đầy đủ', 6.5, N'Đã biết cách lập dàn ý trước khi làm bài.'), 
('K003B15','LH001_15','HV003', N'Có mặt', N'Đầy đủ', 6.0, N'Kết bài còn hơi lửng lơ.'), ('K003B16','LH001_16','HV003', N'Có mặt', N'Đầy đủ', 6.5, N'Hoàn thành bài tập về nhà rất chu đáo.'), 
('K003B17','LH001_17','HV003', N'Có mặt', N'Đầy đủ', 7.0, N'Nắm vững kiến thức truyện dân gian.'), ('K003B18','LH001_18','HV003', N'Có mặt', N'Đầy đủ', 6.5, N'Tích cực giơ tay phát biểu.'), 
('K003B19','LH001_19','HV003', N'Có mặt', N'Thiếu', 6.0, N'Bài văn tự sự thiếu phần thân bài.'), ('K003B20','LH001_20','HV003', N'Có mặt', N'Đầy đủ', 6.5, N'Cải thiện cách sử dụng dấu câu.'), 
('K003B21','LH001_21','HV003', N'Có mặt', N'Đầy đủ', 7.0, N'Kiểm tra định kỳ đạt kết quả khá tốt.'),


-- 4. HV004 (LH007 - Lớp 8 Trung bình - 22 Buổi - ĐI ĐỦ) -> Điểm 5.5 - 6.5

('K004B01','LH007_01','HV004', N'Đi muộn', N'Thiếu', 5.5, N'Đi muộn. Không thuộc lòng bài thơ Nhớ Rừng.'), ('K004B02','LH007_02','HV004', N'Có mặt', N'Đầy đủ', 6.5, N'Hiểu bài nhưng làm bài kiểm tra quá chậm.'), 
('K004B03','LH007_03','HV004', N'Có mặt', N'Đầy đủ', 6.0, N'Phân tích bức tranh làng chài trong bài Quê Hương còn sơ sài.'), ('K004B04','LH007_04','HV004', N'Có mặt', N'Đầy đủ', 6.5, N'Đã biết cách lập dàn ý trước khi làm bài.'), 
('K004B05','LH007_05','HV004', N'Có mặt', N'Đầy đủ', 6.0, N'Bài văn thuyết minh chưa có đủ các phương pháp cơ bản.'), ('K004B06','LH007_06','HV004', N'Có mặt', N'Đầy đủ', 6.0, N'Đã thuộc bài Hịch tướng sĩ. Trợ giảng đã kiểm tra.'), 
('K004B07','LH007_07','HV004', N'Có mặt', N'Đầy đủ', 6.5, N'Đoạn văn nghị luận có ý tưởng nhưng dùng từ chưa đắt giá.'), ('K004B08','LH007_08','HV004', N'Có mặt', N'Thiếu', 5.5, N'Làm thiếu 2 câu bài tập tiếng việt.'), 
('K004B09','LH007_09','HV004', N'Có mặt', N'Đầy đủ', 6.5, N'Có ý thức chữa bài sau khi làm sai.'), ('K004B10','LH007_10','HV004', N'Có mặt', N'Đầy đủ', 6.0, N'Cần mở rộng vốn từ khi viết văn nghị luận.'), 
('K004B11','LH007_11','HV004', N'Có mặt', N'Đầy đủ', 6.5, N'Tiến bộ trong việc xác định luận điểm chính.'), ('K004B12','LH007_12','HV004', N'Có mặt', N'Đầy đủ', 6.0, N'Chữ viết rõ ràng, dễ đọc.'), 
('K004B13','LH007_13','HV004', N'Có mặt', N'Đầy đủ', 6.5, N'Làm bài kiểm tra có sự đầu tư thời gian.'), ('K004B14','LH007_14','HV004', N'Có mặt', N'Thiếu', 5.5, N'Quên nộp vở soạn văn bài Tức cảnh Pác Bó.'), 
('K004B15','LH007_15','HV004', N'Có mặt', N'Đầy đủ', 6.0, N'Đã phân tích được tâm trạng nhân vật.'), ('K004B16','LH007_16','HV004', N'Có mặt', N'Đầy đủ', 6.5, N'Bài làm khá ổn định, đạt yêu cầu.'), 
('K004B17','LH007_17','HV004', N'Có mặt', N'Đầy đủ', 6.5, N'Tích cực xây dựng bài trên lớp.'), ('K004B18','LH007_18','HV004', N'Có mặt', N'Đầy đủ', 6.0, N'Đọc hiểu văn bản làm trọn vẹn điểm.'), 
('K004B19','LH007_19','HV004', N'Có mặt', N'Đầy đủ', 6.5, N'Đoạn văn viết mạch lạc, không lặp từ.'), ('K004B20','LH007_20','HV004', N'Có mặt', N'Đầy đủ', 6.0, N'Cần ôn kĩ phần tác giả tác phẩm.'), 
('K004B21','LH007_21','HV004', N'Có mặt', N'Đầy đủ', 6.5, N'Điểm tổng kết cuối tháng khá tốt.'), ('K004B22','LH007_22','HV004', N'Có mặt', N'Đầy đủ', 6.5, N'Sẵn sàng cho kỳ thi học kỳ sắp tới.'),


-- 5. HV005 (LH011 - Lớp 9 Khá - 21 Buổi - ĐI ĐỦ) -> Điểm 7.0 - 8.0

('K005B01','LH011_01','HV005', N'Có mặt', N'Đầy đủ', 7.5, N'Hành văn lưu loát, phân tích tốt truyện Lặng Lẽ Sa Pa.'), ('K005B02','LH011_02','HV005', N'Có mặt', N'Đầy đủ', 8.0, N'Mở bài rất thu hút. Lập luận chặt chẽ.'), 
('K005B03','LH011_03','HV005', N'Có mặt', N'Đầy đủ', 7.5, N'Phân tích nhân vật rất chi tiết và logic.'), ('K005B04','LH011_04','HV005', N'Có mặt', N'Đầy đủ', 7.5, N'Kiến thức bài Chiếc lược ngà rất tốt, cần luyện thêm tốc độ.'), 
('K005B05','LH011_05','HV005', N'Có mặt', N'Đầy đủ', 8.0, N'Phân tích chi tiết cái bóng rất sâu sắc.'), ('K005B06','LH011_06','HV005', N'Đi muộn', N'Đầy đủ', 7.0, N'Vào lớp muộn. Bài kiểm tra viết chữ hơi ẩu.'), 
('K005B07','LH011_07','HV005', N'Có mặt', N'Thiếu', 6.5, N'Làm trắc nghiệm sai 3 câu. Cần chú ý hơn.'), ('K005B08','LH011_08','HV005', N'Có mặt', N'Đầy đủ', 8.0, N'Đã cải thiện kỹ năng kết bài mở rộng. Bài làm tròn trịa.'), 
('K005B09','LH011_09','HV005', N'Có mặt', N'Đầy đủ', 7.5, N'Sử dụng nhiều dẫn chứng nghị luận xã hội đắt giá.'), ('K005B10','LH011_10','HV005', N'Có mặt', N'Đầy đủ', 8.0, N'Hoàn thành xuất sắc bài thi 15 phút.'), 
('K005B11','LH011_11','HV005', N'Có mặt', N'Đầy đủ', 7.5, N'Bài viết rất có cảm xúc.'), ('K005B12','LH011_12','HV005', N'Có mặt', N'Đầy đủ', 8.0, N'Giữ vững phong độ học tập tốt.'), 
('K005B13','LH011_13','HV005', N'Có mặt', N'Đầy đủ', 7.5, N'Cách liên kết giữa các đoạn văn rất mượt mà.'), ('K005B14','LH011_14','HV005', N'Có mặt', N'Đầy đủ', 7.0, N'Phần Đọc hiểu thi thoảng vẫn mắc bẫy từ vựng.'), 
('K005B15','LH011_15','HV005', N'Có mặt', N'Đầy đủ', 8.0, N'Phân tích tình cảm cha con ông Sáu gây xúc động mạnh.'), ('K005B16','LH011_16','HV005', N'Có mặt', N'Đầy đủ', 7.5, N'Rất tích cực phát biểu xây dựng bài.'), 
('K005B17','LH011_17','HV005', N'Có mặt', N'Đầy đủ', 8.0, N'Đề cương ôn thi làm chi tiết, khoa học.'), ('K005B18','LH011_18','HV005', N'Có mặt', N'Đầy đủ', 7.5, N'Cần phân bổ thời gian hợp lý hơn cho câu nghị luận.'), 
('K005B19','LH011_19','HV005', N'Có mặt', N'Đầy đủ', 8.0, N'Chữ viết đẹp, trình bày sạch sẽ.'), ('K005B20','LH011_20','HV005', N'Có mặt', N'Đầy đủ', 7.5, N'Bài viết trọn vẹn, lập luận sắc bén.'), 
('K005B21','LH011_21','HV005', N'Có mặt', N'Đầy đủ', 8.0, N'Đạt điểm cao trong kì thi thử tháng 5.'),


-- 6. HV006 (LH020 - Lớp 12 Khá - 22 Buổi - ĐI ĐỦ) -> Điểm 7.0 - 8.5

('K006B01','LH020_01','HV006', N'Có mặt', N'Đầy đủ', 7.5, N'Nắm vững phong cách nghệ thuật của Nguyễn Tuân.'), ('K006B02','LH020_02','HV006', N'Đi muộn', N'Đầy đủ', 7.0, N'Vào lớp muộn 10p. Trình bày bài thi thử còn tẩy xóa.'), 
('K006B03','LH020_03','HV006', N'Có mặt', N'Đầy đủ', 8.5, N'Đạt điểm cao. Phân tích Chiếc thuyền ngoài xa rất sâu sắc.'), ('K006B04','LH020_04','HV006', N'Có mặt', N'Thiếu', 6.5, N'Chưa làm đủ đề cương ôn tập.'), 
('K006B05','LH020_05','HV006', N'Có mặt', N'Đầy đủ', 8.0, N'Viết luận văn xã hội 200 chữ rất xuất sắc, dẫn chứng phong phú.'), ('K006B06','LH020_06','HV006', N'Có mặt', N'Đầy đủ', 7.5, N'Phân tích nhân vật Phùng khá tốt, cần trau chuốt câu từ.'), 
('K006B07','LH020_07','HV006', N'Có mặt', N'Đầy đủ', 7.5, N'Làm trọn vẹn điểm phần Đọc hiểu. Cần chú ý thời gian.'), ('K006B08','LH020_08','HV006', N'Có mặt', N'Đầy đủ', 8.0, N'Phong độ rất ổn định, tự tin hướng tới kỳ thi.'), 
('K006B09','LH020_09','HV006', N'Có mặt', N'Đầy đủ', 7.5, N'Hiểu bài tốt, vận dụng lí luận văn học vào bài làm.'), ('K006B10','LH020_10','HV006', N'Có mặt', N'Đầy đủ', 8.0, N'Bài viết rất có chiều sâu.'), 
('K006B11','LH020_11','HV006', N'Có mặt', N'Đầy đủ', 7.5, N'Cần mở rộng thêm phần liên hệ thực tế.'), ('K006B12','LH020_12','HV006', N'Có mặt', N'Đầy đủ', 8.0, N'Phân tích thơ Sóng của Xuân Quỳnh cực kỳ tinh tế.'), 
('K006B13','LH020_13','HV006', N'Có mặt', N'Đầy đủ', 7.5, N'Hành văn mạch lạc, rõ ràng các luận điểm.'), ('K006B14','LH020_14','HV006', N'Có mặt', N'Đầy đủ', 8.0, N'Hoàn thành 100% bài tập về nhà trong tuần.'), 
('K006B15','LH020_15','HV006', N'Có mặt', N'Thiếu', 7.0, N'Bài làm hơi ngắn do phân bổ thời gian sai.'), ('K006B16','LH020_16','HV006', N'Có mặt', N'Đầy đủ', 7.5, N'Sửa được lỗi diễn đạt lủng củng.'), 
('K006B17','LH020_17','HV006', N'Có mặt', N'Đầy đủ', 8.5, N'Đạt điểm tuyệt đối phần nghị luận xã hội.'), ('K006B18','LH020_18','HV006', N'Có mặt', N'Đầy đủ', 8.0, N'Giữ vững phong độ luyện đề.'), 
('K006B19','LH020_19','HV006', N'Có mặt', N'Đầy đủ', 7.5, N'Làm bài cẩn thận, không có lỗi chính tả.'), ('K006B20','LH020_20','HV006', N'Có mặt', N'Đầy đủ', 8.0, N'Tư duy phân tích đề rất sắc sảo.'), 
('K006B21','LH020_21','HV006', N'Có mặt', N'Đầy đủ', 8.0, N'Hoàn thành xuất sắc bài thi thử đợt 2.'), ('K006B22','LH020_22','HV006', N'Có mặt', N'Đầy đủ', 8.5, N'Sẵn sàng 100% cho kì thi THPT QG.'),


-- 7. HV008 (LH013 - Lớp 10 Trung bình - 21 Buổi - ĐI ĐỦ) -> Điểm 5.5 - 6.5

('K008B01','LH013_01','HV008', N'Có mặt', N'Đầy đủ', 6.0, N'Phân tích Bình Ngô Đại Cáo còn giống như diễn xuôi.'), ('K008B02','LH013_02','HV008', N'Có mặt', N'Đầy đủ', 6.5, N'Đã thuộc các dẫn chứng, cần liên kết câu mượt hơn.'), 
('K008B03','LH013_03','HV008', N'Có mặt', N'Đầy đủ', 6.5, N'Có cố gắng ghi chép bài đầy đủ.'), ('K008B04','LH013_04','HV008', N'Có mặt', N'Đầy đủ', 6.0, N'Chưa nắm vững đặc trưng của thể loại Phú.'), 
('K008B05','LH013_05','HV008', N'Có mặt', N'Thiếu', 5.5, N'Mất tập trung, không làm bài tập phần Tiếng Việt.'), ('K008B06','LH013_06','HV008', N'Có mặt', N'Đầy đủ', 6.5, N'Mở bài thu hút nhưng thân bài lặp ý.'), 
('K008B07','LH013_07','HV008', N'Đi muộn', N'Đầy đủ', 6.0, N'Đi muộn 15 phút. Sai nhiều lỗi chính tả.'), ('K008B08','LH013_08','HV008', N'Có mặt', N'Đầy đủ', 6.5, N'Đã cải thiện kỹ năng tóm tắt văn bản.'), 
('K008B09','LH013_09','HV008', N'Có mặt', N'Đầy đủ', 6.0, N'Trình bày bài kiểm tra còn hơi ẩu.'), ('K008B10','LH013_10','HV008', N'Có mặt', N'Đầy đủ', 6.5, N'Có tiến bộ trong việc học thuộc thơ.'), 
('K008B11','LH013_11','HV008', N'Có mặt', N'Đầy đủ', 6.0, N'Cần đọc kĩ đề trước khi làm bài.'), ('K008B12','LH013_12','HV008', N'Có mặt', N'Đầy đủ', 6.5, N'Hoàn thành bài trên lớp đúng giờ.'), 
('K008B13','LH013_13','HV008', N'Có mặt', N'Thiếu', 5.5, N'Quên nộp bài tập về nhà tuần này.'), ('K008B14','LH013_14','HV008', N'Có mặt', N'Đầy đủ', 6.0, N'Bài viết văn tự sự có cảm xúc nhưng hơi ngắn.'), 
('K008B15','LH013_15','HV008', N'Có mặt', N'Đầy đủ', 6.5, N'Đã biết cách chia đoạn văn hợp lý.'), ('K008B16','LH013_16','HV008', N'Có mặt', N'Đầy đủ', 6.0, N'Hiểu bài, làm trắc nghiệm Đọc hiểu tốt.'), 
('K008B17','LH013_17','HV008', N'Có mặt', N'Đầy đủ', 6.5, N'Chăm chỉ phát biểu xây dựng bài.'), ('K008B18','LH013_18','HV008', N'Có mặt', N'Đầy đủ', 6.0, N'Đoạn văn nghị luận xã hội còn thiếu dẫn chứng.'), 
('K008B19','LH013_19','HV008', N'Có mặt', N'Đầy đủ', 6.5, N'Đã khắc phục lỗi chính tả.'), ('K008B20','LH013_20','HV008', N'Có mặt', N'Đầy đủ', 6.0, N'Kết bài cần được trau chuốt hơn.'), 
('K008B21','LH013_21','HV008', N'Có mặt', N'Đầy đủ', 6.5, N'Thái độ học tập luôn nghiêm túc.'),


-- 8. HV009 (LH012 - Lớp 9 Giỏi - 22 Buổi - ĐI ĐỦ) -> Điểm 8.5 - 9.5

('K009B01','LH012_01','HV009', N'Có mặt', N'Đầy đủ', 9.0, N'Tư duy phản biện bài Nghị luận xã hội cực kỳ xuất sắc.'), ('K009B02','LH012_02','HV009', N'Có mặt', N'Đầy đủ', 8.5, N'Phân tích bài Bếp lửa dạt dào cảm xúc.'), 
('K009B03','LH012_03','HV009', N'Có mặt', N'Đầy đủ', 9.5, N'Hoàn thành xuất sắc bài thi thử vào 10. Điểm Đọc hiểu tuyệt đối.'), ('K009B04','LH012_04','HV009', N'Có mặt', N'Đầy đủ', 9.0, N'Văn phong mạch lạc, chững chạc. Có tố chất.'), 
('K009B05','LH012_05','HV009', N'Có mặt', N'Đầy đủ', 9.0, N'Bài viết điểm tuyệt đối nhờ mở bài cực kỳ lôi cuốn.'), ('K009B06','LH012_06','HV009', N'Có mặt', N'Đầy đủ', 9.5, N'Dẫn dắt mở bài bằng thơ Chế Lan Viên rất hay.'), 
('K009B07','LH012_07','HV009', N'Có mặt', N'Thiếu', 8.0, N'Quên nộp BTVN làm thêm nhưng bài trên lớp vẫn tốt.'), ('K009B08','LH012_08','HV009', N'Có mặt', N'Đầy đủ', 9.0, N'Cảm nhận vẻ đẹp khuất lấp của nhân vật sắc sảo.'), 
('K009B09','LH012_09','HV009', N'Có mặt', N'Đầy đủ', 9.5, N'Hoàn thiện xuất sắc các câu hỏi nâng cao.'), ('K009B10','LH012_10','HV009', N'Có mặt', N'Đầy đủ', 9.0, N'Luôn dẫn đầu lớp trong các bài kiểm tra.'), 
('K009B11','LH012_11','HV009', N'Có mặt', N'Đầy đủ', 8.5, N'Trình bày sạch đẹp, ý tứ rõ ràng, không mắc lỗi.'), ('K009B12','LH012_12','HV009', N'Có mặt', N'Đầy đủ', 9.0, N'Có sự sáng tạo trong cách phân tích tác phẩm.'), 
('K009B13','LH012_13','HV009', N'Có mặt', N'Đầy đủ', 9.5, N'Hiểu cực kỳ sâu sắc giá trị nhân đạo của tác phẩm.'), ('K009B14','LH012_14','HV009', N'Có mặt', N'Đầy đủ', 9.0, N'Sử dụng từ ngữ trau chuốt, giàu hình ảnh.'), 
('K009B15','LH012_15','HV009', N'Có mặt', N'Đầy đủ', 8.5, N'Đã hoàn thành toàn bộ đề cương ôn thi học kì.'), ('K009B16','LH012_16','HV009', N'Có mặt', N'Đầy đủ', 9.0, N'Biết cách so sánh mở rộng các tác phẩm cùng chủ đề.'), 
('K009B17','LH012_17','HV009', N'Có mặt', N'Đầy đủ', 9.5, N'Văn phong cuốn hút, lập luận logic và chặt chẽ.'), ('K009B18','LH012_18','HV009', N'Có mặt', N'Đầy đủ', 9.0, N'Đạt điểm 10 phần Đọc hiểu Tiếng Việt.'), 
('K009B19','LH012_19','HV009', N'Có mặt', N'Đầy đủ', 8.5, N'Giữ vững phong độ cao trong suốt thời gian dài.'), ('K009B20','LH012_20','HV009', N'Có mặt', N'Đầy đủ', 9.0, N'Bài thi thử đạt kết quả rất đáng khen ngợi.'), 
('K009B21','LH012_21','HV009', N'Có mặt', N'Đầy đủ', 9.5, N'Tuyệt đối tự tin hướng tới kì thi chuyển cấp.'), ('K009B22','LH012_22','HV009', N'Có mặt', N'Đầy đủ', 9.0, N'Học sinh ưu tú của trung tâm.'),


-- 9. HV010 (LH021 - Lớp 12 Giỏi - 22 Buổi - NGHỈ 1 BUỔI: 07) -> Điểm 8.5 - 9.5

('K010B01','LH021_01','HV010', N'Có mặt', N'Đầy đủ', 9.0, N'Khả năng cảm thụ văn học cực tốt. Văn phong dạt dào cảm xúc.'), ('K010B02','LH021_02','HV010', N'Có mặt', N'Đầy đủ', 9.5, N'Điểm thi thử đạt loại Xuất sắc. Lập luận đanh thép.'), 
('K010B03','LH021_03','HV010', N'Có mặt', N'Đầy đủ', 9.0, N'Trình bày bài thi sạch đẹp, không mắc một lỗi chính tả nào.'), ('K010B04','LH021_04','HV010', N'Đi muộn', N'Đầy đủ', 8.5, N'Mở bài rất sáng tạo nhưng phần thân bài hơi ngắn.'), 
('K010B05','LH021_05','HV010', N'Có mặt', N'Đầy đủ', 9.5, N'Tuyệt vời! Phân tích chất vàng mười trong Người lái đò sông Đà.'), ('K010B06','LH021_06','HV010', N'Có mặt', N'Đầy đủ', 9.0, N'Nghị luận xã hội đưa được dẫn chứng rất thời sự.'), 
('K010B07','LH021_07','HV010', N'Vắng', N'Không', 0.0, N'Nghỉ ốm xin phép.'), ('K010B08','LH021_08','HV010', N'Có mặt', N'Đầy đủ', 9.0, N'Luôn giữ vững vị trí dẫn đầu lớp. Sẵn sàng cho kỳ thi.'), 
('K010B09','LH021_09','HV010', N'Có mặt', N'Đầy đủ', 9.5, N'Khắc phục tốt sau buổi nghỉ, chép bài đầy đủ.'), ('K010B10','LH021_10','HV010', N'Có mặt', N'Đầy đủ', 9.0, N'Phân tích tùy bút Ai đã đặt tên cho dòng sông rất hay.'), 
('K010B11','LH021_11','HV010', N'Có mặt', N'Đầy đủ', 8.5, N'Văn phong luôn mang dấu ấn cá nhân rõ nét.'), ('K010B12','LH021_12','HV010', N'Có mặt', N'Đầy đủ', 9.0, N'Phần mở bài luôn là điểm sáng của bài viết.'), 
('K010B13','LH021_13','HV010', N'Có mặt', N'Đầy đủ', 9.5, N'Giải quyết trọn vẹn đề thi thử khó của trung tâm.'), ('K010B14','LH021_14','HV010', N'Có mặt', N'Đầy đủ', 9.0, N'Biết kết hợp linh hoạt các thao tác lập luận.'), 
('K010B15','LH021_15','HV010', N'Có mặt', N'Đầy đủ', 8.5, N'Có sự chuẩn bị bài rất kĩ ở nhà.'), ('K010B16','LH021_16','HV010', N'Có mặt', N'Đầy đủ', 9.0, N'Phát biểu xây dựng bài sôi nổi, ý kiến sắc sảo.'), 
('K010B17','LH021_17','HV010', N'Có mặt', N'Đầy đủ', 9.5, N'Cảm nhận được chiều sâu tư tưởng của tác phẩm Vợ Nhặt.'), ('K010B18','LH021_18','HV010', N'Có mặt', N'Đầy đủ', 9.0, N'Chữ viết rõ ràng, cách chia đoạn mạch lạc.'), 
('K010B19','LH021_19','HV010', N'Có mặt', N'Đầy đủ', 8.5, N'Duy trì sự tập trung cao độ trong các buổi luyện đề.'), ('K010B20','LH021_20','HV010', N'Có mặt', N'Đầy đủ', 9.0, N'Phân tích Vợ chồng A Phủ xuất sắc.'), 
('K010B21','LH021_21','HV010', N'Có mặt', N'Đầy đủ', 9.5, N'Top 1 học sinh giỏi của khối 12 tháng này.'), ('K010B22','LH021_22','HV010', N'Có mặt', N'Đầy đủ', 9.0, N'Sẵn sàng bứt phá tại kì thi THPT Quốc Gia.'),


-- 10. HV011 (LH002 - Lớp 6 Khá - 21 Buổi - ĐI ĐỦ) -> Điểm 7.0 - 8.0

('K011B01','LH002_01','HV011', N'Có mặt', N'Thiếu', 6.5, N'Không làm BTVN. Cần rút kinh nghiệm thái độ học tập.'), ('K011B02','LH002_02','HV011', N'Có mặt', N'Đầy đủ', 7.5, N'Đã khắc phục lỗi lười học. Bài viết văn miêu tả tiến bộ.'), 
('K011B03','LH002_03','HV011', N'Có mặt', N'Đầy đủ', 7.0, N'Chữ viết đôi chỗ còn khó đọc. Biết dùng từ láy biểu cảm.'), ('K011B04','LH002_04','HV011', N'Có mặt', N'Đầy đủ', 8.0, N'Làm bài kiểm tra 15p đạt điểm tuyệt đối. Rất đáng khen.'), 
('K011B05','LH002_05','HV011', N'Có mặt', N'Đầy đủ', 7.5, N'Đã chép bài đầy đủ. Tiếp thu bài kể chuyện tốt.'), ('K011B06','LH002_06','HV011', N'Có mặt', N'Đầy đủ', 7.5, N'Tiếp thu bài nhanh và chăm chỉ phát biểu.'), 
('K011B07','LH002_07','HV011', N'Đi muộn', N'Đầy đủ', 7.0, N'Vào lớp muộn 5p. Cần đọc kĩ đề bài hơn để không bị lạc đề.'), ('K011B08','LH002_08','HV011', N'Có mặt', N'Đầy đủ', 8.0, N'Sáng tạo trong cách miêu tả nhân vật. Bài làm có cảm xúc.'), 
('K011B09','LH002_09','HV011', N'Có mặt', N'Đầy đủ', 7.5, N'Trí tưởng tượng phong phú khi làm văn tự sự.'), ('K011B10','LH002_10','HV011', N'Có mặt', N'Đầy đủ', 8.0, N'Làm tốt bài tập Đọc hiểu truyện dân gian.'), 
('K011B11','LH002_11','HV011', N'Có mặt', N'Đầy đủ', 7.0, N'Mở bài tốt nhưng kết bài còn viết hơi vội.'), ('K011B12','LH002_12','HV011', N'Có mặt', N'Đầy đủ', 7.5, N'Đã biết cách sử dụng phép nhân hóa, so sánh.'), 
('K011B13','LH002_13','HV011', N'Có mặt', N'Đầy đủ', 8.0, N'Luôn hăng hái tham gia bài giảng của cô.'), ('K011B14','LH002_14','HV011', N'Có mặt', N'Đầy đủ', 7.5, N'Chữ viết có nhiều sự tiến bộ, sạch đẹp hơn.'), 
('K011B15','LH002_15','HV011', N'Có mặt', N'Thiếu', 6.5, N'Quên mang tài liệu học tập buổi nay.'), ('K011B16','LH002_16','HV011', N'Có mặt', N'Đầy đủ', 7.5, N'Bố cục bài viết rõ ràng 3 phần.'), 
('K011B17','LH002_17','HV011', N'Có mặt', N'Đầy đủ', 8.0, N'Cảm thụ văn học rất tốt ở độ tuổi lớp 6.'), ('K011B18','LH002_18','HV011', N'Có mặt', N'Đầy đủ', 7.0, N'Phần tiếng Việt cần chú ý nhận diện đúng cụm danh từ.'), 
('K011B19','LH002_19','HV011', N'Có mặt', N'Đầy đủ', 7.5, N'Đã hoàn thành toàn bộ bài tập tuần.'), ('K011B20','LH002_20','HV011', N'Có mặt', N'Đầy đủ', 8.0, N'Đạt điểm cao trong kì thi cuối kì.'), 
('K011B21','LH002_21','HV011', N'Có mặt', N'Đầy đủ', 7.5, N'Thái độ học tập luôn đáng khen ngợi.'),


-- 11. HV012 (LH004 - Lớp 7 Trung bình - 21 Buổi - NGHỈ 1 BUỔI: 02) -> Điểm 5.0 - 6.5

('K012B01','LH004_01','HV012', N'Có mặt', N'Đầy đủ', 6.0, N'Chưa phân biệt được các câu tục ngữ có ý nghĩa trái ngược.'), ('K012B02','LH004_02','HV012', N'Vắng', N'Không', 0.0, N'Học sinh xin nghỉ về quê.'), 
('K012B03','LH004_03','HV012', N'Có mặt', N'Đầy đủ', 6.5, N'Bài văn nghị luận giải thích làm khá tốt, có dẫn chứng.'), ('K012B04','LH004_04','HV012', N'Có mặt', N'Thiếu', 5.0, N'Lười làm BTVN. Điểm kiểm tra 15p thấp do không học bài cũ.'), 
('K012B05','LH004_05','HV012', N'Có mặt', N'Đầy đủ', 6.5, N'Đã tiến bộ hơn, có ý thức nghe giảng và ghi chép bài.'), ('K012B06','LH004_06','HV012', N'Đi muộn', N'Đầy đủ', 6.0, N'Đoạn văn chứng minh còn thiếu lý lẽ thuyết phục.'), 
('K012B07','LH004_07','HV012', N'Có mặt', N'Đầy đủ', 6.5, N'Chữ viết sạch đẹp, trình bày rõ ràng 3 phần Mở - Thân - Kết.'), ('K012B08','LH004_08','HV012', N'Có mặt', N'Đầy đủ', 6.5, N'Phân tích bài Đức tính giản dị của Bác Hồ rất tốt.'), 
('K012B09','LH004_09','HV012', N'Có mặt', N'Đầy đủ', 6.0, N'Hiểu bài nhưng còn rụt rè chưa dám phát biểu.'), ('K012B10','LH004_10','HV012', N'Có mặt', N'Đầy đủ', 6.5, N'Bài làm khá ổn định.'), 
('K012B11','LH004_11','HV012', N'Có mặt', N'Đầy đủ', 6.0, N'Lập luận chứng minh còn hơi lủng củng.'), ('K012B12','LH004_12','HV012', N'Có mặt', N'Đầy đủ', 6.5, N'Cải thiện được kĩ năng tìm luận điểm.'), 
('K012B13','LH004_13','HV012', N'Có mặt', N'Đầy đủ', 6.0, N'Mở bài trực tiếp vẫn chưa thật sự thu hút.'), ('K012B14','LH004_14','HV012', N'Có mặt', N'Đầy đủ', 6.5, N'Hoàn thành bài tập về nhà đầy đủ.'), 
('K012B15','LH004_15','HV012', N'Có mặt', N'Thiếu', 5.5, N'Quên đem sách giáo khoa, bị trừ điểm ý thức.'), ('K012B16','LH004_16','HV012', N'Có mặt', N'Đầy đủ', 6.0, N'Phần Tiếng Việt còn nhầm lẫn trạng ngữ.'), 
('K012B17','LH004_17','HV012', N'Có mặt', N'Đầy đủ', 6.5, N'Đã biết cách sử dụng câu bị động trong đoạn văn.'), ('K012B18','LH004_18','HV012', N'Có mặt', N'Đầy đủ', 6.5, N'Thái độ học tập trên lớp rất tốt.'), 
('K012B19','LH004_19','HV012', N'Có mặt', N'Đầy đủ', 6.0, N'Bài viết đạt mức trung bình khá.'), ('K012B20','LH004_20','HV012', N'Có mặt', N'Đầy đủ', 6.5, N'Nắm vững nội dung bài Tinh thần yêu nước của nhân dân ta.'), 
('K012B21','LH004_21','HV012', N'Có mặt', N'Đầy đủ', 6.0, N'Cần đọc kĩ đề bài để không bị lạc đề.'),


-- 12. HV013 (LH010 - Lớp 9 Trung bình - 21 Buổi - NGHỈ 1 BUỔI: 08) -> Điểm 5.5 - 6.5

('K013B01','LH010_01','HV013', N'Có mặt', N'Đầy đủ', 6.5, N'Nắm được hệ thống luận điểm nhưng phân tích còn sơ sài.'), ('K013B02','LH010_02','HV013', N'Có mặt', N'Đầy đủ', 6.0, N'Mở bài tốt nhưng thân bài bị lạc đề sang tác phẩm khác.'), 
('K013B03','LH010_03','HV013', N'Có mặt', N'Đầy đủ', 6.0, N'Làm bài kiểm tra có tiến bộ, điểm phần Tiếng Việt khá.'), ('K013B04','LH010_04','HV013', N'Có mặt', N'Thiếu', 5.5, N'Chưa nộp vở bài tập tuần trước. Dựa dẫm tài liệu.'), 
('K013B05','LH010_05','HV013', N'Có mặt', N'Đầy đủ', 6.5, N'Hôm nay làm bài rất nghiêm túc, diễn đạt đã trôi chảy hơn.'), ('K013B06','LH010_06','HV013', N'Đi muộn', N'Đầy đủ', 6.0, N'Đi muộn 10p do kẹt xe. Chữ viết cần rõ ràng hơn.'), 
('K013B07','LH010_07','HV013', N'Có mặt', N'Đầy đủ', 6.5, N'Làm được phần lớn bài tập ôn luyện ngữ pháp Tiếng Việt.'), ('K013B08','LH010_08','HV013', N'Vắng', N'Không', 0.0, N'Nghỉ học xin phép ốm.'), 
('K013B09','LH010_09','HV013', N'Có mặt', N'Đầy đủ', 6.0, N'Chép bài bù đầy đủ. Còn lúng túng khi xác định luận điểm.'), ('K013B10','LH010_10','HV013', N'Có mặt', N'Đầy đủ', 6.5, N'Làm bài thi 15 phút đạt yêu cầu.'), 
('K013B11','LH010_11','HV013', N'Có mặt', N'Đầy đủ', 6.0, N'Phân tích nhân vật anh thanh niên còn thiếu dẫn chứng.'), ('K013B12','LH010_12','HV013', N'Có mặt', N'Đầy đủ', 6.5, N'Đã cải thiện cách chia đoạn trong bài văn.'), 
('K013B13','LH010_13','HV013', N'Có mặt', N'Đầy đủ', 6.0, N'Chữ viết cần được cải thiện để chấm thi dễ đọc hơn.'), ('K013B14','LH010_14','HV013', N'Có mặt', N'Đầy đủ', 6.5, N'Hoàn thành bài tập về nhà nghiêm túc.'), 
('K013B15','LH010_15','HV013', N'Có mặt', N'Thiếu', 5.5, N'Lười đọc trước tác phẩm mới ở nhà.'), ('K013B16','LH010_16','HV013', N'Có mặt', N'Đầy đủ', 6.0, N'Phần Tiếng Việt làm khá tốt.'), 
('K013B17','LH010_17','HV013', N'Có mặt', N'Đầy đủ', 6.5, N'Biết áp dụng các thao tác lập luận bác bỏ.'), ('K013B18','LH010_18','HV013', N'Có mặt', N'Đầy đủ', 6.5, N'Đạt điểm trung bình khá trong bài thi thử.'), 
('K013B19','LH010_19','HV013', N'Có mặt', N'Đầy đủ', 6.0, N'Cần ôn kĩ phần tác giả, hoàn cảnh sáng tác.'), ('K013B20','LH010_20','HV013', N'Có mặt', N'Đầy đủ', 6.5, N'Thái độ học tập trên lớp ngoan, có cố gắng.'), 
('K013B21','LH010_21','HV013', N'Có mặt', N'Đầy đủ', 6.0, N'Kết bài cần được đầu tư thêm thời gian.'),


-- 13. HV014 (LH019 - Lớp 12 Trung bình - 22 Buổi - ĐI ĐỦ) -> Điểm 5.5 - 6.5

('K014B01','LH019_01','HV014', N'Có mặt', N'Đầy đủ', 6.0, N'Thời gian phân bổ làm bài thi chưa hợp lý. Bỏ trống câu NLVH.'), ('K014B02','LH019_02','HV014', N'Có mặt', N'Đầy đủ', 6.5, N'Cảm nhận được giá trị nhân đạo trong Vợ Nhặt.'), 
('K014B03','LH019_03','HV014', N'Có mặt', N'Đầy đủ', 6.5, N'Chú ý nghe giảng, phân tích hình tượng sóng tốt.'), ('K014B04','LH019_04','HV014', N'Có mặt', N'Thiếu', 5.5, N'Lên bảng trả bài cũ không thuộc thơ bài Sóng.'), 
('K014B05','LH019_05','HV014', N'Có mặt', N'Đầy đủ', 6.0, N'Chưa biết cách kết hợp các thao tác lập luận.'), ('K014B06','LH019_06','HV014', N'Đi muộn', N'Đầy đủ', 6.5, N'Đã cải thiện kỹ năng làm phần Đọc hiểu.'), 
('K014B07','LH019_07','HV014', N'Có mặt', N'Đầy đủ', 6.0, N'Bài viết chưa sâu, các luận điểm về Tây Tiến còn chung chung.'), ('K014B08','LH019_08','HV014', N'Có mặt', N'Đầy đủ', 6.5, N'Thái độ học tập tích cực hơn, cố gắng phát huy.'), 
('K014B09','LH019_09','HV014', N'Có mặt', N'Đầy đủ', 6.0, N'Cần bổ sung nhiều dẫn chứng thực tế cho câu nghị luận xã hội.'), ('K014B10','LH019_10','HV014', N'Có mặt', N'Đầy đủ', 6.5, N'Hiểu bài, diễn đạt có phần trôi chảy hơn.'), 
('K014B11','LH019_11','HV014', N'Có mặt', N'Đầy đủ', 6.0, N'Trình bày bài thi cẩu thả, tẩy xóa nhiều.'), ('K014B12','LH019_12','HV014', N'Có mặt', N'Đầy đủ', 6.5, N'Làm trắc nghiệm Tiếng Việt đạt 3/5 điểm.'), 
('K014B13','LH019_13','HV014', N'Có mặt', N'Đầy đủ', 6.0, N'Mở bài dài dòng, đi xa trọng tâm đề.'), ('K014B14','LH019_14','HV014', N'Có mặt', N'Đầy đủ', 6.5, N'Đã làm xong toàn bộ đề cương ở nhà.'), 
('K014B15','LH019_15','HV014', N'Có mặt', N'Thiếu', 5.5, N'Quên sách giáo khoa, không theo kịp tiến độ phân tích.'), ('K014B16','LH019_16','HV014', N'Có mặt', N'Đầy đủ', 6.0, N'Phân tích chi tiết tiếng đàn ghi ta ở mức cơ bản.'), 
('K014B17','LH019_17','HV014', N'Có mặt', N'Đầy đủ', 6.5, N'Thái độ học tập tiến bộ, có ý thức chữa lỗi sai.'), ('K014B18','LH019_18','HV014', N'Có mặt', N'Đầy đủ', 6.5, N'Bài thi thử đạt điểm trung bình khá, cần cố thêm.'), 
('K014B19','LH019_19','HV014', N'Có mặt', N'Đầy đủ', 6.0, N'Cần ôn kĩ các biện pháp tu từ.'), ('K014B20','LH019_20','HV014', N'Có mặt', N'Đầy đủ', 6.5, N'Nắm vững nội dung Vợ chồng A Phủ.'), 
('K014B21','LH019_21','HV014', N'Có mặt', N'Đầy đủ', 6.0, N'Cần quản lý thời gian thi tốt hơn.'), ('K014B22','LH019_22','HV014', N'Có mặt', N'Đầy đủ', 6.5, N'Ổn định tinh thần cho kì thi sắp tới.'),


-- 14. HV016 (LH017 - Lớp 11 Khá - 21 Buổi - ĐI ĐỦ) -> Điểm 7.0 - 8.5

('K016B01','LH017_01','HV016', N'Có mặt', N'Đầy đủ', 7.5, N'Hiểu sâu triết lý thời gian trong thơ Xuân Diệu.'), ('K016B02','LH017_02','HV016', N'Có mặt', N'Đầy đủ', 8.0, N'Phân tích tâm lý nhân vật Chí Phèo rất sắc sảo.'), 
('K016B03','LH017_03','HV016', N'Có mặt', N'Đầy đủ', 8.5, N'Hoàn thành xuất sắc bài thi giữa kỳ tại trung tâm.'), ('K016B04','LH017_04','HV016', N'Có mặt', N'Thiếu', 6.5, N'Chưa hoàn thiện phần Nghị luận xã hội trong BTVN.'), 
('K016B05','LH017_05','HV016', N'Đi muộn', N'Đầy đủ', 7.5, N'Phân tích bức tranh thiên nhiên Tràng Giang giàu hình ảnh.'), ('K016B06','LH017_06','HV016', N'Có mặt', N'Đầy đủ', 7.5, N'Đã làm bù bài tập, ý tưởng phân tích rất tốt.'), 
('K016B07','LH017_07','HV016', N'Đi muộn', N'Đầy đủ', 7.0, N'Hôm nay làm bài kiểm tra hơi chậm nên phần Kết bài bị cụt.'), ('K016B08','LH017_08','HV016', N'Có mặt', N'Đầy đủ', 8.0, N'Bài viết rất có chiều sâu. Tích cực phát biểu.'), 
('K016B09','LH017_09','HV016', N'Có mặt', N'Đầy đủ', 7.5, N'Hiểu rõ phong cách nghệ thuật của Nam Cao.'), ('K016B10','LH017_10','HV016', N'Có mặt', N'Đầy đủ', 8.0, N'Bài văn có cảm xúc, cách sử dụng từ ngữ linh hoạt.'), 
('K016B11','LH017_11','HV016', N'Có mặt', N'Đầy đủ', 7.5, N'Chữ viết rõ ràng, cách phân đoạn luận điểm tốt.'), ('K016B12','LH017_12','HV016', N'Có mặt', N'Đầy đủ', 8.0, N'Nghị luận xã hội nêu được dẫn chứng đa chiều.'), 
('K016B13','LH017_13','HV016', N'Có mặt', N'Đầy đủ', 7.5, N'Cần chú ý không phân tích lan man ở phần thân bài.'), ('K016B14','LH017_14','HV016', N'Có mặt', N'Đầy đủ', 8.0, N'Hoàn thành xuất sắc bài kiểm tra trắc nghiệm.'), 
('K016B15','LH017_15','HV016', N'Có mặt', N'Thiếu', 7.0, N'Quên nộp bài tập về nhà, nhưng làm bài trên lớp rất tốt.'), ('K016B16','LH017_16','HV016', N'Có mặt', N'Đầy đủ', 7.5, N'Đã biết cách mở bài gián tiếp đi từ lí luận văn học.'), 
('K016B17','LH017_17','HV016', N'Có mặt', N'Đầy đủ', 8.0, N'Giữ vững phong độ cao trong lớp học.'), ('K016B18','LH017_18','HV016', N'Có mặt', N'Đầy đủ', 7.5, N'Thái độ học tập luôn đáng khen ngợi.'), 
('K016B19','LH017_19','HV016', N'Có mặt', N'Đầy đủ', 8.0, N'Phân tích chi tiết xin chữ trong Chữ người tử tù sâu sắc.'), ('K016B20','LH017_20','HV016', N'Có mặt', N'Đầy đủ', 7.5, N'Cần ôn kĩ các tác phẩm thơ Mới.'), 
('K016B21','LH017_21','HV016', N'Có mặt', N'Đầy đủ', 8.5, N'Bài thi cuối kì đạt điểm cực kì ấn tượng.'),


-- 15. HV017 (LH011 - Lớp 9 Khá - 21 Buổi - ĐI ĐỦ) -> Điểm 7.0 - 8.0

('K017B01','LH011_01','HV017', N'Có mặt', N'Đầy đủ', 7.5, N'Hành văn lưu loát, phân tích tốt tình huống truyện Lặng Lẽ Sa Pa.'), ('K017B02','LH011_02','HV017', N'Có mặt', N'Đầy đủ', 8.0, N'Mở bài rất thu hút. Lập luận phần nghị luận văn học chặt chẽ.'), 
('K017B03','LH011_03','HV017', N'Có mặt', N'Đầy đủ', 7.5, N'Kiến thức bài Chiếc lược ngà rất tốt, làm bài mạch lạc.'), ('K017B04','LH011_04','HV017', N'Có mặt', N'Đầy đủ', 7.5, N'Kiến thức vững vàng, cần luyện thêm tốc độ viết.'), 
('K017B05','LH011_05','HV017', N'Có mặt', N'Đầy đủ', 8.0, N'Phân tích chi tiết cái bóng trong Chuyện người con gái Nam Xương rất sâu sắc.'), ('K017B06','LH011_06','HV017', N'Đi muộn', N'Đầy đủ', 7.0, N'Vào lớp muộn. Bài kiểm tra viết chữ hơi ẩu do làm vội.'), 
('K017B07','LH011_07','HV017', N'Có mặt', N'Thiếu', 6.5, N'Hôm nay làm bài kiểm tra trắc nghiệm sai 3 câu. Cần chú ý hơn.'), ('K017B08','LH011_08','HV017', N'Có mặt', N'Đầy đủ', 8.0, N'Đã cải thiện kỹ năng kết bài mở rộng. Bài làm tròn trịa.'), 
('K017B09','LH011_09','HV017', N'Có mặt', N'Đầy đủ', 7.5, N'Có sự tiến bộ trong việc liên kết các đoạn văn.'), ('K017B10','LH011_10','HV017', N'Có mặt', N'Đầy đủ', 8.0, N'Luôn hăng hái xây dựng bài.'), 
('K017B11','LH011_11','HV017', N'Có mặt', N'Đầy đủ', 7.5, N'Bài viết sạch đẹp, ý tưởng sáng tạo.'), ('K017B12','LH011_12','HV017', N'Có mặt', N'Đầy đủ', 8.0, N'Đạt điểm cao trong kì thi thử tại trung tâm.'), 
('K017B13','LH011_13','HV017', N'Có mặt', N'Đầy đủ', 7.5, N'Nghị luận xã hội biết kết hợp cả lí lẽ và dẫn chứng.'), ('K017B14','LH011_14','HV017', N'Có mặt', N'Đầy đủ', 8.0, N'Hoàn thành bài tập về nhà rất tốt.'), 
('K017B15','LH011_15','HV017', N'Có mặt', N'Thiếu', 7.0, N'Thiếu bài tập phần từ vựng Tiếng Việt.'), ('K017B16','LH011_16','HV017', N'Có mặt', N'Đầy đủ', 7.5, N'Phân tích bài Đồng Chí tốt, hiểu tinh thần đồng đội.'), 
('K017B17','LH011_17','HV017', N'Có mặt', N'Đầy đủ', 8.0, N'Biết sử dụng các biện pháp tu từ trong bài viết.'), ('K017B18','LH011_18','HV017', N'Có mặt', N'Đầy đủ', 7.5, N'Phong độ học tập rất đáng khen ngợi.'), 
('K017B19','LH011_19','HV017', N'Có mặt', N'Đầy đủ', 8.0, N'Làm trọn vẹn điểm phần đọc hiểu.'), ('K017B20','LH011_20','HV017', N'Có mặt', N'Đầy đủ', 7.5, N'Kết bài cần trau chuốt thêm một chút.'), 
('K017B21','LH011_21','HV017', N'Có mặt', N'Đầy đủ', 8.0, N'Sẵn sàng bứt phá cho kì thi vào lớp 10.'),


-- 16. HV018 (LH020 - Lớp 12 Khá - 22 Buổi - NGHỈ 1 BUỔI: 06) -> Điểm 7.0 - 8.0

('K018B01','LH020_01','HV018', N'Có mặt', N'Đầy đủ', 7.5, N'Tích cực xây dựng bài. Phân tích tốt hình tượng sóng nước Đà Giang.'), ('K018B02','LH020_02','HV018', N'Có mặt', N'Đầy đủ', 8.0, N'Kỹ năng viết luận văn xã hội 200 chữ rất xuất sắc, dẫn chứng phong phú.'), 
('K018B03','LH020_03','HV018', N'Có mặt', N'Đầy đủ', 7.5, N'Làm trọn vẹn điểm phần Đọc hiểu. Cần chú ý thời gian làm phần Làm văn.'), ('K018B04','LH020_04','HV018', N'Có mặt', N'Thiếu', 6.5, N'Chưa làm đủ đề cương ôn tập. Phân tích Sóng của Xuân Quỳnh còn sơ sài.'), 
('K018B05','LH020_05','HV018', N'Có mặt', N'Đầy đủ', 8.0, N'Kỹ năng viết luận văn xã hội 200 chữ xuất sắc, dẫn chứng phong phú.'), ('K018B06','LH020_06','HV018', N'Vắng', N'Không', 0.0, N'Nghỉ học về quê ăn giỗ.'), 
('K018B07','LH020_07','HV018', N'Có mặt', N'Đầy đủ', 7.5, N'Đã hoàn thiện bài làm bù trên lớp khá tốt.'), ('K018B08','LH020_08','HV018', N'Có mặt', N'Đầy đủ', 8.0, N'Phong độ rất ổn định, tự tin hướng tới kỳ thi Quốc gia nhé.'), 
('K018B09','LH020_09','HV018', N'Có mặt', N'Đầy đủ', 7.5, N'Nắm vững kiến thức bài Vợ Nhặt.'), ('K018B10','LH020_10','HV018', N'Có mặt', N'Đầy đủ', 8.0, N'Phân tích diễn biến tâm lí nhân vật sâu sắc.'), 
('K018B11','LH020_11','HV018', N'Có mặt', N'Đầy đủ', 7.5, N'Biết cách liên kết đoạn văn logic.'), ('K018B12','LH020_12','HV018', N'Có mặt', N'Đầy đủ', 8.0, N'Mở bài rất thu hút bằng trích dẫn văn học.'), 
('K018B13','LH020_13','HV018', N'Có mặt', N'Đầy đủ', 7.5, N'Làm phần đọc hiểu chính xác 100%.'), ('K018B14','LH020_14','HV018', N'Có mặt', N'Đầy đủ', 8.0, N'Nghiêm túc trong việc luyện đề ở nhà.'), 
('K018B15','LH020_15','HV018', N'Có mặt', N'Thiếu', 6.5, N'Thiếu sự tập trung, làm bài kiểm tra còn ẩu.'), ('K018B16','LH020_16','HV018', N'Có mặt', N'Đầy đủ', 7.5, N'Đã khắc phục lỗi trình bày, chữ viết sạch sẽ hơn.'), 
('K018B17','LH020_17','HV018', N'Có mặt', N'Đầy đủ', 8.0, N'Lập luận sắc bén, luận điểm rành mạch.'), ('K018B18','LH020_18','HV018', N'Có mặt', N'Đầy đủ', 7.5, N'Bài thi thử đạt kết quả Khá Tốt.'), 
('K018B19','LH020_19','HV018', N'Có mặt', N'Đầy đủ', 8.0, N'Có sự chuẩn bị kĩ lưỡng cho các dạng bài phân tích.'), ('K018B20','LH020_20','HV018', N'Có mặt', N'Đầy đủ', 7.5, N'Cần căn chỉnh thời gian làm bài.'), 
('K018B21','LH020_21','HV018', N'Có mặt', N'Đầy đủ', 8.0, N'Bài viết trọn vẹn, không có điểm chê ở mức Khá.'), ('K018B22','LH020_22','HV018', N'Có mặt', N'Đầy đủ', 7.5, N'Thái độ học tập luôn rất nghiêm túc.'),


-- 17. HV019 (LH001 - Lớp 6 Trung bình - 21 Buổi - NGHỈ 2 BUỔI: 04, 09) -> Điểm 5.5 - 6.5

('K019B01','LH001_01','HV019', N'Có mặt', N'Thiếu', 5.5, N'Lười làm BTVN. Lên bảng kiểm tra bài cũ không thuộc.'), ('K019B02','LH001_02','HV019', N'Có mặt', N'Đầy đủ', 6.0, N'Bài văn miêu tả con vật còn lủng củng, dùng từ chưa chính xác.'), 
('K019B03','LH001_03','HV019', N'Có mặt', N'Đầy đủ', 6.5, N'Đã biết cách chia bố cục 3 phần. Có tiến bộ hơn tuần trước.'), ('K019B04','LH001_04','HV019', N'Vắng', N'Không', 0.0, N'Nghỉ học không xin phép.'), 
('K019B05','LH001_05','HV019', N'Đi muộn', N'Đầy đủ', 6.0, N'Đi muộn 15p. Trình bày vở ghi chép còn bôi xóa nhiều.'), ('K019B06','LH001_06','HV019', N'Có mặt', N'Đầy đủ', 6.5, N'Nắm được các chi tiết tưởng tượng kỳ ảo trong truyện truyền thuyết.'), 
('K019B07','LH001_07','HV019', N'Có mặt', N'Đầy đủ', 6.5, N'Đã cải thiện kỹ năng làm phần tiếng Việt (tìm từ ghép, từ láy).'), ('K019B08','LH001_08','HV019', N'Có mặt', N'Thiếu', 5.0, N'Hôm nay làm bài thi sơ sài, nộp bài quá sớm.'), 
('K019B09','LH001_09','HV019', N'Vắng', N'Không', 0.0, N'Nghỉ học do có việc bận gia đình.'), ('K019B10','LH001_10','HV019', N'Có mặt', N'Đầy đủ', 6.0, N'Đã làm bù bài, hiểu nội dung cơ bản.'), 
('K019B11','LH001_11','HV019', N'Có mặt', N'Đầy đủ', 6.5, N'Biết sử dụng phép nhân hóa trong câu.'), ('K019B12','LH001_12','HV019', N'Có mặt', N'Đầy đủ', 6.0, N'Bài văn tự sự còn thiếu logic.'), 
('K019B13','LH001_13','HV019', N'Có mặt', N'Đầy đủ', 6.5, N'Chữ viết rõ ràng hơn trước.'), ('K019B14','LH001_14','HV019', N'Có mặt', N'Đầy đủ', 6.0, N'Mở bài tốt nhưng chưa triển khai được ý thân bài.'), 
('K019B15','LH019_15','HV019', N'Có mặt', N'Thiếu', 5.5, N'Không làm đề cương theo yêu cầu.'), ('K019B16','LH001_16','HV019', N'Có mặt', N'Đầy đủ', 6.5, N'Tập trung nghe giảng, làm bài tập đầy đủ.'), 
('K019B17','LH001_17','HV019', N'Có mặt', N'Đầy đủ', 6.0, N'Chưa thuộc lòng bài thơ.'), ('K019B18','LH001_18','HV019', N'Có mặt', N'Đầy đủ', 6.5, N'Nắm vững nội dung truyện dân gian.'), 
('K019B19','LH001_19','HV019', N'Có mặt', N'Đầy đủ', 6.0, N'Trình bày bài kiểm tra còn hơi ẩu.'), ('K019B20','LH001_20','HV019', N'Có mặt', N'Đầy đủ', 6.5, N'Bài văn miêu tả đạt mức trung bình khá.'), 
('K019B21','LH001_21','HV019', N'Có mặt', N'Đầy đủ', 6.0, N'Cần phải cố gắng nhiều hơn nữa.'),


-- 18. HV020 (LH014 - Lớp 10 Khá - 21 Buổi - NGHỈ 1 BUỔI: 03) -> Điểm 7.0 - 8.0

('K020B01','LH014_01','HV020', N'Có mặt', N'Đầy đủ', 7.5, N'Nắm chắc giá trị nhân đạo trong Truyện Kiều. Cách chia đoạn hợp lý.'), ('K020B02','LH014_02','HV020', N'Có mặt', N'Đầy đủ', 8.0, N'Phân tích nghệ thuật tả cảnh ngụ tình tinh tế. Có liên hệ mở rộng tốt.'), 
('K020B03','LH014_03','HV020', N'Vắng', N'Không', 0.0, N'Học sinh xin nghỉ ốm.'), ('K020B04','LH014_04','HV020', N'Có mặt', N'Đầy đủ', 7.0, N'Chưa thuộc lòng trích đoạn Trao Duyên. Phần phân tích còn phụ thuộc sách.'), 
('K020B05','LH014_05','HV020', N'Có mặt', N'Đầy đủ', 7.5, N'Đã ôn bài kỹ hơn. Văn phong dạt dào tình cảm.'), ('K020B06','LH014_06','HV020', N'Đi muộn', N'Thiếu', 6.5, N'Vào lớp muộn 15 phút. Quên nộp vở soạn văn.'), 
('K020B07','LH014_07','HV020', N'Có mặt', N'Đầy đủ', 8.0, N'Làm bài kiểm tra 15p rất xuất sắc, điểm phần Tiếng Việt tuyệt đối.'), ('K020B08','LH014_08','HV020', N'Có mặt', N'Đầy đủ', 7.5, N'Biết cách lập dàn ý logic trước khi viết bài dài.'), 
('K020B09','LH014_09','HV020', N'Có mặt', N'Đầy đủ', 7.5, N'Bài viết văn thuyết minh trình bày khoa học.'), ('K020B10','LH014_10','HV020', N'Có mặt', N'Đầy đủ', 8.0, N'Phân tích Bình Ngô đại cáo cực kì hùng hồn.'), 
('K020B11','LH014_11','HV020', N'Có mặt', N'Đầy đủ', 7.0, N'Cần mở rộng thêm dẫn chứng ngoài SGK.'), ('K020B12','LH014_12','HV020', N'Có mặt', N'Đầy đủ', 7.5, N'Phần Đọc hiểu văn bản lấy trọn điểm.'), 
('K020B13','LH014_13','HV020', N'Có mặt', N'Đầy đủ', 8.0, N'Đã biết cách sử dụng các thao tác lập luận đa dạng.'), ('K020B14','LH014_14','HV020', N'Có mặt', N'Đầy đủ', 7.5, N'Chữ viết rất nắn nót, bài làm sạch sẽ.'), 
('K020B15','LH014_15','HV020', N'Có mặt', N'Thiếu', 6.5, N'Làm thiếu 1 câu trong đề cương ôn thi.'), ('K020B16','LH014_16','HV020', N'Có mặt', N'Đầy đủ', 7.5, N'Bài thi thử làm sát với barem điểm.'), 
('K020B17','LH014_17','HV020', N'Có mặt', N'Đầy đủ', 8.0, N'Thái độ học tập luôn rất nghiêm túc, tích cực.'), ('K020B18','LH014_18','HV020', N'Có mặt', N'Đầy đủ', 7.5, N'Kết bài cần được trau chuốt cảm xúc hơn.'), 
('K020B19','LH014_19','HV020', N'Có mặt', N'Đầy đủ', 8.0, N'Mở bài rất sáng tạo và lôi cuốn.'), ('K020B20','LH014_20','HV020', N'Có mặt', N'Đầy đủ', 7.5, N'Hoàn thành đầy đủ mọi yêu cầu của giáo viên.'), 
('K020B21','LH014_21','HV020', N'Có mặt', N'Đầy đủ', 8.0, N'Kết quả học kì đạt loại Tốt.');

--Lịch sử tương tác khi là khách hàng
INSERT INTO LICH_SU_TUONG_TAC (MaTuongTac, MaTK, MaKhachHang, MaHocVien, NgayTuongTac, NoiDung, LoaiTuongTac) VALUES

-- 1. KH001 (Nguyễn Thị Thu Hà - Lớp 9 - Nhận 01/08 - ĐK 03/08)
('TT001', 'TK003', 'KH001', 'HV001', '2025-08-01', N'Khách hàng nhắn tin qua fanpage hỏi về lớp ôn thi môn Văn vào lớp 10. Đã xin SĐT để gọi điện hỗ trợ.', N'Nhắn tin (Zalo/Mess)'),
('TT002', 'TK003', 'KH001', 'HV001', '2025-08-02', N'Tư vấn lộ trình ôn thi vào 10. Mẹ quan tâm đến chất lượng giảng dạy và cam kết đầu ra của trung tâm.', N'Tư vấn qua điện thoại'),
('TT003', 'TK003', 'KH001', 'HV001', '2025-08-03', N'Phụ huynh đưa con qua trung tâm xem cơ sở vật chất phòng học và chốt đăng ký, đóng học phí khóa 1.', N'Gặp trực tiếp'),

-- 2. KH002 (Trần Hoàng Gia Bảo - Lớp 12 - Nhận 01/08 - ĐK 04/08)
('TT004', 'TK003', 'KH002', 'HV002', '2025-08-01', N'Học sinh tự tìm hiểu qua Facebook, hỏi thông tin các ca học tối lớp luyện thi THPT Quốc gia.', N'Nhắn tin (Zalo/Mess)'),
('TT005', 'TK003', 'KH002', 'HV002', '2025-08-02', N'Gọi điện tư vấn chi tiết về học phí và sĩ số lớp (giới hạn 15 bạn/lớp). Học sinh hẹn trao đổi lại với gia đình.', N'Tư vấn qua điện thoại'),
('TT006', 'TK003', 'KH002', 'HV002', '2025-08-04', N'Giải đáp thắc mắc của phụ huynh về việc có được học thử không. Đã chốt đăng ký sau khi giải thích chính sách trung tâm.', N'Giải đáp thắc mắc'),

-- 3. KH003 (Lê Thị Ngọc Mai - Lớp 6 - Nhận 02/08 - ĐK 05/08)
('TT007', 'TK003', 'KH003', 'HV003', '2025-08-02', N'Được phụ huynh khóa trước giới thiệu. Gia đình gọi điện hỏi lớp Văn lớp 6 cho học sinh mới chuyển cấp.', N'Tư vấn qua điện thoại'),
('TT008', 'TK003', 'KH003', 'HV003', '2025-08-04', N'Phụ huynh tới tham quan trung tâm, xem hệ thống điều hòa, ánh sáng và tham khảo giáo trình.', N'Gặp trực tiếp'),
('TT009', 'TK003', 'KH003', 'HV003', '2025-08-05', N'Gửi link bài test đầu vào. Mẹ đã chuyển khoản đăng ký cho con.', N'Nhắn tin (Zalo/Mess)'),

-- 4. KH004 (Phạm Đức Trung Kiên - Lớp 8 - Nhận 03/08 - ĐK 06/08)
('TT010', 'TK003', 'KH004', 'HV004', '2025-08-03', N'Phụ huynh để lại thông tin trên Website. CSKH chủ động kết bạn Zalo và gửi thông tin tổng quan.', N'Nhắn tin (Zalo/Mess)'),
('TT011', 'TK003', 'KH004', 'HV004', '2025-08-05', N'Mẹ hỏi cách lấy lại gốc môn Văn cho con vì con đang lười học. Đã tư vấn phương pháp học tương tác.', N'Giải đáp thắc mắc'),
('TT012', 'TK003', 'KH004', 'HV004', '2025-08-06', N'Gọi điện chốt lịch test đầu vào. Gia đình đồng ý đăng ký học ca thứ 7.', N'Tư vấn qua điện thoại'),

-- 5. KH005 (Đỗ Thị Thanh Thảo - Lớp 9 - Nhận 03/08 - ĐK 07/08)
('TT013', 'TK003', 'KH005', 'HV005', '2025-08-03', N'Gọi qua Hotline hỏi lớp ôn chuyên Văn. Trung tâm thông báo chỉ có lớp Văn điều kiện.', N'Tư vấn qua điện thoại'),
('TT014', 'TK003', 'KH005', 'HV005', '2025-08-04', N'Gửi thông tin profile Giáo viên đang phụ trách lớp 9 để phụ huynh tham khảo.', N'Nhắn tin (Zalo/Mess)'),
('TT015', 'TK003', 'KH005', 'HV005', '2025-08-05', N'Phụ huynh hỏi thêm về việc trung tâm có hỗ trợ chữa bài tập trên lớp của trường không.', N'Giải đáp thắc mắc'),
('TT016', 'TK003', 'KH005', 'HV005', '2025-08-07', N'Tới trung tâm nhận tài liệu và đăng ký xếp lớp chính thức.', N'Gặp trực tiếp'),

-- 6. KH006 (Hoàng Tuấn Dũng - Lớp 12 - Nhận 04/08 - ĐK 08/08)
('TT017', 'TK003', 'KH006', 'HV006', '2025-08-04', N'Bình luận trên bài viết Facebook. CSKH nhắn tin tư vấn lịch học khối 12.', N'Nhắn tin (Zalo/Mess)'),
('TT018', 'TK003', 'KH006', 'HV006', '2025-08-06', N'Gọi điện tư vấn lộ trình 3 giai đoạn: Tổng ôn - Luyện đề - Nước rút.', N'Tư vấn qua điện thoại'),
('TT019', 'TK003', 'KH006', 'HV006', '2025-08-08', N'Học sinh đến trực tiếp để làm bài test đánh giá năng lực và làm thủ tục đăng ký.', N'Gặp trực tiếp'),

-- 7. KH007 (Vũ Ngọc Lan Anh - Lớp 11 - Nhận 04/08 - ĐK 09/08)
('TT020', 'TK003', 'KH007', 'HV007', '2025-08-04', N'Người quen giới thiệu, gia đình tự liên hệ qua Zalo. Đã gửi bảng giá học phí.', N'Nhắn tin (Zalo/Mess)'),
('TT021', 'TK003', 'KH007', 'HV007', '2025-08-07', N'Phụ huynh phân vân giữa học nhóm và gia sư 1-1. Đã phân tích ưu nhược điểm.', N'Giải đáp thắc mắc'),
('TT022', 'TK003', 'KH007', 'HV007', '2025-08-09', N'Phụ huynh gọi điện chốt cho con học lớp nhóm, hẹn chiều đi học buổi đầu.', N'Tư vấn qua điện thoại'),

-- 8. KH008 (Nguyễn Văn Tuấn Đạt - Lớp 10 - Nhận 05/08 - ĐK 10/08)
('TT023', 'TK003', 'KH008', 'HV008', '2025-08-05', N'Đăng ký form trên Website. CSKH gọi điện xác nhận và tìm hiểu học lực.', N'Tư vấn qua điện thoại'),
('TT024', 'TK003', 'KH008', 'HV008', '2025-08-08', N'Gửi ảnh lớp học và thông tin cơ sở vật chất qua Zalo cho phụ huynh.', N'Nhắn tin (Zalo/Mess)'),
('TT025', 'TK003', 'KH008', 'HV008', '2025-08-10', N'Phụ huynh đồng ý đăng ký, đã gửi link làm bài test online.', N'Nhắn tin (Zalo/Mess)'),

-- 9. KH009 (Trần Thị Bích Ngọc - Lớp 9 - Nhận 05/08 - ĐK 11/08)
('TT026', 'TK003', 'KH009', 'HV009', '2025-08-05', N'Phụ huynh để lại SĐT qua Facebook. Mẹ muốn tìm lớp có GV nghiêm khắc vì con hay mất tập trung.', N'Tư vấn qua điện thoại'),
('TT027', 'TK003', 'KH009', 'HV009', '2025-08-08', N'Trả lời tin nhắn thắc mắc về quy định kỷ luật và thông báo điểm danh của trung tâm.', N'Giải đáp thắc mắc'),
('TT028', 'TK003', 'KH009', 'HV009', '2025-08-11', N'Mẹ qua trung tâm gặp quản lý để gửi gắm con và hoàn tất đăng ký.', N'Gặp trực tiếp'),

-- 10. KH010 (Lê Quang Nhật Minh - Lớp 12 - Nhận 06/08 - ĐK 12/08)
('TT029', 'TK003', 'KH010', 'HV010', '2025-08-06', N'Gọi điện trực tiếp vào Hotline xin xếp lớp luyện đề sớm. Đã tư vấn học sinh phải làm test trước.', N'Tư vấn qua điện thoại'),
('TT030', 'TK003', 'KH010', 'HV010', '2025-08-09', N'Học sinh làm bài test, GV chấm xong và CSKH báo điểm qua Zalo.', N'Nhắn tin (Zalo/Mess)'),
('TT031', 'TK003', 'KH010', 'HV010', '2025-08-12', N'Đến nộp học phí và nhận tài liệu ôn tập môn Văn.', N'Gặp trực tiếp'),

-- 11. KH011 (Phạm Phương Linh - Lớp 6 - Nhận 07/08 - ĐK 13/08)
('TT032', 'TK003', 'KH011', 'HV011', '2025-08-07', N'Tư vấn lộ trình học sinh chuyển cấp từ Tiểu học lên THCS, nhấn mạnh kỹ năng viết đoạn văn.', N'Tư vấn qua điện thoại'),
('TT033', 'TK003', 'KH011', 'HV011', '2025-08-10', N'Gửi các bài văn mẫu của HS trung tâm cho phụ huynh tham khảo chất lượng.', N'Nhắn tin (Zalo/Mess)'),
('TT034', 'TK003', 'KH011', 'HV011', '2025-08-13', N'Phụ huynh đồng ý ghi danh, đã chuyển khoản qua số tài khoản trung tâm.', N'Giải đáp thắc mắc'),

-- 12. KH012 (Đặng Trần Nam Khang - Lớp 7 - Nhận 07/08 - ĐK 14/08)
('TT035', 'TK003', 'KH012', 'HV012', '2025-08-07', N'Hỏi thông tin qua sự giới thiệu của phụ huynh lớp 7 hiện tại. Đã xếp ca tối thứ 3.', N'Nhắn tin (Zalo/Mess)'),
('TT036', 'TK003', 'KH012', 'HV012', '2025-08-10', N'Phụ huynh hỏi về chính sách học bù nếu con ốm nghỉ học.', N'Giải đáp thắc mắc'),
('TT037', 'TK003', 'KH012', 'HV012', '2025-08-14', N'Phụ huynh đưa con qua đăng ký và làm quen với trợ giảng lớp.', N'Gặp trực tiếp'),

-- 13. KH013 (Bùi Thị Hồng Nhung - Lớp 9 - Nhận 08/08 - ĐK 15/08)
('TT038', 'TK003', 'KH013', 'HV013', '2025-08-08', N'Để lại contact trên Website. Yêu cầu tư vấn tìm lớp GV kinh nghiệm lâu năm.', N'Tư vấn qua điện thoại'),
('TT039', 'TK003', 'KH013', 'HV013', '2025-08-11', N'Đã gửi danh sách giáo viên và video lớp học demo qua Zalo.', N'Nhắn tin (Zalo/Mess)'),
('TT040', 'TK003', 'KH013', 'HV013', '2025-08-15', N'Mẹ chốt lịch học, hoàn thành việc điền form đăng ký trực tuyến.', N'Giải đáp thắc mắc'),

-- 14. KH014 (Nguyễn Đức Huy - Lớp 12 - Nhận 09/08 - ĐK 16/08)
('TT041', 'TK003', 'KH014', 'HV014', '2025-08-09', N'Học sinh inbox Fanpage hỏi lớp Văn để kéo điểm thi tốt nghiệp. Tư vấn cần làm bài test.', N'Nhắn tin (Zalo/Mess)'),
('TT042', 'TK003', 'KH014', 'HV014', '2025-08-12', N'Báo kết quả test đầu vào, đề xuất lớp 12 Cơ bản.', N'Tư vấn qua điện thoại'),
('TT043', 'TK003', 'KH014', 'HV014', '2025-08-16', N'Học sinh qua nộp tiền mặt đăng ký và nhận giáo trình khóa học.', N'Gặp trực tiếp'),

-- 15. KH015 (Trần Tuấn Phát - Lớp 8 - Nhận 10/08 - ĐK 17/08)
('TT044', 'TK003', 'KH015', 'HV015', '2025-08-10', N'Phụ huynh gọi Hotline, phàn nàn việc con hay viết sai chính tả. Tư vấn phương pháp rèn luyện tại trung tâm.', N'Tư vấn qua điện thoại'),
('TT045', 'TK003', 'KH015', 'HV015', '2025-08-14', N'Giải đáp thắc mắc về khung giờ học có bị trùng lịch học thêm Toán của con không.', N'Giải đáp thắc mắc'),
('TT046', 'TK003', 'KH015', 'HV015', '2025-08-17', N'Gửi thông báo mở lớp mới, phụ huynh chốt đóng học phí đăng ký.', N'Nhắn tin (Zalo/Mess)'),

-- 16. KH016 (Lê Thị Hương Giang - Lớp 11 - Nhận 11/08 - ĐK 18/08)
('TT047', 'TK003', 'KH016', 'HV016', '2025-08-11', N'Được chị họ học khóa trước giới thiệu. Tư vấn nhanh về lịch trống khối 11.', N'Nhắn tin (Zalo/Mess)'),
('TT048', 'TK003', 'KH016', 'HV016', '2025-08-15', N'Phụ huynh hỏi thăm xem trung tâm có tổ chức thi thử định kỳ cho học sinh không.', N'Giải đáp thắc mắc'),
('TT049', 'TK003', 'KH016', 'HV016', '2025-08-18', N'Tới tận nơi làm thủ tục đăng ký và tham quan phòng học.', N'Gặp trực tiếp'),

-- 17. KH017 (Phạm Nguyễn Minh Quân - Lớp 9 - Nhận 11/08 - ĐK 19/08)
('TT050', 'TK003', 'KH017', 'HV017', '2025-08-11', N'CSKH gọi điện dựa trên data từ Web. Khách hàng mong muốn tìm lớp phụ đạo Văn nghị luận.', N'Tư vấn qua điện thoại'),
('TT051', 'TK003', 'KH017', 'HV017', '2025-08-15', N'Gửi thêm tài liệu đọc thử của giáo viên để phụ huynh đánh giá.', N'Nhắn tin (Zalo/Mess)'),
('TT052', 'TK003', 'KH017', 'HV017', '2025-08-19', N'Đã hoàn thiện bài test và được xếp lớp thành công.', N'Giải đáp thắc mắc'),

-- 18. KH018 (Vũ Thị Cẩm Tú - Lớp 12 - Nhận 12/08 - ĐK 20/08)
('TT053', 'TK003', 'KH018', 'HV018', '2025-08-12', N'Tư vấn trực tiếp trên Messenger về học phí ưu đãi khi đăng ký sớm.', N'Nhắn tin (Zalo/Mess)'),
('TT054', 'TK003', 'KH018', 'HV018', '2025-08-16', N'Gọi điện chốt lịch test đầu vào cho học sinh trước khi khai giảng.', N'Tư vấn qua điện thoại'),
('TT055', 'TK003', 'KH018', 'HV018', '2025-08-20', N'Qua trung tâm hoàn tất hồ sơ ghi danh và nhận lịch học chính thức.', N'Gặp trực tiếp'),

-- 19. KH019 (Hoàng Quốc Việt - Lớp 6 - Nhận 13/08 - ĐK 21/08)
('TT056', 'TK003', 'KH019', 'HV019', '2025-08-13', N'Gia đình hỏi về việc theo dõi điểm danh và nhận xét buổi học được gửi qua kênh nào.', N'Giải đáp thắc mắc'),
('TT057', 'TK003', 'KH019', 'HV019', '2025-08-17', N'Gọi điện thoại tư vấn cam kết của trung tâm về việc kết nối giữa Giáo viên và Phụ huynh.', N'Tư vấn qua điện thoại'),
('TT058', 'TK003', 'KH019', 'HV019', '2025-08-21', N'Gia đình đã gửi biên lai chuyển khoản thành công.', N'Nhắn tin (Zalo/Mess)'),

-- 20. KH020 (Nguyễn Lê Thu Hằng - Lớp 10 - Nhận 14/08 - ĐK 22/08)
('TT059', 'TK003', 'KH020', 'HV020', '2025-08-14', N'Được giới thiệu qua trung tâm. Gọi điện tư vấn chương trình Văn lớp 10 theo SGK mới.', N'Tư vấn qua điện thoại'),
('TT060', 'TK003', 'KH020', 'HV020', '2025-08-22', N'Đến trung tâm để làm bài test đầu vào. CSKH xếp lớp và nhận đăng ký thành công.', N'Gặp trực tiếp');


-- Lịch sử tương tác khi trở thành học viên
INSERT INTO LICH_SU_TUONG_TAC (MaTuongTac, MaTK, MaKhachHang, MaHocVien, NgayTuongTac, NoiDung, LoaiTuongTac) VALUES

-- 1. HV001 / KH001 (Nguyễn Thị Thu Hà - ĐK: 03/08/2025)
('TT500', 'TK003', 'KH001', 'HV001', '2025-08-20', N'Hỏi thăm tình hình học tập sau 2 tuần đầu. Mẹ báo con theo kịp bài, thích cách giảng bài của cô giáo.', N'Gọi điện hỏi thăm'),
('TT501', 'TK003', 'KH001', 'HV001', '2025-11-15', N'Phụ huynh hỏi điểm thi giữa kỳ môn Văn của con tại trung tâm. Đã gửi bảng điểm chi tiết và nhận xét của trợ giảng qua Zalo.', N'Phản hồi phụ huynh'),
('TT502', 'TK003', 'KH001', 'HV001', '2026-03-10', N'Nhắc nhở con dạo này làm bài tập về nhà hơi sơ sài. Đã trao đổi với mẹ để đôn đốc con tập trung hơn vào phần nghị luận xã hội.', N'Nhắc nhở học tập'),

-- 2. HV002 / KH002 (Trần Hoàng Gia Bảo - ĐK: 04/08/2025)
('TT503', 'TK003', 'KH002', 'HV002', '2025-09-10', N'Chăm sóc định kỳ đầu tháng. Phụ huynh hài lòng vì con đi học về có ý thức tự giác học bài hơn.', N'Gọi điện hỏi thăm'),
('TT504', 'TK003', 'KH002', 'HV002', '2025-12-20', N'Phụ huynh xin nghỉ phép 1 buổi cho con về quê. Đã xác nhận, báo lại với giáo viên và hướng dẫn con cách xem lại video bài giảng.', N'Phản hồi phụ huynh'),
('TT505', 'TK003', 'KH002', 'HV002', '2026-04-05', N'Gửi thông báo lịch thi thử THPT Quốc gia đợt 2 của trung tâm. Nhắc con đi thi đúng giờ và ôn tập kỹ tác phẩm Vợ Nhặt.', N'Nhắc nhở học tập'),

-- 3. HV003 / KH003 (Lê Thị Ngọc Mai - ĐK: 05/08/2025)
('TT506', 'TK003', 'KH003', 'HV003', '2025-08-25', N'Học sinh quên nộp vở bài tập tuần 3. Gọi điện nhắc mẹ đôn đốc con hoàn thành bù trước buổi học tới.', N'Nhắc nhở học tập'),
('TT507', 'TK003', 'KH003', 'HV003', '2025-10-12', N'Phụ huynh hỏi thăm về thái độ học tập trên lớp của con. Phản hồi con ngoan, hăng hái phát biểu nhưng chữ viết còn hơi ẩu.', N'Phản hồi phụ huynh'),
('TT508', 'TK003', 'KH003', 'HV003', '2026-02-28', N'Gọi điện chúc mừng năm mới gia đình sau Tết. Gửi báo cáo kết quả học tập tháng 2 và phổ biến mục tiêu học tập tháng tới.', N'Gọi điện hỏi thăm'),

-- 4. HV004 / KH004 (Phạm Đức Trung Kiên - ĐK: 06/08/2025)
('TT509', 'TK003', 'KH004', 'HV004', '2025-09-05', N'Phụ huynh gọi điện vui mừng báo con vừa được 8 điểm Văn kiểm tra 15 phút trên trường. Đã ghi nhận và báo cô giáo khen thưởng con trên lớp.', N'Phản hồi phụ huynh'),
('TT510', 'TK003', 'KH004', 'HV004', '2025-12-15', N'Con đi học muộn 15 phút trong buổi tối thứ 4. Gọi điện báo mẹ và nhắc nhở con chú ý giờ giấc đi lại.', N'Nhắc nhở học tập'),
('TT511', 'TK003', 'KH004', 'HV004', '2026-04-18', N'Phụ huynh nhờ trung tâm hỗ trợ con làm đề cương ôn thi học kỳ 2 môn Ngữ Văn của trường. Đã chuyển thông tin cho trợ giảng hỗ trợ con.', N'Phản hồi phụ huynh'),

-- 5. HV005 / KH005 (Đỗ Thị Thanh Thảo - ĐK: 07/08/2025)
('TT512', 'TK003', 'KH005', 'HV005', '2025-08-22', N'Gọi điện hỏi thăm tình hình hòa nhập của con với lớp mới. Mẹ báo con hơi rụt rè nhưng thích cách dạy truyền cảm của cô.', N'Gọi điện hỏi thăm'),
('TT513', 'TK003', 'KH005', 'HV005', '2025-11-10', N'Nhắc nhở học phí tháng 11. Mẹ đã chuyển khoản thành công.', N'Nhắc nhở học tập'),
('TT514', 'TK003', 'KH005', 'HV005', '2026-03-25', N'Gửi kết quả bài kiểm tra định kỳ tháng 3. Con tiến bộ rõ rệt ở phần Đọc hiểu văn bản.', N'Phản hồi phụ huynh'),

-- 6. HV006 / KH006 (Hoàng Tuấn Dũng - ĐK: 08/08/2025)
('TT515', 'TK003', 'KH006', 'HV006', '2025-09-20', N'Con nghỉ học không phép buổi tối thứ 6. Gọi điện thông báo cho mẹ, mẹ báo con bị ốm đột xuất quên không xin phép.', N'Nhắc nhở học tập'),
('TT516', 'TK003', 'KH006', 'HV006', '2025-12-05', N'Phụ huynh hỏi về lịch nghỉ Tết Dương lịch của trung tâm. Đã gửi lịch nghỉ cụ thể qua Zalo.', N'Phản hồi phụ huynh'),
('TT517', 'TK003', 'KH006', 'HV006', '2026-04-10', N'Gọi điện hỏi thăm sức khỏe con trước kỳ thi chuyển cấp. Tư vấn gia đình động viên con giữ tinh thần thoải mái.', N'Gọi điện hỏi thăm'),

-- 7. HV007 / KH007 (Vũ Ngọc Lan Anh - ĐK: 09/08/2025)
('TT518', 'TK003', 'KH007', 'HV007', '2025-08-28', N'Phụ huynh phản hồi con chưa nắm vững cách làm bài nghị luận xã hội. Đã trao đổi với giáo viên bổ sung bài tập luyện thêm cho con.', N'Phản hồi phụ huynh'),
('TT519', 'TK003', 'KH007', 'HV007', '2025-10-15', N'Gọi điện chúc mừng sinh nhật học viên. Trung tâm đã gửi thiệp và quà nhỏ tặng con.', N'Gọi điện hỏi thăm'),
('TT520', 'TK003', 'KH007', 'HV007', '2026-01-20', N'Nhắc nhở con hoàn thành bài tập Tết trước khi đi học lại.', N'Nhắc nhở học tập'),

-- 8. HV008 / KH008 (Nguyễn Văn Tuấn Đạt - ĐK: 10/08/2025)
('TT521', 'TK003', 'KH008', 'HV008', '2025-09-18', N'Hỏi thăm định kỳ. Mẹ rất vui vì con có ý thức tự giác hơn, môn Văn trên lớp trường đã được 7.5.', N'Gọi điện hỏi thăm'),
('TT522', 'TK003', 'KH008', 'HV008', '2025-11-22', N'Nhắc nhở con làm bài thi thử định kỳ cuối tháng. Nhấn mạnh tầm quan trọng của việc đánh giá năng lực đợt 1.', N'Nhắc nhở học tập'),
('TT523', 'TK003', 'KH008', 'HV008', '2026-05-05', N'Phụ huynh hỏi thủ tục xin bảo lưu 1 tháng vì gia đình có việc. Đã hướng dẫn viết đơn bảo lưu.', N'Phản hồi phụ huynh'),

-- 9. HV009 / KH009 (Trần Thị Bích Ngọc - ĐK: 11/08/2025)
('TT524', 'TK003', 'KH009', 'HV009', '2025-08-30', N'Giáo viên báo con thường mất tập trung cuối giờ. Gọi điện nhắc khéo mẹ cân đối thời gian nghỉ ngơi ở nhà cho con.', N'Nhắc nhở học tập'),
('TT525', 'TK003', 'KH009', 'HV009', '2025-11-18', N'Phụ huynh hỏi cách tra cứu điểm danh và nhận xét buổi học của con trên hệ thống. Đã gửi video hướng dẫn sử dụng tài khoản học viên.', N'Phản hồi phụ huynh'),
('TT526', 'TK003', 'KH009', 'HV009', '2026-03-15', N'Hỏi thăm định kỳ sau khi con thi giữa kỳ II. Mẹ báo con làm bài khá tốt, trúng tủ tác phẩm Vợ Chồng A Phủ.', N'Gọi điện hỏi thăm'),

-- 10. HV010 / KH010 (Lê Quang Nhật Minh - ĐK: 12/08/2025)
('TT527', 'TK003', 'KH010', 'HV010', '2025-09-25', N'Gửi kết quả báo cáo tháng 9. Con chăm chỉ, hoàn thành 100% bài tập về nhà.', N'Gọi điện hỏi thăm'),
('TT528', 'TK003', 'KH010', 'HV010', '2025-12-10', N'Phụ huynh nhờ tư vấn chọn khối thi Đại học cho con. Đã tư vấn hướng khối D và C dựa trên phổ điểm hiện tại.', N'Phản hồi phụ huynh'),
('TT529', 'TK003', 'KH010', 'HV010', '2026-04-20', N'Nhắc nhở con mang đầy đủ tài liệu luyện đề bộ mới trong buổi học tối nay.', N'Nhắc nhở học tập'),

-- 11. HV011 / KH011 (Phạm Phương Linh - ĐK: 13/08/2025)
('TT530', 'TK003', 'KH011', 'HV011', '2025-09-02', N'Mẹ hỏi trung tâm có tổ chức hoạt động Trung Thu không. Đã thông báo kế hoạch tặng lồng đèn và phá cỗ đầu giờ.', N'Phản hồi phụ huynh'),
('TT531', 'TK003', 'KH011', 'HV011', '2025-10-28', N'Cảnh báo học tập: Con đạt điểm dưới trung bình bài kiểm tra 1 tiết. Đã trao đổi với mẹ để sắp xếp học kèm 1 buổi với trợ giảng.', N'Nhắc nhở học tập'),
('TT532', 'TK003', 'KH011', 'HV011', '2026-02-15', N'Gọi điện chúc Tết gia đình. Hỏi thăm việc chuẩn bị bài vở của con sau kì nghỉ lễ dài.', N'Gọi điện hỏi thăm'),

-- 12. HV012 / KH012 (Đặng Trần Nam Khang - ĐK: 14/08/2025)
('TT533', 'TK003', 'KH012', 'HV012', '2025-09-12', N'Hỏi thăm sức khỏe học viên vì con bị sốt xuất huyết nghỉ 2 buổi. Mẹ báo con đã đỡ và sẽ đi học lại tuần tới.', N'Gọi điện hỏi thăm'),
('TT534', 'TK003', 'KH012', 'HV012', '2025-11-30', N'Phụ huynh phản hồi file bài tập trên Zalo bị lỗi không mở được. Đã gửi lại file PDF chuẩn.', N'Phản hồi phụ huynh'),
('TT535', 'TK003', 'KH012', 'HV012', '2026-03-05', N'Nhắc nhở con nhớ lịch học bù vào sáng Chủ Nhật tuần này.', N'Nhắc nhở học tập'),

-- 13. HV013 / KH013 (Bùi Thị Hồng Nhung - ĐK: 15/08/2025)
('TT536', 'TK003', 'KH013', 'HV013', '2025-10-05', N'Nhắc nhở đóng học phí khóa 2. Phụ huynh báo sẽ chuyển khoản vào hôm sau.', N'Nhắc nhở học tập'),
('TT537', 'TK003', 'KH013', 'HV013', '2025-12-25', N'Gửi lời chúc Giáng Sinh và thông báo điểm thi thử cuối kỳ của con. Con đạt loại Khá.', N'Gọi điện hỏi thăm'),
('TT538', 'TK003', 'KH013', 'HV013', '2026-04-25', N'Mẹ hỏi mua thêm sách tham khảo nâng cao môn Văn do trung tâm biên soạn. Đã ghi nhận đơn hàng.', N'Phản hồi phụ huynh'),

-- 14. HV014 / KH014 (Nguyễn Đức Huy - ĐK: 16/08/2025)
('TT539', 'TK003', 'KH014', 'HV014', '2025-09-22', N'Hỏi thăm tình hình ôn thi đầu năm của con. Gia đình báo con đang hơi áp lực.', N'Gọi điện hỏi thăm'),
('TT540', 'TK003', 'KH014', 'HV014', '2026-01-10', N'Giáo viên nhận xét con có năng khiếu viết văn biểu cảm rất tốt. Đã gọi điện khen ngợi động viên mẹ và con.', N'Phản hồi phụ huynh'),
('TT541', 'TK003', 'KH014', 'HV014', '2026-04-12', N'Nhắc nhở con thời gian này không nên thức quá khuya sát giờ học, ảnh hưởng sự tập trung trên lớp.', N'Nhắc nhở học tập'),

-- 15. HV015 / KH015 (Trần Tuấn Phát - ĐK: 17/08/2025)
('TT542', 'TK003', 'KH015', 'HV015', '2025-10-18', N'Phụ huynh hỏi về chính sách ưu đãi khi giới thiệu học viên mới. Đã tư vấn chính sách giảm 10% học phí.', N'Phản hồi phụ huynh'),
('TT543', 'TK003', 'KH015', 'HV015', '2026-01-28', N'Nhắc nhở con làm bài tập ôn luyện phần Tiếng Việt. Trợ giảng báo con hay sai phần câu ghép.', N'Nhắc nhở học tập'),
('TT544', 'TK003', 'KH015', 'HV015', '2026-05-02', N'Hỏi thăm quá trình ôn thi chuyển cấp. Mẹ đánh giá cao sự sát sao của đội ngũ giáo viên.', N'Gọi điện hỏi thăm'),

-- 16. HV016 / KH016 (Lê Thị Hương Giang - ĐK: 18/08/2025)
('TT545', 'TK003', 'KH016', 'HV016', '2025-09-08', N'Cảnh báo: Con nộp bài tập về nhà nhưng chép mạng 100%. Đã gọi điện trao đổi nghiêm túc với mẹ.', N'Nhắc nhở học tập'),
('TT546', 'TK003', 'KH016', 'HV016', '2025-11-20', N'Phụ huynh gọi điện gửi lời chúc mừng ngày Nhà giáo Việt Nam 20/11 đến đội ngũ giáo viên trung tâm.', N'Phản hồi phụ huynh'),
('TT547', 'TK003', 'KH016', 'HV016', '2026-03-20', N'Hỏi thăm định kỳ. Con đã có ý thức tự làm bài và tiến bộ nhiều so với đầu năm.', N'Gọi điện hỏi thăm'),

-- 17. HV017 / KH017 (Phạm Nguyễn Minh Quân - ĐK: 19/08/2025)
('TT548', 'TK003', 'KH017', 'HV017', '2025-10-02', N'Mẹ hỏi xem con có theo kịp tiến độ của lớp Giỏi không. Phản hồi con học rất vững, đang là top 3 của lớp.', N'Phản hồi phụ huynh'),
('TT549', 'TK003', 'KH017', 'HV017', '2026-02-20', N'Gọi điện hỏi thăm sau Tết. Mẹ báo con đã chuẩn bị tinh thần tốt để luyện đề.', N'Gọi điện hỏi thăm'),
('TT550', 'TK003', 'KH017', 'HV017', '2026-04-28', N'Nhắc nhở lịch thi thử tháng 4. Đề nghị con có mặt trước 15 phút để làm thủ tục.', N'Nhắc nhở học tập'),

-- 18. HV018 / KH018 (Vũ Thị Cẩm Tú - ĐK: 20/08/2025)
('TT551', 'TK003', 'KH018', 'HV018', '2025-09-15', N'Nhắc nhở đóng học phí. Mẹ báo chiều đi làm về sẽ ghé trung tâm nộp tiền mặt.', N'Nhắc nhở học tập'),
('TT552', 'TK003', 'KH018', 'HV018', '2025-12-08', N'Phụ huynh hỏi thăm điểm thi thử môn Văn. Đã báo điểm và gửi file pdf bài thi có lời phê của giáo viên.', N'Phản hồi phụ huynh'),
('TT553', 'TK003', 'KH018', 'HV018', '2026-03-30', N'Hỏi thăm tình hình học tập định kỳ. Mẹ rất tin tưởng vào lộ trình luyện thi của lớp.', N'Gọi điện hỏi thăm'),

-- 19. HV019 / KH019 (Hoàng Quốc Việt - ĐK: 21/08/2025)
('TT554', 'TK003', 'KH019', 'HV019', '2025-10-25', N'Phụ huynh đề xuất trung tâm cho con học thêm 1 buổi tăng cường vì con yếu phần Văn biểu cảm. Đã sắp xếp lịch học kèm trợ giảng.', N'Phản hồi phụ huynh'),
('TT555', 'TK003', 'KH019', 'HV019', '2026-01-05', N'Nhắc nhở con dạo này hay quên mang sách giáo khoa đi học. Cô giáo đã ghi sổ đầu bài 2 lần.', N'Nhắc nhở học tập'),
('TT556', 'TK003', 'KH019', 'HV019', '2026-05-08', N'Gọi điện chúc con thi tốt kỳ thi học kỳ II ở trường. Gia đình gửi lời cảm ơn trung tâm.', N'Gọi điện hỏi thăm'),

-- 20. HV020 / KH020 (Nguyễn Lê Thu Hằng - ĐK: 22/08/2025)
('TT557', 'TK003', 'KH020', 'HV020', '2025-09-28', N'Hỏi thăm định kỳ sau tháng đầu tiên. Mẹ báo con hòa nhập tốt, kết bạn được với nhiều bạn trong lớp.', N'Gọi điện hỏi thăm'),
('TT558', 'TK003', 'KH020', 'HV020', '2026-02-12', N'Mẹ hỏi cách xin chuyển lịch học bù từ thứ 4 sang thứ 6 do con cấn lịch học thêm môn Toán. Đã hỗ trợ đổi ca.', N'Phản hồi phụ huynh'),
('TT559', 'TK003', 'KH020', 'HV020', '2026-04-15', N'Nhắc nhở con nộp bài thu hoạch cuối đợt luyện đề số 1. Yêu cầu hoàn thiện trước 20/04.', N'Nhắc nhở học tập');

select * from TAI_KHOAN
select * from KHACH_HANG
select * from HOC_VIEN
select * from LICH_SU_TUONG_TAC
select * from LOI_NHAC
select * from CT_PHU_TRACH
select * from BAI_TEST
select * from BAI_LAM
select * from KQ_BAI_TEST
select * from KQ_HOC_TAP
select * from CANH_BAO


DROP TABLE LICH_SU_TUONG_TAC;
DROP TABLE CT_XU_LY;
DROP TABLE CANH_BAO;
DROP TABLE KQ_HOC_TAP;
DROP TABLE BUOI_HOC;
DROP TABLE LICH_HOC;
DROP TABLE CT_PHU_TRACH;
DROP TABLE KQ_BAI_TEST;
DROP TABLE BAI_LAM;
DROP TABLE LOI_NHAC;
DROP TABLE BAI_TEST;
DROP TABLE KHACH_HANG;
DROP TABLE HOC_VIEN;
DROP TABLE LOP_HOC;
DROP TABLE TAI_KHOAN;
DROP TABLE CHUC_VU;

select * from KQ_HOC_TAP where MaTK = 'TK002';

DELETE FROM LICH_SU_TUONG_TAC;
DELETE FROM CT_XU_LY;
DELETE FROM CANH_BAO;
DELETE FROM KQ_HOC_TAP;
DELETE FROM BUOI_HOC;
DELETE FROM LICH_HOC;
DELETE FROM CT_PHU_TRACH;
DELETE FROM KQ_BAI_TEST;
DELETE FROM BAI_LAM;
DELETE FROM LOI_NHAC;
DELETE FROM BAI_TEST;
DELETE FROM KHACH_HANG;
DELETE FROM HOC_VIEN;
DELETE FROM LOP_HOC;
DELETE FROM TAI_KHOAN;
DELETE FROM CHUC_VU;

ALTER TABLE KHACH_HANG
ADD FacebookID NVARCHAR(MAX);

ALTER TABLE HOC_VIEN
ADD FacebookID NVARCHAR(MAX);

