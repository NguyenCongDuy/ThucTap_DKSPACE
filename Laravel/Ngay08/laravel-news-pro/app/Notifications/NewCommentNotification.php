<?php

namespace App\Notifications;

use App\Models\Comment;
use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Notifications\Messages\MailMessage;
use Illuminate\Notifications\Notification;
use Illuminate\Support\Facades\Log;

class NewCommentNotification extends Notification
{
    use Queueable;
    public $comment;

    /**
     * Create a new notification instance.
     */
    public function __construct(Comment $comment)
    {
         $this->comment = $comment;
    }

    /**
     * Get the notification's delivery channels.
     *
     * @return array<int, string>
     */
    public function via(object $notifiable): array
    {
        return ['mail', 'database'];
    }

    /**
     * Get the mail representation of the notification.
     */
    public function toMail(object $notifiable): MailMessage
    {
        try {
            return (new MailMessage)
                ->subject('Bài viết của bạn có bình luận mới')
                ->greeting('Xin chào ' . $notifiable->name)
                ->line('Bình luận: ' . $this->comment->content)
                ->action('Xem chi tiết', url('/posts/' . $this->comment->post_id))
                ->line('Cảm ơn bạn đã sử dụng Laravel News Pro!');
        } catch (\Exception $e) {
            Log::error('Lỗi khi tạo email thông báo bình luận: ' . $e->getMessage());
            return (new MailMessage)
                ->subject('Bài viết của bạn có bình luận mới')
                ->line('Có bình luận mới trên bài viết của bạn.');
        }
    }

    /**
     * Get the array representation of the notification.
     *
     * @return array<string, mixed>
     */
    public function toArray(object $notifiable): array
    {
       return [
            'post_id' => $this->comment->post_id,
            'comment_id' => $this->comment->id,
            'comment_content' => $this->comment->content,
            'commenter' => $this->comment->user->name,
        ];
    }
}



