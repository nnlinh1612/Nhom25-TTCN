using System;
using System.Collections.Generic;
using Microsoft.EntityFrameworkCore;

namespace TTNguVan.Models;

public partial class TrungTamNguVanContext : DbContext
{
    public TrungTamNguVanContext()
    {
    }

    public TrungTamNguVanContext(DbContextOptions<TrungTamNguVanContext> options)
        : base(options)
    {
    }

    public virtual DbSet<BaiLam> BaiLams { get; set; }

    public virtual DbSet<BaiTest> BaiTests { get; set; }

    public virtual DbSet<BuoiHoc> BuoiHocs { get; set; }

    public virtual DbSet<CanhBao> CanhBaos { get; set; }

    public virtual DbSet<ChucVu> ChucVus { get; set; }

    public virtual DbSet<CtPhuTrach> CtPhuTraches { get; set; }

    public virtual DbSet<HocVien> HocViens { get; set; }

    public virtual DbSet<KhachHang> KhachHangs { get; set; }

    public virtual DbSet<KqBaiTest> KqBaiTests { get; set; }

    public virtual DbSet<KqHocTap> KqHocTaps { get; set; }

    public virtual DbSet<LichHoc> LichHocs { get; set; }

    public virtual DbSet<LichSuTuongTac> LichSuTuongTacs { get; set; }

    public virtual DbSet<LoiNhac> LoiNhacs { get; set; }

    public virtual DbSet<LopHoc> LopHocs { get; set; }

    public virtual DbSet<TaiKhoan> TaiKhoans { get; set; }

    protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
#warning To protect potentially sensitive information in your connection string, you should move it out of source code. You can avoid scaffolding the connection string by using the Name= syntax to read it from configuration - see https://go.microsoft.com/fwlink/?linkid=2131148. For more guidance on storing connection strings, see https://go.microsoft.com/fwlink/?LinkId=723263.
        => optionsBuilder.UseSqlServer("Server=DESKTOP-APN6RL7\\SQLEXPRESS;Database=TrungTamNguVan;Trusted_Connection=True;TrustServerCertificate=True");

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.Entity<BaiLam>(entity =>
        {
            entity.HasKey(e => e.MaBaiLam).HasName("PK__BAI_LAM__15A2E38471228F49");

            entity.ToTable("BAI_LAM");

            entity.Property(e => e.MaBaiLam)
                .HasMaxLength(8)
                .IsUnicode(false);
            entity.Property(e => e.MaBaiTest)
                .HasMaxLength(8)
                .IsUnicode(false);
            entity.Property(e => e.MaHocVien)
                .HasMaxLength(8)
                .IsUnicode(false);

            entity.HasOne(d => d.MaBaiTestNavigation).WithMany(p => p.BaiLams)
                .HasForeignKey(d => d.MaBaiTest)
                .HasConstraintName("FK__BAI_LAM__MaBaiTe__6501FCD8");

            entity.HasOne(d => d.MaHocVienNavigation).WithMany(p => p.BaiLams)
                .HasForeignKey(d => d.MaHocVien)
                .HasConstraintName("FK__BAI_LAM__MaHocVi__65F62111");
        });

        modelBuilder.Entity<BaiTest>(entity =>
        {
            entity.HasKey(e => e.MaBaiTest).HasName("PK__BAI_TEST__1B25CC4B1C7EBBE4");

            entity.ToTable("BAI_TEST");

            entity.Property(e => e.MaBaiTest)
                .HasMaxLength(8)
                .IsUnicode(false);
            entity.Property(e => e.TenBaiTest).HasMaxLength(150);
        });

        modelBuilder.Entity<BuoiHoc>(entity =>
        {
            entity.HasKey(e => e.MaBuoiHoc).HasName("PK__BUOI_HOC__533025065CB16617");

            entity.ToTable("BUOI_HOC");

            entity.Property(e => e.MaBuoiHoc)
                .HasMaxLength(8)
                .IsUnicode(false);
            entity.Property(e => e.MaLop)
                .HasMaxLength(8)
                .IsUnicode(false);

            entity.HasOne(d => d.MaLopNavigation).WithMany(p => p.BuoiHocs)
                .HasForeignKey(d => d.MaLop)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__BUOI_HOC__MaLop__5B78929E");
        });

