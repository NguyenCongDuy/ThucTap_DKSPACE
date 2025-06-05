<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Comment extends Model
{
    use HasFactory;
    protected $fillable = ['user_id', 'content', 'commentable_id', 'commentable_type'];

    // comment thuộc về người viết (user)
    public function user()
    {
        return $this->belongsTo(User::class);
    }

    // comment có thể thuộc về Course hoặc Lesson
    public function commentable()
    {
        return $this->morphTo();
    }
}
