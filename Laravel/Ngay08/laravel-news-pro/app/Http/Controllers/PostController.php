<?php

namespace App\Http\Controllers;

use App\Models\Post;
use Illuminate\Http\Request;
use Illuminate\Support\Carbon;
use Illuminate\Support\Facades\Cache;

class PostController extends Controller
{
    public function index()
    {

        $posts = Cache::remember('top_viewed_today', now()->addMinutes(30), function () {
            return Post::whereDate('created_at', Carbon::today())
                ->orderByDesc('views')
                ->take(5)
                ->get(); 
        });
        return view('posts.index', compact('posts'));
    }

    public function show($id)
    {
        $post = Post::with(['author', 'comments.user'])->findOrFail($id);
        return view('posts.show', compact('post'));
    }
}
