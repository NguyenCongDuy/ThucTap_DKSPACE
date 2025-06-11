<?php

namespace App\Listeners;

use App\Events\UserRegistered;
use App\Mail\WelcomeEmail;
use Illuminate\Contracts\Queue\ShouldQueue;

use Illuminate\Queue\InteractsWithQueue;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\Mail;

class SendWelcomeEmail
{
    public $tries = 3;

    public function __construct()
    {
        //
    }

    public function handle(UserRegistered $event): void
    {
        try {
            if (!$event->user) {
                Log::error("User không tồn tại trong event");
                return;
            }
            
            // Ghi log trước khi gửi email
            Log::info("Chuẩn bị gửi email chào mừng đến {$event->user->email}");
            
            // Gửi email chào mừng
            Mail::to($event->user->email)->send(new WelcomeEmail($event->user));
            
            Log::info("Đã gửi email chào mừng đến {$event->user->email}");
        } catch (\Exception $e) {
            Log::error("Lỗi khi gửi email chào mừng: " . $e->getMessage());
            Log::error("Stack trace: " . $e->getTraceAsString());
        }
    }
}




