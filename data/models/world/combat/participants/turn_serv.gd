class_name ParticipantsTurnService
extends RefCounted
## Service class for handling turn-related actions
## 
## Parent: [TacticsParticipantService]

## Resource containing participant data and configurations
var res: ParticipantsResource
## Resource for camera-related data and configurations
var camera: CameraResource
## Resource for control-related data and configurations
var controls: ControlsResource


## Initializes the ParticipantsTurnService
##
## @param _res: The ParticipantsResource to use
## @param _camera: The CameraResource to use
## @param _controls: The ControlsResource to use
func _init(_res: ParticipantsResource, _camera: CameraResource, _controls: ControlsResource) -> void:
	res = _res
	camera = _camera
	controls = _controls


## Handles the player's turn
##
## @param delta: Time elapsed since the last frame
## @param player: The PlayerUnits node
## @param participant: The Participants node
func handle_player_turn(delta: float, player: PlayerUnits, participant: Participants) -> void:
	if res.turn_just_started:
		camera.target = player.get_children().front()
		res.turn_just_started = false
	
	controls.move_camera(delta)
	controls.set_actions_menu_visibility(res.stage in [res.STAGE_SHOW_ACTIONS, res.STAGE_SHOW_MOVEMENTS, res.STAGE_SELECT_LOCATION, res.STAGE_DISPLAY_TARGETS, res.STAGE_SELECT_ATTACK_TARGET], res.curr_unit)
	
	match res.stage:
		res.STAGE_SELECT_UNIT: controls.select_unit(player)
		res.STAGE_SHOW_ACTIONS: player.show_available_unit_actions()
		res.STAGE_SHOW_MOVEMENTS: player.show_available_movements()
		res.STAGE_SELECT_LOCATION: controls.select_new_location()
		res.STAGE_MOVE_UNIT: player.move_unit()
		res.STAGE_DISPLAY_TARGETS: player.display_attackable_targets()
		res.STAGE_SELECT_ATTACK_TARGET: controls.select_unit_to_attack()
		#TODO: res.STAGE_ATTACK: participant.serv.combat_service.attack_unit(delta, true)


## Handles the enemy's turn
##
## @param delta: Time elapsed since the last frame
## @param enemy: The EnemyUnits node
## @param participant: The Participants node
func handle_enemy_turn(delta: float, enemy: EnemyUnits, participant: Participants) -> void:
	res.targets = participant.get_node("%TacticsPlayer")
	controls.set_actions_menu_visibility(false, null)
	if res.stage > 4:
		res.stage = 0
		DebugLog.debug_nospam("turn_stage", res.stage)
	match res.stage:
		res.STAGE_SELECT_UNIT: enemy.choose_unit()
		res.STAGE_SHOW_ACTIONS: enemy.chase_nearest_enemy()
		res.STAGE_SHOW_MOVEMENTS: enemy.is_unit_done_moving()
		res.STAGE_SELECT_LOCATION: enemy.choose_unit_to_attack()
		#TODO: res.STAGE_MOVE_UNIT: participant.serv.combat_service.attack_unit(delta, false)


## Checks if the participant can perform an action
##
## @param parent: The parent node of the participant
## @return: Whether the participant can act
func can_act(parent: Node3D) -> bool:
	for unit: DefaultUnit in parent.get_children():
		if unit.can_act():
			return true
	return false


## Resets the participant's turn
##
## @param parent: The parent node of the participant
func reset_turn(parent: Node3D) -> void:
	res.turn_just_started = true
	for p: DefaultUnit in parent.get_children():
		p.reset_turn()


## Ends the participant's turn
##
## @param player: The PlayerUnits node
func end_turn(player: PlayerUnits) -> void:
	for unit: DefaultUnit in player.get_children():
		unit.end_unit_turn()
	res.stage = res.STAGE_SELECT_UNIT
