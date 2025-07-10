//Sử dụng Multi-Document Transaction
// 1: Multi-Document Transactions – Mượn sách
const session = db.getMongo().startSession();

try {
    session.startTransaction({
        readConcern: { level: "snapshot" },
        writeConcern: { w: "majority", wtimeout: 5000 },
    });

    const booksColl = session.getDatabase("libraryDB_06").books;
    const loansColl = session.getDatabase("libraryDB_06").loans;

    const bookId = UUID("7ca7b810-9dad-11d1-80b4-00c04fd430c8");
    const memberId = UUID("550e8400-e29b-41d4-a716-446655440000");

    const book = booksColl.findOne({ book_id: bookId });
    if (!book || book.stock <= 0) {
        throw new Error("Sách không còn trong kho");
    }

    const updateResult = booksColl.updateOne(
        { book_id: bookId, stock: { $gt: 0 } },
        { $inc: { stock: -1 } }
    );
    if (updateResult.matchedCount === 0) {
        throw new Error("Cập nhật số lượng sách thất bại");
    }

    loansColl.insertOne({
        loan_id: UUID(),
        member_id: memberId,
        book_id: bookId,
        borrow_date: new Date(),
        due_date: new Date(Date.now() + 14 * 24 * 3600 * 1000),
        status: "ACTIVE",
    });

    session.commitTransaction();
    print("Giao dịch thành công: Đã mượn sách");
} catch (e) {
    print("Giao dịch bị hủy:", e.message);
    session.abortTransaction();
} finally {
    session.endSession();
}

// 2: Transaction cập nhật email thành viên và thêm loan
const session = db.getMongo().startSession();

try {
    session.startTransaction({
        readConcern: { level: "majority" },
        writeConcern: { w: "majority", wtimeout: 5000 },
    });

    const db06 = session.getDatabase("libraryDB_06");
    const membersColl = db06.members;
    const loansColl = db06.loans;

    const memberId = UUID("550e8400-e29b-41d4-a716-446655440000");
    const newEmail = "updatedemail@gmail.com";

    const updateResult = membersColl.updateOne(
        { member_id: memberId },
        { $set: { email: newEmail } }
    );

    if (updateResult.matchedCount === 0) {
        throw new Error("Không tìm thấy thành viên cần cập nhật");
    }

    const bookId = UUID("7ca7b810-9dad-11d1-80b4-00c04fd430c8");

    loansColl.insertOne({
        loan_id: UUID(),
        member_id: memberId,
        book_id: bookId,
        borrow_date: new Date(),
        due_date: new Date(Date.now() + 14 * 24 * 3600 * 1000),
        status: "ACTIVE",
    });

    session.commitTransaction();
    print("Thành công: Cập nhật email và thêm loan");
} catch (e) {
    print("Giao dịch bị hủy:", e.message);
    session.abortTransaction();
} finally {
    session.endSession();
}


// 4. Thiết kế logic để thực hiện retryable write cho thao tác cập nhật stock trong books:
function updateStockWithRetry(bookId, maxRetries = 3) {
    const session = db.getMongo().startSession();
    const booksColl = session.getDatabase("libraryDB_06").books;
    let attempt = 0;
    let success = false;

    while (attempt < maxRetries && !success) {
        attempt++;
        try {
            session.startTransaction({
                readConcern: { level: "majority" },
                writeConcern: { w: "majority", wtimeout: 5000 },
            });

            const book = booksColl.findOne({ book_id: bookId });
            if (!book || book.stock <= 0) {
                throw new Error("Sách không còn trong kho");
            }

            const result = booksColl.updateOne(
                { book_id: bookId, stock: { $gt: 0 } },
                { $inc: { stock: -1 } }
            );

            if (result.matchedCount === 0) {
                throw new Error("Không thể cập nhật stock");
            }

            session.commitTransaction();
            success = true;
            print(`Update stock thành công ở lần thử thứ ${attempt}`);
        } catch (e) {
            print(`Lỗi khi cập nhật stock (lần ${attempt}):`, e.message);
            session.abortTransaction();

            if (attempt === maxRetries) {
                print(" Đã thử quá 3 lần, thất bại hoàn toàn.");
            } else {
                print(" Đang thử lại...");
            }
        }
    }

    session.endSession();
}

