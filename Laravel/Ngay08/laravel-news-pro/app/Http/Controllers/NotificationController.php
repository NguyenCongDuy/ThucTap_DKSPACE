<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Database\Eloquent\ModelNotFoundException;
use App\Models\User;

class NotificationController extends Controller
{
    /**
     * @param string $id ID của thông báo
     * @return \Illuminate\Http\RedirectResponse
     */
    public function markAsRead($id)
    {

        try {
            $user = Auth::user();

            if (!$user) {
                return redirect()->route('login')
                    ->with('error', 'Bạn cần đăng nhập để thực hiện hành động này.');
            }

            /** @var \App\Models\User|\Illuminate\Notifications\Notifiable $user */

            $notification = $user->notifications()->findOrFail($id);
            $notification->markAsRead();

            return back()->with('success', 'Đã đánh dấu thông báo là đã đọc');
        } catch (ModelNotFoundException $e) {
            return back()->with('error', 'Không tìm thấy thông báo.');
        } catch (\Exception $e) {
            return back()->with('error', 'Đã xảy ra lỗi: ' . $e->getMessage());
        }
    }

    /**
     * Đánh dấu tất cả thông báo là đã đọc
     *
     * @return \Illuminate\Http\RedirectResponse
     */
    public function markAllAsRead()
    {
        try {
            $user = Auth::user();

            if (!$user) {
                return redirect()->route('login')
                    ->with('error', 'Bạn cần đăng nhập để thực hiện hành động này.');
            }
            $user->unreadNotifications->markAsRead();

            return back()->with('success', 'Đã đánh dấu tất cả thông báo là đã đọc');
        } catch (\Exception $e) {
            return back()->with('error', 'Đã xảy ra lỗi: ' . $e->getMessage());
        }
    }

    /**
     * Xóa một thông báo
     *
     * @param string $id ID của thông báo
     * @return \Illuminate\Http\RedirectResponse
     */
    public function destroy($id)
    {
        try {
            $user = Auth::user();

            if (!$user) {
                return redirect()->route('login')
                    ->with('error', 'Bạn cần đăng nhập để thực hiện hành động này.');
            }
            /** @var \App\Models\User|\Illuminate\Notifications\Notifiable $user */

            $notification = $user->notifications()->findOrFail($id);
            $notification->delete();

            return back()->with('success', 'Đã xóa thông báo');
        } catch (ModelNotFoundException $e) {
            return back()->with('error', 'Không tìm thấy thông báo.');
        } catch (\Exception $e) {
            return back()->with('error', 'Đã xảy ra lỗi: ' . $e->getMessage());
        }
    }
}
