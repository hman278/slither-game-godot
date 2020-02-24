extends Node

"""
Handles spawning food
"""

onready var food: PackedScene = preload("res://scenes/food.tscn")

var food_timer: Timer

onready var food_spawn_extents: Vector3 = $ground.scale

func init_food_spawn_timer() -> void:
	food_timer = Timer.new()
	add_child(food_timer)
	food_timer.connect("timeout", self, "_on_food_timer_timeout")
	food_timer.autostart = true
	food_timer.one_shot = false
	food_timer.wait_time = 0.2
	food_timer.start()

func _ready() -> void:
	init_food_spawn_timer()

# spawn food
func _on_food_timer_timeout() -> void:
	randomize()
	food_timer.wait_time = rand_range(0.2, 0.3)
	
	var food_new: Spatial = food.instance()
	$food_root.add_child(food_new)

	food_new.global_transform.origin = Vector3(rand_range(-food_spawn_extents.x, food_spawn_extents.x),
												2.0,
												rand_range(-food_spawn_extents.z, food_spawn_extents.z))
