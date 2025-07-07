class_name ControlsSelectionService
extends RefCounted
## Service class for managing unit and tile selection in the Tactics game.

## Reference to the ParticipantsResource.
var participant: ParticipantsResource
## Reference to the BoardResource.
var board: BoardResource
## Reference to the ControlsResource.
var controls: ControlsResource
## Reference to the CameraResource.
var t_cam: CameraResource
## Reference to the ControlsInputService.
var input_service: ControlsInputService
## Reference to the last hovered tile.
var last_hovered_tile: Tile = null

## Initializes the TacticsControlsSelectionService with necessary resources and services.
func _init(_participant: ParticipantsResource, _board: BoardResource, _controls: ControlsResource, _t_cam: CameraResource, _input_service: ControlsInputService) -> void:
	participant = _participant
	board = _board
	controls = _controls
	t_cam = _t_cam
	input_service = _input_service


## Handles the selection of a unit.
func select_unit(player: PlayerUnits, control: TacticsControls) -> void:
	board.reset_all_tile_markers()
	if control.curr_unit:
		controls.set_actions_menu_visibility(false, participant.curr_unit)
		control.curr_unit.show_unit_stats(false)
	
	control.curr_unit = _select_hovered_unit(control)
	if not control.curr_unit:
		return
	else:
		control.curr_unit.show_unit_stats(true)
	
	if Input.is_action_just_pressed("ui_accept") and control.curr_unit.can_act():
		if control.curr_unit in player.get_children():
			t_cam.target = control.curr_unit
			participant.curr_unit = control.curr_unit
			controls.set_actions_menu_visibility(true, participant.curr_unit)
			participant.stage = 1


## Selects the unit currently hovered by the mouse.
func _select_hovered_unit(ctrl: TacticsControls) -> PhysicsBody3D:
	var unit: DefaultUnit = input_service.get_3d_canvas_mouse_position(2, ctrl)
	var tile: Tile = input_service.get_3d_canvas_mouse_position(1, ctrl) if not unit else unit.get_tile()
	board.mark_hover_tile(tile)
	return unit if unit else tile.get_tile_occupier() if tile else null


## Selects the tile currently hovered by the mouse.
func _select_hovered_tile(ctrl: TacticsControls) -> Tile:
	var unit: DefaultUnit = input_service.get_3d_canvas_mouse_position(2, ctrl)

	var hovered := input_service.get_3d_canvas_mouse_position(1, ctrl)
	var tile: Tile = null
	
	if hovered is Tile:
		tile = hovered
	elif unit:
		tile = unit.get_tile()

	board.mark_hover_tile(tile)
	return tile


## Updates the tile hovered by the mouse.
func update_hovered_tile(control: TacticsControls) -> void:
	var _t: Tile = _select_hovered_tile(control)
	if _t != last_hovered_tile:
		board.mark_hover_tile(_t)
		last_hovered_tile = _t


## Updates the preview path from the hovered tile
func update_path_preview(control: TacticsControls) -> void:
	var _t: Tile = _select_hovered_tile(control)
	board.mark_path_preview(_t)


## Handles the selection of a new location for the current unit.
func select_new_location(ctrl: TacticsControls) -> void:
	var tile: Tile = input_service.get_3d_canvas_mouse_position(1, ctrl)
	board.mark_hover_tile(tile)
	if Input.is_action_just_pressed("ui_accept") and tile and tile.is_reachable:
		ctrl.curr_unit.res.pathfinding_tilestack = board.get_pathfinding_tilestack(tile)
		t_cam.target = tile
		participant.stage = 4


## Handles the selection of a unit to attack.
func select_unit_to_attack(ctrl: TacticsControls) -> void:
	controls.set_actions_menu_visibility(true, participant.curr_unit)
	if participant.targetable_unit:
		controls.set_actions_menu_visibility(false, participant.targetable_unit)
		participant.targetable_unit.show_unit_stats(false)
	var tile: Tile = _select_hovered_tile(ctrl)
	participant.targetable_unit = tile.get_tile_occupier() if tile else null
	if participant.targetable_unit:
		controls.set_actions_menu_visibility(true, participant.targetable_unit)
		participant.targetable_unit.show_unit_stats(true)
	if Input.is_action_just_pressed("ui_accept") and tile and tile.is_targetable:
		t_cam.target = participant.targetable_unit
		participant.stage = 7


