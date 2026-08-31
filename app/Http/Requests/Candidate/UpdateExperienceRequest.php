<?php

namespace App\Http\Requests\Candidate;

use Illuminate\Foundation\Http\FormRequest;

class UpdateExperienceRequest extends FormRequest
{
    public function authorize(): bool
    {
        return $this->user() !== null && ($this->user()->isCandidate() || $this->user()->isAdmin());
    }

    public function prepareForValidation(): void
    {
        if ($this->has('company_name') && !$this->has('employer_name')) {
            $this->merge(['employer_name' => $this->input('company_name')]);
        }
        if ($this->has('position_title') && !$this->has('position')) {
            $this->merge(['position' => $this->input('position_title')]);
        }
    }

    public function rules(): array
    {
        return [
            'employer_name' => ['sometimes', 'required', 'string', 'max:255'],
            'position' => ['sometimes', 'required', 'string', 'max:255'],
            'start_date' => ['sometimes', 'required', 'date'],
            'end_date' => ['nullable', 'date', 'after_or_equal:start_date'],
            'description' => ['nullable', 'string', 'max:1000'],
            'is_current' => ['boolean'],
        ];
    }
}
