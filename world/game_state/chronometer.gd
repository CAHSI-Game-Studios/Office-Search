extends Control

@onready var label = $Label

var time = 0
var timer_on = false

func _process(delta):
	if timer_on:
		time += delta
		label.text = str(time)
	var secs = fmod(time,60)
	var mins = fmod(time,60*60)/60
	
	var time_passed = "%02d : %02d" % [mins,secs]
	label.text = time_passed

func game_completed():
	desactive_timer()
	
func activate_timer():
	timer_on = true

func desactive_timer():
	timer_on = false
