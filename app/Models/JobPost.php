<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Builder;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\BelongsToMany;
use Illuminate\Database\Eloquent\SoftDeletes;
use Illuminate\Support\Carbon;
use Illuminate\Support\Str;

class JobPost extends Model
{
    use HasFactory, SoftDeletes;

    protected $fillable = [
        'employer_id',
        'category_id',
        'position_id',
        'location_id',
        'title',
        'slug',
        'description',
        'requirements',
        'responsibilities',
        'shift_type',
        'placement_address',
        'salary_min',
        'salary_max',
        'salary_is_hidden',
        'experience_years_min',
        'min_height_cm',
        'min_weight_kg',
        'required_certificate_level',
        'requires_sim',
        'required_sim_types',
        'is_urgent',
        'is_featured',
        'status',
        'rejection_reason',
        'published_at',
        'expires_at',
        'moderation_notes',
        'moderated_by',
        'moderated_at',
        'views_count',
        'applications_count',
    ];

    protected function casts(): array
    {
        return [
            'salary_is_hidden' => 'boolean',
            'requires_sim' => 'boolean',
            'required_sim_types' => 'array',
            'is_urgent' => 'boolean',
            'is_featured' => 'boolean',
            'salary_min' => 'integer',
            'salary_max' => 'integer',
            'experience_years_min' => 'integer',
            'min_height_cm' => 'integer',
            'min_weight_kg' => 'integer',
            'views_count' => 'integer',
            'applications_count' => 'integer',
            'published_at' => 'datetime',
            'expires_at' => 'date',
            'moderated_at' => 'datetime',
        ];
    }

    protected static function boot()
    {
        parent::boot();

        static::creating(function ($job) {
            if (empty($job->slug)) {
                $baseSlug = Str::slug($job->title);
                $uniqueSlug = $baseSlug . '-' . Str::lower(Str::random(6));
                $job->slug = $uniqueSlug;
            }
        });
    }

    // ==========================================
    // RELATIONSHIPS
    // ==========================================

    public function employer(): BelongsTo
    {
        return $this->belongsTo(EmployerProfile::class, 'employer_id');
    }

    public function category(): BelongsTo
    {
        return $this->belongsTo(JobCategory::class, 'category_id');
    }

    public function position(): BelongsTo
    {
        return $this->belongsTo(JobPosition::class, 'position_id');
    }

    public function location(): BelongsTo
    {
        return $this->belongsTo(Location::class, 'location_id');
    }

    public function facilities(): BelongsToMany
    {
        return $this->belongsToMany(Facility::class, 'job_post_facilities', 'job_post_id', 'facility_id');
    }

    public function skills(): BelongsToMany
    {
        return $this->belongsToMany(Skill::class, 'job_post_skills', 'job_post_id', 'skill_id');
    }

    public function certifications(): BelongsToMany
    {
        return $this->belongsToMany(Certification::class, 'job_post_certifications', 'job_post_id', 'certification_id')
            ->withPivot('is_mandatory');
    }

    public function moderator(): BelongsTo
    {
        return $this->belongsTo(User::class, 'moderated_by');
    }

    // ==========================================
    // SCOPES
    // ==========================================

    public function scopePublished(Builder $query): Builder
    {
        return $query->where('status', 'published')
            ->where(function ($q) {
                $q->whereNull('expires_at')
                    ->orWhere('expires_at', '>=', Carbon::today());
            });
    }

    public function scopeFeatured(Builder $query): Builder
    {
        return $query->published()->where('is_featured', true);
    }

    public function scopeUrgent(Builder $query): Builder
    {
        return $query->published()->where('is_urgent', true);
    }

    public function scopeFilter(Builder $query, array $filters): Builder
    {
        if (!empty($filters['q'])) {
            $keyword = $filters['q'];
            $query->where(function ($q) use ($keyword) {
                $q->where('title', 'like', "%{$keyword}%")
                    ->orWhere('description', 'like', "%{$keyword}%")
                    ->orWhereHas('employer', fn($emp) => $emp->where('company_name', 'like', "%{$keyword}%"));
            });
        }

        if (!empty($filters['category_id'])) {
            $query->where('category_id', $filters['category_id']);
        }

        if (!empty($filters['category_slug'])) {
            $query->whereHas('category', fn($q) => $q->where('slug', $filters['category_slug']));
        }

        if (!empty($filters['location_id'])) {
            $query->where('location_id', $filters['location_id']);
        }

        if (!empty($filters['location_slug'])) {
            $query->whereHas('location', fn($q) => $q->where('slug', $filters['location_slug']));
        }

        if (!empty($filters['shift_type'])) {
            $query->where('shift_type', $filters['shift_type']);
        }

        if (!empty($filters['certificate_level'])) {
            $query->where('required_certificate_level', $filters['certificate_level']);
        }

        if (!empty($filters['salary_min'])) {
            $query->where('salary_max', '>=', (int) $filters['salary_min']);
        }

        if (isset($filters['is_urgent'])) {
            $query->where('is_urgent', filter_var($filters['is_urgent'], FILTER_VALIDATE_BOOLEAN));
        }

        if (isset($filters['is_featured'])) {
            $query->where('is_featured', filter_var($filters['is_featured'], FILTER_VALIDATE_BOOLEAN));
        }

        return $query;
    }

    // ==========================================
    // LIFECYCLE & STATE ACTIONS
    // ==========================================

    public function publish(?User $moderator = null): bool
    {
        return $this->update([
            'status' => 'published',
            'published_at' => $this->published_at ?? Carbon::now(),
            'rejection_reason' => null,
            'moderated_by' => $moderator?->id,
            'moderated_at' => Carbon::now(),
        ]);
    }

    public function pause(): bool
    {
        return $this->update(['status' => 'paused']);
    }

    public function close(): bool
    {
        return $this->update(['status' => 'closed']);
    }

    public function submitForReview(): bool
    {
        return $this->update(['status' => 'review']);
    }

    public function reject(string $reason, ?User $moderator = null): bool
    {
        return $this->update([
            'status' => 'rejected',
            'rejection_reason' => $reason,
            'moderated_by' => $moderator?->id,
            'moderated_at' => Carbon::now(),
        ]);
    }

    public function incrementViews(): void
    {
        $this->increment('views_count');
    }
}
