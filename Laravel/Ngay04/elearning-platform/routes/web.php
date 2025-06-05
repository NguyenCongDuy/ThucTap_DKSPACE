<?php

use App\Http\Controllers\CourseController;
use App\Http\Controllers\LessonController;
use App\Http\Controllers\TestQueryController;
use Illuminate\Support\Facades\Route;

Route::get('/', function () {
    return view('welcome');
});

Route::prefix('test')->group(function () {
    Route::get('/courses-5-lessons', [TestQueryController::class, 'coursesWithFiveLessons']);
    Route::get('/lessons-tag-laravel', [TestQueryController::class, 'lessonsWithTagLaravel']);
    Route::get('/top-instructors', [TestQueryController::class, 'top3Instructors']);
    Route::get('/lesson-comment-count', [TestQueryController::class, 'commentCountPerLesson']);
    Route::get('/courses-with-count', [TestQueryController::class, 'courseWithLessonCount']);
    //
    Route::get('create-course-with-lessons', [TestQueryController::class, 'createCourseWithLessons']);
    Route::get('attach-tags-to-lesson', [TestQueryController::class, 'attachTagsToLesson']);
    Route::get('comments-of-course', [TestQueryController::class, 'getCommentsOfCourse']);
    Route::get('course-with-counts', [TestQueryController::class, 'courseWithCounts']);
    Route::get('lesson-with-tag-and-comments', [TestQueryController::class, 'lessonWithTagAndComments']);
});

Route::get('/courses/eager', [CourseController::class, 'eagerLoad']);
Route::get('/lessons/{id}/eager', [LessonController::class, 'eagerLoad']);
Route::get('/courses', [CourseController::class, 'index']);

