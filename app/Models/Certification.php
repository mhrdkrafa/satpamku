<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Str;

class Certification extends Model
{
    use HasFactory;

    protected $fillable = [
        'name',
        'slug',
        'issuing_body',
        'description',
        'level',
        'is_active',
    ];

    protected function casts(): array
    {
        return [
            'is_active' => 'boolean',
        ];
    }

    protected static function boot()
    {
        parent::boot();

        static::creating(function ($cert) {
            if (empty($cert->slug)) {
                $cert->slug = Str::slug($cert->name);
            }
        });
    }

    public function scopeActive($query)
    {
        return $query->where('is_active', true);
    }
}
