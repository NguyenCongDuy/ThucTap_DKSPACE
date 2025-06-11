<?php

namespace App\Http\Controllers;

use App\Jobs\NotifyAuthorOfComment;
use App\Models\Comment;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class CommentController extends Controller
{
    public function store(Request $request, $postId)
{
    $request->validate([
        'content' => 'required|string|max:1000',
    ]);

    $comment = Comment::create([
        'post_id' => $postId,
        'user_id' => Auth::id(),
        'content' => $request->content,
    ]);
    
    NotifyAuthorOfComment::dispatch($comment);

    return redirect()->back()->with('success', 'Bình luận đã được gửi!');
}
}