        modelBuilder.Entity<CanhBao>(entity =>
        {
            entity.HasKey(e => e.MaCanhBao).HasName("PK__CANH_BAO__73C23D93B431F436");

            entity.ToTable("CANH_BAO");

            entity.Property(e => e.MaCanhBao)
                .HasMaxLength(8)
                .IsUnicode(false);
            entity.Property(e => e.HanChot).HasColumnType("datetime");
            entity.Property(e => e.MaKqht)
                .HasMaxLength(8)
                .IsUnicode(false)
                .HasColumnName("MaKQHT");
            entity.Property(e => e.MucDo).HasMaxLength(50);
            entity.Property(e => e.NoiDungCb)
                .HasMaxLength(500)
                .HasColumnName("NoiDungCB");
            entity.Property(e => e.TieuDe).HasMaxLength(100);
            entity.Property(e => e.TrangThai).HasDefaultValue(false);

            entity.HasOne(d => d.MaKqhtNavigation).WithMany(p => p.CanhBaos)
                .HasForeignKey(d => d.MaKqht)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__CANH_BAO__MaKQHT__7908F585");
        });

        modelBuilder.Entity<ChucVu>(entity =>
        {
            entity.HasKey(e => e.MaChucVu).HasName("PK__CHUC_VU__D46395333BE64A7C");

            entity.ToTable("CHUC_VU");

            entity.Property(e => e.MaChucVu)
                .HasMaxLength(8)
                .IsUnicode(false);
            entity.Property(e => e.TenChucVu).HasMaxLength(20);
        });

        modelBuilder.Entity<CtPhuTrach>(entity =>
        {
            entity.HasKey(e => new { e.MaTk, e.MaLop }).HasName("PK__CT_PHU_T__049C8D57BBE2CCBF");

            entity.ToTable("CT_PHU_TRACH");

            entity.Property(e => e.MaTk)
                .HasMaxLength(8)
                .IsUnicode(false)
                .HasColumnName("MaTK");
            entity.Property(e => e.MaLop)
                .HasMaxLength(8)
                .IsUnicode(false);
            entity.Property(e => e.NgayBatDauPt).HasColumnName("NgayBatDauPT");
            entity.Property(e => e.NgayKetThucPt).HasColumnName("NgayKetThucPT");
            entity.Property(e => e.VaiTro).HasMaxLength(50);

            entity.HasOne(d => d.MaLopNavigation).WithMany(p => p.CtPhuTraches)
                .HasForeignKey(d => d.MaLop)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__CT_PHU_TR__MaLop__6D9742D9");

            entity.HasOne(d => d.MaTkNavigation).WithMany(p => p.CtPhuTraches)
                .HasForeignKey(d => d.MaTk)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__CT_PHU_TRA__MaTK__6CA31EA0");
        });

        modelBuilder.Entity<HocVien>(entity =>
        {
            entity.HasKey(e => e.MaHocVien).HasName("PK__HOC_VIEN__685B0E6AEC144E74");

            entity.ToTable("HOC_VIEN");

            entity.Property(e => e.MaHocVien)
                .HasMaxLength(8)
                .IsUnicode(false);
            entity.Property(e => e.FacebookId).HasColumnName("FacebookID");
            entity.Property(e => e.MaLop)
                .HasMaxLength(8)
                .IsUnicode(false);
            entity.Property(e => e.Sdt)
                .HasMaxLength(10)
                .IsUnicode(false)
                .HasColumnName("SDT");
            entity.Property(e => e.TenHocVien).HasMaxLength(50);
            entity.Property(e => e.TrangThai).HasMaxLength(50);

            entity.HasOne(d => d.MaLopNavigation).WithMany(p => p.HocViens)
                .HasForeignKey(d => d.MaLop)
                .HasConstraintName("FK__HOC_VIEN__MaLop__589C25F3");
        });

