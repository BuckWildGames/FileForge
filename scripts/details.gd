extends Control

const ARRAY_ELEMENT = preload("res://scenes/array_element.tscn")

@onready var label: Label = $VBoxContainer/Label
@onready var text_edit: TextEdit = $VBoxContainer/TypeContainer/String/TextEdit
@onready var spin_box: SpinBox = $VBoxContainer/TypeContainer/Numeral/SpinBox
@onready var array_container: VBoxContainer = $VBoxContainer/TypeContainer/Array/ScrollContainer/ArrayContainer
@onready var type_container: TabContainer = $VBoxContainer/TypeContainer
@onready var check_button: CheckButton = $VBoxContainer/TypeContainer/Bool/CheckButton

var target: TreeItem = null
var root: TreeItem = null

signal element_get_id()

func setup(target_branch: TreeItem, tree_root: TreeItem) -> void:
	# Clear
	_clear()
	# Set target
	target = target_branch
	# Set root
	root = tree_root
	# Set text
	label.set_text(target_branch.get_text(0))
	# Enable clear tab
	type_container.set_tab_disabled(4, false)
	# Set varr
	var varr = null
	# Check if root
	if target == root:
		# Add to tree
		varr = Global.tree
		# Disable clear tab
		type_container.set_tab_disabled(4, true)
	elif target.get_parent() == root:
		# Add to tree
		varr = Global.tree[target.get_text(0)]
	elif target.get_parent().get_parent() == root:
		# Add to tree
		varr = Global.tree[target.get_parent().get_text(0)][target.get_text(0)]
	elif target.get_parent().get_parent().get_parent() == root:
		# Add to tree
		varr = Global.tree[target.get_parent().get_parent().get_text(0)][target.get_parent().get_text(0)][target.get_text(0)]
	elif target.get_parent().get_parent().get_parent().get_parent() == root:
		# Add to tree
		varr = Global.tree[target.get_parent().get_parent().get_parent().get_text(0)][target.get_parent().get_parent().get_text(0)][target.get_parent().get_text(0)][target.get_text(0)]
	elif target.get_parent().get_parent().get_parent().get_parent().get_parent() == root:
		# Add to tree
		varr = Global.tree[target.get_parent().get_parent().get_parent().get_parent().get_text(0)][target.get_parent().get_parent().get_parent().get_text(0)][target.get_parent().get_parent().get_text(0)][target.get_parent().get_text(0)][target.get_text(0)]
	# Check var
	if varr != null:
		if varr is String:
			# Set text edit
			text_edit.set_block_signals(true)
			text_edit.insert_text_at_caret(varr)
			await get_tree().create_timer(0.1).timeout
			text_edit.set_block_signals(false)
			# Set current tab
			type_container.set_current_tab(0)
			_disable_tabs(0)
		elif varr is int or varr is float:
			# Set spin box
			spin_box.set_value_no_signal(varr)
			# Set current tab
			type_container.set_current_tab(1)
			_disable_tabs(1)
		elif varr is bool:
			# Set spin box
			check_button.set_pressed_no_signal(varr)
			check_button.set_text(str(varr))
			# Set current tab
			type_container.set_current_tab(2)
			_disable_tabs(2)
		elif varr is Array:
			# Set current tab
			type_container.set_current_tab(3)
			_disable_tabs(3)
			# Setup array
			for a in varr:
				# Create element
				_create_element(a)
	# Show
	show()


func _clear() -> void:
	# Reset target
	#target = null
	#root = null
	# Clear all values
	text_edit.clear()
	spin_box.set_value_no_signal(0)
	check_button.set_pressed_no_signal(false)
	check_button.set_text("false")
	for i in array_container.get_children():
		i.queue_free()
	# Enable tabs
	type_container.set_tab_disabled(0, false)
	type_container.set_tab_disabled(1, false)
	type_container.set_tab_disabled(2, false)
	type_container.set_tab_disabled(3, false)


func _disable_tabs(safe_tab: int) -> void:
	# Match safe tab
	match safe_tab:
		0:
			type_container.set_tab_disabled(1, true)
			type_container.set_tab_disabled(2, true)
			type_container.set_tab_disabled(3, true)
		1:
			type_container.set_tab_disabled(0, true)
			type_container.set_tab_disabled(2, true)
			type_container.set_tab_disabled(3, true)
		2:
			type_container.set_tab_disabled(1, true)
			type_container.set_tab_disabled(0, true)
			type_container.set_tab_disabled(3, true)
		3:
			type_container.set_tab_disabled(1, true)
			type_container.set_tab_disabled(0, true)
			type_container.set_tab_disabled(2, true)


