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
        Schema::create('certifications', function (Blueprint $table) {
            $table->id();
            $table->string('name');
            $table->string('slug')->unique();
            $table->string('issuing_body'); // Polda Metro Jaya, Mabes Polri, BNSP, Kemnaker, PMI
            $table->text('description')->nullable();
            $table->string('level')->default('specialized'); // pratama, madya, utama, specialized
            $table->boolean('is_active')->default(true);
            $table->timestamps();

            $table->index(['level', 'is_active']);
            $table->index('is_active');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('certifications');
    }
};
