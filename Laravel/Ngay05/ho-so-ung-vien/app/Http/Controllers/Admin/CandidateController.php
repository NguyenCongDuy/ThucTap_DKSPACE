<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Candidate;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;

class CandidateController extends Controller
{
    public function index()
    {
        $candidates = Candidate::latest()->paginate(10);
        return view('admin.candidates.index', compact('candidates'));
    }
    public function destroy($id)
    {
        $candidate = Candidate::findOrFail($id);

        if ($candidate->avatar_path) {
            Storage::disk('public')->delete($candidate->avatar_path);
        }

        if ($candidate->cv_path) {
            Storage::disk('public')->delete($candidate->cv_path);
        }

        $candidate->delete();

        return redirect()->route('admin.candidates.index')->with('success', 'Ứng viên đã được xoá thành công!');
    }
}