func _create_element(value = null) -> void:
	# Create element
	var el = ARRAY_ELEMENT.instantiate()
	# Add to container
	array_container.add_child(el)
	# Set element
	el.setup(target, root, self, value)
	# Wait
	await get_tree().process_frame
	# Emit signal
	element_get_id.emit()
	# Add spacer
	#array_container.add_spacer(false)


func _update_tree() -> void:
	# Set var
	var txt = []
	# Check if root
	if target == root:
		# Loop through var
		for v in Global.tree:
			# Set var text
			txt.append(str(v))
	elif target.get_parent() == root:
		# Check if array
		if Global.tree[target.get_text(0)] is Array:
			# Loop through var
			for v in Global.tree[target.get_text(0)]:
				# Set var text
				txt.append(str(v))
		else:
			# Set var text
				txt.append(str(Global.tree[target.get_text(0)]))
	elif target.get_parent().get_parent() == root:
		# Check if array
		if Global.tree[target.get_parent().get_text(0)][target.get_text(0)] is Array:
			# Loop through var
			for v in Global.tree[target.get_parent().get_text(0)][target.get_text(0)]:
				# Set var text
				txt.append(str(v))
		else:
			# Set var text
				txt.append(str(Global.tree[target.get_parent().get_text(0)][target.get_text(0)]))
	elif target.get_parent().get_parent().get_parent() == root:
		# Check if array
		if Global.tree[target.get_parent().get_parent().get_text(0)][target.get_parent().get_text(0)][target.get_text(0)] is Array:
			# Loop through var
			for v in Global.tree[target.get_parent().get_parent().get_text(0)][target.get_parent().get_text(0)][target.get_text(0)]:
				# Set var text
				txt.append(str(v))
		else:
			# Set var text
				txt.append(str(Global.tree[target.get_parent().get_parent().get_text(0)][target.get_parent().get_text(0)][target.get_text(0)]))
	elif target.get_parent().get_parent().get_parent().get_parent() == root:
		# Check if array
		if Global.tree[target.get_parent().get_parent().get_parent().get_text(0)][target.get_parent().get_parent().get_text(0)][target.get_parent().get_text(0)][target.get_text(0)] is Array:
			# Loop through var
			for v in Global.tree[target.get_parent().get_parent().get_parent().get_text(0)][target.get_parent().get_parent().get_text(0)][target.get_parent().get_text(0)][target.get_text(0)]:
				# Set var text
				txt.append(str(v))
		else:
			# Set var text
				txt.append(str(Global.tree[target.get_parent().get_parent().get_parent().get_text(0)][target.get_parent().get_parent().get_text(0)][target.get_parent().get_text(0)][target.get_text(0)]))
	elif target.get_parent().get_parent().get_parent().get_parent().get_parent() == root:
		# Check if array
		if Global.tree[target.get_parent().get_parent().get_parent().get_parent().get_text(0)][target.get_parent().get_parent().get_parent().get_text(0)][target.get_parent().get_parent().get_text(0)][target.get_parent().get_text(0)][target.get_text(0)] is Array:
			# Loop through var
			for v in Global.tree[target.get_parent().get_parent().get_parent().get_parent().get_text(0)][target.get_parent().get_parent().get_parent().get_text(0)][target.get_parent().get_parent().get_text(0)][target.get_parent().get_text(0)][target.get_text(0)]:
				# Set var text
				txt.append(str(v))
		else:
			# Set var text
				txt.append(str(Global.tree[target.get_parent().get_parent().get_parent().get_parent().get_text(0)][target.get_parent().get_parent().get_parent().get_text(0)][target.get_parent().get_parent().get_text(0)][target.get_parent().get_text(0)][target.get_text(0)]))
	# Loop through children
	for t in txt.size():
		# Update var
		target.get_child(t).set_text(0, txt[t])


