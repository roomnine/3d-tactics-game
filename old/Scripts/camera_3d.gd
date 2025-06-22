extends Camera3D
@onready var ray_cast_3d = $RayCast3D
@onready var hover_indicator: MeshInstance3D = $HoverIndicator

@export var character: CharacterBody3D

const TILE_SIZE = 1
var mouse_position: Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	mouse_position = get_viewport().get_mouse_position()
	ray_cast_3d.target_position = project_local_ray_normal(mouse_position) * 100
	ray_cast_3d.force_raycast_update()
	
	if ray_cast_3d.is_colliding():
		if "floor" and ray_cast_3d.get_collider().get_groups():
			var position: Vector3 = ray_cast_3d.get_collision_point()
			var snapped_position = position.snapped(Vector3.ONE * TILE_SIZE)
			hover_indicator.global_position = snapped_position + Vector3.UP * 0.01
			hover_indicator.visible = true
		else:
			hover_indicator.visible = false
	else:
		hover_indicator.visible = false
	
	if Input.is_action_just_pressed("click"):
		if ray_cast_3d.is_colliding() and "floor" and ray_cast_3d.get_collider().get_groups():
			var position: Vector3 = ray_cast_3d.get_collision_point()
			var snapped_position = position.snapped(Vector3.ONE * TILE_SIZE)
			character.move_character_click(snapped_position)
