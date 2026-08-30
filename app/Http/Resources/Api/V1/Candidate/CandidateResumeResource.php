<?php

namespace App\Http\Resources\Api\V1\Candidate;

use App\Http\Resources\Api\V1\CandidateProfileResource;
use App\Http\Resources\Api\V1\UserProfileResource;
use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class CandidateResumeResource extends JsonResource
{
    public function toArray(Request $request): array
    {
        return [
            'id' => $this->id,
            'name' => $this->name,
            'email' => $this->email,
            'phone' => $this->phone,
            'role' => $this->role,
            'status' => $this->status,
            'profile' => new UserProfileResource($this->profile),
            'candidate_profile' => new CandidateProfileResource($this->candidateProfile),
            'experiences' => ExperienceResource::collection($this->candidateProfile?->experiences ?? []),
            'skills' => CandidateSkillResource::collection($this->candidateProfile?->skills ?? []),
            'certifications' => CandidateCertificationResource::collection($this->candidateProfile?->certifications ?? []),
            'documents' => CandidateDocumentResource::collection($this->candidateProfile?->documents ?? []),
        ];
    }
}
