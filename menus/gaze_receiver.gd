extends Node

func update_gaze(screen_pos: Vector2):
	var ts = Time.get_unix_time_from_system()
	EyeLogger.record_sample(screen_pos, ts)
