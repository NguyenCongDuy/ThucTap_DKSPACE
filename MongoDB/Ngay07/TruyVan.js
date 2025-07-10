// 1 Query Optimization với explain()
// truy vấn để lấy danh sách đặt giá (bids) cho một phiên đấu giá cụ thể (auction_id)
//  trong khoảng thời gian từ 10:00 đến 12:00 ngày 1/6/2025.
db.bids.find({
    auction_id: UUID("550e8400-e29b-41d4-a716-446655440000"),
    bid_time: {
        $gte: ISODate("2025-06-01T10:00:00Z"),
        $lte: ISODate("2025-06-01T12:00:00Z")
    }
})
// Sử dụng explain("executionStats") để phân tích kế hoạch truy vấn
db.bids.find({
    auction_id: UUID("550e8400-e29b-41d4-a716-446655440000"),
    bid_time: {
        $gte: ISODate("2025-06-01T10:00:00Z"),
        $lte: ISODate("2025-06-01T12:00:00Z")
    }
}).explain("executionStats")

// 2.Index Optimization với Covered Queries:
//  Tạo compound index:
db.bids.createIndex({ auction_id: 1, bid_time: 1, status: 1 })
// Viết truy vấn dạng covered query
db.bids.find(
    {
        auction_id: UUID("550e8400-e29b-41d4-a716-446655440000"),
        status: "ACCEPTED"
    },
    {
        auction_id: 1,
        bid_time: 1,
        status: 1,
        _id: 0
    }
)

// 4 Sharding: Shard Key và Shard Distribution:
// Chọn Shard Key cho bids
// Shard theo auction_id:
sh.shardCollection("auctionDB.bids", { auction_id: "hashed" });
// Kích hoạt Sharding cho bids:
use auctionDB
sh.enableSharding("auctionDB")
sh.shardCollection("auctionDB.bids", { auction_id: "hashed" })

// 5 Replication: Replica Sets và Primary-Secondary:
// Khởi tạo 3 node
mongod --port 27017 --dbpath "C:\mongodb\data\db" --replSet rs0 --bind_ip localhost
mongod --port 27018 --dbpath "C:\data\db1" --replSet rs0
mongod --port 27019 --dbpath "C:\data\db2" --replSet rs0
// Kết nối đến Primary node
mongosh "mongodb://127.0.0.1:27017/?replicaSet=rs0"
rs.initiate()
// thêm các node 
rs.add("127.0.0.1:27018")
rs.add("127.0.0.1:27019")
// Thiết kế truy vấn đọc từ Secondary – dùng Read Preference
db.bids.find(
  { auction_id: UUID("550e8400-e29b-41d4-a716-446655440000") }
).readPref("secondary")

// 6 Read Preference (nearest, primaryPreferred):
// Sử dụng readPreference: "nearest"
db.auctions.find({ category: "Automobile" }).readPref("nearest")
// Sử dụng readPreference: "primaryPreferred"
db.bids.find(
  { auction_id: UUID("550e8400-e29b-41d4-a716-446655440000") }
).readPref("primaryPreferred")


// 7 Aggregation Optimization với Early Filtering
db.bids.aggregate([
  {
    $match: {
      status: "ACCEPTED",
      bid_time: {
        $gte: ISODate("2025-06-01T00:00:00Z"),
        $lt: ISODate("2025-06-02T00:00:00Z")
      }
    }
  },
  {
    $group: {
      _id: "$auction_id",
      total_bid: { $sum: "$bid_amount" }
    }
  },
  {
    $sort: { total_bid: -1 }
  }
])
// Kiểm tra với explain()
// thêm inde để tối ưu hóa truy vấn

// 8. Kiểm tra và giám sát:
// Thống kê collection bids
db.bids.stats()

// Xem các thao tác đang diễn ra
db.currentOp()

// Bật chế độ theo dõi truy vấn:
db.setProfilingLevel(1, { slowms: 50 })
// Xem truy vấn chậm đã ghi:
db.system.profile.find().sort({ ts: -1 }).limit(5)


// rs.status()