class_name EnemyService
extends RefCounted
## Service class for EnemyUnits

## Resource containing participant data and configurations
var res: ParticipantsResource
## Resource for camera-related data and configurations
var camera: CameraResource
## Resource for control-related data and configurations
var controls: ControlsResource
## Reference to the TacticsBoard node
var board: TacticsBoard


## Initializes the EnemyService
##
## @param _res: The TacticsParticipantResource to use
## @param _camera: The TacticsCameraResource to use
## @param _controls: The TacticsControlsResource to use
## @param _board: The TacticsBoard node to use
func _init(_res: ParticipantsResource, _camera: CameraResource, _controls: ControlsResource, _board: TacticsBoard) -> void:
	res = _res
	camera = _camera
	controls = _controls
	board = _board


## Checks if all enemy units are properly configured
##
## @param enemy: The EnemyUnits node to check
## @return: Whether all units are configured
func is_unit_configured(enemy: EnemyUnits) -> bool:
	for unit: DefaultUnit in enemy.get_children():
		if not unit.center():
			return false
	return true


## Selects a unit for the enemy to control
##
## @param enemy: The EnemyUnits node
func choose_unit(enemy: EnemyUnits) -> void:
	board.reset_all_tile_markers()
	for p: DefaultUnit in enemy.get_children():
		if p.can_act() and p.is_alive():
			res.curr_unit = p
			res.stage = res.STAGE_SHOW_ACTIONS
			return


## Initiates the player's unit to chase the nearest enemy
##
## @param player: The PlayerUnits node
## @param player_node: The player's node
func chase_nearest_enemy() -> void:
	if res.curr_unit.res.can_move:
		board.reset_all_tile_markers()
		board.process_surrounding_tiles(res.curr_unit.get_tile(), res.curr_unit.stats.movement, res.allies_on_map.get_children(), res.enemies_on_map.get_children())
		board.mark_reachable_tiles(res.curr_unit.get_tile(), res.curr_unit.stats.movement)
		
		var to: Tile = board.get_nearest_target_adjacent_tile(res.curr_unit, res.enemies_on_map.get_children())
		res.curr_unit.res.pathfinding_tilestack = board.get_pathfinding_tilestack(to)
		camera.target = to
		if DebugLog.debug_enabled:
			print_rich("[color=orange]", res.curr_unit, " moving to [i]", to, "[/i][/color]")
			print_rich("[color=orange]Through: [i]", res.curr_unit.res.pathfinding_tilestack, "[/i][/color]")
			print_rich("[color=cyan]Camera target updated to destination tile.[/color]")
		res.stage = res.STAGE_SHOW_MOVEMENTS
	else:
		res.stage = res.STAGE_SELECT_UNIT
		push_error("Tried to make a unit that cannot move chase nearest enemy: ", res.curr_unit)


## Checks if the enemy's unit has finished moving
func is_unit_done_moving() -> void:
	if res.curr_unit.res.pathfinding_tilestack.is_empty():
		if DebugLog.debug_enabled:
			print_rich("[color=orange]Unit is done moving.[/color]")
		res.stage = res.STAGE_SELECT_LOCATION


## Selects a unit for the enemy to attack
func choose_unit_to_attack() -> void:
	board.reset_all_tile_markers()
	board.process_surrounding_tiles(res.curr_unit.get_tile(), res.curr_unit.stats.attack_range, res.allies_on_map.get_children(), res.enemies_on_map.get_children())
	board.mark_targetable_tiles(res.curr_unit.get_tile(), res.curr_unit.stats.attack_range)
	
	res.targetable_unit = board.get_weakest_targetable_unit(res.enemies_on_map.get_children())
	if res.targetable_unit:
		if DebugLog.debug_enabled:
			print_rich("[color=orange]Weakest target detected:", res.targetable_unit, "[/color]")
		controls.set_actions_menu_visibility(true, res.targetable_unit)
		camera.target = res.targetable_unit
	else:
		if DebugLog.debug_enabled:
			print_rich("[color=orange]No target detected.[/color]")
		
	res.stage = res.STAGE_MOVE_UNIT
