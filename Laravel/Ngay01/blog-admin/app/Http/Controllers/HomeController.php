<?php

namespace App\Http\Controllers;

use App\Contracts\EmailSenderInterface;
use App\Contracts\TranslatorInterface;
use Illuminate\Http\Request;

class HomeController extends Controller
{
    protected TranslatorInterface $translator;
     protected EmailSenderInterface $emailSender;

    public function __construct(TranslatorInterface $translator, EmailSenderInterface $emailSender,)
    {
        $this->emailSender = $emailSender;
        $this->translator = $translator;
    }

    public function index()
    {
        $this->emailSender->sendWelcome('admin@example.com');
        
        return response()->json([
            'message' => $this->translator->greet(),
            'messages' => 'Welcome email sentss!'
        ]);

    }
}