        modelBuilder.Entity<KhachHang>(entity =>
        {
            entity.HasKey(e => e.MaKhachHang).HasName("PK__KHACH_HA__88D2F0E5520F868F");

            entity.ToTable("KHACH_HANG");

            entity.Property(e => e.MaKhachHang)
                .HasMaxLength(8)
                .IsUnicode(false);
            entity.Property(e => e.FacebookId).HasColumnName("FacebookID");
            entity.Property(e => e.MaHocVien)
                .HasMaxLength(8)
                .IsUnicode(false);
            entity.Property(e => e.NgayTiepNhan).HasDefaultValueSql("(getdate())");
            entity.Property(e => e.NguonDen).HasMaxLength(255);
            entity.Property(e => e.Sdt)
                .HasMaxLength(10)
                .IsUnicode(false)
                .HasColumnName("SDT");
            entity.Property(e => e.TenKhachHang).HasMaxLength(50);
            entity.Property(e => e.TrangThai).HasMaxLength(50);

            entity.HasOne(d => d.MaHocVienNavigation).WithMany(p => p.KhachHangs)
                .HasForeignKey(d => d.MaHocVien)
                .HasConstraintName("FK__KHACH_HAN__MaHoc__6225902D");
        });

        modelBuilder.Entity<KqBaiTest>(entity =>
        {
            entity.HasKey(e => new { e.MaBaiLam, e.MaTk }).HasName("PK__KQ_BAI_T__07D0B38364F5E1F9");

            entity.ToTable("KQ_BAI_TEST");

            entity.Property(e => e.MaBaiLam)
                .HasMaxLength(8)
                .IsUnicode(false);
            entity.Property(e => e.MaTk)
                .HasMaxLength(8)
                .IsUnicode(false)
                .HasColumnName("MaTK");
            entity.Property(e => e.GhiChu).HasMaxLength(500);
            entity.Property(e => e.NhanXet).HasMaxLength(500);

            entity.HasOne(d => d.MaBaiLamNavigation).WithMany(p => p.KqBaiTests)
                .HasForeignKey(d => d.MaBaiLam)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_KQ_Test");

            entity.HasOne(d => d.MaTkNavigation).WithMany(p => p.KqBaiTests)
                .HasForeignKey(d => d.MaTk)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__KQ_BAI_TES__MaTK__74444068");
        });

        modelBuilder.Entity<KqHocTap>(entity =>
        {
            entity.HasKey(e => e.MaKqht).HasName("PK__KQ_HOC_T__405D93065D92B8E3");

            entity.ToTable("KQ_HOC_TAP");

            entity.Property(e => e.MaKqht)
                .HasMaxLength(8)
                .IsUnicode(false)
                .HasColumnName("MaKQHT");
            entity.Property(e => e.Btvn)
                .HasMaxLength(50)
                .HasColumnName("BTVN");
            entity.Property(e => e.DiemDanh).HasMaxLength(50);
            entity.Property(e => e.MaBuoiHoc)
                .HasMaxLength(8)
                .IsUnicode(false);
            entity.Property(e => e.MaHocVien)
                .HasMaxLength(8)
                .IsUnicode(false);
            entity.Property(e => e.NhanXet).HasMaxLength(500);

            entity.HasOne(d => d.MaBuoiHocNavigation).WithMany(p => p.KqHocTaps)
                .HasForeignKey(d => d.MaBuoiHoc)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__KQ_HOC_TA__MaBuo__68D28DBC");

            entity.HasOne(d => d.MaHocVienNavigation).WithMany(p => p.KqHocTaps)
                .HasForeignKey(d => d.MaHocVien)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__KQ_HOC_TA__MaHoc__69C6B1F5");
        });

        modelBuilder.Entity<LichHoc>(entity =>
        {
            entity.HasKey(e => e.MaLich).HasName("PK__LICH_HOC__728A9AE969E4FC1D");

            entity.ToTable("LICH_HOC");

            entity.Property(e => e.MaLich)
                .HasMaxLength(8)
                .IsUnicode(false);
            entity.Property(e => e.MaLop)
                .HasMaxLength(8)
                .IsUnicode(false);
            entity.Property(e => e.TenCa).HasMaxLength(50);

            entity.HasOne(d => d.MaLopNavigation).WithMany(p => p.LichHocs)
                .HasForeignKey(d => d.MaLop)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Lich_Lop");
        });

