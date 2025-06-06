<?php

namespace App\Rules;

use Closure;
use Illuminate\Contracts\Validation\ValidationRule;

class NoProfanity implements ValidationRule
{
    /**
     *
     * @param  string  $attribute
     * @param  mixed   $value
     * @param  \Closure(string, string): void  $fail
     */
    protected $blacklist = ['cho', 'fuck', 'shit'];

    public function validate(string $attribute, mixed $value, Closure $fail): void
    {
        foreach ($this->blacklist as $badWord) {
            if (stripos($value, $badWord) !== false) {
                $fail("Trường $attribute chứa từ không phù hợp.");
                return;
            }
        }
    }
}