// gọi hàm test
updateStockWithRetry(UUID("7ca7b810-9dad-11d1-80b4-00c04fd430c8"));

// 5 Error Handling (Write Errors, Network Errors):
// Xử lý Write Errors (ví dụ: vi phạm unique index khi thêm email trùng lặp).
const session = db.getMongo().startSession();

try {
    session.startTransaction({
        readConcern: { level: "majority" },
        writeConcern: { w: "majority", wtimeout: 5000 }
    });

    const dbWithSession = session.getDatabase("libraryDB_06");
    const membersColl = dbWithSession.members;

    membersColl.updateOne(
        { member_id: UUID("550e8400-e29b-41d4-a716-446655440000") },
        { $set: { email: "levanc@example.com" } }
    );

    session.commitTransaction();
    print("Giao dịch thành công");
} catch (e) {
    if (e.code === 11000) {
        print("DuplicateKeyError: Email đã tồn tại");
    } else if (e.errorLabels && e.errorLabels.includes("TransientTransactionError")) {
        print("Lỗi mạng tạm thời, có thể thử lại.");
    } else {
        print("Lỗi khác:", e.message);
    }

    session.abortTransaction();
} finally {
    session.endSession();
}
// Xử lý Network Errors (ví dụ: mất kết nối với server) bằng cách retry transaction.
const session = db.getMongo().startSession();
while (true) {
    try {
        session.startTransaction();

        const members = session.getDatabase("libraryDB_06").members;

        members.insertOne({
            member_id: UUID(),
            full_name: "Nguyen Van A",
            email: "nguyenvana@example.com",
            joined_at: new Date()
        });

        session.commitTransaction();
        print("Thêm thành công");
        break;
    } catch (e) {
        if (!(e.errorLabels || []).includes("TransientTransactionError")) {
            session.abortTransaction();
            print("Giao dịch thất bại:", e.message);
            break;
        }
        print("Lỗi mạng tạm thời – thử lại...");
    } finally {
        session.endSession();
    }
}

// 6 Sử dụng Change Streams:
// Theo dõi mượn sách mới trong loans
const changeStream = db.getSiblingDB("libraryDB_06").loans.watch([
  { $match: { operationType: "insert" } }
]);

print("Đang theo dõi các lượt mượn sách mới...");

while (true) {
  const change = changeStream.tryNext();
  if (change) {
    const memberId = change.fullDocument.member_id;
    print(` Loans mới đã được tạo: ${memberId}`);
  }

  sleep(1000);
}
//  Theo dõi cập nhật stock trong books
const changeStream = db.getSiblingDB("libraryDB_06").books.watch([
  {
    $match: {
      operationType: "update",
      "updateDescription.updatedFields.stock": { $exists: true }
    }
  }
]);

print("📘 Đang theo dõi thay đổi stock trong books...");

while (changeStream.hasNext()) {
  const change = changeStream.next();
  const bookId = change.documentKey.book_id;
  const newStock = change.updateDescription.updatedFields.stock;

  if (newStock < 2) {
    print(` Cảnh báo: Sách ${bookId} còn lại ${newStock} cuốn trong kho!`);
  } else {
    print(` Stock sách ${bookId} vừa cập nhật: ${newStock}`);
  }
}

// 7 Write Concern (majority, wtimeout):
const session = db.getMongo().startSession();

try {
  session.startTransaction({
    writeConcern: { w: "majority", wtimeout: 3000 },
  });

  const dbSession = session.getDatabase("libraryDB_06");
  const loansColl = dbSession.loans;
  const bookId = UUID("7ca7b810-9dad-11d1-80b4-00c04fd430c8");
  const memberId = UUID("550e8400-e29b-41d4-a716-446655440000");

  loansColl.insertOne({
    loan_id: UUID(),
    member_id: memberId,
    book_id: bookId,
    borrow_date: new Date(),
    due_date: new Date(Date.now() + 14 * 24 * 3600 * 1000),
    status: "ACTIVE",
  });

  session.commitTransaction();
  print("Giao dịch thêm loan thành công.");
} catch (e) {
  print("Lỗi khi ghi dữ liệu:", e.message);
  session.abortTransaction();
} finally {
  session.endSession();
}
