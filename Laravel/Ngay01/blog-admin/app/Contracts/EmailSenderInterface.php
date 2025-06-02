<?php

namespace App\Contracts;

interface EmailSenderInterface
{
    public function sendWelcome(string $to): void;
}
