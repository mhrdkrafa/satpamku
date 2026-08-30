<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('job_post_facilities', function (Blueprint $table) {
            $table->id();
            $table->foreignId('job_post_id')->constrained('job_posts')->cascadeOnDelete();
            $table->foreignId('facility_id')->constrained('facilities')->cascadeOnDelete();

            $table->unique(['job_post_id', 'facility_id']);
        });

        Schema::create('job_post_skills', function (Blueprint $table) {
            $table->id();
            $table->foreignId('job_post_id')->constrained('job_posts')->cascadeOnDelete();
            $table->foreignId('skill_id')->constrained('skills')->cascadeOnDelete();

            $table->unique(['job_post_id', 'skill_id']);
        });

        Schema::create('job_post_certifications', function (Blueprint $table) {
            $table->id();
            $table->foreignId('job_post_id')->constrained('job_posts')->cascadeOnDelete();
            $table->foreignId('certification_id')->constrained('certifications')->cascadeOnDelete();
            $table->boolean('is_mandatory')->default(true);

            $table->unique(['job_post_id', 'certification_id']);
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('job_post_certifications');
        Schema::dropIfExists('job_post_skills');
        Schema::dropIfExists('job_post_facilities');
    }
};
