<?php

namespace App\Http\Resources\Api\V1\Taxonomy;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class CertificationResource extends JsonResource
{
    public function toArray(Request $request): array
    {
        return [
            'id' => $this->id,
            'name' => $this->name,
            'slug' => $this->slug,
            'issuing_body' => $this->issuing_body,
            'description' => $this->description,
            'level' => $this->level,
        ];
    }
}
