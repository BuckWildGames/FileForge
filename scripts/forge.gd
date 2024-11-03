extends Control

const DUPE_ICON = preload("res://sprites/dupe.png")
const EDIT_ICON = preload("res://sprites/edit.png")
const VAR_ICON = preload("res://sprites/var.png")
const PLUS_ICON = preload("res://sprites/plus.png")
const MINUS_ICON = preload("res://sprites/minus.png")


@onready var item_tree: Tree = $Tree
@onready var detail_container: VBoxContainer = $Details/VBoxContainer
@onready var details: Control = $Details
@onready var menu: PanelContainer = $"../Menu"

var tree_root: TreeItem = null
var old_name: String = ""

signal title_changed()


func _ready() -> void:
	# Set forge
	Global.forge = self
	# Make sure hidden
	if details.is_visible():
		# Hide
		details.hide()
	# Make sure hidden
	if is_visible():
		# Hide
		hide()


func start_new() -> void:
	# Clear tree
	item_tree.clear()
	# Check if visible
	if details.is_visible():
		# Hide details
		details.hide()
	# Create root
	_create_root()
	# Show
	show()


func reload() -> void:
	# Start new
	start_new()
	# Set title
	menu._set_title()
	# Set var
	var branch
	# Create braches
	for key in Global.tree:
		# Check if dictionary
		if Global.tree is Dictionary:
			# Check if button exists
			if tree_root.get_button_count(0) == 2:
				# Erase button
				if Global.tree_button_disable:
					tree_root.set_button_disabled(0, 0, true)
				else:
					tree_root.erase_button(0,0)
			# Set var
			var branch1
			# Create branch
			branch = _create_branch(key, tree_root, Global.branch1_colour)
			# Check if dictionary
			if Global.tree[key] is Dictionary:
				# Check if button exists
				if branch.get_button_count(0) == 4:
					# Erase button
					if Global.tree_button_disable:
						branch.set_button_disabled(0, 0, true)
					else:
						branch.erase_button(0,0)
				# Set var
				var branch2
				# Create branchs
				for key1 in Global.tree[key]:
					# Create branch
					branch1 = _create_branch(key1, branch, Global.branch2_colour)
					# Check if dictionary
					if Global.tree[key][key1] is Dictionary:
						# Check if button exists
						if branch1.get_button_count(0) == 4:
							# Erase button
							if Global.tree_button_disable:
								branch1.set_button_disabled(0, 0, true)
							else:
								branch1.erase_button(0,0)
						# Set var
						var branch3
						# Create branches
						for key2 in Global.tree[key][key1]:
							# Create branch
							branch2 = _create_branch(key2, branch1, Global.branch3_colour)
							# Check if dictionary
							if Global.tree[key][key1][key2] is Dictionary:
								# Check if button exists
								if branch2.get_button_count(0) == 4:
									# Erase button
									if Global.tree_button_disable:
										branch2.set_button_disabled(0, 0, true)
									else:
										branch2.erase_button(0,0)
								# Create branches
								for key3 in Global.tree[key][key1][key2]:
									# Create branch
									branch3 = _create_branch(key3, branch2, Global.branch4_colour)
									# Check if dictionary
									if Global.tree[key][key1][key2][key3] is Dictionary:
										# Check if button exists
										if branch3.get_button_count(0) == 4:
											# Erase button
											if Global.tree_button_disable:
												branch3.set_button_disabled(0, 0, true)
											else:
												branch3.erase_button(0,0)
										# Create branches
										for key4 in Global.tree[key][key1][key2][key3]:
											# Create branch
											_create_branch(key4, branch3, Global.branch5_colour)
									else:
										# Check if array
										if Global.tree[key][key1][key2][key3] is Array:
											# Loop through vars
											for v in Global.tree[key][key1][key2][key3]:
												# Create var
												_create_var(branch3, false, str(v))
										else:
											# Create var
											_create_var(branch3)
										# Check if button exists
										if branch3.get_button_count(0) == 4:
											# Erase button
											if Global.tree_button_disable:
												branch3.set_button_disabled(0, 0, true)
											else:
												branch3.erase_button(0,3)
							else:
								# Check if array
								if Global.tree[key][key1][key2] is Array:
									# Loop through vars
									for v in Global.tree[key][key1][key2]:
										# Create var
										_create_var(branch2, false, str(v))
								else:
									# Create var
									_create_var(branch2)
								# Check if button exists
								if branch2.get_button_count(0) == 4:
									# Erase button
									if Global.tree_button_disable:
										branch2.set_button_disabled(0, 3, true)
									else:
										branch2.erase_button(0,3)
					else:
						# Check if array
						if Global.tree[key][key1] is Array:
							# Loop through vars
							for v in Global.tree[key][key1]:
								# Create var
								_create_var(branch1, false, str(v))
						else:
							# Create var
							_create_var(branch1)
						# Check if button exists
						if branch1.get_button_count(0) == 4:
							# Erase button
							if Global.tree_button_disable:
								branch1.set_button_disabled(0, 3, true)
							else:
								branch1.erase_button(0,3)
			else:
				# Check if array
				if Global.tree[key] is Array:
					# Loop through vars
					for v in Global.tree[key]:
						# Create var
						_create_var(branch, false, str(v))
				else:
					# Create var
					_create_var(branch)
				# Check if button exists
				if branch.get_button_count(0) == 4:
					# Erase button
					if Global.tree_button_disable:
						branch.set_button_disabled(0, 3, true)
					else:
						branch.erase_button(0,3)
		else:
			# Create var
			_create_var(tree_root, false, str(key))
			# Check if button exists
			if tree_root.get_button_count(0) == 2:
				# Erase button
				if Global.tree_button_disable:
					tree_root.set_button_disabled(0, 1, true)
				else:
					tree_root.erase_button(0,1)


