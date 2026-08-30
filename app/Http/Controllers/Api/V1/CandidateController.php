<?php

namespace App\Http\Controllers\Api\V1;

use App\Http\Controllers\Controller;
use App\Http\Requests\Candidate\StoreCandidateCertificationRequest;
use App\Http\Requests\Candidate\StoreCandidateDocumentRequest;
use App\Http\Requests\Candidate\StoreExperienceRequest;
use App\Http\Requests\Candidate\SyncCandidateSkillsRequest;
use App\Http\Requests\Candidate\UpdateExperienceRequest;
use App\Http\Requests\Candidate\UpdateProfileVisibilityRequest;
use App\Http\Resources\Api\V1\Candidate\CandidateCertificationResource;
use App\Http\Resources\Api\V1\Candidate\CandidateDocumentResource;
use App\Http\Resources\Api\V1\Candidate\CandidateResumeResource;
use App\Http\Resources\Api\V1\Candidate\CandidateSkillResource;
use App\Http\Resources\Api\V1\Candidate\ExperienceResource;
use App\Models\CandidateCertification;
use App\Models\CandidateDocument;
use App\Models\CandidateProfile;
use App\Models\Experience;
use App\Models\User;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Gate;
use Illuminate\Support\Facades\Storage;
use Symfony\Component\HttpFoundation\StreamedResponse;

class CandidateController extends Controller
{
    private function getCandidateProfile(Request $request): CandidateProfile
    {
        $user = $request->user();
        return $user->candidateProfile ?? $user->candidateProfile()->create(['user_id' => $user->id]);
    }

    // ==========================================
    // EXPERIENCES
    // ==========================================

    public function listExperiences(Request $request): JsonResponse
    {
        $profile = $this->getCandidateProfile($request);
        $experiences = $profile->experiences;

        return response()->json([
            'success' => true,
            'data' => ExperienceResource::collection($experiences),
        ]);
    }

    public function storeExperience(StoreExperienceRequest $request): JsonResponse
    {
        $profile = $this->getCandidateProfile($request);
        $experience = $profile->experiences()->create($request->validated());

        $profile->recalculateProfileCompletion();

        return response()->json([
            'success' => true,
            'message' => 'Pengalaman kerja berhasil ditambahkan.',
            'data' => new ExperienceResource($experience),
        ], 201);
    }

    public function updateExperience(UpdateExperienceRequest $request, Experience $experience): JsonResponse
    {
        Gate::authorize('update', $experience);

        $experience->update($request->validated());
        $experience->candidate->recalculateProfileCompletion();

        return response()->json([
            'success' => true,
            'message' => 'Pengalaman kerja berhasil diperbarui.',
            'data' => new ExperienceResource($experience),
        ]);
    }

    public function destroyExperience(Experience $experience): JsonResponse
    {
        Gate::authorize('delete', $experience);

        $profile = $experience->candidate;
        $experience->delete();
        $profile->recalculateProfileCompletion();

        return response()->json([
            'success' => true,
            'message' => 'Pengalaman kerja berhasil dihapus.',
        ]);
    }

    // ==========================================
    // SKILLS
    // ==========================================

    public function listSkills(Request $request): JsonResponse
    {
        $profile = $this->getCandidateProfile($request);

        return response()->json([
            'success' => true,
            'data' => CandidateSkillResource::collection($profile->skills),
        ]);
    }

    public function syncSkills(SyncCandidateSkillsRequest $request): JsonResponse
    {
        $profile = $this->getCandidateProfile($request);

        $syncData = [];
        foreach ($request->input('skills', []) as $item) {
            $syncData[$item['skill_id']] = ['level' => $item['level'] ?? 'intermediate'];
        }

        $profile->skills()->sync($syncData);
        $profile->recalculateProfileCompletion();

        return response()->json([
            'success' => true,
            'message' => 'Keahlian satpam berhasil disimpan.',
            'data' => CandidateSkillResource::collection($profile->fresh()->skills),
        ]);
    }

    // ==========================================
    // CERTIFICATIONS
    // ==========================================

    public function listCertifications(Request $request): JsonResponse
    {
        $profile = $this->getCandidateProfile($request);
        $certs = $profile->certifications()->with('certification')->get();

        return response()->json([
            'success' => true,
            'data' => CandidateCertificationResource::collection($certs),
        ]);
    }

    public function storeCertification(StoreCandidateCertificationRequest $request): JsonResponse
    {
        $profile = $this->getCandidateProfile($request);
        $file = $request->file('document');

        // Store privately
        $path = $file->store('certifications', 'private_documents');

        $cert = $profile->certifications()->create([
            'certification_id' => $request->input('certification_id'),
            'certificate_number' => $request->input('certificate_number'),
            'issued_at' => $request->input('issued_at'),
            'expires_at' => $request->input('expires_at'),
            'document_path' => $path,
            'verification_status' => 'pending',
        ]);

        $profile->recalculateProfileCompletion();

        return response()->json([
            'success' => true,
            'message' => 'Sertifikat berhasil diunggah dan menunggu verifikasi admin.',
            'data' => new CandidateCertificationResource($cert->load('certification')),
        ], 201);
    }

