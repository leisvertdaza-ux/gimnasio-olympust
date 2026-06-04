<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Entrenador extends Model
{
    protected $table = 'entrenadores';
    protected $fillable = [
        'nombres',
        'especialidad'
    ];

    public function rutinas()
    {
        return $this->hasMany(Rutina::class);
    }
}
