<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\EntrenadorController;
use App\Http\Controllers\RutinaController;

// Carga la plantilla HTML que monta Vue
Route::get('/', function () {
    return view('welcome');
});

// Operaciones para Entrenadores
Route::get('/entrenadores', [EntrenadorController::class, 'index']);
Route::post('/entrenadores', [EntrenadorController::class, 'store']);
Route::put('/entrenadores/{id}', [EntrenadorController::class, 'update']);
Route::delete('/entrenadores/{id}', [EntrenadorController::class, 'destroy']);

// Operaciones para Rutinas (Módulo Nuevo)
Route::get('/rutinas', [RutinaController::class, 'index']);
Route::post('/rutinas', [RutinaController::class, 'store']);
Route::put('/rutinas/{id}', [RutinaController::class, 'update']);
Route::delete('/rutinas/{id}', [RutinaController::class, 'destroy']);