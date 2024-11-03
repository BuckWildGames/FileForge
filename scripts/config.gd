extends Node

const DEBUGGER: bool = false

var version_major: int = 1
var version_minor: int = 0
var version_patch: int = 0
var play_time: float = 0.0
var config_data: Dictionary = {
	"first_major": version_major, "first_minor": version_minor, "first_patch": version_patch,
	"last_major": version_major, "last_minor": version_minor, "last_patch": version_patch,
	"total_play_time": play_time, "session_play_time": play_time, "longest_play_time": play_time,
}


func _process(delta: float) -> void:
	# Get playtime
	play_time += 1 * delta


func _save_data() -> bool:
	# Set debug
	var debug: String = "_save_data(). "
	# Set return var
	var complete = false
	# Create new config file
	var config = ConfigFile.new()
	# Set values.
	config.set_value("Version", "first_major", config_data["first_major"])
	config.set_value("Version", "first_minor", config_data["first_minor"])
	config.set_value("Version", "first_patch", config_data["first_patch"])
	config.set_value("Version", "last_major", version_major)
	config.set_value("Version", "last_minor", version_minor)
	config.set_value("Version", "last_patch", version_patch)
	config.set_value("Options", "disable_tree_button", Global.tree_button_disable)
	config.set_value("Options", "click_sound", Global.click_sound)
	config.set_value("Options", "ask_close", Global.ask_close)
	config.set_value("Options", "start_full", Global.start_full)
	config.set_value("Options", "root_colour", Global.root_colour)
	config.set_value("Options", "branch1_colour", Global.branch1_colour)
	config.set_value("Options", "branch2_colour", Global.branch2_colour)
	config.set_value("Options", "branch3_colour", Global.branch3_colour)
	config.set_value("Options", "branch4_colour", Global.branch4_colour)
	config.set_value("Options", "branch5_colour", Global.branch5_colour)
	config.set_value("Options", "var_colour", Global.var_colour)
	config.set_value("Playtime", "total_play_time", config_data["total_play_time"] + play_time)
	config.set_value("Playtime", "session_play_time", play_time)
	# Set var
	var long = config_data["longest_play_time"]
	# Check longest
	if play_time > config_data["longest_play_time"]:
		# Set longest
		long = play_time
	config.set_value("Playtime", "longest_play_time", long)
	# Save file
	var error = config.save("user://config.cfg")
	# Check error
	if error == OK:
		# Set complete
		complete = true
		# Set debug
		debug += "Complete. "
	else:
		# Set debug
		debug += "Failed. "
	# Send to debug
	_debugger(debug)
	# Return var
	return complete


func _load_data() -> bool:
	# Set debug
	var debug: String = "_load_data(). "
	# Set return var
	var complete = false
	# Create new config file
	var config = ConfigFile.new()
	# Load data from a file.
	var error = config.load("user://config.cfg")
	# Check error
	if error == OK:
		# Set loaded data
		config_data["first_major"] = config.get_value("Version", "first_major")
		config_data["first_minor"] = config.get_value("Version", "first_minor")
		config_data["first_patch"] = config.get_value("Version", "first_patch")
		config_data["last_major"] = config.get_value("Version", "last_major")
		config_data["last_minor"] = config.get_value("Version", "last_minor")
		config_data["last_patch"] = config.get_value("Version", "last_patch")
		Global.tree_button_disable = config.get_value("Options", "disable_tree_button")
		Global.click_sound = config.get_value("Options", "click_sound")
		Global.ask_close = config.get_value("Options", "ask_close")
		Global.start_full = config.get_value("Options", "start_full")
		Global.root_colour = config.get_value("Options", "root_colour")
		Global.branch1_colour = config.get_value("Options", "branch1_colour")
		Global.branch2_colour = config.get_value("Options", "branch2_colour")
		Global.branch3_colour = config.get_value("Options", "branch3_colour")
		Global.branch4_colour = config.get_value("Options", "branch4_colour")
		Global.branch5_colour = config.get_value("Options", "branch5_colour")
		Global.var_colour = config.get_value("Options", "var_colour")
		config_data["total_play_time"] = config.get_value("Playtime", "total_play_time")
		config_data["session_play_time"] = config.get_value("Playtime", "session_play_time")
		config_data["longest_play_time"] = config.get_value("Playtime", "longest_play_time")
		# Set complete
		complete = true
		# Set debug
		debug += "Complete. "
	else:
		# Set debug
		debug += "Failed. "
	# Send to debug
	_debugger(debug)
	# Return var
	return complete


func _debugger(debug_message) -> void:
	# Check if script is debug
	if DEBUGGER == true:
		# Check if os debug on
		if OS.is_debug_build():
			# Print message
			print_debug(debug_message)


func _enter_tree() -> void:
	# Load data
	_load_data()


func _exit_tree() -> void:
	# Load data
	_save_data()
