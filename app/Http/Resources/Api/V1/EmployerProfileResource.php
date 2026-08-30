<?php

namespace App\Http\Resources\Api\V1;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;
use Illuminate\Support\Facades\Storage;

class EmployerProfileResource extends JsonResource
{
    public function toArray(Request $request): array
    {
        return [
            'id' => $this->id,
            'user_id' => $this->user_id,
            'company_name' => $this->company_name,
            'slug' => $this->slug,
            'nib' => $this->nib,
            'bujp_license_number' => $this->bujp_license_number,
            'logo_url' => $this->logo_path ? (str_starts_with($this->logo_path, 'http') ? $this->logo_path : Storage::disk('public')->url($this->logo_path)) : null,
            'banner_url' => $this->banner_path ? Storage::disk('public')->url($this->banner_path) : null,
            'description' => $this->description,
            'industry' => $this->industry,
            'website' => $this->website,
            'address' => $this->address,
            'city_id' => $this->city_id,
            'city' => $this->city,
            'pic_name' => $this->pic_name,
            'pic_phone' => $this->pic_phone,
            'pic_position' => $this->pic_position,
            'verification_status' => $this->verification_status,
            'created_at' => $this->created_at?->toIso8601String(),
            'updated_at' => $this->updated_at?->toIso8601String(),
        ];
    }
}
