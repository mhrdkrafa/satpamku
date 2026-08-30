<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class CandidateProfile extends Model
{
    use HasFactory;

    protected $fillable = [
        'user_id',
        'headline',
        'summary',
        'preferred_city_id',
        'preferred_city',
        'preferred_shift',
        'preferred_employment_type',
        'salary_min',
        'salary_max',
        'height_cm',
        'weight_kg',
        'has_sim',
        'sim_types',
        'available_from',
        'years_experience',
        'highest_certificate_level',
        'verification_status',
        'profile_completion',
    ];

    protected function casts(): array
    {
        return [
            'has_sim' => 'boolean',
            'sim_types' => 'array',
            'available_from' => 'date',
            'salary_min' => 'integer',
            'salary_max' => 'integer',
            'height_cm' => 'integer',
            'weight_kg' => 'integer',
            'years_experience' => 'integer',
            'profile_completion' => 'integer',
        ];
    }

    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class);
    }

    /**
     * Recalculate profile completion percentage.
     */
    public function recalculateProfileCompletion(): int
    {
        $score = 20; // Base registration score

        if (!empty($this->headline)) {
            $score += 15;
        }

        if (!empty($this->summary)) {
            $score += 15;
        }

        if (!empty($this->preferred_shift) || !empty($this->preferred_employment_type)) {
            $score += 10;
        }

        if (!empty($this->salary_min) || !empty($this->salary_max)) {
            $score += 10;
        }

        if (!empty($this->height_cm) && !empty($this->weight_kg)) {
            $score += 10;
        }

        if ($this->highest_certificate_level !== 'none') {
            $score += 10;
        }

        if ($this->years_experience > 0) {
            $score += 10;
        }

        $finalScore = min(100, $score);
        $this->update(['profile_completion' => $finalScore]);

        return $finalScore;
    }
}
