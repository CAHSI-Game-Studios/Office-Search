extends Panel
class_name HeatMap
const worldSize : Vector2 = Vector2(5.2,5)

const MarkerScene : PackedScene = preload("res://ui/positionMarker.tscn")
func createMap(posi : Array[Vector3]) -> void:
	for pos in posi:
		var markerToAdd : PositionMarker =  MarkerScene.instantiate()
		markerToAdd._init(pos.z)
		var relativePos : Vector2 = Vector2(pos.x/worldSize.x,pos.y/worldSize.y)
		markerToAdd.position = relativePos * Vector2(240,240)
		$Points.add_child(markerToAdd)
func _ready() -> void:
	createMap([Vector3(1,1,1)])
