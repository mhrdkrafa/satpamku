<?php

namespace App\Http\Requests\Candidate;

use Illuminate\Foundation\Http\FormRequest;

class StoreExperienceRequest extends FormRequest
{
    public function authorize(): bool
    {
        return $this->user() !== null && ($this->user()->isCandidate() || $this->user()->isAdmin());
    }

    public function rules(): array
    {
        return [
            'employer_name' => ['required', 'string', 'max:255'],
            'position' => ['required', 'string', 'max:255'],
            'start_date' => ['required', 'date'],
            'end_date' => ['nullable', 'date', 'after_or_equal:start_date', 'required_if:is_current,false'],
            'description' => ['nullable', 'string', 'max:1000'],
            'is_current' => ['boolean'],
        ];
    }
}
