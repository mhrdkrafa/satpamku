<?php

namespace App\Policies;

use App\Models\CandidateCertification;
use App\Models\User;

class CandidateCertificationPolicy
{
    public function view(User $user, CandidateCertification $cert): bool
    {
        return $user->isAdmin() || $user->id === $cert->candidate->user_id || $user->isEmployer();
    }

    public function download(User $user, CandidateCertification $cert): bool
    {
        return $user->isAdmin() || $user->id === $cert->candidate->user_id || $user->isEmployer();
    }

    public function delete(User $user, CandidateCertification $cert): bool
    {
        return $user->isAdmin() || $user->id === $cert->candidate->user_id;
    }

    public function verify(User $user, CandidateCertification $cert): bool
    {
        return $user->isAdmin();
    }
}
