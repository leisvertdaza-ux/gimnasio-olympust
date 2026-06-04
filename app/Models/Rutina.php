<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Rutina extends Model
{
    protected $fillable = [
        'entrenador_id',
        'nombre',
        'nivel',
        'descripcion',
        'imagen'
    ];

    public function entrenador()
    {
        return $this->belongsTo(Entrenador::class);
    }
}