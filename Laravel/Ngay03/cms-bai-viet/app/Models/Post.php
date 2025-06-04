<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Builder;
use Illuminate\Support\Carbon;
use Illuminate\Support\Str;

class Post extends Model
{
    use HasFactory;

    protected $fillable = ['author_id', 'title', 'slug', 'content', 'status', 'published_at'];
    
    public function author()
    {
        return $this->belongsTo(Author::class);
    }

    public function scopePublished(Builder $query): Builder
    {
        return $query->where('status', 'published');
    }

    public function scopeRecent(Builder $query): Builder
    {
        return $query->where('created_at', '>=', Carbon::now()->subDays(30));
    }

    public function setTitleAttribute($value)
    {
        $this->attributes['title'] = ucwords($value); // viết hoa chữ cái đầu
        $this->attributes['slug'] = Str::slug($value); // tạo slug
    }

    public function getPublishedAtAttribute($value)
    {
        if (!$value) return null;
        return \Carbon\Carbon::parse($value)->format('d/m/Y H:i');
    }

}
