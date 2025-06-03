<?php

namespace App\Http\Requests;


use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Support\Facades\Auth;

class StorePostRequest extends FormRequest
{
    /**
     * Determine if the user is authorized to make this request.
     */
    public function authorize(): bool
    {
        return Auth::check();
    }

    /**
     * Get the validation rules that apply to the request.
     *
     * @return array<string, \Illuminate\Contracts\Validation\ValidationRule|array<mixed>|string>
     */
    public function rules(): array
    {
       return [
            'title' => 'required|unique:posts,title',
            'content' => 'required|min:10',
        ];
    }

    public function messages()
    {
        return [
            'title.required' => 'Tiêu đề bài viết không được để trống',
            'title.unique' => 'Tiêu đề đã tồn tại, vui lòng chọn tiêu đề khác',
            'content.required' => 'Nội dung không được để trống',
            'content.min' => 'Nội dung phải có ít nhất 10 ký tự',
        ];
    }
}
