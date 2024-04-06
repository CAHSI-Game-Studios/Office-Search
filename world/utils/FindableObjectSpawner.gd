extends Node3D
# Findable object spawner does not function by itself. {FindableObjectLocation} must be set as
# a child of this object. When adding new objects to spawn, make sure the naming convention stays 
# consistent. 

# Declare and export the array that will hold all objects to be spawned.

@export var objectsToBeSpawned : Array

#Array can have duplicates, example {cup,cup,cup}. Given enough spawnpoints, this will spawn three cups.

# DOCUMENTATION CHART. PLEASE ADD OBJECT CLASS NAME AND STRING NAME.
#	OBJECT-----STRING NAME
#	Findable Cup	"cup"



func _ready():
	# Iterate through array.
	for object in objectsToBeSpawned:
		# Useful counters.
		var maxCount : int = get_child_count()
		var spawnerCount : int = 0
		# Valid boolean that determiens if there is an available spawnpoint.
		var foundValidSpawner : bool = true
		var spawnpointIndex : int = randi_range(0, get_child_count()-1)
		var selectedSpawnpoint = get_child(spawnpointIndex)
		#Find a spawnpoint that has item in its valid item list and has not already spawned an item.
		while (selectedSpawnpoint.getHasSpawned() == true || !(object in selectedSpawnpoint.getValidItems())):
			#Base case assuming we run out of spawners.
			if maxCount == spawnerCount:
				foundValidSpawner = false
			# Linear probe.
			spawnpointIndex = spawnpointIndex + 1
			if (spawnpointIndex == objectsToBeSpawned.size()):
				spawnpointIndex = 0
			selectedSpawnpoint = get_child(spawnpointIndex)
			spawnerCount = spawnerCount +1
		if (foundValidSpawner):
			selectedSpawnpoint.spawn(object)
