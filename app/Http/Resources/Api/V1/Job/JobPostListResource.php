<?php

namespace App\Http\Resources\Api\V1\Job;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class JobPostListResource extends JsonResource
{
    public function toArray(Request $request): array
    {
        return [
            'id' => $this->id,
            'title' => $this->title,
            'slug' => $this->slug,
            'employer' => [
                'id' => $this->employer?->id,
                'company_name' => $this->employer?->company_name,
                'slug' => $this->employer?->slug,
                'logo_url' => $this->employer?->logo_path ? url('storage/' . $this->employer->logo_path) : null,
                'city' => $this->employer?->city,
                'verification_status' => $this->employer?->verification_status,
            ],
            'category' => [
                'id' => $this->category?->id,
                'name' => $this->category?->name,
                'icon' => $this->category?->icon,
            ],
            'position' => $this->position ? [
                'id' => $this->position->id,
                'name' => $this->position->name,
            ] : null,
            'location' => [
                'id' => $this->location?->id,
                'name' => $this->location?->name,
                'type' => $this->location?->type,
            ],
            'shift_type' => $this->shift_type,
            'salary_min' => $this->salary_is_hidden ? null : $this->salary_min,
            'salary_max' => $this->salary_is_hidden ? null : $this->salary_max,
            'salary_is_hidden' => (bool) $this->salary_is_hidden,
            'required_certificate_level' => $this->required_certificate_level,
            'is_urgent' => (bool) $this->is_urgent,
            'is_featured' => (bool) $this->is_featured,
            'published_at' => $this->published_at?->toIso8601String(),
            'expires_at' => $this->expires_at?->format('Y-m-d'),
        ];
    }
}
