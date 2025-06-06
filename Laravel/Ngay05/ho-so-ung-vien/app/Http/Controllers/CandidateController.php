<?php

namespace App\Http\Controllers;

use App\Http\Requests\StoreCandidateRequest;
use App\Models\Candidate;
use Illuminate\Http\Request;

class CandidateController extends Controller
{
    public function create()
    {
        return view('candidates.create');
    }
    public function store(StoreCandidateRequest $request){
        // lưu avtar
        $avatarPath = $request->hasFile('avatar')
            ? $request->file('avatar')->store('candidates', 'public')
            : null;
        //  lưu cv
        $cvPath = $request->file('cv')->store('candidates', 'public');
        // tạo mới bản ghi
        Candidate::create([
            'name'        => $request->name,
            'email'       => $request->email,
            'birthday'    => $request->birthday,
            'bio'         => $request->bio,
            'avatar_path' => $avatarPath,
            'cv_path'     => $cvPath,
        ]);
        return redirect()->route('candidates.create')->with('success', 'Hồ sơ đã được gửi thành công!');
    }
}
