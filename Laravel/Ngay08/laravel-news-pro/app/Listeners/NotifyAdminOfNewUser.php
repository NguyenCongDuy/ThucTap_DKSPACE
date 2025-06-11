<?php

namespace App\Listeners;

use App\Events\UserRegistered;
use App\Models\User;
use App\Notifications\NewUserRegistered;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Queue\InteractsWithQueue;
use Illuminate\Support\Facades\Log;

class NotifyAdminOfNewUser 
{   

    public $tries = 3;

    public function __construct()
    {
        //
    }

    public function handle(UserRegistered $event): void
    {
        try {
            // Kiểm tra user có tồn tại không
            if (!$event->user) {
                Log::error("User không tồn tại trong event");
                return;
            }
            
            Log::info("Chuẩn bị tìm admin để gửi thông báo");
            
            $admin = User::find(36);
            if ($admin) {
                Log::info("Đã tìm thấy admin ID = 36: {$admin->email}");
                
                $admin->notify(new NewUserRegistered($event->user));
                
                Log::info("Đã gửi thông báo về người dùng mới đến admin {$admin->email}");
            } else {
                Log::warning("Không tìm thấy admin với ID = 36");
                
                // Fallback: tìm admin đầu tiên trong hệ thống
                $firstAdmin = User::first();
                
                if ($firstAdmin) {
                    Log::info("Fallback: Sử dụng user đầu tiên làm admin: {$firstAdmin->email}");
                    $firstAdmin->notify(new NewUserRegistered($event->user));
                    Log::info("Đã gửi thông báo về người dùng mới đến admin {$firstAdmin->email}");
                } else {
                    Log::warning("Không tìm thấy user nào trong hệ thống");
                }
            }
        } catch (\Exception $e) {
            Log::error("Lỗi khi gửi thông báo cho admin: " . $e->getMessage());
            Log::error("Stack trace: " . $e->getTraceAsString());
        }
    }
}




