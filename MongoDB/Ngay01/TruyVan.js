// Tổng quan và cài đặt MongoDB:
//  PHẦN 2: DATABASE, COLLECTION, DOCUMENT

// Tạo cơ sở dữ liệu và collection trong MongoDB
// use banking_system

db.createCollection("customers")
db.createCollection("transactions")
// xem danh sách

// show dbs
// show collections
//  PHẦN 3: CREATE - THÊM Dữ LIỆU

// thêm 1 khách hàng
db.customers.insertOne({
    customer_id: UUID("550e8400-e29b-41d4-a716-446655440000"),
    full_name: "Nguyen Van A",
    email: "nguyen@example.com",
    created_at: new ISODate("2024-01-01T00:00:00Z")
})

// thêm nhiều khách hàng
db.transactions.insertMany([
  {
    transaction_id: UUID("6ba7b810-9dad-11d1-80b4-00c04fd430c8"),
    customer_id: UUID("550e8400-e29b-41d4-a716-446655440000"),
    amount: 1000,
    type: "DEPOSIT",
    transaction_date: new ISODate("2024-02-01T10:00:00Z")
  },
  {
    transaction_id: UUID("6ba7b811-9dad-11d1-80b4-00c04fd430c8"),
    customer_id: UUID("550e8400-e29b-41d4-a716-446655440000"),
    amount: 500,
    type: "WITHDRAW",
    transaction_date: new ISODate("2024-02-02T12:00:00Z")
  }
])

// PHẦN 4: READ - TRUY VẤN Dữ LIỆU

// tìm khách hàng chứa từ "Nguyen"
db.customers.find({ full_name:{$regex:"Nguyen"}})

// Tìm giao dịch > 700:
db.transactions.findOne({ amount: { $gt: 700 } })

//Kết hợp nhiều điều kiện

// amount >= 500 và type != "WITHDRAW"
db.transactions.find({
  amount: { $gte: 500 },
  type: { $ne: "WITHDRAW" }
})

// Khách hàng tạo trước 1/6/2024

db.customers.find({
  created_at: { $lt: new ISODate("2024-06-01T00:00:00Z") }
})

// PHẦN 5: UPDATE - CẬP NHẬT Dữ LIỆU

// . Cập nhật email khách hàng:

db.customers.updateOne(
  { customer_id: UUID("550e8400-e29b-41d4-a716-446655440000") },
  { $set: { email: "newemail@example.com" } }
)

// Thêm trường status cho khách hàng mới
db.customers.updateMany(
  { created_at: { $gt: new ISODate("2024-01-01T00:00:00Z") } },
  { $set: { status: "ACTIVE" } }
)

// PHẦN 6: DELETE - XOÁ Dữ LIỆU

// Xoá giao dịch có transaction_id cụ thể:
db.transactions.deleteOne({
  transaction_id: UUID("6ba7b811-9dad-11d1-80b4-00c04fd430c8")
})

// PHẦN 7: Sử DỤNG TOÁN TỬ SO SÁNH (Query Operators)

// Tìm theo $eq:
db.customers.find({ full_name: { $eq: "Nguyen Van A" } })

//  $gt + $lte::
db.transactions.find({
  amount: { $gt: 300 },
  transaction_date: { $lte: new ISODate("2024-02-01T10:00:00.000+00:00") }
})

// $ne:
db.customers.find({ email: { $ne: "le.van.c@example.com" } })