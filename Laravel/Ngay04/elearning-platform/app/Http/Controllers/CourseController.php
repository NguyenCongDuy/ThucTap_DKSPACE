<?php

namespace App\Http\Controllers;

use App\Models\Course;
use Illuminate\Http\Request;

class CourseController extends Controller
{
    public function eagerLoad()
    {
        $courses = Course::with([
            'user',
            'lessons.tags'
        ])
            ->withCount('lessons')
            ->get();

        return response()->json($courses, 200, [], JSON_PRETTY_PRINT);
    }

    public function index(Request $request)
    {
        $query = Course::with(['user', 'lessons.tags'])
            ->withCount('lessons');

        //  filter theo tag từ lessons
        if ($request->filled('tag')) {
            $query->whereHas('lessons.tags', function ($q) use ($request) {
                $q->where('name', $request->tag);
            });
        }

        //  filter theo instructor name (User)
        if ($request->filled('instructor')) {
            $query->whereHas('user', function ($q) use ($request) {
                $q->where('name', 'like', '%' . $request->instructor . '%');
            });
        }

        //  filter theo số lượng bài học (ví dụ >= 5)
        if ($request->filled('min_lessons')) {
            $query->having('lessons_count', '>=', (int)$request->min_lessons);
        }

        //  paginate 
        $courses = $query->paginate(10);

        return response()->json($courses, 200, [], JSON_PRETTY_PRINT);
    }
}
