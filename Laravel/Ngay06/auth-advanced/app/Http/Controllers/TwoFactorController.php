<?php

namespace App\Http\Controllers;

use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Str;
use Illuminate\Support\Facades\Crypt;;

class TwoFactorController extends Controller
{
    // Hiển thị trang 2FA (trạng thái, mã QR, mã khôi phục)
    public function show()
    {
        return view('profile.two-factor');
    }

    // Bật 2FA cho user hiện tại
    public function enable(Request $request)
    {
        /** @var \App\Models\User $user */
        $user = Auth::user();

        if ($user->two_factor_secret) {
            return redirect()->back()->with('error', '2FA đã được bật trước đó.');
        }

        $user->forceFill([
            'two_factor_secret' => encrypt(app('pragmarx.google2fa')->generateSecretKey()),
            'two_factor_recovery_codes' => encrypt(json_encode(
                collect(range(1, 8))->map(fn() => Str::random(10))
            )),
        ])->save();

        return redirect()->back()->with('success', 'Đã bật xác thực 2 bước thành công.');
    }

    // Tắt 2FA cho user hiện tại
    public function disable(Request $request)
    {
        /** @var \App\Models\User $user */
        $user = Auth::user();

        $user->forceFill([
            'two_factor_secret' => null,
            'two_factor_recovery_codes' => null,
        ])->save();

        return redirect()->back()->with('success', 'Đã tắt xác thực 2 bước thành công.');
    }
}
