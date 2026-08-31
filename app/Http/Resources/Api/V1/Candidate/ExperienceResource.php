<?php

namespace App\Http\Resources\Api\V1\Candidate;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class ExperienceResource extends JsonResource
{
    public function toArray(Request $request): array
    {
        return [
            'id' => $this->id,
            'candidate_id' => $this->candidate_id,
            'employer_name' => $this->employer_name,
            'company_name' => $this->employer_name,
            'position' => $this->position,
            'position_title' => $this->position,
            'start_date' => $this->start_date?->format('Y-m-d'),
            'end_date' => $this->end_date?->format('Y-m-d'),
            'description' => $this->description,
            'is_current' => (bool) $this->is_current,
            'created_at' => $this->created_at?->toIso8601String(),
            'updated_at' => $this->updated_at?->toIso8601String(),
        ];
    }
}
