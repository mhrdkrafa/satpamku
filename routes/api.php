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
});
