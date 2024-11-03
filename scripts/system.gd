extends Node
class_name System

const DEBUGGER: bool = false

static func get_folders(path: String) -> Array:
	# Set vars
	var debug: String = "get_folders(" +path +"). "
	var data: Array = []
	# Open folder
	var dir = DirAccess.open(path)
	# Check if dir exists
	if dir != null:
		# Set debug
		debug += "Directory found. "
		# Get all files
		data = dir.get_directories()
	else:
		# Set debug
		debug += "Directory not found. "
	# Clear dir
	dir = null
	# Send to debug
	_debugger(debug)
	# Return data
	return data


static func get_files(path: String) -> Array:
	# Set vars
	var debug: String = "get_files(" +path +"). "
	var data: Array = []
	# Open folder
	var dir = DirAccess.open(path)
	# Check if dir exists
	if dir != null:
		# Set debug
		debug += "Directory found. "
		# Get all files
		data = dir.get_files()
	else:
		# Set debug
		debug += "Directory not found. "
	# Clear dir
	dir = null
	# Send to debug
	_debugger(debug)
	# Return data
	return data


static func create_folder(path: String, folder_name: String) -> bool:
	# Set vars
	var debug: String = "create_folder(" +path +"," +folder_name +"). "
	var folders: Array = []
	var complete: bool = false
	# Open folder
	var dir = DirAccess.open(path)
	# Check if folder exists
	if dir != null:
		# Set debug
		debug += "Directory found. "
		# Get all folders
		folders = dir.get_directories()
		# Check if folder exists
		if !folders.has(folder_name):
			# Create folder
			var error = dir.make_dir(path +"/" +folder_name)
			# Check error
			if error == OK:
				# Set debug
				debug += "Folder created. "
				# Set complete
				complete = true
			else:
				# Set debug
				debug += "Could not create folder. "
		else:
			# Set debug
			debug += "Folder already exists. "
	else:
		# Set debug
		debug += "Directory not found. "
	# Clear dir
	dir = null
	# Send to debug
	_debugger(debug)
	# Return data
	return complete


static func delete_folder(path: String, folder_name: String, recycle: bool, clear: bool = false) -> bool:
	# Set vars
	var debug: String = "delete_folder(" +path +"," +folder_name +"," +str(recycle) +"). "
	var folders: Array = []
	var complete: bool = false
	# Open folder
	var dir = DirAccess.open(path)
	# Check if dir exists
	if dir != null:
		# Set debug
		debug += "Directory found. "
		# Get all folders
		folders = dir.get_directories()
		# Check if folder exists
		if folders.has(folder_name):
			# Check if recycle
			if recycle == true:
				# Set debug
				debug += "Moving folder to recycle bin. "
				# Move to recycle bin
				var error = OS.move_to_trash(ProjectSettings.globalize_path(path +"/" +folder_name))
				# Check error
				if error == FAILED:
					# Set debug
					debug += "Could not move folder. "
				else:
					# Set debug
					debug += "Folder moved. "
					# Set complete
					complete = true
			else:
				# Set debug
				debug += "Deleting folder. "
				# Delete folder
				var error = dir.remove(path +"/" +folder_name)
				# Check error
				if error == OK:
					# Set debug
					debug += "Folder deleted. "
					# Set complete
					complete = true
				else:
					# Set debug
					debug += "Could not delete folder. "
		else:
			# Set debug
			debug += "Folder not found. "
	else:
		# Set debug
		debug += "Directory not found. "
	# Clear dir
	dir = null
	folders.clear()
	# Send to debug
	_debugger(debug)
	# Return data
	return complete