func _on_add_element_button_pressed() -> void:
	# Check target
	if target != null:
		# Disable tabs
		_disable_tabs(3)
		# Set var
		var new_array = false
		# Check if root
		if target == root:
			# Check if array
			if Global.tree is not Array:
				# Add to tree
				Global.tree = [null]
				# Set new array
				new_array = true
			else:
				# Add to tree
				Global.tree.append(null)
		elif target.get_parent() == root:
			# Check if array
			if Global.tree[target.get_text(0)] is not Array:
				# Add to tree
				Global.tree[target.get_text(0)] = [null]
				# Set new array
				new_array = true
			else:
				# Add to tree
				Global.tree[target.get_text(0)].append(null)
		elif target.get_parent().get_parent() == root:
			# Check if array
			if Global.tree[target.get_parent().get_text(0)][target.get_text(0)] is not Array:
				# Add to tree
				Global.tree[target.get_parent().get_text(0)][target.get_text(0)] = [null]
				# Set new array
				new_array = true
			else:
				# Add to tree
				Global.tree[target.get_parent().get_text(0)][target.get_text(0)].append(null)
		elif target.get_parent().get_parent().get_parent() == root:
			# Check if array
			if Global.tree[target.get_parent().get_parent().get_text(0)][target.get_parent().get_text(0)][target.get_text(0)] is not Array:
				# Add to tree
				Global.tree[target.get_parent().get_parent().get_text(0)][target.get_parent().get_text(0)][target.get_text(0)] = [null]
				# Set new array
				new_array = true
			else:
				# Add to tree
				Global.tree[target.get_parent().get_parent().get_text(0)][target.get_parent().get_text(0)][target.get_text(0)].append(null)
		elif target.get_parent().get_parent().get_parent().get_parent() == root:
			# Check if array
			if Global.tree[target.get_parent().get_parent().get_parent().get_text(0)][target.get_parent().get_parent().get_text(0)][target.get_parent().get_text(0)][target.get_text(0)] is not Array:
				# Add to tree
				Global.tree[target.get_parent().get_parent().get_parent().get_text(0)][target.get_parent().get_parent().get_text(0)][target.get_parent().get_text(0)][target.get_text(0)] = [null]
				# Set new array
				new_array = true
			else:
				# Add to tree
				Global.tree[target.get_parent().get_parent().get_parent().get_text(0)][target.get_parent().get_parent().get_text(0)][target.get_parent().get_text(0)][target.get_text(0)].append(null)
		elif target.get_parent().get_parent().get_parent().get_parent().get_parent() == root:
			# Check if array
			if Global.tree[target.get_parent().get_parent().get_parent().get_parent().get_text(0)][target.get_parent().get_parent().get_parent().get_text(0)][target.get_parent().get_parent().get_text(0)][target.get_parent().get_text(0)][target.get_text(0)] is not Array:
				# Add to tree
				Global.tree[target.get_parent().get_parent().get_parent().get_parent().get_text(0)][target.get_parent().get_parent().get_parent().get_text(0)][target.get_parent().get_parent().get_text(0)][target.get_parent().get_text(0)][target.get_text(0)] = [null]
				# Set new array
				new_array = true
			else:
				# Add to tree
				Global.tree[target.get_parent().get_parent().get_parent().get_parent().get_text(0)][target.get_parent().get_parent().get_parent().get_text(0)][target.get_parent().get_parent().get_text(0)][target.get_parent().get_text(0)][target.get_text(0)].append(null)
		# Creat element
		_create_element()
		# Check new array
		if not new_array:
			# Create var
			get_parent()._create_var(target, false, str(null))


func _on_text_edit_text_changed() -> void:
	# Check target
	if target != null:
		# Disable tabs
		_disable_tabs(0)
		# Check if root
		if target.get_parent() == root:
			# Add to tree
			Global.tree[target.get_text(0)] = text_edit.get_text()
		elif target.get_parent().get_parent() == root:
			# Add to tree
			Global.tree[target.get_parent().get_text(0)][target.get_text(0)] = text_edit.get_text()
		elif target.get_parent().get_parent().get_parent() == root:
			# Add to tree
			Global.tree[target.get_parent().get_parent().get_text(0)][target.get_parent().get_text(0)][target.get_text(0)] = text_edit.get_text()
		elif target.get_parent().get_parent().get_parent().get_parent() == root:
			# Add to tree
			Global.tree[target.get_parent().get_parent().get_parent().get_text(0)][target.get_parent().get_parent().get_text(0)][target.get_parent().get_text(0)][target.get_text(0)] = text_edit.get_text()
		elif target.get_parent().get_parent().get_parent().get_parent().get_parent() == root:
			# Add to tree
			Global.tree[target.get_parent().get_parent().get_parent().get_parent().get_text(0)][target.get_parent().get_parent().get_parent().get_text(0)][target.get_parent().get_parent().get_text(0)][target.get_parent().get_text(0)][target.get_text(0)] = text_edit.get_text()
		# Update tree
		_update_tree()


