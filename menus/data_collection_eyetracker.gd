extends Control
const DATA_FILE_PATH = "user://game_data.csv"
@onready var TTFFolder: TextEdit = $TTF/TTFFolder
@onready var TTFCalc: TextEdit = $TTF/TTFCalc
@onready var TTFPen: TextEdit = $TTF/TTFPen
@onready var TTFGlasses: TextEdit = $TTF/TTFGlasses
@onready var TTFToy: TextEdit = $TTF/TTFToy
@onready var TTFBook: TextEdit = $TTF/TTFBook
@onready var TTFRuler: TextEdit = $TTF/TTFRuler

@onready var TPTFolder: TextEdit = $Prev/TPTFolder
@onready var TPTCalc: TextEdit = $Prev/TPTCalc
@onready var TPTPen: TextEdit = $Prev/TPTPen
@onready var TPTGlasses: TextEdit = $Prev/TPTGlasses
@onready var TPTToy: TextEdit = $Prev/TPTToy
@onready var TPTBook: TextEdit = $Prev/TPTBook
@onready var TPTRuler: TextEdit = $Prev/TPTRuler

var session_id = ""
#
#var map_of_times_ET : Dictionary = {}
#
#var session_id = 0 # Unique ID for the current play session
#
#func _ready():
	## Initialize session ID when the game starts
	#session_id = PlayerData.player_name
	#map_of_times_ET["folder"] = TTFFolder.text + " " + TPTFolder.text
	#map_of_times_ET["calculator"] = TTFCalc.text + " " + TPTCalc.text
	#map_of_times_ET["pen"] = TTFPen.text + " " + TPTPen.text
	#map_of_times_ET["glasses"] = TTFGlasses.text + " " + TPTGlasses.text
	#map_of_times_ET["toy"] = TTFToy.text + " " + TPTToy.text
	#map_of_times_ET["book"] = TTFBook.text + " " + TPTBook.text
	#map_of_times_ET["ruler"] = TTFRuler.text + " " + TPTFolder.text
#
# Define the dictionary to hold the new data (Folder paths, etc.)
var map_of_times_ET: Dictionary = {}

func _ready():
	# 1. SETUP AND GATHER DATA
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	DirAccess.make_dir_recursive_absolute("user://")
	
	session_id = PlayerData.player_name
	
	# Sort keys for consistent order (kept as is)
	var keys: Array = PlayerData.map_of_times.keys()
	keys.sort()

func write_session_data_to_csv():
	# 1. OPEN FILE FOR APPENDING
	# Use FileAccess.WRITE to create the file if it doesn't exist, 
	# but the key is seeking to the end later.
	var file = FileAccess.open(DATA_FILE_PATH, FileAccess.WRITE) 
	
	if not file:
		print("Error: Could not open or create CSV file at:", DATA_FILE_PATH)
		return

	# 2. CHECK FOR HEADER (Only write header if file is brand new/empty)
	var is_new_file = file.get_length() == 0
	if is_new_file:
		# Define the header for the *entire* row of data
		# Order: Session ID, Metadata Keys..., Time Data Keys...
		var header_parts = [
			"Session_ID",
			"TTF_Calc", "TPT_Calc", 
			"TTF_Pen", "TPT_Pen", "TTF_Glasses", "TPT_Glasses",
			"TTF_Toy", "TPT_Toy", "TTF_Book", "TPT_Book", "TTF_Ruler", "TPT_Ruler",
			"Total_Time_s",
			"ET_TTF_Calc", "ET_TPT_Calc", 
			"ET_TTF_Pen", "ET_TPT_Pen", "ET_TTF_Glasses", "ET_TPT_Glasses",
			"ET_TTF_Toy", "ET_TPT_Toy", "ET_TTF_Book", "ET_TPT_Book", "ET_TTF_Ruler", "ET_TPT_Ruler",
			"ET_Total_Time_s",
			]
		file.store_line(header_parts.join(","))
		
	# 3. CONSTRUCT BASE METADATA ROW
	# These values are constant for the entire session and will be repeated
	var base_data_parts: Array = [
		session_id,
		TTFFolder.text, TPTFolder.text, TTFCalc.text, TPTCalc.text,
		TTFPen.text, TPTPen.text, TTFGlasses.text, TPTGlasses.text,
		TTFToy.text, TPTToy.text, TTFBook.text, TPTBook.text, TTFRuler.text, TPTRuler.text,
		str(PlayerData.total_time)
	]
	
	var base_row_string = ",".join(base_data_parts)
	
	# 4. GET AND SORT TIME KEYS
	var keys: Array = PlayerData.map_of_times.keys()
	keys.sort()
	
	# 5. APPEND DATA (Seek to the end before writing)
	file.seek_end()
	
	# Loop through the time data and write a new line for each object found
	for i in range(len(keys)):
		# Calculate time-specific data
		# NOTE: Using the raw time values here, create_new_time_label seems redundant for CSV
		var object_time_since_start = str("%12.3f"%PlayerData.map_of_times[keys[i]])
		var time_difference = get_time_diff(keys, i)
		
		# Construct the final CSV line: BASE METADATA + TIME DATA
		var final_line = base_row_string + "," + str(i + 1) + "," + object_time_since_start + "," + time_difference
		file.store_line(final_line)

	file.close()
	print("Session data successfully appended to:", DATA_FILE_PATH)

func get_time_diff(keys, i):
	if typeof(keys[i]) != TYPE_FLOAT and typeof(keys[i]) != TYPE_INT:
		return "N/A"
	if(i == 0):
		return str("%12.3f"%keys[i]) + "s"
	else:
		return  str("%12.3f"%(abs(keys[i-1] - keys[i]))) + "s"
		



func _on_button_pressed():
	map_of_times_ET["folder"] = TTFFolder.text + " " + TPTFolder.text
	map_of_times_ET["calculator"] = TTFCalc.text + " " + TPTCalc.text
	map_of_times_ET["pen"] = TTFPen.text + " " + TPTPen.text
	map_of_times_ET["glasses"] = TTFGlasses.text + " " + TPTGlasses.text
	map_of_times_ET["toy"] = TTFToy.text + " " + TPTToy.text
	map_of_times_ET["book"] = TTFBook.text + " " + TPTBook.text
	map_of_times_ET["ruler"] = TTFRuler.text + " " + TPTFolder.text
	
	
	
	get_tree().change_scene_to_file("res://menus/GameOverScreen.tscn")
