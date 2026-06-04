<?php

namespace App\Http\Controllers;

use App\Models\Rutina;
use Illuminate\Http\Request;

class RutinaController extends Controller
{
    // Listar todas las rutinas con su entrenador asignado
    public function index()
    {
        return Rutina::with('entrenador')->orderBy('id', 'desc')->get();
    }

    // Guardar una nueva rutina con imagen
    public function store(Request $request)
    {
        $request->validate([
            'entrenador_id' => 'required|exists:entrenadores,id',
            'nombre'        => 'required|string|max:255',
            'nivel'         => 'required|string',
            'descripcion'   => 'required|string',
            'imagen'        => 'nullable|image|mimes:jpeg,png,jpg,gif|max:2048' // Validación de imagen real
        ]);

        $data = $request->only(['entrenador_id', 'nombre', 'nivel', 'descripcion']);

        // Si el usuario subió una imagen, la guardamos en la carpeta pública
        if ($request->hasFile('imagen')) {
            $file = $request->file('imagen');
            $filename = time() . '_' . $file->getClientOriginalName();
            $file->move(public_path('uploads'), $filename); 
            $data['imagen'] = '/uploads/' . $filename;
        }

        $rutina = Rutina::create($data);

        return response()->json($rutina->load('entrenador'));
    }

    // Actualizar una rutina existente (incluyendo su imagen)
    public function update(Request $request, $id)
    {
        $request->validate([
            'entrenador_id' => 'required|exists:entrenadores,id',
            'nombre'        => 'required|string|max:255',
            'nivel'         => 'required|string',
            'descripcion'   => 'required|string',
            'imagen'        => 'nullable'
        ]);

        $rutina = Rutina::findOrFail($id);
        $data = $request->only(['entrenador_id', 'nombre', 'nivel', 'descripcion']);

        // Si se sube una nueva imagen para reemplazar la anterior
        if ($request->hasFile('imagen')) {
            // Borramos la foto vieja para no acumular basura en el servidor
            if ($rutina->imagen && file_exists(public_path($rutina->imagen))) {
                @unlink(public_path($rutina->imagen));
            }

            $file = $request->file('imagen');
            $filename = time() . '_' . $file->getClientOriginalName();
            $file->move(public_path('uploads'), $filename);
            $data['imagen'] = '/uploads/' . $filename;
        }

        $rutina->update($data);

        return response()->json($rutina->load('entrenador'));
    }

    // Eliminar la rutina y su foto
    public function destroy($id)
    {
        $rutina = Rutina::findOrFail($id);
        
        if ($rutina->imagen && file_exists(public_path($rutina->imagen))) {
            @unlink(public_path($rutina->imagen));
        }

        $rutina->delete();

        return response()->json(['mensaje' => 'Rutina eliminada correctamente']);
    }
}