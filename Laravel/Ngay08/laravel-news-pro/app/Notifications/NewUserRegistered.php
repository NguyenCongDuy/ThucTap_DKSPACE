<?php

namespace App\Notifications;

use App\Models\User;
use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Notifications\Messages\MailMessage;
use Illuminate\Notifications\Notification;

class NewUserRegistered extends Notification implements ShouldQueue
{
    use Queueable;

    protected $newUser;

    public function __construct(User $user)
    {
        $this->newUser = $user;
    }

    public function via(object $notifiable): array
    {
        return ['mail', 'database'];
    }

    public function toMail(object $notifiable): MailMessage
    {
        return (new MailMessage)
            ->subject('Người dùng mới đã đăng ký')
            ->greeting('Xin chào ' . $notifiable->name . '!')
            ->line('Người dùng mới đã đăng ký vào hệ thống.')
            ->line('Tên: ' . $this->newUser->name)
            ->line('Email: ' . $this->newUser->email)
            ->line('Thời gian đăng ký: ' . $this->newUser->created_at->format('d/m/Y H:i:s'))
            ->action('Xem chi tiết', url('/admin/users/' . $this->newUser->id))
            ->line('Cảm ơn bạn đã sử dụng ứng dụng của chúng tôi!');
    }

    public function toArray(object $notifiable): array
    {
        return [
            'name' => $this->newUser->name,
            'email' => $this->newUser->email,
            'registered_at' => $this->newUser->created_at,
            'user_id' => $this->newUser->id
        ];
    }
}

