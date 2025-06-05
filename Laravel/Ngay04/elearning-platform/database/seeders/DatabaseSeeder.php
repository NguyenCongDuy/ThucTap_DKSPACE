<?php

namespace Database\Seeders;

use App\Models\Comment;
use App\Models\Course;
use App\Models\Lesson;
use App\Models\Profile;
use App\Models\Tag;
use App\Models\User;
// use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class DatabaseSeeder extends Seeder
{
    /**
     * Seed the application's database.
     */
    public function run(): void
    {
        // Tạo 10 users kèm profile
        User::factory(10)->create()->each(function ($user) {
            $user->profile()->create(Profile::factory()->make()->toArray());

            // Mỗi user là giảng viên có 1-3 khóa học
            $courses = Course::factory(rand(1, 3))->create([
                'user_id' => $user->id,
            ]);

            $courses->each(function ($course) use ($user) {
                // Mỗi course có 3-7 bài học
                $lessons = Lesson::factory(rand(3, 7))->create([
                    'course_id' => $course->id,
                ]);

                // Comment cho course
                Comment::factory(rand(1, 5))->create([
                    'user_id' => $user->id,
                    'commentable_id' => $course->id,
                    'commentable_type' => Course::class,
                ]);

                $lessons->each(function ($lesson) use ($user) {
                    // Gắn comment cho lesson
                    Comment::factory(rand(1, 4))->create([
                        'user_id' => $user->id,
                        'commentable_id' => $lesson->id,
                        'commentable_type' => Lesson::class,
                    ]);
                });
            });
        });

        // Tạo sẵn 5 tag cố định
        $tags = collect(['Laravel', 'Eloquent', 'PHP', 'Performance', 'Database'])->map(function ($name) {
            return Tag::create(['name' => $name]);
        });

        // Gắn tags ngẫu nhiên cho mỗi lesson
        Lesson::all()->each(function ($lesson) use ($tags) {
            $lesson->tags()->attach(
                $tags->random(rand(1, 3))->pluck('id')->toArray()
            );
        });
    }
}
