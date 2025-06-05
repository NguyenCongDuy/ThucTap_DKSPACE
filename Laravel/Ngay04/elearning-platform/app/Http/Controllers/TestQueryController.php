<?php

namespace App\Http\Controllers;

use App\Models\Course;
use App\Models\Lesson;
use App\Models\Tag;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class TestQueryController extends Controller
{
    // Lấy khóa học có >= 5 bài học
    public function coursesWithFiveLessons()
    {
        $courses = DB::table('courses')
            ->join('lessons', 'courses.id', '=', 'lessons.course_id')
            ->select('courses.id', 'courses.title', DB::raw('COUNT(lessons.id) as lesson_count'))
            ->groupBy('courses.id', 'courses.title')
            ->havingRaw('COUNT(lessons.id) >= 5')
            ->get();

        return response()->json($courses, 200, [], JSON_PRETTY_PRINT);
    }

    // Lấy các bài học có tag 'Laravel'
    public function lessonsWithTagLaravel()
    {
        $lessons = DB::table('lessons')
            ->join('lesson_tag', 'lessons.id', '=', 'lesson_tag.lesson_id')
            ->join('tags', 'tags.id', '=', 'lesson_tag.tag_id')
            ->where('tags.name', 'Laravel')
            ->select('lessons.id', 'lessons.title')
            ->distinct()
            ->get();

        return response()->json($lessons, 200, [], JSON_PRETTY_PRINT);
    }
    // Top 3 giảng viên nhiều khóa học nhất
    public function top3Instructors()
    {
        $topUsers = DB::table('users')
            ->leftJoin('courses', 'users.id', '=', 'courses.user_id')
            ->select('users.id', 'users.name', DB::raw('COUNT(courses.id) as courses_count'))
            ->groupBy('users.id', 'users.name')
            ->orderByDesc('courses_count')
            ->limit(3)
            ->get();

        return response()->json($topUsers, 200, [], JSON_PRETTY_PRINT);
    }


    // Tổng số comment mỗi bài học
    public function commentCountPerLesson()
    {
        $lessons = DB::table('lessons')
            ->select('lessons.id', 'lessons.title')
            ->selectSub(function ($query) {
                $query->from('comments')
                    ->whereColumn('comments.commentable_id', 'lessons.id')
                    ->where('comments.commentable_type', 'App\\Models\\Lesson')
                    ->selectRaw('COUNT(*)');
            }, 'comments_count')
            ->get();
        return response()->json($lessons, 200, [], JSON_PRETTY_PRINT);
    }

    // Lấy khóa học + số lượng bài học
    public function courseWithLessonCount()
    {
        $courses = DB::table('courses')
            ->select('courses.id', 'courses.title')
            ->selectSub(function ($query) {
                $query->from('lessons')
                    ->whereColumn('lessons.course_id', 'courses.id')
                    ->selectRaw('COUNT(*)');
            }, 'lessons_count')
            ->get();

        return response()->json($courses, 200, [], JSON_PRETTY_PRINT);
    }


    // tạo khóa học và 3 bài học
    public function createCourseWithLessons()
    {
        $author = User::first();

        $course = Course::create([
            'title' => 'Khóa học Laravel mới',
            'description' => 'Nội dung khóa học Laravel nâng cao',
            'user_id' => $author->id,
        ]);

        $course->lessons()->createMany([
            ['title' => 'Giới thiệu'],
            ['title' => 'Routing nâng cao'],
            ['title' => 'Middleware và Auth'],
        ]);

        return 'Tạo khóa học và bài học thành công!';
    }

    // gắn tag cho bài học
    public function attachTagsToLesson()
    {
        $lesson = Lesson::first();

        $tagLaravel = Tag::firstOrCreate(['name' => 'Laravel']);
        $tagEloquent = Tag::firstOrCreate(['name' => 'Eloquent']);

        $lesson->tags()->syncWithoutDetaching([$tagLaravel->id, $tagEloquent->id]);

        return 'Gắn tag thành công!';
    }

    // lấy comment của course
    public function getCommentsOfCourse()
    {
        $course = Course::with('comments.user')->first();

        $data = $course->comments->map(function ($c) {
            return [
                'nội dung' => $c->content,
                'người viết' => $c->user->name ?? 'Ẩn danh'
            ];
        });

        return response()->json($data, 200, [], JSON_UNESCAPED_UNICODE | JSON_PRETTY_PRINT);
    }

    // khóa học + số lượng bài học & comment
    public function courseWithCounts()
    {
        $courses = Course::withCount('lessons')
            ->withCount(['comments as total_comments'])
            ->get();

        $data = $courses->map(function ($c) {
            return [
                'title' => $c->title,
                'số bài học' => $c->lessons_count,
                'số comment' => $c->total_comments
            ];
        });
        return response()->json($data, 200, [], JSON_UNESCAPED_UNICODE | JSON_PRETTY_PRINT);
    }

    // bài học có tag 'Performance' & >3 comment
    public function lessonWithTagAndComments()
    {
        $lessons = Lesson::with('tags')
            ->withCount('comments')
            ->whereHas('tags', fn($q) => $q->where('name', 'Performance'))
            ->having('comments_count', '>', 3)
            ->get();

        $data = $lessons->map(function ($l) {
            return [
                'bài học' => $l->title,
                'số comment' => $l->comments_count,
                'tags' => $l->tags->pluck('name')
            ];
        });
        return response()->json($data, 200, [], JSON_UNESCAPED_UNICODE | JSON_PRETTY_PRINT);
    }
}
