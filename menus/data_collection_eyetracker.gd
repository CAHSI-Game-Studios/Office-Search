extends Control
const DATA_FILE_PATH = "user://data/game_data.csv"
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

@onready var eyetracker_time: TextEdit = $EyetrackerTime

var session_id = ""

# Define the dictionary to hold the new data (Folder paths, etc.)
var map_of_times_ET: Dictionary = {}
var inverted_player_map: Dictionary = {}
var inv_player_map_prev: Dictionary = {}

func _ready():
	# 1. SETUP AND GATHER DATA
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	DirAccess.make_dir_recursive_absolute("user://")
	
	session_id = PlayerData.player_name
	
	# Sort keys for consistent order (kept as is)
	var keys: Array = PlayerData.map_of_times.keys()
	keys.sort()
	
	for i in range(len(keys)):
		var obj = PlayerData.map_of_times[keys[i]]
		inverted_player_map[obj] = keys[i]
		print("Writing " + str(obj) + " " + str(keys[i]))
		
		if (i < 1):
			inv_player_map_prev[obj] = keys[i]
		else :
			inv_player_map_prev[obj] = keys[i] - keys[i-1]

		

#func write_session_data_to_csv():

	## 1. OPEN FILE FOR APPENDING
	## Use FileAccess.WRITE to create the file if it doesn't exist, 
	## but the key is seeking to the end later.
	#var file_exists = FileAccess.file_exists(DATA_FILE_PATH)
	#
	#var file = FileAccess.open(DATA_FILE_PATH, FileAccess.WRITE_READ) 
		#
	#print("Writing to " + DATA_FILE_PATH)
	#
	#if not file:
		#print("Error: Could not open/create CSV file at:", DATA_FILE_PATH)
		#return
	#
	## 2. CHECK FOR HEADER (Only write header if file is brand new/empty)
	#if not file_exists:
		## Define the header for the *entire* row of data
		## Order: Session ID, Metadata Keys..., Time Data Keys...
		#print("Did not find file")
		#var header_parts = [
			#"Session_ID",
			#"ET_TTF_Folder", "ET_TTF_Calc", "ET_TTF_Pen", "ET_TTF_Glasses",
			#"ET_TTF_Toy", "ET_TTF_Book", "ET_TTF_Ruler",
			#"ET_TPT_Folder", "ET_TPT_Calc", "ET_TPT_Pen", "ET_TPT_Glasses",
			#"ET_TPT_Toy", "ET_TPT_Book", "ET_TPT_Ruler",
			#"ET_Total_Time_s",
			#"TTF_Folder", "TTF_Calc", "TTF_Pen", "TTF_Glasses",
			#"TTF_Toy", "TTF_Book", "TTF_Ruler",
			#"TPT_Folder", "TPT_Calc", "TPT_Pen", "TPT_Glasses",
			#"TPT_Toy", "TPT_Book", "TPT_Ruler",
			#"Total_Time_s",
			#]
		#file.store_line(",".join(header_parts))
		#
	## 3. CONSTRUCT BASE METADATA ROW
	## These values are constant for the entire session and will be repeated
	#
	#var base_data_parts: Array = [
		#session_id,
		#inverted_player_map["Green Folder"], inverted_player_map["Calculator"],
		#inverted_player_map["Pen"], inverted_player_map["Sun Glasses"],
		#inverted_player_map["Toy"], inverted_player_map["White Book"],
		#inverted_player_map["Ruler"],
		#inv_player_map_prev["Green Folder"], inv_player_map_prev["Calculator"],
		#inv_player_map_prev["Pen"], inv_player_map_prev["Sun Glasses"],
		#inv_player_map_prev["Toy"], inv_player_map_prev["White Book"],
		#inv_player_map_prev["Ruler"],
		#eyetracker_time.text,
		#TTFFolder.text, TTFCalc.text, TTFPen.text,
		#TTFGlasses.text, TTFToy.text, TTFBook.text,
		#TTFRuler.text,
		#TPTFolder.text, TPTCalc.text, TPTPen.text,
		#TPTGlasses.text, TPTToy.text, TPTBook.text,
		#TPTRuler.text,
		#str(PlayerData.total_time)
	#]
	#
	#var base_row_string = ",".join(base_data_parts)
	#
	## 4. GET AND SORT TIME KEYS
	#var keys: Array = PlayerData.map_of_times.keys()
	#keys.sort()
	#
	## 5. APPEND DATA (Seek to the end before writing)
	#file.seek_end()
