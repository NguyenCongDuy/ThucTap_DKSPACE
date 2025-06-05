<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Course extends Model
{
    use HasFactory;
    protected $fillable = ['user_id', 'title', 'description'];

    // khóa học thuộc nhiều user(giảng viên)
    public function user()
    {
        return $this->belongsTo(User::class);
    }

    // khóa học thuộc nhiều bài học 
    public function lessons()
    {
        return $this->hasMany(Lesson::class);
    }

    // 1 khóa học có nhiều comment
    public function comments()
    {
        return $this->morphMany(Comment::class, 'commentable');
    }


    public function likes()
    {
        return $this->morphMany(Likes::class, 'likeable');
    }

    public function scopePopular($query)
    {
        return $query->withCount('lessons')
            ->orderByDesc('lessons_count');
    }
}
