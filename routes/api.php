<?php

use App\Http\Controllers\Api\V1\AuthController;
use App\Http\Controllers\Api\V1\ProfileController;
use Illuminate\Support\Facades\Route;

/*
|--------------------------------------------------------------------------
| API Routes — Satpamku API v1
|--------------------------------------------------------------------------
*/

Route::prefix('v1')->group(function () {
    // Authentication Endpoints (Public)
    Route::prefix('auth')->group(function () {
        Route::post('/register-candidate', [AuthController::class, 'registerCandidate']);
        Route::post('/register-employer', [AuthController::class, 'registerEmployer']);
        Route::post('/login', [AuthController::class, 'login']);

        // Authenticated Auth Endpoints
        Route::middleware('auth:sanctum')->group(function () {
            Route::get('/me', [AuthController::class, 'me']);
            Route::post('/logout', [AuthController::class, 'logout']);
            Route::put('/change-password', [AuthController::class, 'changePassword']);
        });
    });

    // Profile Endpoints (Protected)
    Route::middleware('auth:sanctum')->prefix('profile')->group(function () {
        Route::get('/candidate', [ProfileController::class, 'showCandidate']);
        Route::put('/candidate', [ProfileController::class, 'updateCandidate']);
        Route::get('/employer', [ProfileController::class, 'showEmployer']);
        Route::put('/employer', [ProfileController::class, 'updateEmployer']);
        Route::post('/avatar', [ProfileController::class, 'uploadAvatar']);
    });

    // Taxonomy Endpoints (Public)
    Route::prefix('taxonomy')->group(function () {
        Route::get('/locations', [\App\Http\Controllers\Api\V1\TaxonomyController::class, 'locations']);
        Route::get('/categories', [\App\Http\Controllers\Api\V1\TaxonomyController::class, 'categories']);
        Route::get('/positions', [\App\Http\Controllers\Api\V1\TaxonomyController::class, 'positions']);
        Route::get('/facilities', [\App\Http\Controllers\Api\V1\TaxonomyController::class, 'facilities']);
        Route::get('/skills', [\App\Http\Controllers\Api\V1\TaxonomyController::class, 'skills']);
        Route::get('/certifications', [\App\Http\Controllers\Api\V1\TaxonomyController::class, 'certifications']);
        Route::get('/all', [\App\Http\Controllers\Api\V1\TaxonomyController::class, 'all']);
    });

    // Candidate Domain Endpoints (Protected)
    Route::middleware('auth:sanctum')->prefix('candidate')->group(function () {
        // Experiences
        Route::get('/experiences', [\App\Http\Controllers\Api\V1\CandidateController::class, 'listExperiences']);
        Route::post('/experiences', [\App\Http\Controllers\Api\V1\CandidateController::class, 'storeExperience']);
        Route::put('/experiences/{experience}', [\App\Http\Controllers\Api\V1\CandidateController::class, 'updateExperience']);
        Route::delete('/experiences/{experience}', [\App\Http\Controllers\Api\V1\CandidateController::class, 'destroyExperience']);

        // Skills
        Route::get('/skills', [\App\Http\Controllers\Api\V1\CandidateController::class, 'listSkills']);
        Route::post('/skills/sync', [\App\Http\Controllers\Api\V1\CandidateController::class, 'syncSkills']);

        // Certifications
        Route::get('/certifications', [\App\Http\Controllers\Api\V1\CandidateController::class, 'listCertifications']);
        Route::post('/certifications', [\App\Http\Controllers\Api\V1\CandidateController::class, 'storeCertification']);
        Route::get('/certifications/{certification}/file', [\App\Http\Controllers\Api\V1\CandidateController::class, 'downloadCertificationFile']);
        Route::delete('/certifications/{certification}', [\App\Http\Controllers\Api\V1\CandidateController::class, 'destroyCertification']);

        // Documents (CV, KTP, SKCK, etc.)
        Route::get('/documents', [\App\Http\Controllers\Api\V1\CandidateController::class, 'listDocuments']);
        Route::post('/documents', [\App\Http\Controllers\Api\V1\CandidateController::class, 'storeDocument']);
        Route::get('/documents/{document}/file', [\App\Http\Controllers\Api\V1\CandidateController::class, 'downloadDocumentFile']);
        Route::delete('/documents/{document}', [\App\Http\Controllers\Api\V1\CandidateController::class, 'destroyDocument']);

        // Resume / Full CV view & Visibility
        Route::get('/resume/{user?}', [\App\Http\Controllers\Api\V1\CandidateController::class, 'showResume']);
        Route::put('/visibility', [\App\Http\Controllers\Api\V1\CandidateController::class, 'updateVisibility']);

        // Applications & Saved Jobs
        Route::get('/applications', [\App\Http\Controllers\Api\V1\JobApplicationController::class, 'listCandidateApplications']);
        Route::get('/applications/{application}', [\App\Http\Controllers\Api\V1\JobApplicationController::class, 'showApplication']);
        Route::post('/applications/{application}/withdraw', [\App\Http\Controllers\Api\V1\JobApplicationController::class, 'withdraw']);
        Route::get('/saved-jobs', [\App\Http\Controllers\Api\V1\JobApplicationController::class, 'listSavedJobs']);
    });

    // Public Job Discovery Endpoints
    Route::prefix('jobs')->group(function () {
        Route::get('/', [\App\Http\Controllers\Api\V1\JobController::class, 'index']);
        Route::get('/featured', [\App\Http\Controllers\Api\V1\JobController::class, 'featured']);
        Route::get('/urgent', [\App\Http\Controllers\Api\V1\JobController::class, 'urgent']);
        Route::get('/{slug}', [\App\Http\Controllers\Api\V1\JobController::class, 'show']);

        // Authenticated Job Actions (Apply & Save)
        Route::middleware('auth:sanctum')->group(function () {
            Route::post('/{job}/apply', [\App\Http\Controllers\Api\V1\JobApplicationController::class, 'apply']);
            Route::post('/{job}/save', [\App\Http\Controllers\Api\V1\JobApplicationController::class, 'toggleSaveJob']);
        });
    });

    // Employer Job & Applicant Management Endpoints (Protected)
    Route::middleware('auth:sanctum')->prefix('employer')->group(function () {
        Route::get('/dashboard', [\App\Http\Controllers\Api\V1\EmployerApplicantController::class, 'dashboard']);
        Route::get('/applicants', [\App\Http\Controllers\Api\V1\EmployerApplicantController::class, 'index']);
        Route::get('/applicants/{application}', [\App\Http\Controllers\Api\V1\EmployerApplicantController::class, 'show']);
        Route::put('/applicants/{application}/status', [\App\Http\Controllers\Api\V1\EmployerApplicantController::class, 'changeStatus']);

        Route::prefix('jobs')->group(function () {
            Route::get('/', [\App\Http\Controllers\Api\V1\EmployerJobController::class, 'index']);
            Route::post('/', [\App\Http\Controllers\Api\V1\EmployerJobController::class, 'store']);
            Route::get('/{job}', [\App\Http\Controllers\Api\V1\EmployerJobController::class, 'show']);
            Route::put('/{job}', [\App\Http\Controllers\Api\V1\EmployerJobController::class, 'update']);
            Route::put('/{job}/status', [\App\Http\Controllers\Api\V1\EmployerJobController::class, 'changeStatus']);
            Route::delete('/{job}', [\App\Http\Controllers\Api\V1\EmployerJobController::class, 'destroy']);
        });
    });

    // Notifications & Device Tokens (Protected)
    Route::middleware('auth:sanctum')->group(function () {
        Route::get('/notifications', [\App\Http\Controllers\Api\V1\NotificationController::class, 'index']);
        Route::put('/notifications/read-all', [\App\Http\Controllers\Api\V1\NotificationController::class, 'markAllAsRead']);
        Route::put('/notifications/{id}/read', [\App\Http\Controllers\Api\V1\NotificationController::class, 'markAsRead']);

        Route::post('/device-token', [\App\Http\Controllers\Api\V1\NotificationController::class, 'storeDeviceToken']);
        Route::delete('/device-token', [\App\Http\Controllers\Api\V1\NotificationController::class, 'destroyDeviceToken']);
    });
});
