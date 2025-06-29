class_name Participants
extends Node3D
## Handles participant (i.e. Player & Opponent) actions and decision-making
## 
## Resource Interface: [ParticipantResource] -- Service: [ParticipantService]
## Parent of: [PlayerUnits], [OpponentUnits]

## Resource containing participant data and configurations
@export var res: ParticipantsResource = load("res://data/models/world/combat/participants/participants.tres")
## Resource for camera-related data and configurations
@export var camera: CameraResource = load("res://data/models/view/camera/camera.tres")
## Resource for control-related data and configurations
@export var controls: ControlsResource = load("res://data/models/view/control/control.tres")
## Service handling participant logic and operations
var serv: ParticipantsService
## Reference to the TacticsBoard node
@onready var board: TacticsBoard = %TestTacticsBoard
## Reference to the PlayerUnits node
@onready var player: PlayerUnits = %PlayerUnits
## Reference to the EnemyUnits node
@onready var enemy: EnemyUnits = %EnemyUnits


## Initializes the TacticsParticipant node
func _ready() -> void:
	# Initialize the service with necessary resources
	serv = ParticipantsService.new(res, camera, controls)
	# Set up the service with this node as context
	serv.setup(self)
	# TODO: Connect the end_turn signal to the end_turn method
	#res.connect("called_end_turn", end_turn)


## Performs the participant's action
##
## @param delta: Time elapsed since the last frame
## @param is_player: Whether the acting participant is the player
## @param parent: The parent node of the participant
func act(delta: float, is_player: bool, parent: Node3D) -> void:
	serv.act(delta, is_player, parent, self)


## Configures the participant with camera and control resources
##
## @param my_camera: The camera resource to use
## @param my_control: The control resource to use
func configure(my_camera: Resource, my_control: Resource) -> void:
	serv.configure(my_camera, my_control)


## Checks if the participant is properly configured
##
## @param parent: The parent node of the participant
## @return: Whether the participant is configured
func is_configured(parent: Node3D) -> bool:
	return serv.is_configured(parent)


## Checks if the participant can perform an action
##
## @param parent: The parent node of the participant
## @return: Whether the participant can act
func can_act(parent: Node3D) -> bool:
	return serv.can_act(parent)


## Resets the participant's turn
##
## @param parent: The parent node of the participant
func reset_turn(parent: Node3D) -> void:
	serv.reset_turn(parent)


## TODO: Ends the participant's turn
#func end_turn() -> void:
	#serv.end_turn(player)
