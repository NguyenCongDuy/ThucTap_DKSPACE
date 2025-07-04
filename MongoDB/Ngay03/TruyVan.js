// I: Tạo và Quản lý Indexes trong MongoDB

// 1. Tạo Single Field Index trên trường email trong collection members
db.members.createIndex({ email: 1 })
// 2. Tạo Compound Index (chỉ mục kết hợp) trên member_id và borrow_date trong collection loans
db.loans.createIndex({ member_id: 1, borrow_date: -1 })

// 3. Xóa Index trên email trong members.
db.members.dropIndex("email_1")
// Viết truy vấn sử dụng explain() để kiểm tra hiệu quả của chỉ mục
db.loans.find({
  member_id: UUID("123e4567-e89b-12d3-a456-426614174001"),
  borrow_date: { $gte: ISODate("2024-05-01"), $lte: ISODate("2024-05-31") }
}).explain("executionStats")

// II: Text Index – Tìm kiếm văn bản
// 1. Tạo Text Index trên book_title trong collection loans
db.loans.createIndex({ book_title: "text" })
// 2. Truy vấn dùng $text để tìm văn bản chứa từ khóa “Science Fiction”
db.loans.find({
  $text: { $search: "Science Fiction" }
})

// III: Unique Index – Đảm bảo không trùng dữ liệu
// 1. Tạo Unique Index trên email trong collection members
db.members.createIndex(
  { email: 1 },
  { unique: true }
)
// 2. Thử thêm một thành viên với email đã tồn tại để kiểm tra Unique Index
db.members.insertOne({
  member_id: UUID("123e4567-e89b-12d3-a456-426614174010"),
  full_name: "Nguyen Van Duplicate",
  email: "trana@example.com",
  joined_at: ISODate("2025-07-01T00:00:00Z")
})

// IV: TTL Index – Tự động xóa dữ liệu sau một thời gian

// 1. Tạo TTL Index trên trường created_at của collection audit_logs
db.audit_logs.createIndex(
  { created_at: 1 },
  { expireAfterSeconds: 2592000 }
)
// 2. Thêm bản ghi vào audit_logs
db.audit_logs.insertOne({
  log_id: UUID("8da7b810-9dad-11d1-80b4-00c04fd430c9"),
  action: "BORROW",
  member_id: UUID("123e4567-e89b-12d3-a456-426614174001"),
  created_at: new Date()
})

// V: Capped Collection – Bộ nhớ tuần hoàn cố định
// 1. Tạo Capped Collection system_notifications có dung lượng tối đa 1MB
db.createCollection("system_notifications", {
  capped: true,
  size: 1048576
})
// 2. Thêm thông báo vào system_notifications
db.system_notifications.insertOne({
  notification_id: UUID("3ea7b810-9dad-11d1-80b4-00c04fd43100"),
  message: "Server lỗi sẽ restart vào tối nay.",
  created_at: new Date()
})

// VI: Bulk Write Operations – Viết nhiều thao tác trong một lệnh
// Lệnh bulkWrite – cho members:
db.members.bulkWrite([
  {
    insertOne: {
      document: {
        member_id: UUID("123e4567-e89b-12d3-a456-426614174011"),
        full_name: "Le Thi Da",
        email: "lesad@example.com",
        joined_at: new Date()
      }
    }
  },
  {
    updateOne: {
      filter: { member_id: UUID("123e4567-e89b-12d3-a456-426614174001") },
      update: { $set: { email: "newemail@example.com" } }
    }
  }
])
// Lệnh bulkWrite – cho loans:
db.loans.bulkWrite([
  {
    deleteOne: {
      filter: { loan_id: UUID("6ba7b810-9dad-11d1-80b4-00c04fd430c8") }
    }
  },
  {
    insertOne: {
      document: {
        loan_id: UUID("a0a7b810-9dad-11d1-80b4-00c04fd43111"),
        member_id: UUID("123e4567-e89b-12d3-a456-426614174011"),
        book_id: UUID("b0a7b810-9dad-11d1-80b4-00c04fd43112"),
        book_title: "1984",
        borrow_date: ISODate("2025-07-01T00:00:00Z"),
        due_date: ISODate("2025-07-15T00:00:00Z")
      }
    }
  },
  {
    insertOne: {
      document: {
        loan_id: UUID("c0a7b810-9dad-11d1-80b4-00c04fd43113"),
        member_id: UUID("123e4567-e89b-12d3-a456-426614174011"),
        book_id: UUID("d0a7b810-9dad-11d1-80b4-00c04fd43114"),
        book_title: "Brave New World",
        borrow_date: ISODate("2025-07-01T00:00:00Z"),
        due_date: ISODate("2025-07-15T00:00:00Z")
      }
    }
  }
])


// VII: Kiểm tra & Tối ưu hóa chỉ mục trong MongoDB 
// 1. Liệt kê tất cả chỉ mục trong collection loans
db.loans.getIndexes()
// 2. Sử dụng explain("executionStats") để kiểm tra hiệu quả truy vấn trước và sau khi tạo compound index
db.loans.find({
  member_id: UUID("550e8400-e29b-41d4-a716-446655440000"),
  borrow_date: {
    $gte: ISODate("2024-03-01T00:00:00Z"),
    $lte: ISODate("2024-04-30T00:00:00Z")
  }
}).explain("executionStats")
// 3. Giám sát kích thước chỉ mục với collStats 
db.runCommand({ collStats: "loans" })