func _on_spin_box_value_changed(value: float) -> void:
	# Check target
	if target != null:
		# Disable tabs
		_disable_tabs(1)
		# Check if root
		if target.get_parent() == root:
			# Add to tree
			Global.tree[target.get_text(0)] = value
		elif target.get_parent().get_parent() == root:
			# Add to tree
			Global.tree[target.get_parent().get_text(0)][target.get_text(0)] = value
		elif target.get_parent().get_parent().get_parent() == root:
			# Add to tree
			Global.tree[target.get_parent().get_parent().get_text(0)][target.get_parent().get_text(0)][target.get_text(0)] = value
		elif target.get_parent().get_parent().get_parent().get_parent() == root:
			# Add to tree
			Global.tree[target.get_parent().get_parent().get_parent().get_text(0)][target.get_parent().get_parent().get_text(0)][target.get_parent().get_text(0)][target.get_text(0)] = value
		elif target.get_parent().get_parent().get_parent().get_parent().get_parent() == root:
			# Add to tree
			Global.tree[target.get_parent().get_parent().get_parent().get_parent().get_text(0)][target.get_parent().get_parent().get_parent().get_text(0)][target.get_parent().get_parent().get_text(0)][target.get_parent().get_text(0)][target.get_text(0)] = value
		# Update tree
		_update_tree()


func _on_check_button_toggled(toggled_on: bool) -> void:
	# Check target
	if target != null:
		# Set text
		check_button.set_text(str(toggled_on))
		# Disable tabs
		_disable_tabs(2)
		# Check if root
		if target.get_parent() == root:
			# Add to tree
			Global.tree[target.get_text(0)] = toggled_on
		elif target.get_parent().get_parent() == root:
			# Add to tree
			Global.tree[target.get_parent().get_text(0)][target.get_text(0)] = toggled_on
		elif target.get_parent().get_parent().get_parent() == root:
			# Add to tree
			Global.tree[target.get_parent().get_parent().get_text(0)][target.get_parent().get_text(0)][target.get_text(0)] = toggled_on
		elif target.get_parent().get_parent().get_parent().get_parent() == root:
			# Add to tree
			Global.tree[target.get_parent().get_parent().get_parent().get_text(0)][target.get_parent().get_parent().get_text(0)][target.get_parent().get_text(0)][target.get_text(0)] = toggled_on
		elif target.get_parent().get_parent().get_parent().get_parent().get_parent() == root:
			# Add to tree
			Global.tree[target.get_parent().get_parent().get_parent().get_parent().get_text(0)][target.get_parent().get_parent().get_parent().get_text(0)][target.get_parent().get_parent().get_text(0)][target.get_parent().get_text(0)][target.get_text(0)] = toggled_on
		# Update tree
		_update_tree()


func _on_clear_button_pressed() -> void:
	# Check target
	if target != null:
		# Clear
		_clear()
		# Check if root
		if target.get_parent() == root:
			# Add to tree
			Global.tree[target.get_text(0)] = null
		elif target.get_parent().get_parent() == root:
			# Add to tree
			Global.tree[target.get_parent().get_text(0)][target.get_text(0)] = null
		elif target.get_parent().get_parent().get_parent() == root:
			# Add to tree
			Global.tree[target.get_parent().get_parent().get_text(0)][target.get_parent().get_text(0)][target.get_text(0)] = null
		elif target.get_parent().get_parent().get_parent().get_parent() == root:
			# Add to tree
			Global.tree[target.get_parent().get_parent().get_parent().get_text(0)][target.get_parent().get_parent().get_text(0)][target.get_parent().get_text(0)][target.get_text(0)] = null
		elif target.get_parent().get_parent().get_parent().get_parent().get_parent() == root:
			# Add to tree
			Global.tree[target.get_parent().get_parent().get_parent().get_parent().get_text(0)][target.get_parent().get_parent().get_parent().get_text(0)][target.get_parent().get_parent().get_text(0)][target.get_parent().get_text(0)][target.get_text(0)] = null
		# Find child
		for c in target.get_child_count() - 1:
			# Check if first
			if c == 0:
				# Set text
				target.get_child(c).set_text(0, str(null))
			else:
				# Destroy it
				await get_tree().process_frame
				target.get_child(c).free()
		# Update tree
		_update_tree()


func _on_visibility_changed() -> void:
	# Check visible
	if not is_visible() and target != null:
		# Update tree
		_update_tree()
		# Clear
		_clear()
