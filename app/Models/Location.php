<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;
use Illuminate\Support\Str;

class Location extends Model
{
    use HasFactory;

    protected $fillable = [
        'parent_id',
        'name',
        'slug',
        'type',
        'latitude',
        'longitude',
        'is_active',
    ];

    protected function casts(): array
    {
        return [
            'is_active' => 'boolean',
            'latitude' => 'decimal:7',
            'longitude' => 'decimal:7',
        ];
    }

    protected static function boot()
    {
        parent::boot();

        static::creating(function ($location) {
            if (empty($location->slug)) {
                $slug = Str::slug($location->name);
                $originalSlug = $slug;
                $count = 1;
                while (static::where('slug', $slug)->exists()) {
                    $slug = "{$originalSlug}-" . $count++;
                }
                $location->slug = $slug;
            }
        });
    }

    public function parent(): BelongsTo
    {
        return $this->belongsTo(Location::class, 'parent_id');
    }

    public function children(): HasMany
    {
        return $this->hasMany(Location::class, 'parent_id');
    }

    public function scopeActive($query)
    {
        return $query->where('is_active', true);
    }

    public function scopeProvinces($query)
    {
        return $query->where('type', 'province');
    }

    public function scopeCities($query)
    {
        return $query->where('type', 'city');
    }
}
