<?php

namespace App\Http\Resources\Api\V1;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class CandidateProfileResource extends JsonResource
{
    public function toArray(Request $request): array
    {
        return [
            'id' => $this->id,
            'user_id' => $this->user_id,
            'headline' => $this->headline,
            'summary' => $this->summary,
            'preferred_city_id' => $this->preferred_city_id,
            'preferred_city' => $this->preferred_city,
            'preferred_shift' => $this->preferred_shift,
            'preferred_employment_type' => $this->preferred_employment_type,
            'salary_min' => $this->salary_min,
            'salary_max' => $this->salary_max,
            'height_cm' => $this->height_cm,
            'weight_kg' => $this->weight_kg,
            'has_sim' => (bool) $this->has_sim,
            'sim_types' => $this->sim_types ?? [],
            'available_from' => $this->available_from?->format('Y-m-d'),
            'years_experience' => (int) $this->years_experience,
            'highest_certificate_level' => $this->highest_certificate_level,
            'verification_status' => $this->verification_status,
            'profile_completion' => (int) $this->profile_completion,
            'created_at' => $this->created_at?->toIso8601String(),
            'updated_at' => $this->updated_at?->toIso8601String(),
        ];
    }
}
