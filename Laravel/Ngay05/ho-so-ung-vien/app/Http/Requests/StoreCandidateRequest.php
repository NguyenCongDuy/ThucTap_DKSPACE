<?php

namespace App\Http\Requests;

use App\Rules\NoProfanity;
use Faker\Guesser\Name;
use Illuminate\Foundation\Http\FormRequest;

class StoreCandidateRequest extends FormRequest
{
    /**
     * Determine if the user is authorized to make this request.
     */
    public function authorize(): bool
    {
        return true;
    }

    /**
     * Get the validation rules that apply to the request.
     *
     * @return array<string, \Illuminate\Contracts\Validation\ValidationRule|array<mixed>|string>
     */
    public function rules(): array
    {
        return [
            'name'    => ['required','min:5'],
            'email'    => ['required','email','unique:candidates,email'],
            'birthday'    => ['required','date','before:-18 years'],
            'avatar'    => ['nullable','image','max:2048'],
            'cv'    => ['required', 'file', 'mimetypes:application/pdf', 'max:5120'],
            'bio'    => ['nullable', 'max:1000', new NoProfanity()],
        ];
    }

    public function messages(): array
    {
        return [
            'name.required'     => 'Vui lòng nhập họ tên.',
            'name.min'          => 'Họ tên phải có ít nhất :min ký tự.',

            'email.required'    => 'Vui lòng nhập địa chỉ email.',
            'email.email'       => 'Email không hợp lệ.',
            'email.unique'      => 'Email này đã được đăng ký.',

            'birthday.required' => 'Vui lòng chọn ngày sinh.',
            'birthday.date'     => 'Ngày sinh không hợp lệ.',
            'birthday.before'   => 'Ứng viên phải từ 18 tuổi trở lên.',

            'avatar.image'      => 'Ảnh đại diện phải là file hình ảnh.',
            'avatar.max'        => 'Ảnh đại diện không được vượt quá 2MB.',

            'cv.required'       => 'Vui lòng tải lên CV.',
            'cv.file'           => 'CV phải là một tệp hợp lệ.',
            'cv.mimetypes'      => 'CV phải là file PDF.',
            'cv.max'            => 'CV không được vượt quá 5MB.',

            'bio.max'           => 'Mô tả không được dài quá 1000 ký tự.',
            'bio.*'             => 'Mô tả chứa nội dung không phù hợp.',
        ];
    }
}
