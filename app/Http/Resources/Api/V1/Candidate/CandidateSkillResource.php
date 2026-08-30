<?php

namespace App\Http\Resources\Api\V1\Candidate;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class CandidateSkillResource extends JsonResource
{
    public function toArray(Request $request): array
    {
        return [
            'id' => $this->id,
            'name' => $this->name,
            'slug' => $this->slug,
            'category' => $this->category,
            'level' => $this->pivot?->level ?? $this->level ?? 'intermediate',
        ];
    }
}