    public function downloadCertificationFile(Request $request, CandidateCertification $certification): StreamedResponse|JsonResponse
    {
        Gate::authorize('download', $certification);

        if (!Storage::disk('private_documents')->exists($certification->document_path)) {
            return response()->json([
                'success' => false,
                'message' => 'File sertifikat tidak ditemukan di server.',
            ], 404);
        }

        return Storage::disk('private_documents')->response($certification->document_path);
    }

    public function destroyCertification(CandidateCertification $certification): JsonResponse
    {
        Gate::authorize('delete', $certification);

        if (Storage::disk('private_documents')->exists($certification->document_path)) {
            Storage::disk('private_documents')->delete($certification->document_path);
        }

        $profile = $certification->candidate;
        $certification->delete();
        $profile->recalculateProfileCompletion();

        return response()->json([
            'success' => true,
            'message' => 'Sertifikat berhasil dihapus.',
        ]);
    }

    // ==========================================
    // DOCUMENTS
    // ==========================================

    public function listDocuments(Request $request): JsonResponse
    {
        $profile = $this->getCandidateProfile($request);

        return response()->json([
            'success' => true,
            'data' => CandidateDocumentResource::collection($profile->documents),
        ]);
    }

    public function storeDocument(StoreCandidateDocumentRequest $request): JsonResponse
    {
        $profile = $this->getCandidateProfile($request);
        $file = $request->file('document');

        $path = $file->store('documents', 'private_documents');

        $doc = $profile->documents()->create([
            'type' => $request->input('type'),
            'title' => $request->input('title'),
            'path' => $path,
            'file_size' => $file->getSize(),
            'mime_type' => $file->getClientMimeType(),
            'expires_at' => $request->input('expires_at'),
            'verification_status' => 'pending',
        ]);

        $profile->recalculateProfileCompletion();

        return response()->json([
            'success' => true,
            'message' => 'Dokumen berhasil diunggah.',
            'data' => new CandidateDocumentResource($doc),
        ], 201);
    }

    public function downloadDocumentFile(Request $request, CandidateDocument $document): StreamedResponse|JsonResponse
    {
        Gate::authorize('download', $document);

        if (!Storage::disk('private_documents')->exists($document->path)) {
            return response()->json([
                'success' => false,
                'message' => 'File dokumen tidak ditemukan di server.',
            ], 404);
        }

        return Storage::disk('private_documents')->response($document->path);
    }

    public function destroyDocument(CandidateDocument $document): JsonResponse
    {
        Gate::authorize('delete', $document);

        if (Storage::disk('private_documents')->exists($document->path)) {
            Storage::disk('private_documents')->delete($document->path);
        }

        $profile = $document->candidate;
        $document->delete();
        $profile->recalculateProfileCompletion();

        return response()->json([
            'success' => true,
            'message' => 'Dokumen berhasil dihapus.',
        ]);
    }

    // ==========================================
    // RESUME & VISIBILITY
    // ==========================================

    public function showResume(Request $request, ?User $user = null): JsonResponse
    {
        $targetUser = $user ?? $request->user();

        if (!$targetUser->isCandidate()) {
            return response()->json([
                'success' => false,
                'message' => 'User bukan kandidat satpam.',
            ], 404);
        }

        // Authorization check for visibility
        if ($user && $user->id !== $request->user()->id && !$request->user()->isAdmin()) {
            $visibility = $targetUser->profile?->profile_visibility ?? 'employers_only';

            if ($visibility === 'private') {
                return response()->json([
                    'success' => false,
                    'message' => 'Profil kandidat bersifat privat.',
                ], 403);
            }

            if ($visibility === 'employers_only' && !$request->user()->isEmployer()) {
                return response()->json([
                    'success' => false,
                    'message' => 'Profil hanya dapat dilihat oleh akun perusahaan terverifikasi.',
                ], 403);
            }
        }

        $targetUser->load([
            'profile',
            'candidateProfile.experiences',
            'candidateProfile.skills',
            'candidateProfile.certifications.certification',
            'candidateProfile.documents',
        ]);

        return response()->json([
            'success' => true,
            'data' => new CandidateResumeResource($targetUser),
        ]);
    }

    public function updateVisibility(UpdateProfileVisibilityRequest $request): JsonResponse
    {
        $user = $request->user();
        $user->profile()->updateOrCreate(
            ['user_id' => $user->id],
            ['profile_visibility' => $request->input('profile_visibility')]
        );

        return response()->json([
            'success' => true,
            'message' => 'Visibilitas profil berhasil diperbarui.',
            'data' => [
                'profile_visibility' => $request->input('profile_visibility'),
            ],
        ]);
    }
}
