<?php

namespace App\Http\Resources\Api\V1\Candidate;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class CandidateCertificationResource extends JsonResource
{
    public function toArray(Request $request): array
    {
        return [
            'id' => $this->id,
            'candidate_id' => $this->candidate_id,
            'certification_id' => $this->certification_id,
            'certification_name' => $this->certification?->name,
            'issuing_body' => $this->certification?->issuing_body,
            'level' => $this->certification?->level,
            'certificate_number' => $this->certificate_number,
            'issued_at' => $this->issued_at?->format('Y-m-d'),
            'expires_at' => $this->expires_at?->format('Y-m-d'),
            'verification_status' => $this->verification_status,
            'rejection_reason' => $this->rejection_reason,
            'verified_at' => $this->verified_at?->toIso8601String(),
            'is_expired' => $this->isExpired(),
            'file_url' => url("/api/v1/candidate/certifications/{$this->id}/file"),
            'created_at' => $this->created_at?->toIso8601String(),
            'updated_at' => $this->updated_at?->toIso8601String(),
        ];
    }
}
