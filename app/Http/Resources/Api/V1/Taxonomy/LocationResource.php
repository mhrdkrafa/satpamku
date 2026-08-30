<?php

namespace App\Http\Resources\Api\V1\Taxonomy;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class LocationResource extends JsonResource
{
    public function toArray(Request $request): array
    {
        return [
            'id' => $this->id,
            'parent_id' => $this->parent_id,
            'name' => $this->name,
            'slug' => $this->slug,
            'type' => $this->type,
            'latitude' => $this->latitude ? (float) $this->latitude : null,
            'longitude' => $this->longitude ? (float) $this->longitude : null,
            'is_active' => (bool) $this->is_active,
            'children' => LocationResource::collection($this->whenLoaded('children')),
        ];
    }
}
