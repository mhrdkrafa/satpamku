<?php

namespace App\Http\Requests\Candidate;

use Illuminate\Foundation\Http\FormRequest;

class StoreCandidateDocumentRequest extends FormRequest
{
    public function authorize(): bool
    {
        return $this->user() !== null && ($this->user()->isCandidate() || $this->user()->isAdmin());
    }

    public function rules(): array
    {
        return [
            'type' => ['required', 'string', 'in:cv,ktp,skck,surat_sehat,ijazah,other'],
            'title' => ['required', 'string', 'max:255'],
            'document' => ['required', 'file', 'mimes:pdf,jpeg,png,jpg,webp', 'max:5120'],
            'expires_at' => ['nullable', 'date'],
        ];
    }
}