func _input(event: InputEvent) -> void:
	# Check event
	if event.is_action_pressed("ui_cancel"):# or event.is_action_pressed("ui_accept"):
		# Deselect tree
		item_tree.deselect_all()
		# Check if visible
		if details.is_visible():
			# Hide details
			details.hide()


func _duplicate_branch(target_branch: TreeItem) -> void:
	# Set var 
	#var data = null
	# Get count
	var count = target_branch.get_parent().get_child_count()
	# Set name
	var txt = target_branch.get_text(0) + "-Duplicate" +str(count)
	# Check if root
	if target_branch.get_parent() == tree_root:
		# Add To tree
		Global.tree[txt] = Global.tree[target_branch.get_text(0)].duplicate(true)
		# Set data
		#data = Global.tree[txt]
	elif target_branch.get_parent().get_parent() == tree_root:
		# Add To tree
		Global.tree[target_branch.get_parent().get_text(0)][txt] = Global.tree[target_branch.get_parent().get_text(0)][target_branch.get_text(0)].duplicate(true)
		# Set data
		#data = Global.tree[target_branch.get_parent().get_text(0)][txt]
	elif target_branch.get_parent().get_parent().get_parent() == tree_root:
		# Add To tree
		Global.tree[target_branch.get_parent().get_parent().get_text(0)][target_branch.get_parent().get_text(0)][txt] = Global.tree[target_branch.get_parent().get_parent().get_text(0)][target_branch.get_parent().get_text(0)][target_branch.get_text(0)].duplicate(true)
		# Set data
		#data = Global.tree[target_branch.get_parent().get_parent().get_text(0)][target_branch.get_parent().get_text(0)][txt]
	elif target_branch.get_parent().get_parent().get_parent().get_parent() == tree_root:
		# Add To tree
		Global.tree[target_branch.get_parent().get_parent().get_parent().get_text(0)][target_branch.get_parent().get_parent().get_text(0)][target_branch.get_parent().get_text(0)][txt] = Global.tree[target_branch.get_parent().get_parent().get_parent().get_text(0)][target_branch.get_parent().get_parent().get_text(0)][target_branch.get_parent().get_text(0)][target_branch.get_text(0)].duplicate(true)
		# Set data
		#data = Global.tree[target_branch.get_parent().get_parent().get_parent().get_text(0)][target_branch.get_parent().get_parent().get_text(0)][target_branch.get_parent().get_text(0)][txt]
	elif target_branch.get_parent().get_parent().get_parent().get_parent().get_parent() == tree_root:
		# Add To tree
		Global.tree[target_branch.get_parent().get_parent().get_parent().get_parent().get_text(0)][target_branch.get_parent().get_parent().get_parent().get_text(0)][target_branch.get_parent().get_parent().get_text(0)][target_branch.get_parent().get_text(0)][txt] = Global.tree[target_branch.get_parent().get_parent().get_parent().get_parent().get_text(0)][target_branch.get_parent().get_parent().get_parent().get_text(0)][target_branch.get_parent().get_parent().get_text(0)][target_branch.get_parent().get_text(0)][target_branch.get_text(0)].duplicate(true)
		# Set data
		#data = Global.tree[target_branch.get_parent().get_parent().get_parent().get_parent().get_text(0)][target_branch.get_parent().get_parent().get_parent().get_text(0)][target_branch.get_parent().get_parent().get_text(0)][target_branch.get_parent().get_text(0)][txt]
	# Reload
	reload()
	# Duplaicate
	#_duplicate(target_branch)


