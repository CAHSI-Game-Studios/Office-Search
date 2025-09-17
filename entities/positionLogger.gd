extends Node3D
class_name PositionLogger

@export var pRef : Player
@onready var origin: Marker3D = $origin
@onready var frequency: Timer = $frequency
# Called when the node enters the scene tree for the first time.
var positions : Array[Vector3] # (posX, posY, rotY)


func _ready() -> void:
	$frequency.start()
func _on_frequency_timeout() -> void:
	logPosition()
func logPosition() -> void:
	positions.append(Vector3
		(
			abs(origin.global_position.x-pRef.global_position.x),
			abs(origin.global_position.z-pRef.global_position.z),
			pRef.getNeck().global_rotation.y
		)
	)
