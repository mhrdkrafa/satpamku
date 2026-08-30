<?php

namespace App\Http\Requests\Candidate;

use Illuminate\Foundation\Http\FormRequest;

class SyncCandidateSkillsRequest extends FormRequest
{
    public function authorize(): bool
    {
        return $this->user() !== null && ($this->user()->isCandidate() || $this->user()->isAdmin());
    }

    public function rules(): array
    {
        return [
            'skills' => ['required', 'array'],
            'skills.*.skill_id' => ['required', 'integer', 'exists:skills,id'],
            'skills.*.level' => ['nullable', 'string', 'in:beginner,intermediate,advanced,expert'],
        ];
    }
}