#func _duplicate(target_branch: TreeItem, txt: String = "") ->void:
	## Copy settings
	#var colour = target_branch.get_custom_color
	## Create _branch
	#_create_branch(txt, target_branch.get_parent(), colour)
#
	## Recursively duplicate all child items of the source_tree_item
	#var child = target_branch.get_first_child()
	#while child:
		#_duplicate(child, txt)
		#child = child.get_next()


func _create_var(target_branch: TreeItem, old_branch: bool = false, txt: String = "") -> void:
	# Create 
	var varr = item_tree.create_item(target_branch)
	# Check if txt set
	if txt == "":
		# Check if root
		if target_branch == tree_root:
			# Check if old branch
			if old_branch:
				# Reset var
				Global.tree = [null]
			# Get txt
			txt = str(null)
		elif target_branch.get_parent() == tree_root:
			# Check if old branch
			if old_branch:
				# Reset var
				Global.tree[target_branch.get_text(0)] = null
			# Get txt
			txt = str(Global.tree[target_branch.get_text(0)])
		elif target_branch.get_parent().get_parent() == tree_root:
			# Check if old branch
			if old_branch:
				# Reset var
				Global.tree[target_branch.get_parent().get_text(0)][target_branch.get_text(0)] = null
			# Get txt
			txt = str(Global.tree[target_branch.get_parent().get_text(0)][target_branch.get_text(0)])
		elif target_branch.get_parent().get_parent().get_parent() == tree_root:
			# Check if old branch
			if old_branch:
				# Reset var
				Global.tree[target_branch.get_parent().get_parent().get_text(0)][target_branch.get_parent().get_text(0)][target_branch.get_text(0)] = null
			# Get txt
			txt = str(Global.tree[target_branch.get_parent().get_parent().get_text(0)][target_branch.get_parent().get_text(0)][target_branch.get_text(0)])
		elif target_branch.get_parent().get_parent().get_parent().get_parent() == tree_root:
			# Check if old branch
			if old_branch:
				# Reset var
				Global.tree[target_branch.get_parent().get_parent().get_parent().get_text(0)][target_branch.get_parent().get_parent().get_text(0)][target_branch.get_parent().get_text(0)][target_branch.get_text(0)] = null
			# Get txt
			txt = str(Global.tree[target_branch.get_parent().get_parent().get_parent().get_text(0)][target_branch.get_parent().get_parent().get_text(0)][target_branch.get_parent().get_text(0)][target_branch.get_text(0)])
		elif target_branch.get_parent().get_parent().get_parent().get_parent().get_parent() == tree_root:
			# Check if old branch
			if old_branch:
				# Reset var
				Global.tree[target_branch.get_parent().get_parent().get_parent().get_parent().get_text(0)][target_branch.get_parent().get_parent().get_parent().get_text(0)][target_branch.get_parent().get_parent().get_text(0)][target_branch.get_parent().get_text(0)][target_branch.get_text(0)] = null
			# Get txt
			txt = str(Global.tree[target_branch.get_parent().get_parent().get_parent().get_parent().get_text(0)][target_branch.get_parent().get_parent().get_parent().get_text(0)][target_branch.get_parent().get_parent().get_text(0)][target_branch.get_parent().get_text(0)][target_branch.get_text(0)])
	# Set text
	varr.set_text(0, txt)
	# Set branch
	varr.set_selectable(0, true)
	varr.set_editable(0, false)
	varr.set_custom_color(0, Global.var_colour)


