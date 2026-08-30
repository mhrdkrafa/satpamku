<?php

namespace App\Http\Requests\Job;

use Illuminate\Foundation\Http\FormRequest;

class ChangeJobPostStatusRequest extends FormRequest
{
    public function authorize(): bool
    {
        return $this->user() !== null && ($this->user()->isEmployer() || $this->user()->isAdmin());
    }

    public function rules(): array
    {
        return [
            'status' => ['required', 'string', 'in:draft,review,published,paused,closed,rejected'],
            'rejection_reason' => ['nullable', 'string', 'required_if:status,rejected'],
        ];
    }
}