        modelBuilder.Entity<LichSuTuongTac>(entity =>
        {
            entity.HasKey(e => e.MaTuongTac).HasName("PK__LICH_SU___E947A5AC2B4239F1");

            entity.ToTable("LICH_SU_TUONG_TAC");

            entity.Property(e => e.MaTuongTac)
                .HasMaxLength(8)
                .IsUnicode(false);
            entity.Property(e => e.LoaiTuongTac).HasMaxLength(50);
            entity.Property(e => e.MaHocVien)
                .HasMaxLength(8)
                .IsUnicode(false);
            entity.Property(e => e.MaKhachHang)
                .HasMaxLength(8)
                .IsUnicode(false);
            entity.Property(e => e.MaTk)
                .HasMaxLength(8)
                .IsUnicode(false)
                .HasColumnName("MaTK");

            entity.HasOne(d => d.MaHocVienNavigation).WithMany(p => p.LichSuTuongTacs)
                .HasForeignKey(d => d.MaHocVien)
                .HasConstraintName("FK__LICH_SU_T__MaHoc__7DCDAAA2");

            entity.HasOne(d => d.MaKhachHangNavigation).WithMany(p => p.LichSuTuongTacs)
                .HasForeignKey(d => d.MaKhachHang)
                .HasConstraintName("FK__LICH_SU_T__MaKha__7CD98669");

            entity.HasOne(d => d.MaTkNavigation).WithMany(p => p.LichSuTuongTacs)
                .HasForeignKey(d => d.MaTk)
                .HasConstraintName("FK__LICH_SU_TU__MaTK__7BE56230");
        });

        modelBuilder.Entity<LoiNhac>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PK__LOI_NHAC__3214EC072364F489");

            entity.ToTable("LOI_NHAC");

            entity.Property(e => e.HanChot).HasColumnType("datetime");
            entity.Property(e => e.MaTk)
                .HasMaxLength(8)
                .IsUnicode(false)
                .HasColumnName("MaTK");
            entity.Property(e => e.MucDo).HasMaxLength(50);
            entity.Property(e => e.TieuDe).HasMaxLength(200);
            entity.Property(e => e.TrangThai).HasDefaultValue(false);

            entity.HasOne(d => d.MaTkNavigation).WithMany(p => p.LoiNhacs)
                .HasForeignKey(d => d.MaTk)
                .HasConstraintName("FK_Loi_nhac");
        });

        modelBuilder.Entity<LopHoc>(entity =>
        {
            entity.HasKey(e => e.MaLop).HasName("PK__LOP_HOC__3B98D2736D96D35F");

            entity.ToTable("LOP_HOC");

            entity.Property(e => e.MaLop)
                .HasMaxLength(8)
                .IsUnicode(false);
            entity.Property(e => e.MoTa).HasMaxLength(500);
            entity.Property(e => e.TenLop).HasMaxLength(150);
        });

        modelBuilder.Entity<TaiKhoan>(entity =>
        {
            entity.HasKey(e => e.MaTk).HasName("PK__TAI_KHOA__272500708D7FE0E1");

            entity.ToTable("TAI_KHOAN");

            entity.Property(e => e.MaTk)
                .HasMaxLength(8)
                .IsUnicode(false)
                .HasColumnName("MaTK");
            entity.Property(e => e.Email)
                .HasMaxLength(100)
                .IsUnicode(false);
            entity.Property(e => e.HoTen).HasMaxLength(50);
            entity.Property(e => e.MaChucVu)
                .HasMaxLength(8)
                .IsUnicode(false);
            entity.Property(e => e.MatKhau)
                .HasMaxLength(255)
                .IsUnicode(false);
            entity.Property(e => e.TrangThai).HasMaxLength(20);

            entity.HasOne(d => d.MaChucVuNavigation).WithMany(p => p.TaiKhoans)
                .HasForeignKey(d => d.MaChucVu)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__TAI_KHOAN__MaChu__55BFB948");
        });

        OnModelCreatingPartial(modelBuilder);
    }

    partial void OnModelCreatingPartial(ModelBuilder modelBuilder);
}
