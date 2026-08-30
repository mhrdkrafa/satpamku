<?php

namespace App\Policies;

use App\Models\CandidateDocument;
use App\Models\User;

class CandidateDocumentPolicy
{
    public function view(User $user, CandidateDocument $doc): bool
    {
        return $user->isAdmin() || $user->id === $doc->candidate->user_id || $user->isEmployer();
    }

    public function download(User $user, CandidateDocument $doc): bool
    {
        return $user->isAdmin() || $user->id === $doc->candidate->user_id || $user->isEmployer();
    }

    public function delete(User $user, CandidateDocument $doc): bool
    {
        return $user->isAdmin() || $user->id === $doc->candidate->user_id;
    }

    public function verify(User $user, CandidateDocument $doc): bool
    {
        return $user->isAdmin();
    }
}
