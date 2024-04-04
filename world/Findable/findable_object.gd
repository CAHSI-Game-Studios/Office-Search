class_name Findable_Object
extends Node3D

var particles: GPUParticles3D
# Called when the node enters the scene tree for the first time.
func _ready():
	var scene = load("res://world/Findable/findable_particles.tscn")
	var particles = scene.instantiate()
	self.add_child(particles)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func consume():
	pass
	
