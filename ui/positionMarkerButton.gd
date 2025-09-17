extends TextureButton
class_name PositionMarker




var rot : float = 0.0
func _ready() -> void:
	$Line2D.visible = false
	$Line2D.rotation = rot
# Called when the node enters the scene tree for the first time.
func _init(angle : float = 0.0) -> void:
	rot = angle
func _on_mouse_entered() -> void:
	$Line2D.visible = true
	modulate.b = 0
func _on_mouse_exited() -> void:
	$Line2D.visible = false
	modulate.b = 255
