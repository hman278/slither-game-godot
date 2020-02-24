extends Spatial

"""
Controls slither body/scale and score management
"""

onready var body: PackedScene = preload("res://scenes/slither_body.tscn")
onready var gui: Control = $GUI

var bodies: Array = []

onready var head: KinematicBody = $slither_head_root
onready var camera: Camera = $camera

# initial default distance
onready var current_camera_distance: float = 15.0

# default scale
var current_slither_axis_scale: float = 0.5
# needed for camera distance calculation
var old_slither_axis_scale: float = 0.5

var size_increment: float = 0.0

onready var current_slither_scale: Vector3 = Vector3(0.5, 0.5, 0.5)

func _ready() -> void:
	head.get_node("head_area").connect("area_entered", self, "_on_head_area_entered")
	
	add_body()
	add_body()
	add_body()
	add_body()

func add_body() -> void:
	var body_new: KinematicBody = body.instance()
	add_child(body_new)
	if bodies.size() == 0:
		body_new.parent = head
	else:
		body_new.parent = bodies.back()
	bodies.append(body_new)
	
	if last_eaten_food != null:
		size_increment = last_eaten_food.get_node("food_mesh").scale.x / 100
		increase_slither_size(size_increment)
		change_camera_distance()
		print('current scale: ' + str(head.get_node("slither_head").scale))
		print('current camera distance: ' + str(current_camera_distance))

func change_slither_size(increment: float) -> void:
	old_slither_axis_scale = current_slither_axis_scale
	current_slither_axis_scale += increment
	current_slither_scale = Vector3(current_slither_axis_scale,
								current_slither_axis_scale,
								current_slither_axis_scale)
	# set scales
	head.get_node("head_area/area_collision").scale = current_slither_scale
	head.get_node("collision").scale = current_slither_scale
	head.get_node("slither_head").scale = current_slither_scale
	for body in bodies:
		body.get_node("collision").scale = current_slither_scale
		body.get_node("slither_body").scale = current_slither_scale
		body.get_node("body_area/area_collision").scale = current_slither_scale

func increase_slither_size(increment: float) -> void:
	change_slither_size(increment)

func change_camera_distance() -> void:
	current_camera_distance = (current_slither_axis_scale * current_camera_distance) / old_slither_axis_scale
	camera.global_transform.origin.y = current_camera_distance

var food_score: float = 0.0
var grow_score: int = 0
var last_eaten_food: Spatial = null
var score_increment: int = 0
func _on_head_area_entered(area) -> void:
	if area.name == "food_area":
		last_eaten_food = area.get_parent()
	
	score_increment = floor(last_eaten_food.get_node("food_mesh").scale.x * 10)
	
	#print('last eaten food axis scale: ' + str(last_eaten_food.get_node("food_mesh").scale.x))
	
	food_score += score_increment
	grow_score += score_increment
	
	#print("Food eaten for scaling: " + str(grow_score))
	if (grow_score >= 50):
		add_body()
		grow_score = 0

	last_eaten_food.queue_free()
	gui.get_node("HBoxContainer/VBoxContainer/MarginContainer/score_label").text = str("Score: " + str(food_score))
