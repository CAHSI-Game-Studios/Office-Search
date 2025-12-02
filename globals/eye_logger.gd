# globals/eye_logger.gd
extends Node

# ---------------------------------------------------
# CONFIGURACIÓN
# ---------------------------------------------------
var min_fixation_duration := 0.15 # en segundos, duración mínima para fijación
var objects_AOI := {} # Diccionario de objetos de interés: {"object_name": Rect2(...)}

# ---------------------------------------------------
# DATOS
# ---------------------------------------------------
var recording := false
var samples := [] # muestras crudas de gaze
var logs := []    # fijaciones/overlooks finales
var current_object := null
var buffer := []  # buffer temporal para calcular fijaciones

# ---------------------------------------------------
# INICIO / FIN GRABACIÓN
# ---------------------------------------------------
func start_recording():
	samples.clear()
	logs.clear()
	buffer.clear()
	current_object = null
	recording = true
	print("Eye tracking started!")

func stop_recording():
	recording = false
	# Guardar la última fijación si hay
	_process_buffer(final=true)
	save_to_csv()
	print("Eye tracking stopped!")

# ---------------------------------------------------
# RECIBIR NUEVA MUESTRA
# ---------------------------------------------------
func record_sample(gaze: Vector2, timestamp: float):
	if not recording:
		return

	# Guardar muestra cruda
	samples.append({"time": timestamp, "x": gaze.x, "y": gaze.y})

	# Determinar si la mirada está sobre algún objeto
	var looked_object := null
	for name in objects_AOI.keys():
		if objects_AOI[name].has_point(gaze):
			looked_object = name
			break

	# Procesar fijación previa si cambiamos de objeto
	if current_object != looked_object:
		_process_buffer()
		current_object = looked_object
		buffer.clear()

	# Agregar al buffer si hay un objeto
	if looked_object != null:
		buffer.append({"time": timestamp, "x": gaze.x, "y": gaze.y})

# ---------------------------------------------------
# PROCESAR BUFFER PARA CALCULAR FIJACIÓN
# ---------------------------------------------------
func _process_buffer(final=false):
	if buffer.size() == 0:
		return
	if current_object == null:
		buffer.clear()
		return

	var start_time = buffer[0]["time"]
	var end_time = buffer[buffer.size() - 1]["time"]
	var duration = end_time - start_time
	var fixation_type = "fixation" if duration >= min_fixation_duration else "non-fixation"

	logs.append({
		"object": current_object,
		"fixation_type": fixation_type,
		"start_time": start_time,
		"end_time": end_time,
		"duration": duration
	})

	buffer.clear()

# ---------------------------------------------------
# GUARDAR CSV
# ---------------------------------------------------
func save_to_csv():
	var file = File.new()
	file.open("user://eye_tracking.csv", File.WRITE)
	file.store_line("object,fixation_type,start_time,end_time,duration")
	for l in logs:
		file.store_line("%s,%s,%f,%f,%f" % [l["object"], l["fixation_type"], l["start_time"], l["end_time"], l["duration"]])
	file.close()
	print("Eye tracking data saved to CSV")