## Handles skill usage for a non-targeting skill. Highlights the cells within range of the skill.
func confirm_skill_usage(ctrl: TacticsControls) -> void:
	controls.set_actions_menu_visibility(true, participant.curr_unit)
	if not participant.selected_skill:
		push_warning("No skill selected!")
		return
	var skill = participant.selected_skill
	var unit = participant.curr_unit
	if not unit:
		push_warning("No current unit selected!")
		return
	# Clear old markers and highlight tiles in skill range
	board.reset_all_tile_markers()
	var tiles_in_range = unit.get_tile().get_tiles_in_radius(skill.area_radius)
	for t in tiles_in_range:
		t.is_targetable = true
	# If a tile within the area is selected, move to stage 11 and reset
	var tile: Tile = _select_hovered_tile(ctrl)
	if Input.is_action_just_pressed("ui_accept") and tile and tile.is_targetable:
		t_cam.target = participant.targetable_unit
		participant.stage = 11


##TODO: Handles the selection of a unit to use skill on. 
## Sets participant.targetable_unit so that it can be referenced to execute the effect in ParticipantsCombatService
func select_unit_to_use_skill_on(ctrl: TacticsControls) -> void:
	controls.set_actions_menu_visibility(true, participant.curr_unit)
	if participant.targetable_unit:
		controls.set_actions_menu_visibility(false, participant.targetable_unit)
		participant.targetable_unit.show_unit_stats(false)
	var tile: Tile = _select_hovered_tile(ctrl)
	participant.targetable_unit = tile.get_tile_occupier() if tile else null
	if participant.targetable_unit:
		controls.set_actions_menu_visibility(true, participant.targetable_unit)
		participant.targetable_unit.show_unit_stats(true)
	if Input.is_action_just_pressed("ui_accept") and tile and tile.is_targetable:
		t_cam.target = participant.targetable_unit
		participant.stage = 11


##TODO: Handles the selection of a tile to use skill on. 
## Sets participant.targetable_tile so that it can be referenced to execute the effect in ParticipantsCombatService
func select_tile_to_use_skill_on(ctrl: TacticsControls) -> void:
	controls.set_actions_menu_visibility(true, participant.curr_unit)
	if participant.targetable_unit:
		controls.set_actions_menu_visibility(false, participant.targetable_unit)
		participant.targetable_unit.show_unit_stats(false)
	var tile: Tile = _select_hovered_tile(ctrl)
	participant.targetable_unit = tile.get_tile_occupier() if tile else null
	if participant.targetable_unit:
		controls.set_actions_menu_visibility(true, participant.targetable_unit)
		participant.targetable_unit.show_unit_stats(true)
	if Input.is_action_just_pressed("ui_accept") and tile and tile.is_targetable:
		t_cam.target = participant.targetable_unit
		participant.stage = 11

## Handles the player's intention to move.
func player_wants_to_move() -> void:
	if participant.display_enemy_stats:
		participant.display_enemy_stats = false
	participant.stage = 2


## Handles the player's intention to cancel.
func player_wants_to_cancel() -> void:
	if participant.display_enemy_stats:
		participant.display_enemy_stats = false
	participant.stage = 1 if participant.stage > 1 else 0


## Handles the player's intention to use skill.
func player_wants_to_use_skill(skill: SkillResource) -> void:
	participant.selected_skill = skill
	print("Skill selected:", skill.name)
	match skill.skill_type:
		SkillResource.SkillType.NO_TARGET:
			participant.stage = 8
		SkillResource.SkillType.TARGET_UNIT:
			participant.stage = 9
		SkillResource.SkillType.TARGET_TILE:
			participant.stage = 10


## Handles the player's intention to end turn.
func player_wants_to_end_turn() -> void:
	if participant.display_enemy_stats:
		participant.display_enemy_stats = false
	participant.end_turn()


## Handles the player's intention to attack.
func player_wants_to_attack() -> void:
	participant.stage = 5
