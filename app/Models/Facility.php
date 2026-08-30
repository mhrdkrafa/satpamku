<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Str;

class Facility extends Model
{
    use HasFactory;

    protected $fillable = [
        'name',
        'slug',
        'type',
        'icon',
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

        static::creating(function ($facility) {
            if (empty($facility->slug)) {
                $facility->slug = Str::slug($facility->name);
            }
        });
    }

    public function scopeActive($query)
    {
        return $query->where('is_active', true);
    }

    public function scopeFacilities($query)
    {
        return $query->where('type', 'facility');
    }

    public function scopeBenefits($query)
    {
        return $query->where('type', 'benefit');
    }
}
