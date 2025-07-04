// 1. Sử dụng Logical Operators ($and, $or, $not, $nor):
// 1.1. $and: Thành viên ở "Ho Chi Minh City" và có sở thích "Fiction"
db.members.find({
  $and: [
    { "contact.city": "Ho Chi Minh City" },
    { interests: "Fiction" }
  ]
})
// 1.2. $or: Thành viên có joined_at trước 1/1/2025 hoặc email chứa "example.com"
db.members.find({
  $or: [
    { joined_at: { $lt: ISODate("2025-01-01T00:00:00Z") } },
    { email: /example\.com$/ }
  ]
})
// 1.3. $not: Giao dịch không có status là "ACTIVE"
db.loans.find({
  status: { $not: { $eq: "ACTIVE" } }
})
// 1.4. $nor: Thành viên không có interests là "Science" và không sống ở "Hanoi"
db.members.find({
  $nor: [
    { interests: "Science" },
    { "contact.city": "Hanoi" }
  ]
})

// 2. Sử dụng Element Operators ($exists, $type):
// 2.1. $exists: Tìm thành viên có trường contact.phone
db.members.find({
  "contact.phone": { $exists: true }
})
// 2.2. $type: Tìm các giao dịch loans có due_date kiểu date
db.loans.find({
  due_date: { $type: "date" }
})

// 3. Sử dụng Array Operators ($in, $nin, $all):
// 3.1. $in: Thành viên có interests thuộc 1 trong 2 giá trị "Fiction" hoặc "History"
db.members.find({
  interests: { $in: ["Fiction", "History"] }
})
// 3.2. $nin: Thành viên không có "Science" hoặc "Technology" trong interests
db.members.find({
  interests: { $nin: ["Science", "Technology"] }
})
// 3.3. all
 db.members.find({
 interests: { $all: ["Fiction", "History"]}
 })

// 4. Sắp xếp với sort():
// 4.1 Sắp xếp members theo joined_at giảm dần
db.members.find().sort({ joined_at: -1 })
// 4.2 Sắp xếp loans theo due_date tăng dần và member_id giảm dần
db.loans.find().sort({ due_date: 1, member_id: -1 })
// 5. Phân trang với limit() và skip():
// 5.1 Lấy 10 thành viên đầu tiên, bỏ qua 20 bản ghi đầu, sắp xếp theo tên tăng dần
db.members.find().sort({ full_name: 1 }).skip(2).limit(2)
// 5.2 Lấy 5 loan từ bản ghi thứ 11, sắp xếp theo due_date giảm dần
db.loans.find().sort({ due_date: -1 }).skip(2).limit(2)
// 6. Projection: Lựa chọn trường trả về:
// 6.1. Lấy danh sách members, chỉ trả về full_name, email, loại bỏ _id
db.members.find({}, {
  full_name: 1,
  email: 1,
  _id: 0
})
// 6.2 Lấy danh sách loans, chỉ trả về member_id, status, books.title
db.loans.find({}, {
  member_id: 1,
  status: 1,
  "books.title": 1,
  _id: 0
})
// 7. Truy vấn Embedded Documents:
// 7.1 Tìm các thành viên (members) có contact.city là "Hanoi".
db.members.find({
  "contact.city": "Hanoi"
})
// 7.2 Tìm các giao dịch mượn có ít nhất một cuốn sách trong books với borrow_date sau 1/4/2024
db.loans.find({
  "books.borrow_date": {
    $gt: ISODate("2024-04-01T00:00:00Z")
  }
})
// 8. Truy vấn Arrays:
// 8.1 Tìm các members có đúng 3 sở thích (mảng interests có độ dài = 3)
db.members.find({
  interests: { $size: 3 }
})
// 8.2 Tìm các giao dịch mượn c óbooks chứa cuốn sách với title là "Dune".
db.loans.find({
  "books.title": "Dune"
})


