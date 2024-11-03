extends TabContainer

const ARRAY_ELEMENT = preload("res://scenes/array_element.tscn")

@onready var text_edit: TextEdit = $String/TextEdit
@onready var spin_box: SpinBox = $Numeral/SpinBox
@onready var check_button: CheckButton = $Bool/CheckButton

var id: int = -1
var target: TreeItem = null
var root: TreeItem = null
var detail: Node = null


func setup(target_branch: TreeItem, tree_root: TreeItem, details: Node, val = null) -> void:
	# Set target
	target = target_branch
	# Set root
	root = tree_root
	# Set detail
	detail = details
	# Connect signal
	detail.connect("element_get_id", _get_id)
	# Check val
	if val != null:
		if val is String:
			# Set text edit
			text_edit.set_block_signals(true)
			text_edit.insert_text_at_caret(val)
			await get_tree().create_timer(0.1).timeout
			text_edit.set_block_signals(false)
			# Set current tab
			set_current_tab(0)
			_disable_tabs(0)
		elif val is int or val is float:
			# Set spin box
			spin_box.set_value_no_signal(val)
			# Set current tab
			set_current_tab(1)
			_disable_tabs(1)
		if val is bool:
			# Set text edit
			check_button.set_pressed_no_signal(val)
			check_button.set_text(str(val))
			# Set current tab
			set_current_tab(2)
			_disable_tabs(2)


func _get_id() -> void:
	# Set id
	id = get_index()


func _disable_tabs(safe_tab: int) -> void:
	# Match safe tab
	match safe_tab:
		0:
			set_tab_disabled(1, true)
			set_tab_disabled(2, true)
		1:
			set_tab_disabled(0, true)
			set_tab_disabled(2, true)
		2:
			set_tab_disabled(1, true)
			set_tab_disabled(0, true)



#func _on_add_element_button_pressed() -> void:
	## Disable tabs
	#_disable_tabs(2)
	## Check if root
	#if target.get_parent() == root:
		## Check if array
		#if Global.tree[target.get_text(0)][id] is not Array:
			## Add to tree
			#Global.tree[target.get_text(0)][id] = []
	#elif target.get_parent().get_parent() == root:
		## Check if array
		#if Global.tree[target.get_parent().get_text(0)][target.get_text(0)][id] is not Array:
			## Add to tree
			#Global.tree[target.get_parent().get_text(0)][target.get_text(0)][id] = []
	#elif target.get_parent().get_parent().get_parent() == root:
		## Check if array
		#if Global.tree[target.get_parent().get_parent().get_text(0)][target.get_parent().get_text(0)][target.get_text(0)][id] is not Array:
			## Add to tree
			#Global.tree[target.get_parent().get_parent().get_text(0)][target.get_parent().get_text(0)][target.get_text(0)][id] = []
	## Create element
	#var el = ARRAY_ELEMENT.instantiate()
	## Add to tree
	## Add to container
	#array_container.add_child(el)
	#array_container.add_spacer(false)


func _on_text_edit_text_changed() -> void:
	# Check target
	if target != null and id != -1:
		print("HMM")
		# Disable tabs
		_disable_tabs(0)
		# Check if root
		if target == root:
			# Add to tree
			Global.tree[id] = text_edit.get_text()
		elif target.get_parent() == root:
			# Add to tree
			Global.tree[target.get_text(0)][id] = text_edit.get_text()
		elif target.get_parent().get_parent() == root:
			# Add to tree
			Global.tree[target.get_parent().get_text(0)][target.get_text(0)][id] = text_edit.get_text()
		elif target.get_parent().get_parent().get_parent() == root:
			# Add to tree
			Global.tree[target.get_parent().get_parent().get_text(0)][target.get_parent().get_text(0)][target.get_text(0)][id] = text_edit.get_text()
		elif target.get_parent().get_parent().get_parent().get_parent() == root:
			# Add to tree
			Global.tree[target.get_parent().get_parent().get_parent().get_text(0)][target.get_parent().get_parent().get_text(0)][target.get_parent().get_text(0)][target.get_text(0)][id] = text_edit.get_text()
		elif target.get_parent().get_parent().get_parent().get_parent().get_parent() == root:
			# Add to tree
			Global.tree[target.get_parent().get_parent().get_parent().get_parent().get_text(0)][target.get_parent().get_parent().get_parent().get_text(0)][target.get_parent().get_parent().get_text(0)][target.get_parent().get_text(0)][target.get_text(0)][id] = text_edit.get_text()
		# Update tree
		detail._update_tree()


func _on_spin_box_value_changed(value: float) -> void:
	# Check target
	if target != null and id != -1:
		# Disable tabs
		_disable_tabs(1)
		# Check if root
		if target == root:
			# Add to tree
			Global.tree[id] = value
		elif target.get_parent() == root:
			# Add to tree
			Global.tree[target.get_text(0)][id] = value
		elif target.get_parent().get_parent() == root:
			# Add to tree
			Global.tree[target.get_parent().get_text(0)][target.get_text(0)][id] = value
		elif target.get_parent().get_parent().get_parent() == root:
			# Add to tree
			Global.tree[target.get_parent().get_parent().get_text(0)][target.get_parent().get_text(0)][target.get_text(0)][id] = value
		elif target.get_parent().get_parent().get_parent().get_parent() == root:
			# Add to tree
			Global.tree[target.get_parent().get_parent().get_parent().get_text(0)][target.get_parent().get_parent().get_text(0)][target.get_parent().get_text(0)][target.get_text(0)][id] = value
		elif target.get_parent().get_parent().get_parent().get_parent().get_parent() == root:
			# Add to tree
			Global.tree[target.get_parent().get_parent().get_parent().get_parent().get_text(0)][target.get_parent().get_parent().get_parent().get_text(0)][target.get_parent().get_parent().get_text(0)][target.get_parent().get_text(0)][target.get_text(0)][id] = value
		# Update tree
		detail._update_tree()


