<template>
    <div class="gym-container">
        <header class="gym-header">
            <div class="logo-area">
                <span class="icon">🏋️‍♂️</span>
                <h1>Olympus <span class="highlight">Rutinas</span></h1>
            </div>
            <p class="subtitle">Asignación y Planificación de Entrenamientos</p>
        </header>

        <main class="gym-content">
            <section class="card form-card">
                <h2>
                    <span class="action-icon">{{ rutinaId ? '📝' : '➕' }}</span>
                    {{ rutinaId ? 'Modificar Rutina' : 'Nueva Rutina' }}
                </h2>
                
                <div class="form-group">
                    <label>Nombre del Entrenador</label>
                    <input 
                        v-model="entrenador_id" 
                        type="text" 
                        placeholder="Ej. Leisvert Daza, Carlos Ramírez" 
                        class="gym-input"
                    >
                </div>

                <div class="form-group">
                    <label>Nombre de la Rutina</label>
                    <input v-model="nombre" type="text" placeholder="Ej. Hipertrofia Piernas" class="gym-input">
                </div>

                <div class="form-group">
                    <label>Nivel de Exigencia</label>
                    <select v-model="nivel" class="gym-input">
                        <option value="" disabled selected>Seleccione el nivel...</option>
                        <option value="Principiante">🟢 Principiante</option>
                        <option value="Intermedio">🟡 Intermedio</option>
                        <option value="Avanzado">🔴 Avanzado</option>
                    </select>
                </div>

                <div class="form-group">
                    <label>Descripción / Ejercicios</label>
                    <textarea v-model="descripcion" placeholder="Ej. 4 series de 12 repeticiones..." class="gym-input gym-textarea" rows="3"></textarea>
                </div>

                <div class="form-group">
                    <label>Imagen de la Rutina (Foto Guía)</label>
                    <input type="file" @change="seleccionarImagen" accept="image/*" class="gym-input">
                </div>

                <div class="form-actions">
                    <button @click="guardarRutina" class="btn btn-primary">
                        {{ rutinaId ? 'Actualizar Rutina' : 'Publicar Rutina' }}
                    </button>
                    <button v-if="rutinaId" @click="cancelarEdicion" class="btn btn-secondary">
                        Cancelar
                    </button>
                </div>
            </section>

            <section class="card table-card">
                <h2>📋 Programas de Entrenamiento Activos</h2>
                <div class="table-responsive">
                    <table class="gym-table">
                        <thead>
                            <tr>
                                <th>Foto</th> 
                                <th>Rutina</th>
                                <th>Coach Responsable</th>
                                <th>Nivel</th>
                                <th>Descripción</th>
                                <th class="text-center">Gestión</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr v-if="rutinas.length === 0">
                                <td colspan="6" class="text-center no-data">No hay rutinas asignadas.</td>
                            </tr>
                            <tr v-for="rutina in rutinas" :key="rutina.id">
                                <td>
                                    <img v-if="rutina.imagen" :src="rutina.imagen" alt="Rutina" style="width: 50px; height: 50px; object-fit: cover; border-radius: 6px; border: 1px solid #3b4256;">
                                    <span v-else style="color: #64748b; font-style: italic; font-size: 0.85rem;">Sin foto</span>
                                </td>
                                <td class="name-cell">{{ rutina.nombre }}</td>
                                <td>
                                    <span class="coach-text">👤 {{ rutina.entrenador_id }}</span>
                                </td>
                                <td>
                                    <span :class="['badge-nivel', rutina.nivel.toLowerCase()]">{{ rutina.nivel }}</span>
                                </td>
                                <td class="desc-cell" :title="rutina.descripcion">{{ rutina.descripcion }}</td>
                                <td class="text-center actions-cell">
                                    <button @click="editar(rutina)" class="btn-icon btn-edit">✏️</button>
                                    <button @click="eliminar(rutina.id)" class="btn-icon btn-delete">🗑️</button>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </section>
        </main>
    </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import axios from 'axios'

const rutinas = ref([])

const rutinaId = ref(null)
const entrenador_id = ref('')
const nombre = ref('')
const nivel = ref('')
const descripcion = ref('')
const imagenArchivo = ref(null)

const seleccionarImagen = (event) => {
    imagenArchivo.value = event.target.files[0]
}

const cargarRutinas = async () => {
    try {
        const response = await axios.get('/rutinas')
        rutinas.value = response.data
    } catch (error) { console.error(error) }
}

