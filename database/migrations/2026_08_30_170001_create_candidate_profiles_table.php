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
        Schema::create('candidate_profiles', function (Blueprint $table) {
            $table->id();
            $table->foreignId('user_id')->constrained()->cascadeOnDelete();
            $table->string('headline')->nullable();
            $table->text('summary')->nullable();
            $table->unsignedBigInteger('preferred_city_id')->nullable();
            $table->string('preferred_city')->nullable();
            $table->string('preferred_shift')->nullable(); // pagi, malam, 2_shift, 3_shift, rolling, any
            $table->string('preferred_employment_type')->nullable(); // full_time, contract, event, daily
            $table->unsignedBigInteger('salary_min')->nullable();
            $table->unsignedBigInteger('salary_max')->nullable();
            $table->unsignedSmallInteger('height_cm')->nullable();
            $table->unsignedSmallInteger('weight_kg')->nullable();
            $table->boolean('has_sim')->default(false);
            $table->json('sim_types')->nullable();
            $table->date('available_from')->nullable();
            $table->unsignedTinyInteger('years_experience')->default(0);
            $table->string('highest_certificate_level')->default('none'); // none, gada_pratama, gada_madya, gada_utama
            $table->string('verification_status')->default('unverified'); // unverified, pending, verified, rejected
            $table->unsignedTinyInteger('profile_completion')->default(20);
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('candidate_profiles');
    }
};
