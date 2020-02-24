extends KinematicBody

""" 
Controls individual slither body part movement
"""

var parent: KinematicBody = null

func follow_parent() -> void:
	self.global_transform.origin = lerp(self.global_transform.origin, 
		parent.global_transform.origin, get_physics_process_delta_time() * 8.0)
	self.rotation_degrees = lerp(self.rotation_degrees, 
		parent.rotation_degrees, get_physics_process_delta_time() * 5.0)

func _physics_process(delta: float) -> void:
	follow_parent()
