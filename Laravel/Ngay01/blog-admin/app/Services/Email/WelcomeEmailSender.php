<?php

namespace App\Services\Email;

use App\Contracts\EmailSenderInterface;
use Illuminate\Support\Facades\Mail;

class WelcomeEmailSender implements EmailSenderInterface
{
    public function sendWelcome(string $to): void
    {
        Mail::raw("Welcome to our system!", function ($message) use ($to) {
            $message->to($to)->subject("Welcome Email");
        });
    }
}
