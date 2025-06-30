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
	# Handle case when no attackable unit is available
	if not res.attackable_unit:
		res.curr_unit.res.can_attack = false
	else:
		# Attempt to attack target unit
		if not res.curr_unit.basic_attack(res.attackable_unit):
			return
		# Hide actions menu and focus camera on attacking unit
		controls.set_actions_menu_visibility(false, res.attackable_unit)
		camera.target = res.curr_unit
	
	# Reset attackable unit
	res.attackable_unit = null
	# Reset enemy stats display
	if res.display_enemy_stats:
		res.display_enemy_stats = false

	# Determine next stage based on current unit's ability to act and whether it's a player's unit
	if not res.curr_unit.can_act() or not is_player:
		res.stage = res.STAGE_SELECT_UNIT
	elif res.curr_unit.can_act() and is_player:
		res.stage = res.STAGE_SHOW_ACTIONS
