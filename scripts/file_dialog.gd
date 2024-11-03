extends Control

@onready var canvas_layer: CanvasLayer = $CanvasLayer
@onready var file_dialog: FileDialog = $CanvasLayer/PanelContainer/FileDialog
@onready var open_button: Button = $CanvasLayer/PanelContainer/OpenButton

var mode: String = ""
var file_path: String = ""


func _ready() -> void:
	await get_tree().create_timer(1.0).timeout
	# Connect popups
	_connect_popups()


func setup(new_mode: String) -> void:
	# Set mode
	mode = new_mode
	# Match mode
	match mode:
		"save":
			# Set file dialog
			file_dialog.set_file_mode(FileDialog.FILE_MODE_SAVE_FILE)
			file_dialog.set_access(FileDialog.ACCESS_USERDATA)
			file_dialog.set_root_subfolder("user://saves")
			file_dialog.set_filters(["*.sav"])
			file_dialog.set_ok_button_text("Save")
			file_dialog.set_title("Save As")
			file_dialog.get_line_edit().set_text("")
			open_button.show()
		"load":
			# Set file dialog
			file_dialog.set_file_mode(FileDialog.FILE_MODE_OPEN_FILE)
			file_dialog.set_access(FileDialog.ACCESS_USERDATA)
			file_dialog.set_root_subfolder("user://saves")
			file_dialog.set_filters(["*.sav"])
			file_dialog.set_ok_button_text("Load")
			file_dialog.set_title("Load File")
			file_dialog.get_line_edit().set_text("")
			open_button.show()
		"import":
			# Set file dialog
			file_dialog.set_file_mode(FileDialog.FILE_MODE_OPEN_FILE)
			file_dialog.set_access(FileDialog.ACCESS_FILESYSTEM)
			file_dialog.set_root_subfolder("")
			file_dialog.set_filters(["*.json"])
			file_dialog.set_ok_button_text("Import")
			file_dialog.set_title("Import File")
			file_dialog.get_line_edit().set_text("")
			open_button.hide()
		"export":
			# Set file dialog
			file_dialog.set_file_mode(FileDialog.FILE_MODE_SAVE_FILE)
			file_dialog.set_access(FileDialog.ACCESS_FILESYSTEM)
			file_dialog.set_root_subfolder("")
			file_dialog.set_filters(["*.json"])
			file_dialog.set_ok_button_text("Export")
			file_dialog.set_title("Export File")
			file_dialog.get_line_edit().set_text("")
			open_button.hide()
	# Show
	canvas_layer.show()
	file_dialog.show()


func _input(event: InputEvent) -> void:
	# Check event
	if event.is_action_pressed("ui_cancel"):
		_on_file_dialog_canceled()


func _connect_popups() -> void:
	# Loop through children
	for child in file_dialog.get_children(true):
		# Find popups
		if child is ConfirmationDialog:
			# Hide
			child.connect("confirmed", _overwrite_confirmed)


func _close_popups() -> void:
	# Loop through children
	for child in file_dialog.get_children():
		# Find popups
		if child is ConfirmationDialog or child is AcceptDialog:
			# Hide
			child.hide()


func _overwrite_confirmed() -> void:
	# Check mode
	if mode == "save":
		# Get file_name
		var file_name = file_dialog.get_line_edit().get_text()
		# Save as one dictionary
		var dic = {Global.tree_name: Global.tree}
		# Save data
		var complete = System.save_data("user://saves/", file_name, dic, true)
		# Check complete
		if complete:
			# Hide
			canvas_layer.hide()
			file_dialog.hide()
		else:
				# Show
				file_dialog.show()


func _on_file_dialog_canceled() -> void:
	# Hide
	canvas_layer.hide()
	file_dialog.hide()


func _on_file_dialog_confirmed() -> void:
	# Match mode
	match mode:
		"save":
			# Get file_name
			var file_name = file_dialog.get_line_edit().get_text()
			# Save as one dictionary
			var dic = {Global.tree_name: Global.tree}
			# Save data
			var complete = System.save_data("user://saves/", file_name, dic)
			# Check complete
			if complete:
				# Hide
				canvas_layer.hide()
				file_dialog.hide()
			else:
					# Show
					file_dialog.show()
		"load":
			# Get file_name
			var file_name = file_dialog.get_line_edit().get_text()
			# load data
			var dic = System.load_data("user://saves/", file_name)
			# Seperate
			var dic_name = dic.keys()
			Global.tree_name = dic_name[0]
			Global.tree = dic[Global.tree_name]
			# Load
			Global.forge.reload()
			# Hide
			canvas_layer.hide()
			file_dialog.hide()
		"import":
			# Get file_name
			var file_name = file_dialog.get_line_edit().get_text()
			# Remove name from path
			file_path = file_path.replace(file_name, "")
			# Save as one dictionary
			var dic = System.load_data(file_path, file_name)
			# Seperate
			var dic_name = dic.keys()
			if dic_name.size() > 0:
				Global.tree_name = dic_name[0]
				Global.tree = dic[Global.tree_name]
				# Load
				Global.forge.reload()
				# Hide
				canvas_layer.hide()
				file_dialog.hide()
		"export":
			# Get file_name
			var file_name = file_dialog.get_line_edit().get_text()
			# Remove name from path
			file_path = file_path.replace(file_name, "")
			# Save as one dictionary
			var dic = {Global.tree_name: Global.tree}
			# load data
			var complete = System.save_data(file_path, file_name, dic, true)
			# Check complete
			if complete:
				# Hide
				canvas_layer.hide()
				file_dialog.hide()
			else:
				# Show
				file_dialog.show()


func _on_file_dialog_file_selected(path: String) -> void:
	# Set path
	file_path = path


func _on_open_button_pressed() -> void:
	# Set path
	var path = ProjectSettings.globalize_path("user://saves/")
	# Open folder
	var error = OS.shell_open(path)
	# Check error
	if error != OK:
		# Print error
		print(error)
