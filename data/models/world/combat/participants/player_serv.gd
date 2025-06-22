class_name PlayerService
extends RefCounted
## Service class for PlayerUnits

## Resource containing participant data and configurations
var res: ParticipantsResource
## Resource for camera-related data and configurations
var camera: CameraResource
## Resource for control-related data and configurations
var controls: ControlsResource
## Reference to the TacticsBoard node
var board: TacticsBoard


## Initializes the PlayerService
##
## @param _res: The ParticipantsResource to use
## @param _camera: The CameraResource to use
## @param _controls: The ControlsResource to use
## @param _board: The TacticsBoard node to use
func _init(_res: ParticipantsResource, _camera: CameraResource, _controls: ControlsResource, _board: TacticsBoard) -> void:
	res = _res
	camera = _camera
	controls = _controls
	board = board


## Toggles the display of enemy unit stats
##
## @param enemy_node: The enemy's node containing enemy units
func toggle_enemy_stats(enemy_node: Node) -> void:
	var enemy_units: Array = enemy_node.get_children()
	
	if res.display_opponent_stats:
		for p: DefaultUnit in enemy_units:
			p.res.unit_hud_enabled = true
			p.show_unit_stats(true)
	else:
		for p: DefaultUnit in enemy_units:
			if p.res.unit_hud_enabled == true:
				p.show_unit_stats(false)
				p.res.unit_hud_enabled = false


## Checks if all player pawns are properly configured
##
## @param player: The TacticsPlayer node to check
## @return: Whether all pawns are configured
func is_unit_configured(player: PlayerUnits) -> bool:
	for unit: DefaultUnit in player.get_children():
		if unit is DefaultUnit:
			if not unit.center():
				return false
	return true


## Displays available actions for the current unit
func show_available_unit_actions() -> void:
	controls.set_actions_menu_visibility(true, res.curr_unit)
	board.reset_all_tile_markers()
	board.mark_hover_tile(res.curr_unit.get_tile())


## Displays available movement options for the current unit
func show_available_movements() -> void:
	board.reset_all_tile_markers()
	
	var p: DefaultUnit = res.curr_unit
	if not p:
		return
	
	camera.target = p
	board.process_surrounding_tiles(p.get_tile(), int(p.stats.movement), p.get_parent().get_children())
	board.mark_reachable_tiles(p.get_tile(), p.stats.movement)
	res.stage = res.STAGE_SELECT_LOCATION


## Displays attackable targets for the current pawn
func display_attackable_targets() -> void:
	board.reset_all_tile_markers()
	var p: DefaultUnit = res.curr_unit
	if not p:
		return
	
	res.display_opponent_stats = true
	
	camera.target = p
	board.process_surrounding_tiles(p.get_tile(), float(p.stats.attack_range))
	board.mark_attackable_tiles(p.get_tile(), float(p.stats.attack_range))
	res.stage = res.STAGE_SELECT_ATTACK_TARGET


## Initiates the movement of the current unit
func move_unit() -> void:
	var p: DefaultUnit = res.curr_unit
	controls.set_actions_menu_visibility(false, p)
	if p.res.pathfinding_tilestack.is_empty():
		res.stage = res.STAGE_SELECT_UNIT if not p.can_act() else res.STAGE_SHOW_ACTIONS
