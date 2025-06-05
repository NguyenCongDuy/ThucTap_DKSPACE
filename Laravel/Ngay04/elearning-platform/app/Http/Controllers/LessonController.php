<?php

namespace App\Http\Controllers;

use App\Models\Lesson;
use Illuminate\Http\Request;

class LessonController extends Controller
{
    public function eagerLoad($id)
    {
        $lesson = Lesson::with([
            'comments.user'
        ])
            ->withCount('comments')
            ->findOrFail($id);

        return response()->json($lesson, 200, [], JSON_PRETTY_PRINT);
    }
}
