<?php

namespace App\Http\Resources\Api\V1;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class UserResource extends JsonResource
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
            'email_verified' => $this->email_verified_at !== null,
            'profile' => new UserProfileResource($this->whenLoaded('profile')),
            'candidate_profile' => new CandidateProfileResource($this->whenLoaded('candidateProfile')),
            'employer_profile' => new EmployerProfileResource($this->whenLoaded('employerProfile')),
            'created_at' => $this->created_at?->toIso8601String(),
            'updated_at' => $this->updated_at?->toIso8601String(),
        ];
    }
}