const guardarRutina = async () => {
    if (!entrenador_id.value.trim() || !nombre.value.trim() || !nivel.value || !descripcion.value.trim()) {
        alert('Por favor, completa todos los campos del formulario.')
        return
    }

    const formData = new FormData()
    formData.append('entrenador_id', entrenador_id.value)
    formData.append('nombre', nombre.value)
    formData.append('nivel', nivel.value)
    formData.append('descripcion', descripcion.value)
    
    if (imagenArchivo.value) {
        formData.append('imagen', imagenArchivo.value)
    }

    try {
        if (rutinaId.value) {
            formData.append('_method', 'PUT')
            await axios.post(`/rutinas/${rutinaId.value}`, formData, {
                headers: { 'Content-Type': 'multipart/form-data' }
            })
        } else {
            await axios.post('/rutinas', formData, {
                headers: { 'Content-Type': 'multipart/form-data' }
            })
        }
        limpiarFormulario()
        cargarRutinas()
    } catch (error) {
        alert("Error al procesar la rutina con la imagen.")
    }
}

const eliminar = async (id) => {
    if (!confirm("¿Deseas eliminar esta rutina?")) return
    try {
        await axios.delete(`/rutinas/${id}`)
        cargarRutinas()
    } catch (error) { console.error(error) }
}

const editar = (rutina) => {
    rutinaId.value = rutina.id
    entrenador_id.value = rutina.entrenador_id
    nombre.value = rutina.nombre
    nivel.value = rutina.nivel
    descripcion.value = rutina.descripcion
}

const cancelarEdicion = () => { limpiarFormulario() }

const limpiarFormulario = () => {
    rutinaId.value = null
    entrenador_id.value = ''
    nombre.value = ''
    nivel.value = ''
    descripcion.value = ''
    imagenArchivo.value = null
    const fileInput = document.querySelector('input[type="file"]')
    if (fileInput) fileInput.value = ''
}

onMounted(() => {
    cargarRutinas()
})
</script>

<style scoped>
.gym-container { background-color: #12141c; color: #e2e8f0; min-height: 100vh; padding: 30px; font-family: sans-serif; }
.gym-header { text-align: center; margin-bottom: 40px; border-bottom: 1px solid #232936; padding-bottom: 20px; }
.logo-area { display: flex; justify-content: center; align-items: center; gap: 12px; }
.gym-header h1 { font-size: 2.5rem; font-weight: 800; margin: 0; color: #ffffff; }
.gym-header .highlight { color: #00ff87; }
.subtitle { color: #94a3b8; margin-top: 5px; }
.gym-content { display: grid; grid-template-columns: 1fr; gap: 30px; max-width: 1400px; margin: 0 auto; }
@media (min-width: 950px) { .gym-content { grid-template-columns: 380px 1fr; } }
.card { background: #1e2230; border-radius: 12px; padding: 25px; box-shadow: 0 10px 25px rgba(0, 0, 0, 0.3); border: 1px solid #2d3548; }
.card h2 { font-size: 1.3rem; color: #ffffff; margin-top: 0; margin-bottom: 25px; display: flex; align-items: center; gap: 10px; }
.form-group { margin-bottom: 18px; }
.form-group label { display: block; font-size: 0.85rem; color: #94a3b8; margin-bottom: 8px; text-transform: uppercase; }
.gym-input { width: 100%; padding: 12px 15px; background-color: #12141c; border: 1px solid #3b4256; border-radius: 6px; color: #ffffff; font-size: 0.95rem; box-sizing: border-box; }
.gym-input:focus { outline: none; border-color: #00ff87; }
.gym-textarea { resize: vertical; font-family: inherit; }
.form-actions { display: flex; flex-direction: column; gap: 10px; margin-top: 25px; }
.btn { padding: 12px; font-weight: 600; border-radius: 6px; cursor: pointer; border: none; }
.btn-primary { background-color: #00ff87; color: #0b0c10; }
.btn-secondary { background-color: #3b4256; color: #ffffff; }
.table-responsive { overflow-x: auto; }
.gym-table { width: 100%; border-collapse: collapse; }
.gym-table th { background-color: #12141c; color: #94a3b8; font-size: 0.85rem; text-transform: uppercase; padding: 15px; border-bottom: 2px solid #2d3548; text-align: left; }
.gym-table td { padding: 15px; border-bottom: 1px solid #2d3548; }
.name-cell { font-weight: 600; color: #ffffff; }
.coach-text { color: #38bdf8; font-weight: 500; }
.desc-cell { max-width: 200px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; color: #94a3b8; }
.badge-nivel { padding: 4px 10px; border-radius: 12px; font-size: 0.8rem; font-weight: bold; }
.badge-nivel.principiante { background: rgba(34, 197, 94, 0.15); color: #22c55e; }
.badge-nivel.intermedio { background: rgba(234, 179, 8, 0.15); color: #eab308; }
.badge-nivel.avanzado { background: rgba(239, 68, 68, 0.15); color: #ef4444; }
.actions-cell { display: flex; gap: 6px; justify-content: center; }
.btn-icon { padding: 6px 10px; border-radius: 4px; border: none; cursor: pointer; }
.btn-edit { background-color: rgba(234, 179, 8, 0.15); color: #eab308; }
.btn-delete { background-color: rgba(239, 68, 68, 0.15); color: #ef4444; }
.text-center { text-align: center; }
.no-data { color: #64748b; font-style: italic; padding: 30px !important; }
</style>