static func copy_file(from_path: String, to_path: String, file_name: String) -> bool:
	# Set vars
	var debug: String = "copy_file(" +from_path +"," +to_path +"," +file_name+"). "
	var files: Array = []
	var to_files: Array = get_files(to_path)
	var complete: bool = false
	# Check if files exist in to path
	if !to_files.has(file_name):
		# Open folder
		var dir = DirAccess.open(from_path)
		# Check if folder exists
		if dir != null:
			# Set debug
			debug += "Directory found. "
			# Get all folders
			files = dir.get_files()
			# Check if folder exists
			if files.has(file_name):
				# Create folder
				var error = dir.copy(from_path +"/" +file_name, to_path +"/" +file_name)
				# Check error
				if error == OK:
					# Set debug
					debug += "File Coppied. "
					# Set complete
					complete = true
				else:
					# Set debug
					debug += "Could not copy file. "
			else:
				# Set debug
				debug += "File not found. "
		else:
			# Set debug
			debug += "Directory not found. "
		# Clear dir
		dir = null
		files.clear()
	else:
		# Set debug
		debug += "File already exists. "
	to_files.clear()
	# Send to debug
	_debugger(debug)
	# Return data
	return complete


static func delete_file(path: String, file_name: String, recycle: bool) -> bool:
	# Set vars
	var debug: String = "delete_file(" +path +"," +file_name +"," +str(recycle) +"). "
	var files: Array = []
	var complete: bool = false
	# Open folder
	var dir = DirAccess.open(path)
	# Check if dir exists
	if dir != null:
		# Set debug
		debug += "Directory found. "
		# Get all files
		files = dir.get_files()
		# Check if file exists
		if files.has(file_name):
			# Check if recycle
			if recycle == true:
				# Set debug
				debug += "Moving file to recycle bin. "
				# Move to recycle bin
				var error = OS.move_to_trash(ProjectSettings.globalize_path(path +"/" +file_name))
				# Check error
				if error == FAILED:
					# Set debug
					debug += "Could not move file. "
				else:
					# Set debug
					debug += "File moved. "
					# Set complete
					complete = true
			else:
				# Set debug
				debug += "Deleting file. "
				# Delete file
				var error = dir.remove(path +"/" +file_name)
				# Check error
				if error == OK:
					# Set debug
					debug += "File deleted. "
					# Set complete
					complete = true
				else:
					# Set debug
					debug += "Could not delete file. "
		else:
			# Set debug
			debug += "File not found. "
	else:
		# Set debug
		debug += "Directory not found. "
	# Clear dir
	dir = null
	files.clear()
	# Send to debug
	_debugger(debug)
	# Return data
	return complete


static func save_data(path: String,  file_name: String, data: Dictionary, overwrite: bool = false) -> bool:
	# Set vars
	var debug: String = "save_data(" +path +"," +file_name +"," +str(data.size()) +"," +str(overwrite) +"). "
	var files: Array = []
	var complete: bool = false
	# Open folder
	var dir = DirAccess.open(path)
	# Check if dir exists
	if dir != null:
		# Set debug
		debug += "Directory found. "
		# Get all files
		files = dir.get_files()
		# Check if file exists
		if files.has(file_name):
			# Set debug
			debug += "File already exists. "
			# Check if overwrite
			if overwrite == true:
				# Set debug
				debug += "Overwriting. "
				# Delete file
				delete_file(path,file_name,false)
				# Save file
				complete = _save_data(path, file_name, data)
		else:
			# Set debug
			debug += "Saving. "
			# Save resource
			complete = _save_data(path, file_name, data)
	else:
		# Set debug
		debug += "Directory not found. "
	# Clear vars
	dir = null
	files.clear()
	# Send to debug
	_debugger(debug)
	# Return complete
	return complete


static func _save_data(path: String, file_name: String, data: Dictionary) -> bool:
	# Set vars
	var debug: String = "_save_data(" +path +"," +file_name +"," +str(data.size()) +"). "
	var complete: bool = false
	# Create file
	var file = FileAccess.open(path +"/" +file_name, FileAccess.WRITE)
	# Check if file exist
	if file != null:
		# Set debug
		debug += "Saved to file. "
		# Set data to json string
		var json_string = JSON.stringify(data,"\t")
		# Save in file
		file.store_line(json_string)
		# Close file
		file.close()
		# Set complete
		complete = true
	else:
		# Set debug
		debug += "Could not save to file. "
	# Send to debug
	_debugger(debug)
	# Return complete
	return complete