func _create_branch(txt: String, target_branch: TreeItem, colour: Color) -> TreeItem:
	# Create 
	var branch = item_tree.create_item(target_branch)
	# Set text
	branch.set_text(0, txt)
	# Set branch
	branch.set_editable(0, true)
	branch.set_custom_color(0, colour)
	# Set leaf var
	var leaf = false
	# Check color
	if colour == Global.branch5_colour:
		# Set leaf
		leaf = true
		# Add var
		_create_var(branch)
	# Add buttons
	_create_buttons(branch, leaf)
	# Return branch
	return branch


func _create_root() -> void:
	# Create 
	var root = item_tree.create_item()
	# Set text
	root.set_text(0, Global.tree_name)
	# Set root
	root.set_editable(0, true)
	root.set_custom_color(0, Global.root_colour)
	# Add buttons
	_create_buttons(root)
	# Set tree root
	tree_root = root


func _create_buttons(target_branch: TreeItem, leaf: bool = false) -> void:
	# Check if root
	if target_branch.get_text(0) == Global.tree_name:
		# Add buttons
		target_branch.add_button(0, VAR_ICON, 0, false, "Set as variable/ Open details")
		target_branch.add_button(0, PLUS_ICON, 2, false, "Add branch")
	elif leaf:
		# Add buttons
		target_branch.add_button(0, VAR_ICON, 0, false, "Set as variable/ Open details")
		target_branch.add_button(0, DUPE_ICON, 3, false, "Duplicate branch")
		target_branch.add_button(0, MINUS_ICON, 1, false, "Remove branch")
		if Global.tree_button_disable:
			target_branch.add_button(0, PLUS_ICON, 2, true, "Add branch")
	else:
		# Add buttons
		target_branch.add_button(0, VAR_ICON, 0, false, "Set as variable/ Open details")
		target_branch.add_button(0, DUPE_ICON, 3, false, "Duplicate branch")
		target_branch.add_button(0, MINUS_ICON, 1, false, "Remove branch")
		target_branch.add_button(0, PLUS_ICON, 2, false, "Add branch")


func _on_tree_button_clicked(item: TreeItem, _column: int, id: int, _mouse_button_index: int) -> void:
	# Check id
	match id:
		0:
			# Select
			item.select(0)
			# Check text
			if "Branch" in item.get_text(0):
				# Set text
				var txt = item.get_text(0)
				old_name = txt
				var begin = txt.substr(0, txt.length() -8)
				txt = txt.substr(txt.length() -8)
				txt = txt.replace("Branch", "Leaf")
				txt = begin + txt
				# Check change
				if item.get_text(0) != txt:
					item.set_text(0, txt)
					_on_tree_item_edited(item)
			# Check if new var
			if item.get_child_count() == 0:
				# Create var
				_create_var(item, true)
				# Check if root
				if item == tree_root:
					# Erase button
					if Global.tree_button_disable:
						item.set_button_disabled(0, 1, true)
					else:
						item.erase_button(0,1)
			# Show details
			details.setup(item, tree_root)
			# Check if button exists
			if item.get_button_count(0) == 4:
				# Erase button
				if Global.tree_button_disable:
					item.set_button_disabled(0, 3, true)
				else:
					item.erase_button(0,3)
		1:
			# Ask
			Ask.ask()
			# Wait for signal
			await Ask.respond
			# Check response
			if Ask.response:
				# Check if root
				if item.get_parent() == tree_root:
					# Remove from tree
					Global.tree.erase(item.get_text(0))
				elif item.get_parent().get_parent() == tree_root:
					# Remove from tree
					Global.tree[item.get_parent().get_text(0)].erase(item.get_text(0))
				elif item.get_parent().get_parent().get_parent() == tree_root:
					# Remove from tree
					Global.tree[item.get_parent().get_parent().get_text(0)][item.get_parent().get_text(0)].erase(item.get_text(0))
				elif item.get_parent().get_parent().get_parent().get_parent() == tree_root:
					# Remove from tree
					Global.tree[item.get_parent().get_parent().get_parent().get_text(0)][item.get_parent().get_parent().get_text(0)][item.get_parent().get_text(0)].erase(item.get_text(0))
				elif item.get_parent().get_parent().get_parent().get_parent().get_parent() == tree_root:
					# Remove from tree
					Global.tree[item.get_parent().get_parent().get_parent().get_parent().get_text(0)][item.get_parent().get_parent().get_parent().get_text(0)][item.get_parent().get_parent().get_text(0)][item.get_parent().get_text(0)].erase(item.get_text(0))
				# Delete Branch
				await get_tree().process_frame
				item.free()
		2:
			# Set vars
			var count = -1
			var txt = ""
			var colour = Global.branch1_colour
			# Check if root
			if item == tree_root:
				# Set count
				count = item.get_child_count()
				# Set txt
				txt = item.get_text(0) +"-Branch" + str(count)
				# Add to tree
				Global.tree[txt] = {}
				# Check if button exists
				if item.get_button_count(0) == 2:
					# Erase button
					if Global.tree_button_disable:
						item.set_button_disabled(0, 0, true)
					else:
						item.erase_button(0,0)
			elif item.get_parent() == tree_root:
				# Set count
				count = item.get_child_count()
				# Set txt
				txt = item.get_text(0) +"-Branch" + str(count)
				colour = Global.branch2_colour
				# Add to tree
				Global.tree[item.get_text(0)][txt] = {}
			elif item.get_parent().get_parent() == tree_root:
				# Set count
				count = item.get_child_count()
				# Set txt
				txt = item.get_text(0) +"-Branch" + str(count)
				colour = Global.branch3_colour
				# Add to tree
				Global.tree[item.get_parent().get_text(0)][item.get_text(0)][txt] = {}
			elif item.get_parent().get_parent().get_parent() == tree_root:
				# Set count
				count = item.get_child_count()
				# Set txt
				txt = item.get_text(0) +"-Branch" + str(count)
				colour = Global.branch4_colour
				# Add to tree
				Global.tree[item.get_parent().get_parent().get_text(0)][item.get_parent().get_text(0)][item.get_text(0)][txt] = {}
			elif item.get_parent().get_parent().get_parent().get_parent() == tree_root:
				# Set count
				count = item.get_child_count()
				# Set txt
				txt = item.get_text(0) +"-Leaf" + str(count)
				colour = Global.branch5_colour
				# Add to tree
				Global.tree[item.get_parent().get_parent().get_parent().get_text(0)][item.get_parent().get_parent().get_text(0)][item.get_parent().get_text(0)][item.get_text(0)][txt] = null
			if count != -1:
				# Add branch
				_create_branch(txt, item, colour)
				# Check if button exists
				if item.get_button_count(0) == 4:
					# Erase button
					if Global.tree_button_disable:
						item.set_button_disabled(0, 0, true)
					else:
						item.erase_button(0,0)
		3:
			_duplicate_branch(item)


