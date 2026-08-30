<?php

namespace App\Http\Resources\Api\V1\Job;

use App\Http\Resources\Api\V1\Taxonomy\CertificationResource;
use App\Http\Resources\Api\V1\Taxonomy\FacilityResource;
use App\Http\Resources\Api\V1\Taxonomy\SkillResource;
use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class JobPostDetailResource extends JsonResource
{
    public function toArray(Request $request): array
    {
        return [
            'id' => $this->id,
            'title' => $this->title,
            'slug' => $this->slug,
            'description' => $this->description,
            'requirements' => $this->requirements,
            'responsibilities' => $this->responsibilities,
            'shift_type' => $this->shift_type,
            'placement_address' => $this->placement_address,
            'salary_min' => $this->salary_is_hidden ? null : $this->salary_min,
            'salary_max' => $this->salary_is_hidden ? null : $this->salary_max,
            'salary_is_hidden' => (bool) $this->salary_is_hidden,
            'experience_years_min' => (int) $this->experience_years_min,
            'min_height_cm' => $this->min_height_cm,
            'min_weight_kg' => $this->min_weight_kg,
            'required_certificate_level' => $this->required_certificate_level,
            'requires_sim' => (bool) $this->requires_sim,
            'required_sim_types' => $this->required_sim_types ?? [],
            'is_urgent' => (bool) $this->is_urgent,
            'is_featured' => (bool) $this->is_featured,
            'status' => $this->status,
            'views_count' => (int) $this->views_count,
            'applications_count' => (int) $this->applications_count,
            'published_at' => $this->published_at?->toIso8601String(),
            'expires_at' => $this->expires_at?->format('Y-m-d'),
            'employer' => [
                'id' => $this->employer?->id,
                'company_name' => $this->employer?->company_name,
                'slug' => $this->employer?->slug,
                'logo_url' => $this->employer?->logo_path ? (str_starts_with($this->employer->logo_path, 'http') ? $this->employer->logo_path : Storage::disk('public')->url($this->employer->logo_path)) : null,
                'description' => $this->employer?->description,
                'address' => $this->employer?->address,
                'city' => $this->employer?->city,
                'website' => $this->employer?->website,
                'verification_status' => $this->employer?->verification_status,
            ],
            'category' => [
                'id' => $this->category?->id,
                'name' => $this->category?->name,
                'slug' => $this->category?->slug,
                'icon' => $this->category?->icon,
            ],
            'position' => $this->position ? [
                'id' => $this->position->id,
                'name' => $this->position->name,
                'slug' => $this->position->slug,
            ] : null,
            'location' => [
                'id' => $this->location?->id,
                'name' => $this->location?->name,
                'type' => $this->location?->type,
            ],
            'facilities' => FacilityResource::collection($this->whenLoaded('facilities')),
            'skills' => SkillResource::collection($this->whenLoaded('skills')),
            'certifications' => $this->certifications->map(function ($cert) {
                return [
                    'id' => $cert->id,
                    'name' => $cert->name,
                    'issuing_body' => $cert->issuing_body,
                    'level' => $cert->level,
                    'is_mandatory' => (bool) ($cert->pivot->is_mandatory ?? true),
                ];
            }),
        ];
    }
}
