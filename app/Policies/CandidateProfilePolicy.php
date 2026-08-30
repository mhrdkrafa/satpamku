<?php

namespace App\Policies;

use App\Models\CandidateProfile;
use App\Models\User;

class CandidateProfilePolicy
{
    /**
     * Determine whether the user can view the candidate profile.
     */
    public function view(User $user, CandidateProfile $profile): bool
    {
        // Admin or the owner can always view
        if ($user->isAdmin() || $user->id === $profile->user_id) {
            return true;
        }

        // Verified employers can view if visibility is not private
        if ($user->isEmployer()) {
            $userProfile = $profile->user->profile;
            return $userProfile && $userProfile->profile_visibility !== 'private';
        }

        return false;
    }

    /**
     * Determine whether the user can update the candidate profile.
     */
    public function update(User $user, CandidateProfile $profile): bool
    {
        return $user->isAdmin() || $user->id === $profile->user_id;
    }

    /**
     * Determine whether the user can verify the candidate profile.
     */
    public function verify(User $user, CandidateProfile $profile): bool
    {
        return $user->isAdmin();
    }
}
