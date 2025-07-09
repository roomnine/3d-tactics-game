class_name Level
extends Node3D
## Tactics system initialization & turn_stage management.
##
## This is the Tactics Level's topmost script.[br][br]
## Dependencies: [TacticsBoard], [Tile], [Camera], [Controls], [Participants], [EnemyUnits], [PlayerUnits], [DefaultUnit]

#region: --- Props ---
## Level resource that handles the win condition
@export var res: LevelResource = load("res://data/models/world/combat/level/resources/test_level.tres")
## Camera resource for the tactics system
@export var camera: CameraResource = load("res://data/models/view/camera/camera.tres")
## Radius of the camera boundary
@export var camera_boundary_radius: float = 10.0
## UI control resource for the tactics system
@export var ui_control: ControlsResource = load("res://data/models/view/control/control.tres")
## Board layout for the level
@export var starting_layout: TileLayoutResource = load("res://data/models/world/combat/board/tiles/tile_layout/resources/test_layout.tres")

## Reference to the TileLayout node, handling tile layout
@onready var tile_layout: TileLayout = %TestTacticsBoard/TileLayout

## Service handling level-related operations
var serv: LevelService
#endregion

#region: --- Processing ---
func _ready() -> void:
	if not ui_control:
		push_error("Controls needs a ControlResource from /data/models/view/control/tactics/")
	if not camera:
		push_error("Camera needs a CameraResource from /data/models/view/camera/tactics/")
	
	# Initialize node references
	res.participant = $Participants
	res.player = $Participants/PlayerUnits
	res.enemy = $Participants/EnemyUnits
	res.board = $TestTacticsBoard
	
	tile_layout.import_layout(starting_layout)
	res.board.configure_tiles(tile_layout) # Configure board tiles
	res.participant.configure(camera, ui_control) # Configure participant with camera and UI control
	
	serv = LevelService.new(res)
	
	# Update camera boundary radius if necessary
	if camera.boundary_radius != camera_boundary_radius:
		camera.boundary_radius = camera_boundary_radius

## State machine for turns
func _physics_process(delta: float) -> void:
	match res.turn_stage:
		0: _init_turn() # Initialize turn
		1: _handle_turn(delta) # Handle ongoing turn
		2: _end_level() # Handle game ending
#endregion

#region: --- Methods ---
## Checks requirements to begin the first turn.[br]Used by [PlayerUnits], [EnemyUnits]
func _init_turn() -> void:
	if res.participant.is_configured(res.player) and res.participant.is_configured(res.enemy):
		res.turn_stage = 1 # Move to turn handling stage if both player and enemy are configured

## Turn state management.[br]Used by [PlayerUnits], [EnemyUnits]
func _handle_turn(delta: float) -> void:
	DebugLog.debug_nospam("player_can_act", res.participant.can_act(res.player))
	
	if res.participant.can_act(res.player):
		if not res.participant.is_configured(res.player):
			res.participant.configure(camera, ui_control) # Configure player if not already done
		res.participant.act(delta, true, res.player) # Player's turn to act
		
	elif res.participant.can_act(res.enemy):
		if not res.participant.is_configured(res.enemy):
			res.participant.configure(camera, ui_control) # Configure enemy if not already done
		res.participant.act(delta, false, res.enemy) # Enemy's turn to act
		
	else:
		if DebugLog.debug_enabled:
			print_rich("[color=green]0Oo◦° O-----------------------------------O °◦oO0[/color]")
			print_rich("[color=green]0Oo◦°[/color][color=red] >}=----->> [/color][color=yellow][ Turn reset! ][/color][color=red] <<-----={< [/color][color=green]°◦oO0[/color]")
			print_rich("[color=green]0Oo◦° O-----------------------------------O °◦oO0[/color]")
		res.player.reset_turn(res.player) # Reset player's turn
		res.enemy.reset_turn(res.enemy) # Reset enemy's turn
		
		_check_victory_tile_ownership()
		_check_level_end()


## Increments victory points for a player
func increment_victory_points(is_player: bool) -> void:
	serv.increment_victory_points(is_player)


## Checks how many victory tiles are occupied by player vs enemy.
## Increments player victory points by 1 if player controls more tiles and vice versa.
func _check_victory_tile_ownership() -> void:
	serv._check_victory_tile_ownership()

## Checks whether player or enemy has 3 points or no longer has any units left and ends the game if so
func _check_level_end() -> void:
	serv._check_level_end()


## Checks whether all units from a unit group are dead
func _is_all_dead(unit_group: Participants) -> bool:
	return serv._is_all_dead(unit_group)


## TODO: show level end (win/lose) screen
func _end_level() -> void:
	pass
#endregion
