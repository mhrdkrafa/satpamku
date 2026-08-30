<?php

namespace App\Models;

// use Illuminate\Contracts\Auth\MustVerifyEmail;
use Database\Factories\UserFactory;
use Filament\Models\Contracts\FilamentUser;
use Filament\Panel;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\SoftDeletes;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;
use Laravel\Sanctum\HasApiTokens;

class User extends Authenticatable implements FilamentUser
{
    /** @use HasFactory<UserFactory> */
    use HasApiTokens, HasFactory, Notifiable, SoftDeletes;

    /**
     * The attributes that are mass assignable.
     *
     * @var list<string>
     */
    protected $fillable = [
        'name',
        'email',
        'phone',
        'password',
        'role',
        'status',
    ];

    /**
     * The attributes that should be hidden for serialization.
     *
     * @var list<string>
     */
    protected $hidden = [
        'password',
        'remember_token',
    ];

    /**
     * Get the attributes that should be cast.
     *
     * @return array<string, string>
     */
    protected function casts(): array
    {
        return [
            'email_verified_at' => 'datetime',
            'password' => 'hashed',
        ];
    }

    public function profile(): \Illuminate\Database\Eloquent\Relations\HasOne
    {
        return $this->hasOne(UserProfile::class);
    }

    public function candidateProfile(): \Illuminate\Database\Eloquent\Relations\HasOne
    {
        return $this->hasOne(CandidateProfile::class);
    }

    public function employerProfile(): \Illuminate\Database\Eloquent\Relations\HasOne
    {
        return $this->hasOne(EmployerProfile::class);
    }

    public function deviceTokens(): \Illuminate\Database\Eloquent\Relations\HasMany
    {
        return $this->hasMany(DeviceToken::class);
    }

    /**
     * Determine if user can access the Filament panel.
     */
    public function canAccessPanel(Panel $panel): bool
    {
        return in_array($this->role, ['super_admin', 'admin']) && $this->status === 'active';
    }

    public function isSuperAdmin(): bool
    {
        return $this->role === 'super_admin';
    }

    public function isAdmin(): bool
    {
        return in_array($this->role, ['admin', 'super_admin']);
    }

    public function isEmployer(): bool
    {
        return $this->role === 'employer';
    }

    public function isCandidate(): bool
    {
        return $this->role === 'candidate';
    }
}