func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		# Check button
		if event.get_button_index() == MOUSE_BUTTON_LEFT:
			# Check pressed
			if event.is_pressed():
				# Check selected
				#if item_tree.get_selected() != null:
				# Deselect tree
				item_tree.deselect_all()
				# Check if visible
				if details.is_visible():
					# Hide details
					details.hide()


func _on_tree_item_edited(target: TreeItem = item_tree.get_edited()) -> void:
	# Check if oldname set
	if old_name != "" and old_name != target.get_text(0):
		# Check if root
		if target == tree_root:
			# Set tree name
			Global.tree_name = tree_root.get_text(0)
			# Emit signal
			title_changed.emit()
		elif target.get_parent() == tree_root:
			# Set with new name
			Global.tree[target.get_text(0)] = Global.tree[old_name]
			# Erase old
			Global.tree.erase(old_name)
		elif target.get_parent().get_parent() == tree_root:
			# Set with new name
			Global.tree[target.get_parent().get_text(0)][target.get_text(0)] = Global.tree[target.get_parent().get_text(0)][old_name]
			# Clear old
			Global.tree[target.get_parent().get_text(0)].erase(old_name)
		elif target.get_parent().get_parent().get_parent() == tree_root:
			# Set with new name
			Global.tree[target.get_parent().get_parent().get_text(0)][target.get_parent().get_text(0)][target.get_text(0)] = Global.tree[target.get_parent().get_parent().get_text(0)][target.get_parent().get_text(0)][old_name]
			# Clear old
			Global.tree[target.get_parent().get_parent().get_text(0)][target.get_parent().get_text(0)].erase(old_name)
		# Reset old name
		old_name = ""


func _on_tree_item_selected() -> void:
	# Get item
	var item = item_tree.get_selected()
	# Check if editable
	if item.is_editable(0):
		# Set old name
		old_name = item.get_text(0)
	else:
		# Select
		item.get_parent().select(0)
		# Show details
		details.setup(item.get_parent(), tree_root)
