<?php

namespace App\Http\Requests\Candidate;

use Illuminate\Foundation\Http\FormRequest;

class StoreCandidateCertificationRequest extends FormRequest
{
    public function authorize(): bool
    {
        return $this->user() !== null && ($this->user()->isCandidate() || $this->user()->isAdmin());
    }

    public function rules(): array
    {
        return [
            'certification_id' => ['required', 'integer', 'exists:certifications,id'],
            'certificate_number' => ['nullable', 'string', 'max:100'],
            'issued_at' => ['nullable', 'date'],
            'expires_at' => ['nullable', 'date', 'after:issued_at'],
            'document' => ['required', 'file', 'mimes:pdf,jpeg,png,jpg,webp', 'max:5120'], // max 5MB
        ];
    }
}
