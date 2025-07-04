// 1. Sử dụng $match
//  Lọc loans có status = "ACTIVE" và due_date nằm trong tháng 4/2024
db.loans.aggregate([
    {
        $match: {
            status: "ACTIVE",
            due_date: {
                $gte: ISODate("2024-04-01T00:00:00Z"),
                $lte: ISODate("2024-04-30T23:59:59Z")
            }
        }
    }
])
// Lọc members có joined_at > 01/01/2024
db.members.aggregate([
    {
        $match: {
            joined_at: { $gt: ISODate("2024-01-01T00:00:00Z") }
        }
    }
])

// 2 Sử dụng $group:
// Đếm số lượng giao dịch mượn theo member_id
db.loans.aggregate([
    {
        $group: {
            _id: "$member_id",
            total_loans: { $sum: 1 }
        }
    }
])
// Đếm số lần mượn của mỗi sách (books.book_id) 
db.loans.aggregate([
    { $unwind: "$books" },
    {
        $group: {
            _id: "$books.book_id",
            total_borrows: { $sum: 1 }
        }
    }])

// 3 Sử dụng $sort:
// Kết hợp $group và $sort để lấy danh sách thành viên với tổng số lần mượn, sắp xếp theo số lần mượn giảm dần
db.loans.aggregate([
    {
        $group: {
            _id: "$member_id",
            total_loans: { $sum: 1 }
        }
    },
    {
        $sort: { total_loans: -1 }
    }
])
// Sắp xếp các sách theo số lần mượn tăng dần
db.loans.aggregate([
    { $unwind: "$books" },
    {
        $group: {
            _id: "$books.book_id",
            total_borrows: { $sum: 1 }
        }
    },
    {
        $sort: { total_borrows: 1 }
    }
])
// 4 Sử dụng $project:
// Định dạng kết quả từ members, chỉ trả về full_name (viết hoa bằng $toUpper),
// email, và một trường mới year_joined (trích năm từ joined_at)
db.members.aggregate([
    {
        $project: {
            full_name: { $toUpper: "$full_name" },
            email: 1,
            year_joined: { $year: "$joined_at" }
        }
    }
])
// Trả về loan_id, status, và số lượng sách mượn ($size của mảng books)
db.loans.aggregate([
    {
        $project: {
            loan_id: 1,
            status: 1,
            number_of_books: { $size: "$books" }
        }
    }
])

// 5 Sử dụng $unwind
// Sử dụng $unwind trên mảng books trong loans để tách mỗi cuốn sách thành một document riêng
db.loans.aggregate([
    { $unwind: "$books" }
])
// Kết hợp $unwind và $group để tính số lần mượn của mỗi books.title
db.loans.aggregate([
    { $unwind: "$books" },
    {
        $group: {
            _id: "$books.title",
            borrow_count: { $sum: 1 }
        }
    }
])

// 6 Sử dụng $limit và $skip
// Lấy 5 thành viên có số lần mượn cao nhất – dùng $group, $sort, $limit
db.loans.aggregate([
    {
        $group: {
            _id: "$member_id",
            total_loans: { $sum: 1 }
        }
    },
    { $sort: { total_loans: -1 } },
    { $limit: 5 }
])

// Lấy 5 giao dịch mượn từ bản ghi thứ 6, sắp xếp theo due_date giảm dần – dùng $sort, $skip, $limit
db.loans.aggregate([
    { $sort: { due_date: -1 } },
    { $skip: 5 },
    { $limit: 4 }
])

// 7 Sử dụng $count, $sum, $avg, $min, $max
// Dùng $count để đếm số giao dịch mượn có status là "ACTIVE"
db.loans.aggregate([
    { $match: { status: "ACTIVE" } },
    { $count: "active_loans_count" }
])
// Dùng $group với: 
// $avg để tính trung bình số sách mượn mỗi giao dịch.
db.loans.aggregate([
  {
    $project: {
      book_count: { $size: "$books" }
    }
  },
  {
    $group: {
      _id: null,
      avg_books_per_loan: { $avg: "$book_count" }
    }
  }
])
// $min và $max để tìm ngày mượn sớm nhất và muộn nhất (borrow_date trong books).
db.loans.aggregate([
  { $unwind: "$books" },
  {
    $group: {
      _id: null,
      earliest_borrow_date: { $min: "$books.borrow_date" },
      latest_borrow_date: { $max: "$books.borrow_date" }
    }
  }
])
// $sum để tính tổng số sách mượn (tính tổng $size của mảng books)
db.loans.aggregate([
    {
        $project: {
            book_count: { $size: "$books" }
        }
    },
    {
        $group: {
            _id: null,
            total_books_borrowed: { $sum: "$book_count" }
        }
    }
])
// 8 Pipeline Stages và Expressions
// Thiết kế pipeline kết hợp ít nhất 4 stage ($match, $unwind, $group, $sort) để 
// phân tích số lần mượn theo danh mục sách (giả sử books có trường category)
db.loans.aggregate([
  { $unwind: "$books" },
  {
    $match: {
      "books.borrow_date": {
        $gte: ISODate("2024-04-01T00:00:00Z"),
        $lt: ISODate("2024-05-01T00:00:00Z")
      }
    }
  },
  {
    $group: {
      _id: "$books.category",
      borrow_count: { $sum: 1 }
    }
  },
  { $sort: { borrow_count: -1 } }
])

// Sử dụng expression $cond trong $project để thêm trường is_overdue (true nếu due_date < ngày hiện tại)
db.loans.aggregate([
  {
    $project: {
      loan_id: 1,
      due_date: 1,
      is_overdue: {
        $cond: [
          { $lt: ["$due_date", new Date()] },
          true,
          false
        ]
      }
    }
  }
])

