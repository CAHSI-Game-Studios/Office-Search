extends Marker3D
class_name FindableObjectSpawner

# Save a reference to all findable objects.

@onready var cup = preload("res://world/findable/findable_cup.tscn")
#@onready var example = preload("res://world/findable/findable_{class_name}.tscn")

# Boolean to keep track if this specific instance has already spawned an object.

@onready var hasSpawned : bool = false


# All instances will have a default validItem of {cup}, to avoid null instances.
@export var validItems : Array

# DOCUMENTATION CHART. PLEASE ADD OBJECT CLASS NAME AND STRING NAME.
#	OBJECT-----STRING NAME
#	Example Class 	"example"
#	Findable Cup	"cup"


#There is probably a better way of instantiating objects, but for simplicity (and readability)
# lets stick to simple if statements.

func spawn(objectName : String):
	var objectToBeSpawned
	if (objectName == "cup"):
		objectToBeSpawned = cup.instantiate()
	if (objectName == "example"):
		#objectToBeSpawned = example.instantiate()
		pass
	self.add_child(objectToBeSpawned)
	hasSpawned = true
func getHasSpawned():
	return hasSpawned
func getValidItems():
	return validItems
