class_name Findable_Object
extends Node3D

signal object_consumed

var particles: GPUParticles3D
# Called when the node enters the scene tree for the first time.
func _ready():
	var scene = load("res://world/findable/findable_particles.tscn")
	particles = scene.instantiate()
	self.add_child(particles)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("test"):
		consume()

func consume():
	hide_children()
	particles.emitting = true
	object_consumed.emit()
	get_tree().create_timer(3).connect("timeout",Callable(self,"queue_free"))
	
func hide_children():
	for index in self.get_child_count():
		var children = self.get_child(index)
		if not (children is GPUParticles3D):
			children.hide()

