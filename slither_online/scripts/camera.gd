extends Camera

onready var parent: Spatial = get_parent()

# follow one global player
func _physics_process(delta: float) -> void:
	self.global_transform.origin = lerp(self.global_transform.origin, get_parent().head.global_transform.origin, delta)
	self.global_transform.origin.y = parent.current_camera_distance
