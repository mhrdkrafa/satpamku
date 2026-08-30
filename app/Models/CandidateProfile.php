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

    public function experiences(): \Illuminate\Database\Eloquent\Relations\HasMany
    {
        return $this->hasMany(Experience::class, 'candidate_id')->orderBy('start_date', 'desc');
    }

    public function candidateSkills(): \Illuminate\Database\Eloquent\Relations\HasMany
    {
        return $this->hasMany(CandidateSkill::class, 'candidate_id');
    }

    public function skills(): \Illuminate\Database\Eloquent\Relations\BelongsToMany
    {
        return $this->belongsToMany(Skill::class, 'candidate_skill', 'candidate_id', 'skill_id')
            ->withPivot('level')
            ->withTimestamps();
    }

    public function certifications(): \Illuminate\Database\Eloquent\Relations\HasMany
    {
        return $this->hasMany(CandidateCertification::class, 'candidate_id');
    }

    public function documents(): \Illuminate\Database\Eloquent\Relations\HasMany
    {
        return $this->hasMany(CandidateDocument::class, 'candidate_id');
    }

    public function applications(): \Illuminate\Database\Eloquent\Relations\HasMany
    {
        return $this->hasMany(JobApplication::class, 'candidate_id')->latest('applied_at');
    }

    public function savedJobs(): \Illuminate\Database\Eloquent\Relations\HasMany
    {
        return $this->hasMany(SavedJob::class, 'candidate_id');
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
