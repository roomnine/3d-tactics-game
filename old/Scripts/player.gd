extends CharacterBody3D

const SPEED = 5.0

@onready var navigation_agent_3d: NavigationAgent3D = $NavigationAgent3D

var direction: Vector3
var next_position: Vector3

func _physics_process(delta: float) -> void:
	
	navigation_agent_3d.target_position = next_position
	
	direction = navigation_agent_3d.get_next_path_position() - global_position
	
	velocity = direction.normalized() * SPEED
	move_and_slide()

func move_character_click(position: Vector3) -> void:
	next_position = position
