extends Control

@onready var label: Label = $HBoxContainer/Label
@onready var forge: Control = $"../Forge"
@onready var title: VBoxContainer = $"../Title"
@onready var audio_stream_player: AudioStreamPlayer = $"../AudioStreamPlayer"

var is_dragging = false
var drag_offset = Vector2()
var resizing: bool = false
var start_mouse_pos: Vector2
var start_window_size: Vector2


func _ready() -> void:
	# Check fullscreen
	if Global.start_full:
		# Fullscreen window
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
	# Try to create folder
	System.create_folder("user://", "saves")
	System.copy_file("res://", "user://saves", "Help.sav")
	# Connect forge
	forge.connect("title_changed", _set_title)


func _set_title() -> void:
	# Hide title
	title.hide()
	# Set the title
	label.set_text(Global.tree_name)


func _input(event: InputEvent) -> void:
	# Check home button
	if event.is_action_pressed("ui_home"):
		# Get the screen size and window size
		var screen_size = DisplayServer.screen_get_size()
		var window_size = DisplayServer.window_get_size()
		# Calculate the centered position
		var center_position = (screen_size - window_size) / 2
		# Set the window to the center position
		DisplayServer.window_set_position(center_position)
	# Check mouse button
	if event is InputEventMouseButton:
		# Check pressed
		if event.is_pressed() and event.get_button_index() == MOUSE_BUTTON_LEFT:
			# Play sound
			if Global.click_sound:
				audio_stream_player.play()
			# Check if the mouse is near the top of the window
			if event.get_position().y < 40:
				# Set vars
				is_dragging = true
				drag_offset = event.get_position()
		elif not event.is_pressed():
			# Set var
			is_dragging = false
			resizing = false
	elif event is InputEventMouseMotion:
		if is_dragging:
			# Get the window new window position
			var new_position = DisplayServer.window_get_position() + Vector2i(event.get_relative().x, event.get_relative().y)
			# Move window
			DisplayServer.window_set_position(new_position)
		elif resizing:
			# Calculate the difference between the starting mouse position and current mouse position
			var mouse_position = DisplayServer.mouse_get_position()
			var new_size = start_window_size + (Vector2(mouse_position.x, mouse_position.y)  - start_mouse_pos)
			# Apply the new window size
			DisplayServer.window_set_size(new_size)


func _on_save_button_pressed() -> void:
	# Check tree
	if Global.tree.size() > 0:
		# Show file dialog
		GlobalFileDialog.setup("save")


func _on_new_button_pressed() -> void:
	# Check if project started
	if Global.tree.size() == 0:
		# Set title
		Global.tree_name = "Root"
		# Set title
		_set_title()
		# Start new
		forge.start_new()
	else:
		# Ask
		Ask.ask()
		# Wait for signal
		await Ask.respond
		# Check response
		if Ask.response:
			# Set title
			Global.tree_name = "Root"
			_set_title()
			# Start new
			Global.tree.clear()
			Global.tree = {}
			forge.start_new()


func _on_load_button_pressed() -> void:
	# Show file dialog
	GlobalFileDialog.setup("load")


func _on_import_button_pressed() -> void:
	# Show file dialog
	GlobalFileDialog.setup("import")


func _on_export_button_pressed() -> void:
	# Check tree
	if Global.tree.size() > 0:
		# Show file dialog
		GlobalFileDialog.setup("export")


func _on_hide_window_button_pressed() -> void:
	# Hide window
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MINIMIZED)


func _on_min_max_window_button_pressed() -> void:
	# Check mode
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_WINDOWED:
		# Fullscreen window
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
	else:
		# Window window
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)


func _on_close_window_button_pressed() -> void:
	# Check ask
	if Global.ask_close:
		# Ask
		Ask.ask()
		# Wait for signal
		await Ask.respond
		# Check response
		if Ask.response:
			# Close game
			get_tree().quit()
	else:
		# Close game
		get_tree().quit()


func _on_resize_button_button_down() -> void:
	# Start resizing mode
	resizing = true
	start_mouse_pos = DisplayServer.mouse_get_position()
	start_window_size = DisplayServer.window_get_size()


func _on_settings_button_pressed() -> void:
	# Show settings
	Settings.setup(forge)
