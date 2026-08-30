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
        Schema::create('job_posts', function (Blueprint $table) {
            $table->id();
            $table->foreignId('employer_id')->constrained('employer_profiles')->cascadeOnDelete();
            $table->foreignId('category_id')->constrained('job_categories')->cascadeOnDelete();
            $table->foreignId('position_id')->nullable()->constrained('job_positions')->nullOnDelete();
            $table->foreignId('location_id')->constrained('locations')->cascadeOnDelete();
            $table->string('title');
            $table->string('slug')->unique();
            $table->text('description');
            $table->text('requirements')->nullable();
            $table->text('responsibilities')->nullable();
            $table->string('shift_type')->default('2_shift'); // full_time, part_time, 2_shift, 3_shift, event, temporary
            $table->string('placement_address')->nullable();
            $table->unsignedInteger('salary_min')->nullable();
            $table->unsignedInteger('salary_max')->nullable();
            $table->boolean('salary_is_hidden')->default(false);
            $table->unsignedSmallInteger('experience_years_min')->default(0);
            $table->unsignedSmallInteger('min_height_cm')->nullable();
            $table->unsignedSmallInteger('min_weight_kg')->nullable();
            $table->string('required_certificate_level')->default('none'); // none, gada_pratama, gada_madya, gada_utama
            $table->boolean('requires_sim')->default(false);
            $table->json('required_sim_types')->nullable(); // ["A", "C", "B1"]
            $table->boolean('is_urgent')->default(false);
            $table->boolean('is_featured')->default(false);
            $table->string('status')->default('draft'); // draft, review, published, paused, closed, rejected
            $table->text('rejection_reason')->nullable();
            $table->timestamp('published_at')->nullable();
            $table->date('expires_at')->nullable();
            $table->text('moderation_notes')->nullable();
            $table->foreignId('moderated_by')->nullable()->constrained('users')->nullOnDelete();
            $table->timestamp('moderated_at')->nullable();
            $table->unsignedInteger('views_count')->default(0);
            $table->unsignedInteger('applications_count')->default(0);
            $table->timestamps();
            $table->softDeletes();

            $table->index(['status', 'published_at']);
            $table->index(['category_id', 'status']);
            $table->index(['location_id', 'status']);
            $table->index('is_urgent');
            $table->index('is_featured');
            $table->index('salary_min');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('job_posts');
    }
};
