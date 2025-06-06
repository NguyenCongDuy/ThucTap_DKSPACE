<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Candidate extends Model
{
    protected $fillable = [
        'name',
        'email',
        'birthday',
        'avatar_path',
        'cv_path',
        'bio',
    ];
}
