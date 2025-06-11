<?php

use App\Events\UserRegistered;
use App\Listeners\SendWelcomeEmail;
use App\Listeners\CreateDefaultProfile;
use App\Listeners\NotifyAdminOfNewUser;
use App\Providers\AppServiceProvider;
use Illuminate\Auth\Events\Registered;
use Illuminate\Auth\Listeners\SendEmailVerificationNotification;

class EventServiceProvider extends AppServiceProvider
{
    protected $listen = [
        Registered::class => [
            SendEmailVerificationNotification::class,
        ],

        // Đăng ký Event tùy chỉnh
        UserRegistered::class => [
            SendWelcomeEmail::class,
            CreateDefaultProfile::class,
            NotifyAdminOfNewUser::class,
        ],
    ];

    public function boot(): void
    {
        //
    }

    protected $shouldDiscoverEvents = false;
}
