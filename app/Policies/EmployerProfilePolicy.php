<?php

namespace App\Policies;

use App\Models\EmployerProfile;
use App\Models\User;

class EmployerProfilePolicy
{
    /**
     * Determine whether the user can view the employer profile.
     */
    public function view(?User $user, EmployerProfile $profile): bool
    {
        // Publicly viewable by anyone
        return true;
    }

    /**
     * Determine whether the user can update the employer profile.
     */
    public function update(User $user, EmployerProfile $profile): bool
    {
        return $user->isAdmin() || $user->id === $profile->user_id;
    }

    /**
     * Determine whether the user can verify the employer profile.
     */
    public function verify(User $user, EmployerProfile $profile): bool
    {
        return $user->isAdmin();
    }
}
