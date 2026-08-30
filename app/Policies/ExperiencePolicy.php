<?php

namespace App\Policies;

use App\Models\Experience;
use App\Models\User;

class ExperiencePolicy
{
    public function view(User $user, Experience $experience): bool
    {
        return $user->isAdmin() || $user->id === $experience->candidate->user_id || $user->isEmployer();
    }

    public function create(User $user): bool
    {
        return $user->isCandidate() || $user->isAdmin();
    }

    public function update(User $user, Experience $experience): bool
    {
        return $user->isAdmin() || $user->id === $experience->candidate->user_id;
    }

    public function delete(User $user, Experience $experience): bool
    {
        return $user->isAdmin() || $user->id === $experience->candidate->user_id;
    }
}
