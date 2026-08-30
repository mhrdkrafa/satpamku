<?php

namespace App\Policies;

use App\Models\JobPost;
use App\Models\User;

class JobPostPolicy
{
    public function viewAny(?User $user): bool
    {
        return true;
    }

    public function view(?User $user, JobPost $jobPost): bool
    {
        if ($jobPost->status === 'published') {
            return true;
        }

        if (!$user) {
            return false;
        }

        if ($user->isAdmin()) {
            return true;
        }

        return $user->isEmployer() && $user->employerProfile?->id === $jobPost->employer_id;
    }

    public function create(User $user): bool
    {
        return $user->isEmployer() || $user->isAdmin();
    }

    public function update(User $user, JobPost $jobPost): bool
    {
        return $user->isAdmin() || ($user->isEmployer() && $user->employerProfile?->id === $jobPost->employer_id);
    }

    public function delete(User $user, JobPost $jobPost): bool
    {
        return $user->isAdmin() || ($user->isEmployer() && $user->employerProfile?->id === $jobPost->employer_id);
    }

    public function moderate(User $user): bool
    {
        return $user->isAdmin();
    }
}
