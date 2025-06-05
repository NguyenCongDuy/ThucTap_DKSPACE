<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Lesson extends Model
{
    use HasFactory;
    protected $fillable = ['course_id', 'title', 'content'];
    // bài học thuộc 1 khóa học 
    public function course(){
        return $this->belongsTo(Course::class);
    }

    // bài học có nhiều tag
    public function tags(){
        return $this->belongsToMany(Tag::class)->withTimestamps();
    }

    // 1 bài học có nhiều comment
    public function comments(){
        return $this->morphMany(Comment::class, 'commentable');
    }

    public function likes()
    {
        return $this->morphMany(Likes::class, 'likeable');
    }
}
