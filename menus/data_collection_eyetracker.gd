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

var map_of_times_ET : Dictionary = {}

# Define the order of your columns for the header
const CSV_HEADER = "SessionID,MapName,Timestamp,EventType,DataX,DataY"

var session_id = 0 # Unique ID for the current play session

func _ready():
	# Initialize session ID when the game starts
	session_id = PlayerData.player_name
	map_of_times_ET["folder"] = TTFFolder.text + " " + TPTFolder.text
	map_of_times_ET["calculator"] = TTFCalc.text + " " + TPTCalc.text
	map_of_times_ET["pen"] = TTFPen.text + " " + TPTPen.text
	map_of_times_ET["glasses"] = TTFGlasses.text + " " + TPTGlasses.text
	map_of_times_ET["toy"] = TTFToy.text + " " + TPTToy.text
	map_of_times_ET["book"] = TTFBook.text + " " + TPTBook.text
	map_of_times_ET["ruler"] = TTFRuler.text + " " + TPTRuler.text

func append_data_to_csv(timestamp, event_type, data_x, data_y):
	# 1. Format the data row
	var data_row = [
		str(session_id),
		str(timestamp),
		event_type,
		str(data_x),
		str(data_y)
	]
	var csv_line = data_row.join(",") + "\n"

	# 2. Check for File and Write Header
	var file = FileAccess.open(DATA_FILE_PATH, FileAccess.READ_WRITE)

	if not file:
		print("Error: Could not open file for reading and writing.")
		return

	# Check if the file is empty (i.e., new file or first write)
	if file.get_length() == 0:
		# Write the header row
		file.store_string(CSV_HEADER + "\n")

	# 3. Append Data
	# Move the file cursor to the end before writing
	file.seek_end() 
	file.store_string(csv_line)
	
	# FileAccess closes automatically when the variable goes out of scope,
	# but it's good practice to close explicitly if you might open/close rapidly.
	# file.close() 
	
	print("Appended data to CSV: " + csv_line.strip_suffix("\n"))