func _on_check_button_toggled(toggled_on: bool) -> void:
	# Check target
	if target != null and id != -1:
		# Set text
		check_button.set_text(str(toggled_on))
		# Disable tabs
		_disable_tabs(2)
		# Check if root
		if target == root:
			# Add to tree
			Global.tree[id] = toggled_on
		elif target.get_parent() == root:
			# Add to tree
			Global.tree[target.get_text(0)][id] = toggled_on
		elif target.get_parent().get_parent() == root:
			# Add to tree
			Global.tree[target.get_parent().get_text(0)][target.get_text(0)][id] = toggled_on
		elif target.get_parent().get_parent().get_parent() == root:
			# Add to tree
			Global.tree[target.get_parent().get_parent().get_text(0)][target.get_parent().get_text(0)][target.get_text(0)][id] = toggled_on
		elif target.get_parent().get_parent().get_parent().get_parent() == root:
			# Add to tree
			Global.tree[target.get_parent().get_parent().get_parent().get_text(0)][target.get_parent().get_parent().get_text(0)][target.get_parent().get_text(0)][target.get_text(0)][id] = toggled_on
		elif target.get_parent().get_parent().get_parent().get_parent().get_parent() == root:
			# Add to tree
			Global.tree[target.get_parent().get_parent().get_parent().get_parent().get_text(0)][target.get_parent().get_parent().get_parent().get_text(0)][target.get_parent().get_parent().get_text(0)][target.get_parent().get_text(0)][target.get_text(0)][id] = toggled_on
		# Update tree
		detail._update_tree()


func _on_delete_button_pressed() -> void:
	# Check if last
	if target.get_child_count() > 1:
		# Set var
		var varr = null
		if target == root:
			# Set var
			varr = Global.tree[id]
			# # Remove from tree
			Global.tree.erase(Global.tree[id])
		# Check if root
		elif target.get_parent() == root:
			# Set var
			varr = Global.tree[target.get_text(0)][id]
			# # Remove from tree
			Global.tree[target.get_text(0)].erase(Global.tree[target.get_text(0)][id])
		elif target.get_parent().get_parent() == root:
			# Set var
			varr = Global.tree[target.get_parent().get_text(0)][target.get_text(0)][id]
			# Remove from tree
			Global.tree[target.get_parent().get_text(0)][target.get_text(0)].erase(Global.tree[target.get_parent().get_text(0)][target.get_text(0)][id])
		elif target.get_parent().get_parent().get_parent() == root:
			# Set var
			varr = Global.tree[target.get_parent().get_parent().get_text(0)][target.get_parent().get_text(0)][target.get_text(0)][id]
			# # Remove from tree
			Global.tree[target.get_parent().get_parent().get_text(0)][target.get_parent().get_text(0)][target.get_text(0)].erase(Global.tree[target.get_parent().get_parent().get_text(0)][target.get_parent().get_text(0)][target.get_text(0)][id])
		elif target.get_parent().get_parent().get_parent().get_parent() == root:
			# Set var
			varr = Global.tree[target.get_parent().get_parent().get_parent().get_text(0)][target.get_parent().get_parent().get_text(0)][target.get_parent().get_text(0)][target.get_text(0)][id]
			# # Remove from tree
			Global.tree[target.get_parent().get_parent().get_parent().get_text(0)][target.get_parent().get_parent().get_text(0)][target.get_parent().get_text(0)][target.get_text(0)].erase(Global.tree[target.get_parent().get_parent().get_parent().get_text(0)][target.get_parent().get_parent().get_text(0)][target.get_parent().get_text(0)][target.get_text(0)][id])
		elif target.get_parent().get_parent().get_parent().get_parent().get_parent() == root:
			# Set var
			varr = Global.tree[target.get_parent().get_parent().get_parent().get_parent().get_text(0)][target.get_parent().get_parent().get_parent().get_text(0)][target.get_parent().get_parent().get_text(0)][target.get_parent().get_text(0)][target.get_text(0)][id]
			# # Remove from tree
			Global.tree[target.get_parent().get_parent().get_parent().get_parent().get_text(0)][target.get_parent().get_parent().get_parent().get_text(0)][target.get_parent().get_parent().get_text(0)][target.get_parent().get_text(0)][target.get_text(0)].erase(Global.tree[target.get_parent().get_parent().get_parent().get_parent().get_text(0)][target.get_parent().get_parent().get_parent().get_text(0)][target.get_parent().get_parent().get_text(0)][target.get_parent().get_text(0)][target.get_text(0)][id])
		# Set var
		var del = false
		# Find child
		for c in target.get_child_count() - 1:
			# Check if var
			if target.get_child(c).get_text(0) == str(varr) and not del:
				# Set del
				del = true
				# Destroy it
				await get_tree().process_frame
				target.get_child(c).free()
	else:
		# Add fresh element
		detail._create_element()
		# Enable tabs
		#set_tab_disabled(1, false)
		#set_tab_disabled(0, false)
		# Set text
		target.get_child(0).set_text(0, str(null))
	# Delete
	queue_free()


func _on_tree_exited() -> void:
	# Emit signal
	detail.element_get_id.emit()
