class_name Level
extends Node3D
## Tactics system initialization & turn_stage management.
##
## This is the Tactics Level's topmost script.[br][br]
## Dependencies: [TacticsBoard], [Tile], [Camera], [Controls], [Participants], [EnemyUnits], [PlayerUnits], [DefaultUnit]

#region: --- Props ---
## Camera resource for the tactics system
@export var camera: CameraResource = load("res://data/models/view/camera/camera.tres")
## Radius of the camera boundary
@export var camera_boundary_radius: float = 10.0
## UI control resource for the tactics system
@export var ui_control: ControlsResource = load("res://data/models/view/control/control.tres")
## Reference to the Participants node
var participant: Participants
## Reference to the PlayerUnits node
var player: PlayerUnits = null
## Reference to the EnemyUnits node
var enemy: EnemyUnits
## Reference to the TacticsBoard node
var board: TacticsBoard
## Current turn stage (0: init, 1: handle)
var turn_stage: int = 0
#endregion

#region: --- Processing ---
func _ready() -> void:
	if not ui_control:
		push_error("Controls needs a ControlResource from /data/models/view/control/tactics/")
	if not camera:
		push_error("Camera needs a CameraResource from /data/models/view/camera/tactics/")
	
	# Initialize node references
	participant = $Participants
	player = %PlayerUnits
	enemy = %EnemyUnits
	board = $TestTacticsBoard
	
	board.configure_tiles() # Configure board tiles
	participant.configure(camera, ui_control) # Configure participant with camera and UI control
	
	# Update camera boundary radius if necessary
	if camera.boundary_radius != camera_boundary_radius:
		camera.boundary_radius = camera_boundary_radius

## State machine for turns
func _physics_process(delta: float) -> void:
	match turn_stage:
		0: _init_turn() # Initialize turn
		1: _handle_turn(delta) # Handle ongoing turn
#endregion

#region: --- Methods ---
## Checks requirements to begin the first turn.[br]Used by [PlayerUnits], [EnemyUnits]
func _init_turn() -> void:
	if participant.is_configured(player) and participant.is_configured(enemy):
		turn_stage = 1 # Move to turn handling stage if both player and enemy are configured

## Turn state management.[br]Used by [PlayerUnits], [EnemyUnits]
func _handle_turn(delta: float) -> void:
	DebugLog.debug_nospam("player_can_act", participant.can_act(player))
	
	if participant.can_act(player):
		if not participant.is_configured(player):
			participant.configure(camera, ui_control) # Configure player if not already done
		participant.act(delta, true, player) # Player's turn to act
		
	elif participant.can_act(enemy):
		if not participant.is_configured(enemy):
			participant.configure(camera, ui_control) # Configure enemy if not already done
		participant.act(delta, false, enemy) # Enemy's turn to act
		
	else:
		if DebugLog.debug_enabled:
			print_rich("[color=green]0Oo◦° O-----------------------------------O °◦oO0[/color]")
			print_rich("[color=green]0Oo◦°[/color][color=red] >}=----->> [/color][color=yellow][ Turn reset! ][/color][color=red] <<-----={< [/color][color=green]°◦oO0[/color]")
			print_rich("[color=green]0Oo◦° O-----------------------------------O °◦oO0[/color]")
		player.reset_turn(player) # Reset player's turn
		enemy.reset_turn(enemy) # Reset enemy's turn
#endregion
