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
        Schema::create('candidate_documents', function (Blueprint $table) {
            $table->id();
            $table->foreignId('candidate_id')->constrained('candidate_profiles')->cascadeOnDelete();
            $table->string('type'); // cv, ktp, skck, surat_sehat, ijazah, other
            $table->string('title');
            $table->string('path');
            $table->unsignedInteger('file_size')->nullable(); // in bytes
            $table->string('mime_type')->nullable();
            $table->string('verification_status')->default('pending'); // pending, verified, rejected
            $table->text('rejection_reason')->nullable();
            $table->foreignId('verified_by')->nullable()->constrained('users')->nullOnDelete();
            $table->timestamp('verified_at')->nullable();
            $table->date('expires_at')->nullable();
            $table->timestamps();

            $table->index(['candidate_id', 'type']);
            $table->index('verification_status');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('candidate_documents');
    }
};
