<?php

namespace App\Providers;

use App\Contracts\EmailSenderInterface;
use Illuminate\Support\ServiceProvider;
use App\Contracts\TranslatorInterface;
use App\Services\Email\WelcomeEmailSender;
use App\Services\Translator\VietnameseTranslator;
use App\Services\Translator\EnglishTranslator;

/**
 * Bind TranslatorInterface theo ngôn ngữ được cấu hình
 */
class TranslatorServiceProvider extends ServiceProvider
{
    public function register(): void
    {
        $this->app->bindIf(TranslatorInterface::class, function () {
            $locale = config('app.locale');
            return $locale === 'vi'
                ? new VietnameseTranslator()
                : new EnglishTranslator();
        });
        $this->app->singleton(EmailSenderInterface::class, WelcomeEmailSender::class);
    }
}
