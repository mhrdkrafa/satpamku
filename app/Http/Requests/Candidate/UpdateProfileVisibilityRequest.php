<?php

namespace App\Http\Requests\Candidate;

use Illuminate\Foundation\Http\FormRequest;

class UpdateProfileVisibilityRequest extends FormRequest
{
    public function authorize(): bool
    {
        return $this->user() !== null && ($this->user()->isCandidate() || $this->user()->isAdmin());
    }

    public function rules(): array
    {
        return [
            'profile_visibility' => ['required', 'string', 'in:public,employers_only,private'],
        ];
    }
}
