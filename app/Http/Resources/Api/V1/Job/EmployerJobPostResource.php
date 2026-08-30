<?php

namespace App\Http\Resources\Api\V1\Job;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class EmployerJobPostResource extends JsonResource
{
    public function toArray(Request $request): array
    {
        return [
            'id' => $this->id,
            'title' => $this->title,
            'slug' => $this->slug,
            'status' => $this->status,
            'rejection_reason' => $this->rejection_reason,
            'category' => [
                'id' => $this->category?->id,
                'name' => $this->category?->name,
            ],
            'position' => $this->position ? [
                'id' => $this->position->id,
                'name' => $this->position->name,
            ] : null,
            'location' => [
                'id' => $this->location?->id,
                'name' => $this->location?->name,
            ],
            'shift_type' => $this->shift_type,
            'salary_min' => $this->salary_min,
            'salary_max' => $this->salary_max,
            'salary_is_hidden' => (bool) $this->salary_is_hidden,
            'required_certificate_level' => $this->required_certificate_level,
            'is_urgent' => (bool) $this->is_urgent,
            'is_featured' => (bool) $this->is_featured,
            'views_count' => (int) $this->views_count,
            'applications_count' => (int) $this->applications_count,
            'published_at' => $this->published_at?->toIso8601String(),
            'expires_at' => $this->expires_at?->format('Y-m-d'),
            'created_at' => $this->created_at?->toIso8601String(),
            'updated_at' => $this->updated_at?->toIso8601String(),
        ];
    }
}
