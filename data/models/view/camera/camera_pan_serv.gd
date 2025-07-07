class_name CameraPanService
extends RefCounted
## Service class for handling camera panning

var res: CameraResource


func _init(_res: CameraResource):
	res = _res


## Handles panning with WASD
func wasd_pan(delta: float, camera: TacticsCamera, input_dir: Vector2) -> void:
	var h_val: float = float(input_dir.x)
	var v_val: float = float(-input_dir.y)
	
	if h_val != 0 or v_val != 0:
		camera.move_camera(h_val, v_val, delta)
