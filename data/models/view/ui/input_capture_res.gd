class_name InputCaptureResource
extends Resource
## Stores input-related data and configurations
##
## This resource class holds various input states and configurations used for input processing
## in the game. It includes settings for both mouse and joystick input, as well as camera control parameters.

# Input State
## Indicates whether joystick input is currently active
static var is_joystick: bool = false
## The current position of the joystick
var joystick_position: Vector2 = Vector2.ZERO
## X-axis compound value of the right joystick
static var right_stick_x: float
## Y-axis compound value of the right joystick
static var right_stick_y: float
## X-axis compound value of the right joystick
static var left_stick_x: float
## Y-axis compound value of the left joystick
static var left_stick_y: float

## The current position of the mouse cursor
var mouse_position: Vector2 = Vector2.ZERO
## The current direction of the camera
static var cam_direction: Vector2
## Indicates whether free look input is currently active
static var free_look_pressed: bool = false

# Mapping
const CAMERA_PAN_KEYS: Array[String] = ["camera_left", "camera_right", "camera_forward", "camera_backwards"]

# Configuration
## The maximum length for the ray used in mouse cursor position casting
var RAY_LENGTH: int = 10_000

## The sensitivity of mouse input
@export var mouse_sensitivity: float = 1.0

## Deadzone for controller input to prevent unintended movement from small inputs
const CONTROLLER_DEADZONE: float = 0.05
## Sensitivity of right stick input
const RIGHT_STICK_SENSITIVITY: float = 1.0

## The speed at which the camera moves
@export var camera_move_speed: float = 10.0
## The speed at which the camera rotates
@export var camera_rotate_speed: float = 5.0
## The speed at which the camera zooms in and out
@export var camera_zoom_speed: float = 0.1

# Add more input-related variables as needed
