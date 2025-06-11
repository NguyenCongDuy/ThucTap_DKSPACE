<?php

namespace App\Console\Commands;

use App\Models\Comment;
use App\Models\Post;
use App\Models\User;
use Illuminate\Console\Command;
use Illuminate\Support\Facades\Mail;

class ReportSummaryCommand extends Command
{
    /**
     * The name and signature of the console command.
     *
     * @var string
     */
    protected $signature = 'report:summary';

    /**
     * The console command description.
     *
     * @var string
     */
    protected $description = 'Gửi email thống kê bài viết, bình luận và user mới mỗi ngày';

    /**
     * Execute the console command.
     */
    public function handle()
    {
        $totalPosts = Post::whereDate('created_at', today())->count();
        $totalComments = Comment::whereDate('created_at', today())->count();
        $totalUsers = User::whereDate('created_at', today())->count();

        $content = "📰 Thống kê hôm nay:\n- Bài viết: $totalPosts\n- Bình luận: $totalComments\n- Người dùng mới: $totalUsers";

        // Tùy ý gửi tới admin
        Mail::raw($content, function ($message) {
            $message->to('admin@example.com')->subject('Báo cáo thống kê hằng ngày');
        });

        $this->info('Đã gửi thống kê email thành công!');
    }
}
