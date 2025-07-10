// 1 Index Maintenance (Rebuilding, Compaction)
// reIndex() trên appointments
db.appointments.reIndex();
// compact trên medical_records
db.runCommand({ compact: "medical_records" })
// Giám sát kích thước index với collStats
db.appointments.stats().indexSizes

// 2 Storage Optimization với WiredTiger Engine
// Giám sát hiệu suất lưu trữ bằng serverStatus (cache hit ratio)
db.serverStatus().wiredTiger.cache

// 3 Compression (zlib, snappy):
// Dùng zlib cho collection medical_records (ưu tiên nén mạnh)
// Khi tạo collection medical_records với nén zlib
db.createCollection("medical_records", {
  storageEngine: {
    wiredTiger: {
      configString: "block_compressor=zlib"
    }
  }
})
// Dùng snappy cho appointments (ưu tiên tốc độ truy cập)
db.createCollection("appointments", {
  storageEngine: {
    wiredTiger: {
      configString: "block_compressor=snappy"
    }
  }
})

// 4. Profiling (Database Profiler, Slow Queries)
// Kích hoạt Database Profiler trên appointments
// bật profiler ở mức truy vấn > 100ms:
db.setProfilingLevel(1, { slowms: 100 })  // Mức 1: log các truy vấn chậm >100ms
// Truy vấn system.profile để xem các truy vấn chậm
db.system.profile.find({
  ns: "clinicDB.appointments",
  millis: { $gt: 100 }
}).sort({ millis: -1 }).limit(5)

// 5 Caching – Tối ưu hiệu suất đọc bằng In-memory Cache (WiredTiger)
// Caching – Tối ưu hiệu suất đọc bằng In-memory Cache (WiredTiger)
db.appointments.find({
  appointment_date: {
    $gte: ISODate("2025-07-09T00:00:00Z"),  
    $lt: ISODate("2025-07-10T00:00:00Z")  
  }
}).pretty()

// 6 Bulk Operations for Performance
// Thêm 100 bệnh nhân mới
const bulkPatients = [];
for (let i = 1; i <= 100; i++) {
  bulkPatients.push({
    insertOne: {
      document: {
        patient_id: UUID(),
        full_name: `Patient ${i}`,
        email: `patient${i}@clinic.com`,
        phone: `09${10000000 + i}`,
        registered_at: new Date()
      }
    }
  });
}

db.patients.bulkWrite(bulkPatients, { ordered: false });
// Cập nhật 50 lịch hẹn từ "SCHEDULED" → "COMPLETED"
const appointmentsToUpdate = db.appointments.find({ status: "SCHEDULED" }).limit(50).toArray();

const bulkUpdates = appointmentsToUpdate.map(doc => ({
  updateOne: {
    filter: { appointment_id: doc.appointment_id },
    update: { $set: { status: "COMPLETED" } }
  }
}));

db.appointments.bulkWrite(bulkUpdates, { ordered: false });
// Thêm 200 bản ghi medical_records mới
const bulkRecords = [];
const sampleSymptoms = [["fever"], ["cough"], ["headache"], ["fatigue"], ["dizziness"]];

for (let i = 1; i <= 200; i++) {
  bulkRecords.push({
    insertOne: {
      document: {
        record_id: UUID(),
        patient_id: UUID(), 
        visit_date: new Date(),
        symptoms: sampleSymptoms[i % 5],
        prescription: `Prescription ${i}`,
        notes: `Record note ${i}`
      }
    }
  });
}

db.medical_records.bulkWrite(bulkRecords, { ordered: false });

// Schema Optimization với Denormalization
// Tạo một bản ghi appointments kiểu denormalized
const patient = db.patients.findOne();

const denormalizedAppointment = {
  appointment_id: UUID(),
  patient: {
    patient_id: patient.patient_id,
    full_name: patient.full_name,
    email: patient.email
  },
  doctor_id: UUID(),
  appointment_date: ISODate("2025-07-10T10:30:00Z"),
  status: "SCHEDULED"
};

db.appointments.insertOne(denormalizedAppointment);
// Truy vấn lịch hẹn trong ngày với dữ liệu nhúng:
db.appointments.find({
  appointment_date: {
    $gte: ISODate("2025-07-09T00:00:00Z"),
    $lt: ISODate("2025-07-10T00:00:00Z")
  }
}, {
  "patient.full_name": 1,
  "patient.email": 1,
  doctor_id: 1,
  appointment_date: 1,
  status: 1
});
