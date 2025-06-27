class_name InputCaptureService
extends RefCounted

var res: InputCaptureResource

## Magic number for reducing free look mouse motion movement
const FL_ROT_SPEED_DIVIDER: float = 0.25

func _init(_res: InputCaptureResource) -> void:
	res = _res


func process_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		# --- MOUSE BUTTONS ---
		if event.pressed:
			# free look toggle
			if event.is_action("camera_free_look"):
				res.free_look_pressed = true
				if not CameraResource.is_rotating:
					CameraResource.in_free_look = true
			# zoom input -- camera zoom scroll capture
			if event.button_index == MOUSE_BUTTON_WHEEL_UP:
				TacticsCamera.serv.zoom.zoom_camera(-CameraResource.zoom_speed)
			elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
				TacticsCamera.serv.zoom.zoom_camera(CameraResource.zoom_speed)
		else:
			# free look toggle
			if event.is_action_released("camera_free_look"):
				res.free_look_pressed = false
	if event is InputEventMouseMotion:
		# free_look motion capture
		if CameraResource.in_free_look:
			CameraResource.twist_input = -event.relative.x * (FL_ROT_SPEED_DIVIDER * CameraResource.rot_speed)
			CameraResource.pitch_input = -event.relative.y * (FL_ROT_SPEED_DIVIDER * CameraResource.rot_speed)
	elif event is InputEventKey:
		# ----- KEYS -----
		if event.pressed:
			if event.is_action_pressed("camera_rotate_left"):
				if not CameraResource.in_free_look:
					CameraResource.y_rot += -90
			elif event.is_action_pressed("camera_rotate_right"):
				if not CameraResource.in_free_look:
					CameraResource.y_rot += 90
			# camera pan direction (WASD)
			for action: StringName in res.CAMERA_PAN_KEYS:
				if event.is_action(action):
					res.cam_direction = Input.get_vector(
							"camera_left", "camera_right", 
							"camera_forward", "camera_backwards")
					return
		# Handle key releases
		else:
			# camera pan direction (WASD)
			for action: StringName in res.CAMERA_PAN_KEYS:
				if event.is_action_released(action):
					# Recalculate cam_direction after key release
					res.cam_direction = Input.get_vector("camera_left", "camera_right", "camera_forward", "camera_backwards")
					return
	elif event is InputEventJoypadMotion:
		# --- JOYSTICKS ---
		# camera pan direction (left joystick)
		if event.axis in [JOY_AXIS_LEFT_X, JOY_AXIS_LEFT_Y]:
			res.left_stick_x = Input.get_joy_axis(0, JoyAxis.JOY_AXIS_LEFT_X)
			res.left_stick_y = Input.get_joy_axis(0, JoyAxis.JOY_AXIS_LEFT_Y)
			
			# Calculate the magnitude of the joystick input
			var magnitude: float = Vector2(res.left_stick_x, res.left_stick_y).length()
			if magnitude > res.CONTROLLER_DEADZONE:
				res.cam_direction = Vector2(res.left_stick_x, res.left_stick_y)
			else:
				res.cam_direction = Vector2.ZERO
		# camera free look direction (right joystick)
		if event.axis in [JOY_AXIS_RIGHT_X, JOY_AXIS_RIGHT_Y]:
			if abs(event.axis_value) > res.CONTROLLER_DEADZONE:
				res.right_stick_x = -Input.get_joy_axis(0, JoyAxis.JOY_AXIS_RIGHT_X)
				res.right_stick_y = Input.get_joy_axis(0, JoyAxis.JOY_AXIS_RIGHT_Y)
			elif abs(event.axis_value) < res.CONTROLLER_DEADZONE:
				res.right_stick_x = 0.0
				res.right_stick_y = 0.0
	elif event is InputEventJoypadButton:
		# --- JOY BUTTONS ---
		if event.pressed:
			# 
			pass
		else:
			# 
			pass


func handle_input(_event: InputEvent) -> void:
	pass


func project_mouse_position(collision_mask: int, is_joystick: bool, input_capture: InputCapture) -> Object:
	if not input_capture:
		return null

	var camera: Camera3D = input_capture.get_viewport().get_camera_3d()
	var mouse_position: Vector2 = input_capture.get_viewport().get_mouse_position()
	var pointer_origin: Vector2 = mouse_position if not is_joystick else input_capture.get_viewport().size / 2

	var from: Vector3 = camera.project_ray_origin(pointer_origin)
	var to: Vector3 = from + camera.project_ray_normal(pointer_origin) * 1000.0  # Adjust ray length if needed

	if DebugLog.visual_debug:
		draw_debug_ray(from, to, input_capture.debug_ray_mesh, input_capture)

	var ray_query := PhysicsRayQueryParameters3D.create(from, to, collision_mask, [])
	var result := input_capture.get_world_3d().direct_space_state.intersect_ray(ray_query)

	if result and result.has("collider"):
		var collider = result["collider"]
		
		if collider is Tile:
			return collider
		elif collider is DefaultUnit:
			return collider

	return null


func setup_debug_ray(parent: Node3D) -> MeshInstance3D:
	var debug_ray_mesh: MeshInstance3D = MeshInstance3D.new()
	var mesh: ImmediateMesh = ImmediateMesh.new()
	debug_ray_mesh.mesh = mesh
	var material: StandardMaterial3D = StandardMaterial3D.new()
	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.albedo_color = Color.YELLOW
	material.vertex_color_use_as_albedo = true
	debug_ray_mesh.material_override = material
	parent.add_child(debug_ray_mesh)
	return debug_ray_mesh


func draw_debug_ray(from: Vector3, to: Vector3, debug_ray_mesh: MeshInstance3D, parent: Node3D) -> void:
	var mesh: ImmediateMesh = debug_ray_mesh.mesh as ImmediateMesh
	mesh.clear_surfaces()
	mesh.surface_begin(Mesh.PRIMITIVE_LINES)
	mesh.surface_add_vertex(parent.to_local(from))
	mesh.surface_add_vertex(parent.to_local(to))
	mesh.surface_end()