static func load_data(path: String, file_name: String) -> Dictionary:
	# Set vars
	var debug: String = "load_data(" +path +"," +file_name +"). "
	var data: Dictionary = {}
	# Open folder
	var dir = DirAccess.open(path)
	# Check if dir exists
	if dir != null:
		# Set debug
		debug += "Directory found. "
		# Check if file exists
		if FileAccess.file_exists(path +"/" +file_name):
			# Set debug
			debug += "File found. "
			# Open file
			var file = FileAccess.open(path +"/" +file_name, FileAccess.READ)
			# Check file
			if file != null:
				# Set debug
				debug += "Reading file. "
				# Get string
				var json_string = file.get_as_text()
				# Create json helper
				var json = JSON.new()
				# Check for error
				var error = json.parse(json_string)
				if error != OK:
					# Set debug
					debug += "Could not read file. "
				else:
					# Set debug
					debug += "File read. "
					# Get data
					data = json.get_data()
				# Clear json
				json.call_deferred("free")
				# Close file
				file.close()
				# Set debug
				debug += "File loaded. "
			else:
				# Set debug
				debug += "Could not open file. "
		else:
			# Set debug
			debug += "File not found. "
	else:
		# Set debug
		debug += "Directory not found. "
	# Clear vars
	dir = null
	# Send to debug
	_debugger(debug)
	# Return complete
	return data


static func save_resource(path: String, resource_name: String, resource: Resource, overwrite: bool = false) -> bool:
	# Set vars
	var debug: String = "save_resource(" +path +"," +resource_name +"," +str(resource) +"," +str(overwrite)+"). "
	var files: Array = []
	var complete: bool = false
	# Open folder
	var dir = DirAccess.open(path)
	# Check if dir exists
	if dir != null:
		# Set debug
		debug += "Directory found. "
		# Get all files
		files = dir.get_files()
		# Check if file exists
		if files.has(resource_name):
			# Set debug
			debug += "Resource already exists. "
			# Check if overwrite
			if overwrite == true:
				# Set debug
				debug += "Overwriting. "
				# Delete resource
				#delete_file(path,resource_name,false)
				# Save resource
				complete = _save_resource(path, resource_name, resource)
		else:
			# Set debug
			debug += "Saving. "
			# Save resource
			complete = _save_resource(path, resource_name, resource)
	else:
		# Set debug
		debug += "Directory not found. "
	# Clear vars
	dir = null
	files.clear()
	# Send to debug
	_debugger(debug)
	# Return complete
	return complete


static func _save_resource(path: String, resource_name: String, resource: Resource) -> bool:
	# Set vars
	var debug: String = "_save_resource(" +path +"," +resource_name +"," +str(resource) +"). "
	var complete: bool = false
	# Save resource
	var error = ResourceSaver.save(resource, path +"/" +resource_name)
	# Check error
	if error == OK:
		# Set debug
		debug += "Resource saved. "
		# Set complete
		complete = true
	else:
		# Set debug
		debug += "Could not save resource. "
	# Send to debug
	_debugger(debug)
	# Return complete
	return complete


static func load_resource(path: String, resource_name: String) -> Resource:
	# Set vars
	var debug: String = "load_resource(" +path +"," +resource_name +"). "
	var res: Resource = null
	var files: Array = []
	# Open folder
	var dir = DirAccess.open(path)
	# Check if dir exists
	if dir != null:
		# Set debug
		debug += "Directory found. "
		# Get all files
		files = dir.get_files()
		# Check if file exists
		if files.has(resource_name) or files.has(resource_name +".remap"):
			# Set debug
			debug += "Resource found. "
			# Load resource
			res = load(path +"/" +resource_name)
			# Set debug
			debug += "Resource loaded. "
		else:
			# Set debug
			debug += "Resource not found. "
	else:
		# Set debug
		debug += "Directory not found. "
	# Clear vars
	dir = null
	files.clear()
	# Send to debug
	_debugger(debug)
	# Return data
	return res


static func _debugger(debug_message) -> void:
	# Check if script is debug
	if DEBUGGER == true:
		# Check if os debug on
		if OS.is_debug_build():
			# Print message
			print_debug(debug_message)
