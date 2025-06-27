class_name ParticipantsService
extends RefCounted
## Service class for Participants
## 
## Dependency of: [Participants]

## Resource containing participant data and configurations
var res: ParticipantsResource
## Resource for camera-related data and configurations
var camera: CameraResource
## Resource for control-related data and configurations
var controls: ControlsResource
## Service handling turn-related logic
var turn_service: ParticipantsTurnService
## TODO: Service handling combat-related logic
#var combat_service: ParticipantCombatService


## Initializes the ParticipantsService
##
## @param _res: The ParticipantsResource to use
## @param _camera: The CameraResource to use
## @param _controls: The ControlsResource to use
func _init(_res: ParticipantsResource, _camera: CameraResource, _controls: ControlsResource) -> void:
	res = _res
	camera = _camera
	controls = _controls
	turn_service = ParticipantsTurnService.new(res, camera, controls)
	#TODO: combat_service = ParticipantCombatService.new(res, camera, controls)


## Sets up the ParticipantsService
##
## @param _participant: The Participants node to set up
func setup(_participant: Participants) -> void:
	if not controls:
		push_error("Controls needs a ControlResource from /data/models/view/control/tactics/")
	if not camera:
		push_error("Camera needs a CameraResource from /data/models/view/camera/tactics/")
	if not res:
		push_error("Participants needs a ParticipantsResource from /data/models/world/combat/participant/")


## Handles the participant's action
##
## @param delta: Time elapsed since the last frame
## @param is_player: Whether the acting participant is the player
## @param parent: The parent node of the participant
## @param participant: The Participants node
func act(delta: float, is_player: bool, parent: Node3D, participant: Participants) -> void:
	DebugLog.debug_nospam("participant_turn", is_player)
	DebugLog.debug_nospam("turn_stage", res.stage)
	
	if is_player:
		var player: PlayerUnits = parent as PlayerUnits
		turn_service.handle_player_turn(delta, player, participant)
	else:
		var enemy: EnemyUnits = parent as EnemyUnits
		turn_service.handle_enemy_turn(delta, enemy, participant)


## Configures the service with camera and control resources
##
## @param my_camera: The camera resource to use
## @param my_control: The control resource to use
func configure(my_camera: Resource, my_control: Resource) -> void:
	camera = my_camera
	controls = my_control


## Checks if the participant is properly configured
##
## @param parent: The parent node of the participant
## @return: Whether the participant is configured
func is_configured(parent: Node3D) -> bool:
	return parent.is_unit_configured()


# Checks if the participant can perform an action
#
# @param parent: The parent node of the participant
# @return: Whether the participant can act
func can_act(parent: Node3D) -> bool:
	return turn_service.can_act(parent)


## Resets the participant's turn
##
## @param parent: The parent node of the participant
func reset_turn(parent: Node3D) -> void:
	turn_service.reset_turn(parent)


## TODO: Ends the participant's turn
##
## @param player: The PlayerUnits node
#func end_turn(player: PlayerUnits) -> void:
	#turn_service.end_turn(player)
