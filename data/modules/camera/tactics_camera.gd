class_name TacticsCamera
extends CharacterBody3D
## Handles camera movement features
##
## Camera movement methods:[br]
## - [code]rotate_camera[/code]: "Cardinal Points" mode [i](Q,E)[/i][br]
## - [code]move_camera[/code]: "Panning" mode [i](W,A,S,D)[/i][br]
## - [code]free_look[/code]: "Free Look" mode [i](MMB or Right Stick movement)[/i][br]
## - [code]follow[/code]: "Focus" mode [i](programmatically called)[/i][br][br]
## 
## Resource Interface: [TacticsCameraResource] -- Service: [TacticsCameraService]

## Resource containing camera attributes and signals
@export var res: CameraResource = load("res://data/models/view/camera/camera.tres")
## Resource containing control settings
@export var controls: ControlsResource = load("res://data/models/view/control/control.tres")

## Service handling camera operations
static var serv: TacticsCameraService

## Node for horizontal rotation
@onready var t_pivot: Node3D = $TwistPivot
## Node for vertical rotation
@onready var p_pivot: Node3D = $TwistPivot/PitchPivot
## Main camera node
@onready var cam_node: Camera3D = $TwistPivot/PitchPivot/Camera3D


## TODO: initialize camera
#func _ready() -> void:
	#serv = TacticsCameraService.new(res, controls) # Initialize camera service
	#serv.setup(self, cam_node) # Set up camera service
	#res.boundary_center = global_position  # Set the initial boundary center
	## Connect signals
	#res.connect("called_rotate_camera", rotate_camera)
	#res.connect("called_move_camera", move_camera)


func _process(delta: float) -> void:
	serv.process(delta, self) # Process camera service


## Moves the camera based on input
func move_camera(h: float, v: float, joystick: bool, delta: float) -> void:
	serv.move.move_camera(h, v, joystick, delta, self)


## Rotates the camera
func rotate_camera(delta: float, twist: int = 0) -> void:
	res.is_rotating = true
	serv.rotate.add_angle_to_horiz_rotation(twist)
	serv.rotate.rotate_camera(delta, t_pivot, p_pivot)


## Enables free look mode
func free_look(delta: float) -> void:
	serv.rotate.free_look(delta, t_pivot, p_pivot)


## Zooms the camera
static func zoom_camera(zoom_increment: float) -> void:
	serv.zoom.zoom_camera(zoom_increment)


## Resets camera zoom to default
func reset_cam_zoom() -> void:
	serv.zoom.reset_cam_zoom(cam_node, self)
