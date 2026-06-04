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
    Schema::create('rutinas', function (Blueprint $table) {
        $table->id();

        $table->foreignId('entrenador_id')
              ->constrained('entrenadores')
              ->cascadeOnDelete();

        $table->string('nombre');
        $table->string('nivel');
        $table->text('descripcion');
        $table->string('imagen')->nullable();

        $table->timestamps();
    });
}

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('rutinas');
    }
};
