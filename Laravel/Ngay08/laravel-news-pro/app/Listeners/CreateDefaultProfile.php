<?php

namespace App\Listeners;

use App\Events\UserRegistered;
use App\Models\Profile;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Notifications\Notification;
use Illuminate\Queue\InteractsWithQueue;
use Illuminate\Support\Facades\Log;

class CreateDefaultProfile 
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
            
            Log::info("Chuẩn bị tạo profile cho user ID = {$event->user->id}");
            
            // Kiểm tra xem user đã có profile chưa
            if (!$event->user->profile) {
                // Tạo profile mới
                $profile = new Profile([
                    'user_id' => $event->user->id,
                    'bio' => 'Chào mừng đến với Laravel News Pro!',
                    'avatar' => 'default-avatar.png',
                    'created_at' => now(),
                    'updated_at' => now(),
                ]);
                
                // Lưu profile
                $profile->save();
                
                Log::info("Đã tạo hồ sơ mặc định cho user {$event->user->id}");
            } else {
                Log::info("User {$event->user->id} đã có hồ sơ");
            }
        } catch (\Exception $e) {
            Log::error("Lỗi khi tạo hồ sơ mặc định: " . $e->getMessage());
            Log::error("Stack trace: " . $e->getTraceAsString());
        }
    }
}


