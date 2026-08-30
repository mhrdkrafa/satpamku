<?php

namespace App\Http\Requests\Job;

use Illuminate\Foundation\Http\FormRequest;

class UpdateJobPostRequest extends FormRequest
{
    public function authorize(): bool
    {
        return $this->user() !== null && ($this->user()->isEmployer() || $this->user()->isAdmin());
    }

    public function rules(): array
    {
        return [
            'category_id' => ['sometimes', 'required', 'integer', 'exists:job_categories,id'],
            'position_id' => ['nullable', 'integer', 'exists:job_positions,id'],
            'location_id' => ['sometimes', 'required', 'integer', 'exists:locations,id'],
            'title' => ['sometimes', 'required', 'string', 'max:255'],
            'description' => ['sometimes', 'required', 'string'],
            'requirements' => ['nullable', 'string'],
            'responsibilities' => ['nullable', 'string'],
            'shift_type' => ['sometimes', 'required', 'string', 'in:full_time,part_time,2_shift,3_shift,event,temporary'],
            'placement_address' => ['nullable', 'string', 'max:500'],
            'salary_min' => ['nullable', 'integer', 'min:0'],
            'salary_max' => ['nullable', 'integer', 'gte:salary_min'],
            'salary_is_hidden' => ['boolean'],
            'experience_years_min' => ['integer', 'min:0'],
            'min_height_cm' => ['nullable', 'integer', 'min:140', 'max:220'],
            'min_weight_kg' => ['nullable', 'integer', 'min:40', 'max:150'],
            'required_certificate_level' => ['sometimes', 'required', 'string', 'in:none,gada_pratama,gada_madya,gada_utama'],
            'requires_sim' => ['boolean'],
            'required_sim_types' => ['nullable', 'array'],
            'required_sim_types.*' => ['string', 'in:A,B1,B2,C'],
            'is_urgent' => ['boolean'],
            'is_featured' => ['boolean'],
            'expires_at' => ['nullable', 'date'],
            'facility_ids' => ['nullable', 'array'],
            'facility_ids.*' => ['integer', 'exists:facilities,id'],
            'skill_ids' => ['nullable', 'array'],
            'skill_ids.*' => ['integer', 'exists:skills,id'],
            'certifications' => ['nullable', 'array'],
            'certifications.*.certification_id' => ['required', 'integer', 'exists:certifications,id'],
            'certifications.*.is_mandatory' => ['boolean'],
        ];
    }
}
