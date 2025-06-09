<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use PragmaRX\Google2FAQRCode\Google2FA;

class TwoFactorChallengeController extends Controller
{
    public function show()
    {
        return view('auth.TwoFactorChallenge');
    }

    public function verify(Request $request)
    {
        $request->validate([
            'one_time_password' => ['required', 'digits:6'],
        ]);

        $user = Auth::user();

        $google2fa = app('pragmarx.google2fa');

        // Giải mã secret
        $secret = decrypt($user->two_factor_secret);

        // Kiểm tra mã OTP người dùng nhập
        $valid = $google2fa->verifyKey($secret, $request->one_time_password);

        if ($valid) {
            // Đánh dấu user đã xác thực 2FA trong session
            session(['two_factor_passed' => true]);

            return redirect()->intended('/dashboard');
        }

        return back()->withErrors(['one_time_password' => 'Mã xác thực không hợp lệ']);
    }
}
