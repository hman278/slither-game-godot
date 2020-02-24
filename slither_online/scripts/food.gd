extends Spatial

const GROW_SPEED: float = 2.0

onready var max_size: float = rand_range(0.1, 0.5)

var target_scale: Vector3 = Vector3() # end scale of the object
var initial_scale: Vector3 = Vector3(1, 1, 1)

onready var self_mesh: MeshInstance = $food_mesh
onready var self_collision: CollisionShape = $food_area/collision
onready var food_area: Area = $food_area

var new_material: Material

func _ready() -> void:
	randomize()
	new_material = SpatialMaterial.new()
	new_material.albedo_color = Color(
		rand_range(0, 1), rand_range(0, 1), rand_range(0, 1)
	)
	
	self_mesh.set_surface_material(0, new_material)
	
	# set initial scale (just in case)
	self_mesh.scale = initial_scale
	self_collision.scale = initial_scale
	
	target_scale = Vector3(max_size, max_size, max_size)

# decrease the size
# needs to stop when is close to its final size
func _physics_process(delta: float) -> void:
	self_mesh.scale = lerp(self_mesh.scale, target_scale, delta * GROW_SPEED)
	self_collision.scale = lerp(self_collision.scale, target_scale, delta * GROW_SPEED)

