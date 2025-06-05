<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Tag extends Model
{
    use HasFactory;
    protected $fillable = ['name'];
    
    // tag gắn được với nhiều bài học
    public function lessons()
    {
        return $this->belongsToMany(Lesson::class)->withTimestamps();
    }
}
