class_name CameraResource
extends Resource
## Attributes & signals of the tactics camera.

## Emitted when camera movement is requested
signal called_move_camera
## Emitted when free look is activated
signal called_free_look
## Emitted when camera rotation is requested
signal called_rotate_camera

#region Movement
@export_category("Movement")
## Movement speed of the camera
@export_range(1, 100) var move_speed: int
## Rotation speed of the camera
static var rot_speed: float
## Rotation speed setting, converted to rot_speed
@export_range(1, 100) var rotation_speed: int:
	set(val):
		rot_speed = float(val) / 10.0 # Convert rotation_speed to rot_speed
## Smoothing factor for camera movement
@export_range(0.01, 1) var smoothing: float = 0.1
## Target velocity for camera movement
var target_velocity: Vector3 = Vector3.ZERO
## Target node for camera to focus on
var target: Node3D = null:
	set(val):
		target = val
		DebugLog.debug_nospam("cam", val) # Log target change
#endregion

#region Zoom
@export_category("Zoom")
static var zoom_speed: float
## Speed of camera zoom
@export_range(0.01, 1) var camera_zoom_speed: float = 0.5:
	set(val):
		zoom_speed = float(val)
## Smoothness of zoom transition
@export_range(0.01, 1) var zoom_smoothness: float = 0.1
## Duration of zoom transition
@export_range(0.01, 1) var zoom_duration: float = 0.5
## Minimum zoom level (closest)
@export_range(0.1, 50) var min_zoom: float = 1.0
## Maximum zoom level (farthest)
@export_range(10.0, 100.0) var max_zoom: float = 10.0
## Current Field of View
var current_fov: float = 50.0
## Target Field of View for smooth transition
var target_fov: float = 50.0
#endregion

#region Panning
@export_category("Panning")
## Radius of the boundary for camera movement
@export var boundary_radius: float = 10.0
## Center point of the boundary
var boundary_center: Vector3 = Vector3.ZERO
## Threshold for edge panning in pixels
@export_range(1, 50) var border_pan_px_threshold: float = 1.0
## Speed of mouse-controlled panning
@export_range(0.01, 1.0) var mouse_pan_speed: float = 0.5
## Speed of joystick-controlled panning
@export_range(0.01, 1.0) var joy_pan_speed: float = 0.5
## Delay before panning starts
const PANNING_DELAY: float = 0.05
## Timer to track panning delay
var panning_timer: float = 0.0
#endregion

#region Rotation
@export_category("Rotation")
## Duration of snapping to nearest quadrant
@export_range(0.1, 10) var quad_snap_duration: float = 0.2
## Flag to indicate if camera is snapping to quadrant
var is_snapping_to_quad: bool = false:
	set(val):
		is_snapping_to_quad = val
		DebugLog.debug_nospam("quad_snap", val) # Log quadrant snap state
## Flag to indicate if camera is rotating
static var is_rotating: bool = false:
	set(val):
		is_rotating = val
		DebugLog.debug_nospam("cam_rotating", val) # Log rotation state
## Vertical pitch rotation
static var x_rot: int # edit for rotation
## Vertical pitch rotation
@export var vertical_rot: int:
	set(val):
		x_rot = val
## Horizontal twist rotation
static var y_rot: int # edit for rotation
@export var horizontal_rot: int:
	set(val):
		y_rot = val
## Roll rotation
@export var z_rot: int
## Current mouse position
var mouse_pos: Vector2
## Flag to indicate if camera is in free look mode
static var in_free_look: bool:
	set(val):
		in_free_look = val
		DebugLog.debug_nospam("in_free_look", val) # Log free look state
## Timer for free look mode
var free_look_timer: float = 0.0
## Timeout for free look mode
const FREE_LOOK_TIMEOUT: float = 0.05
## Input for twisting rotation
static var twist_input: float
## Input for pitch rotation
static var pitch_input: float
## Size of the viewport
var viewport_size: Vector2i
#endregion

#region Signals
## Emits signal to move camera
func move_camera(h: float, v: float, joystick: bool, delta: float) -> void:
	called_move_camera.emit(h, v, joystick, delta)


## Emits signal to rotate camera
func rotate_camera(delta: float, twist: float = 0.0) -> void:
	called_rotate_camera.emit(delta, twist)


## Emits signal for free look mode
func free_look(delta: float) -> void:
	called_free_look.emit(delta)
#endregion
