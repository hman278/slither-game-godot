extends KinematicBody

"""
Controls the head of the slither
"""

const RAY_LENGTH: float = 1000.0
const SLITHER_SPEED: float = 5.0

var rotation_speed: float = 2.0

onready var parent: Spatial = get_parent()

func _physics_process(delta: float) -> void:
	var result: Dictionary = get_mouse_raycast_result(get_viewport().get_mouse_position(), 1)
	if result:
		var direction = result.position - parent.head.global_transform.origin
		var target_pos = result.position
		
		var new_transform = transform.looking_at((target_pos + direction), Vector3.UP)
		
		var new_rotation = Quat(new_transform.basis)
		
		var self_rotation = Quat(transform.basis)
		
		var lerp_rotation = self_rotation.slerp(new_rotation, delta * rotation_speed)
		
		var final_rotation = Basis(lerp_rotation)
		
		transform.basis = final_rotation
		
		self.rotation.x = 0
		self.rotation.z = 0
		
	move_and_slide(-global_transform.basis.z * SLITHER_SPEED)

func get_mouse_raycast_result(mouse_pos: Vector2, collision_mask: int) -> Dictionary:
	var ray_start: Vector3 = parent.camera.project_ray_origin(mouse_pos)
	var ray_end: Vector3 = ray_start + parent.camera.project_ray_normal(mouse_pos) * RAY_LENGTH
	var space_state: PhysicsDirectSpaceState = get_world().direct_space_state
	return space_state.intersect_ray(ray_start, ray_end, [], collision_mask)
