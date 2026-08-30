<?php

namespace App\Http\Requests\Profile;

use Illuminate\Foundation\Http\FormRequest;

class UpdateCandidateProfileRequest extends FormRequest
{
    public function authorize(): bool
    {
        return $this->user() !== null && ($this->user()->isCandidate() || $this->user()->isAdmin());
    }

    public function rules(): array
    {
        return [
            'name' => ['sometimes', 'required', 'string', 'max:255'],
            'phone' => ['sometimes', 'required', 'string', 'max:20', 'unique:users,phone,' . $this->user()->id],
            'headline' => ['nullable', 'string', 'max:255'],
            'summary' => ['nullable', 'string', 'max:1000'],
            'city' => ['nullable', 'string', 'max:100'],
            'address' => ['nullable', 'string', 'max:500'],
            'date_of_birth' => ['nullable', 'date'],
            'gender' => ['nullable', 'string', 'in:male,female'],
            'preferred_city' => ['nullable', 'string', 'max:100'],
            'preferred_shift' => ['nullable', 'string', 'in:pagi,malam,2_shift,3_shift,rolling,any'],
            'preferred_employment_type' => ['nullable', 'string', 'in:full_time,contract,event,daily'],
            'salary_min' => ['nullable', 'numeric', 'min:0'],
            'salary_max' => ['nullable', 'numeric', 'gte:salary_min'],
            'height_cm' => ['nullable', 'integer', 'min:140', 'max:220'],
            'weight_kg' => ['nullable', 'integer', 'min:40', 'max:150'],
            'has_sim' => ['nullable', 'boolean'],
            'sim_types' => ['nullable', 'array'],
            'sim_types.*' => ['string', 'in:A,B1,B2,C'],
            'available_from' => ['nullable', 'date'],
            'years_experience' => ['nullable', 'integer', 'min:0', 'max:50'],
            'highest_certificate_level' => ['nullable', 'string', 'in:none,gada_pratama,gada_madya,gada_utama'],
            'profile_visibility' => ['nullable', 'string', 'in:public,employers_only,private'],
        ];
    }
}
