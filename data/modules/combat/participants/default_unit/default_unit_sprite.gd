class_name DefaultUnitSprite
extends MeshInstance3D
## Handles the visual representation and animation of a unit in the tactics game

## TODO: Animation state machine playback controller
#var animator: AnimationNodeStateMachinePlayback = null
## TODO: Current frame of the sprite animation
#var curr_frame: int = 0

## TODO: Reference to the AnimationTree node
#@onready var animation_tree: AnimationTree = $AnimationTree
## Reference to the Label3D node displaying the unit's name
@onready var character_ui_name_label: Label3D = $CharacterUI/NameLabel


## Sets up the unit sprite with the given stats and status
##
## @param stats: The Stats resource containing unit data
## @param status: The unit's status (class or type)
func setup(stats: Stats, status: String) -> void:
	#var playback: AnimationNodeStateMachinePlayback = animation_tree["parameters/playback"]
	#if playback is AnimationNodeStateMachinePlayback:
		#animator = playback
	#else:
		#push_error("Expected AnimationNodeStateMachinePlayback, but got " + str(typeof(playback)))
		#return
	#
	#animator.start("IDLE")
	#animation_tree.active = true
	#mesh = load(stats.sprite) as Mesh
	character_ui_name_label.text = stats.override_name if stats.override_name else status


## TODO: Starts the appropriate animation based on the unit's movement and state
##
## @param move_direction: The direction the unit is moving in
## @param is_jumping: Whether the unit is currently jumping
#func start_animator(move_direction: Vector3, is_jumping: bool) -> void:
	#if move_direction == Vector3.ZERO:
		#animator.travel("IDLE")
	#elif is_jumping:
		#animator.travel("JUMP")


## Adjusts the unit's position to the center of its current tile
##
## @param unit: The unit to adjust
## @return: Whether the adjustment was successful
func adjust_to_center(unit: DefaultUnit) -> bool:
	if unit.get_tile() and not unit.res.is_moving:
		unit.global_position = unit.get_tile().global_position
		return true
	return false
