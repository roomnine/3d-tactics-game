class_name ParticipantsCombatService
extends RefCounted
## Service for handling participant combat
##
## Parent: [ParticipantService]

## Resource containing participant data and config
var res: ParticipantsResource
## Resource for camera-related data and config
var camera: CameraResource
## Resource for control-related data and config
var controls: ControlsResource


## Initializes ParticipantsCombatService
func _init(_res: ParticipantsResource, _camera: CameraResource, _controls: ControlsResource) -> void:
	res = _res
	camera = _camera
	controls = _controls


## Handles basic attack action of a unit
func basic_attack(is_player: bool) -> void:
	print(res.targetable_unit)
	# Handle case when no targetable unit is available
	if not res.targetable_unit:
		res.curr_unit.res.can_attack = false
	else:
		# Attempt to attack target unit
		if not res.curr_unit.basic_attack(res.targetable_unit):
			return
		# Hide actions menu and focus camera on attacking unit
		controls.set_actions_menu_visibility(false, res.targetable_unit)
		camera.target = res.curr_unit
	
	# Reset targetable unit
	res.targetable_unit = null
	# Reset enemy stats display
	if res.display_enemy_stats:
		res.display_enemy_stats = false

	# Determine next stage based on current unit's ability to act and whether it's a player's unit
	if not res.curr_unit.can_act() or not is_player:
		res.stage = res.STAGE_SELECT_UNIT
	elif res.curr_unit.can_act() and is_player:
		res.stage = res.STAGE_SHOW_ACTIONS


##Handles skill action of a unit (the effect)
func use_skill(is_player: bool) -> void:
	if res.selected_skill == null:
		push_error("[CombatService] No skill selected!")
		return

	# Determine which target to pass
	var target_unit = res.targetable_unit if res.selected_skill.skill_type == SkillResource.SkillType.TARGET_UNIT else null
	var target_tile = res.targetable_tile if res.selected_skill.skill_type == SkillResource.SkillType.TARGET_TILE else null
	var targetable_units: Array[DefaultUnit] = []
	var targetable_tiles: Array[Tile] = []
	
	# 🟢 Compute targetable tiles if skill has no target
	if res.selected_skill.skill_type == SkillResource.SkillType.NO_TARGET:
		targetable_tiles = res.curr_unit.get_tile().get_tiles_in_radius(res.selected_skill.area_radius)

	# 🟢 Collect units from targetable tiles
	if targetable_tiles.size() > 0:
		for tile in targetable_tiles:
			var unit = tile.get_tile_occupier()
			if unit and unit is DefaultUnit and unit.is_alive():
				targetable_units.append(unit)
	
	# Execute the skill via the unit's combat service
	res.curr_unit.serv.combat.use_skill(res.curr_unit, res.selected_skill, targetable_units, targetable_tiles)

	# Hide UI and reset
	controls.set_actions_menu_visibility(false, res.curr_unit)
	camera.target = res.curr_unit
	res.targetable_unit = null
	res.targetable_tile = null
	if res.display_enemy_stats:
		res.display_enemy_stats = false
	if not res.curr_unit.can_act() or not is_player:
		res.stage = res.STAGE_SELECT_UNIT
	else:
		res.stage = res.STAGE_SHOW_ACTIONS
