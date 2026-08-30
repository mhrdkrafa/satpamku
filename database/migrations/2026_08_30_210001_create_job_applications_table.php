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
        Schema::create('job_applications', function (Blueprint $table) {
            $table->id();
            $table->foreignId('job_post_id')->constrained('job_posts')->cascadeOnDelete();
            $table->foreignId('candidate_id')->constrained('candidate_profiles')->cascadeOnDelete();
            $table->text('cover_letter')->nullable();
            $table->string('resume_snapshot_path')->nullable();
            $table->string('status')->default('submitted'); // submitted, reviewing, shortlisted, interview_scheduled, accepted, rejected, withdrawn
            $table->dateTime('interview_at')->nullable();
            $table->string('interview_location')->nullable();
            $table->text('rejection_reason')->nullable();
            $table->text('employer_notes')->nullable();
            $table->timestamp('applied_at')->useCurrent();
            $table->timestamps();
            $table->softDeletes();

            $table->unique(['job_post_id', 'candidate_id']);
            $table->index(['candidate_id', 'status']);
            $table->index(['job_post_id', 'status']);
            $table->index('applied_at');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('job_applications');
    }
};
