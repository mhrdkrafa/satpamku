<?php

namespace App\Http\Resources\Api\V1\Candidate;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class CandidateDocumentResource extends JsonResource
{
    public function toArray(Request $request): array
    {
        return [
            'id' => $this->id,
            'candidate_id' => $this->candidate_id,
            'type' => $this->type,
            'title' => $this->title,
            'file_size' => (int) $this->file_size,
            'mime_type' => $this->mime_type,
            'verification_status' => $this->verification_status,
            'rejection_reason' => $this->rejection_reason,
            'verified_at' => $this->verified_at?->toIso8601String(),
            'expires_at' => $this->expires_at?->format('Y-m-d'),
            'file_url' => url("/api/v1/candidate/documents/{$this->id}/file"),
            'created_at' => $this->created_at?->toIso8601String(),
            'updated_at' => $this->updated_at?->toIso8601String(),
        ];
    }
}
