<?php

namespace App\Console\Commands;

use Illuminate\Console\Command;
use Illuminate\Support\Facades\Log;

class BackupDatabaseCommand extends Command
{
    /**
     * The name and signature of the console command.
     *
     * @var string
     */
    protected $signature = 'backup:database';

    /**
     * The console command description.
     *
     * @var string
     */
    protected $description = 'Tự động backup cơ sở dữ liệu và lưu vào /storage/backups/';

    /**
     * Execute the console command.
     */
    public function handle()
    {
       $filename = 'backup_' . now()->format('Ymd_His') . '.sql';
        $path = storage_path("backups/{$filename}");

        // Cấu hình DB cho lệnh mysqldump (tùy hệ thống)
        $db = config('database.connections.mysql');
        $command = "mysqldump -u {$db['username']} -p\"{$db['password']}\" {$db['database']} > {$path}";

        exec($command, $output, $return);

        if ($return === 0) {
            Log::info(" Backup thành công: {$path}");
            $this->info("Đã backup thành công vào: {$path}");
        } else {
            Log::error(" Backup thất bại", $output);
            $this->error("Lỗi backup!");
        }
    }
}
