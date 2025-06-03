<?php

use App\Http\Controllers\Admin\DashboardController;
use App\Http\Controllers\Admin\PostController;
use App\Http\Controllers\ProfileController;
use Illuminate\Support\Facades\Route;

Route::get('/', function () {
    return view('welcome');
});
// Route::get('/dashboard', function () {
//     return view('dashboard');
// })->middleware(['auth', 'verified','checkrole:admin'])->name('dashboard');

Route::prefix('admin')
    ->middleware(['auth', 'verified', 'checkrole:admin'])
    ->as('admin.')
    ->group(function () {
        Route::get('/dashboard', DashboardController::class)->name('dashboard');
        // Bài viết (resource), chỉ dùng index, create, store, show
        Route::resource('posts', PostController::class)
            ->only(['index', 'create', 'store', 'show']);
        // Route model binding theo slug
        Route::get('/posts/{post:slug}', [PostController::class, 'show'])
            ->name('posts.show');
    });

Route::middleware('auth')->group(function () {
    Route::get('/profile', [ProfileController::class, 'edit'])->name('profile.edit');
    Route::patch('/profile', [ProfileController::class, 'update'])->name('profile.update');
    Route::delete('/profile', [ProfileController::class, 'destroy'])->name('profile.destroy');
});

Route::fallback(function () {
    return response()->view('errors.404', [], 404);
});

require __DIR__ . '/auth.php';