#
	#file.store_line(base_row_string)
	#file.close()
	#print("Session data successfully appended to:", DATA_FILE_PATH)
#
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
	
	
	write_session_data_to_csv()
	
	get_tree().change_scene_to_file("res://menus/GameOverScreen.tscn")


func write_session_data_to_csv():
	
	# 1. CHECK IF FILE EXISTS (MUST happen BEFORE opening)
	var file_exists = FileAccess.file_exists(DATA_FILE_PATH)
	
	var file: FileAccess # Declare the file variable here
	
	# Decide which mode to open with based on existence
	if file_exists:
		# File exists: Open for reading/writing, keeping content. Cursor starts at 0.
		file = FileAccess.open(DATA_FILE_PATH, FileAccess.READ_WRITE)
	else:
		# File does not exist: Open for writing (will create it). Cursor starts at 0.
		file = FileAccess.open(DATA_FILE_PATH, FileAccess.WRITE)
		
	if not file:
		print("Error: Could not open/create CSV file at:", DATA_FILE_PATH)
		return
		
	print("Writing to " + DATA_FILE_PATH)
	
	# 2. HEADER LOGIC
	# Only write header if the file did NOT exist before we opened it.
	if not file_exists:
		print("Did not find file, writing header")
		var header_parts = [
			 # ... your full header list ...
			"Session_ID", "ET_TTF_Folder", "ET_TTF_Calc", "ET_TTF_Pen", "ET_TTF_Glasses",
			"ET_TTF_Toy", "ET_TTF_Book", "ET_TTF_Ruler",
			"ET_TPT_Folder", "ET_TPT_Calc", "ET_TPT_Pen", "ET_TPT_Glasses",
			"ET_TPT_Toy", "ET_TPT_Book", "ET_TPT_Ruler",
			"ET_Total_Time_s",
			"TTF_Folder", "TTF_Calc", "TTF_Pen", "TTF_Glasses",
			"TTF_Toy", "TTF_Book", "TTF_Ruler",
			"TPT_Folder", "TPT_Calc", "TPT_Pen", "TPT_Glasses",
			"TPT_Toy", "TPT_Book", "TPT_Ruler",
            "Total_Time_s"
		]
		file.store_line(",".join(header_parts))
	
	# 3. CONSTRUCT BASE METADATA ROW (Kept as is)
	var base_data_parts: Array = [
		session_id,
		inverted_player_map["Green Folder"], inverted_player_map["Calculator"],
		inverted_player_map["Pen"], inverted_player_map["Sun Glasses"],
		inverted_player_map["Toy"], inverted_player_map["White Book"],
		inverted_player_map["Ruler"],
		inv_player_map_prev["Green Folder"], inv_player_map_prev["Calculator"],
		inv_player_map_prev["Pen"], inv_player_map_prev["Sun Glasses"],
		inv_player_map_prev["Toy"], inv_player_map_prev["White Book"],
		inv_player_map_prev["Ruler"],
		eyetracker_time.text,
		TTFFolder.text, TTFCalc.text, TTFPen.text,
		TTFGlasses.text, TTFToy.text, TTFBook.text,
		TTFRuler.text,
		TPTFolder.text, TPTCalc.text, TPTPen.text,
		TPTGlasses.text, TPTToy.text, TPTBook.text,
		TPTRuler.text,
		str(PlayerData.total_time)
	]
	
	var base_row_string = ",".join(base_data_parts)
	
	# 4. APPEND DATA
	# Move the cursor to the end of the file (after the header if new, or after the last line if existing)
	file.seek_end() 

	# 5. WRITE DATA
	file.store_line(base_row_string)
	file.close()
	print("Session data successfully appended to:", DATA_FILE_PATH)
