// 3. truy vấn để lấy danh sách sách mà một thành viên đã mượn (ghép loans và books).
db.loans.aggregate([
  {
    $match: {
      member_id: UUID("550e8400-e29b-41d4-a716-446655440000")
    }
  },
  {
    $lookup: {
      from: "books",
      localField: "book_id",
      foreignField: "_id",
      as: "book_info"
    }
  },
  {
    $unwind: "$book_info"
  },
  {
    $project: {
      _id: 0,
      book_title: "$book_info.title",
      borrowed_on: "$borrow_date"
    }
  }
])

// 4. Thiết kế schema loans sử dụng DBRef
db.loans.insertOne({
  _id: UUID("6ba7b810-9dad-11d1-80b4-00c04fd430c8"),
  member: {
    $ref: "members",
    $id: UUID("550e8400-e29b-41d4-a716-446655440000")
  },
  book: {
    $ref: "books",
    $id: UUID("7ca7b810-9dad-11d1-80b4-00c04fd430c8")
  },
  borrow_date: ISODate("2024-04-01T00:00:00Z"),
  return_date: null
})
// Viết truy vấn: Lấy thông tin thành viên và sách từ 1 loan
db.loans.aggregate([
  {
    $lookup: {
      from: "members",
      localField: "member.$id",
      foreignField: "_id",
      as: "member_info"
    }
  },
  { $unwind: "$member_info" },
  {
    $lookup: {
      from: "books",
      localField: "book.$id",
      foreignField: "_id",
      as: "book_info"
    }
  },
  { $unwind: "$book_info" },
  {
    $project: {
      _id: 0,
      member_name: "$member_info.full_name",
      book_title: "$book_info.title",
      borrow_date: 1
    }
  }
])

// 5 Thiết kế schema loans (Manual Referencing)
db.loans.insertOne({
  loan_id: UUID("6ba7b810-9dad-11d1-80b4-00c04fd430c8"),
  member_id: UUID("550e8400-e29b-41d4-a716-446655440000"),
  book_id: UUID("7ca7b810-9dad-11d1-80b4-00c04fd430c8"),
  borrow_date: ISODate("2024-04-01T00:00:00Z"),
  return_date: null
});
// Viết truy vấn $lookup để ghép dữ liệu từ 3 bảng
db.loans.aggregate([
  {
    $lookup: {
      from: "members",
      localField: "member_id",
      foreignField: "member_id",
      as: "member_info"
    }
  },
  { $unwind: "$member_info" },

  {
    $lookup: {
      from: "books",
      localField: "book_id",
      foreignField: "book_id",
      as: "book_info"
    }
  },
  { $unwind: "$book_info" },

  {
    $project: {
      _id: 0,
      loan_id: 1,
      borrow_date: 1,
      "member_name": "$member_info.full_name",
      "book_title": "$book_info.title"
    }
  }
])

// 7. Thêm Validate schema cho collection members
db.runCommand({
  collMod: "members",
  validator: {
    $jsonSchema: {
      bsonType: "object",
      required: ["full_name", "email", "joined_at"],
      properties: {
        full_name: { bsonType: "string", maxLength: 100 },
        email: { bsonType: "string", pattern: "^.+@.+$" },
        joined_at: { bsonType: "date" }
      }
    }
  },
  validationLevel: "strict",
  validationAction: "error"
})

// insert dữ liệu thiếu
db.members.insertOne({
  full_name: "Nguyen Van A",
  joined_at: new Date("2024-06-01")
})

// gợi ý book 
db.runCommand({
  collMod: "books",
  validator: {
    $jsonSchema: {
      bsonType: "object",
      required: ["title", "author", "stock"],
      properties: {
        title: {
          bsonType: "string",
          description: "Tiêu đề sách là chuỗi, bắt buộc"
        },
        author: {
          bsonType: "string",
          description: "Tác giả là chuỗi, bắt buộc"
        },
        category: {
          bsonType: "string",
          description: "Danh mục là chuỗi (không bắt buộc)"
        },
        stock: {
          bsonType: "int",
          minimum: 0,
          description: "Tồn kho là số nguyên không âm"
        }
      }
    }
  },
  validationLevel: "strict",
  validationAction: "error"
})



