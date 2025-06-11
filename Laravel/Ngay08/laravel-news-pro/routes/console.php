<?php

use Illuminate\Console\Scheduling\Schedule;
use Illuminate\Foundation\Inspiring;
use Illuminate\Support\Facades\Artisan;

Artisan::command('inspire', function () {
    $this->comment(Inspiring::quote());
})->purpose('Display an inspiring quote');

Schedule::macro('customSchedules', function () {
    $this->command('report:summary')->dailyAt('01:00');
    $this->command('backup:database')->weekly();
});