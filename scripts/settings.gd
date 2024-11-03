extends Control

@onready var canvas_layer: CanvasLayer = $CanvasLayer
@onready var disable_button: CheckButton = $CanvasLayer/PanelContainer/VBoxContainer/HBoxContainer/VBoxContainer/HBoxContainer/DisableButton
@onready var disable_button_overlay: Button = $CanvasLayer/DisableButton
@onready var click_button: CheckButton = $CanvasLayer/PanelContainer/VBoxContainer/HBoxContainer/VBoxContainer/ClickButton
@onready var ask_button: CheckButton = $CanvasLayer/PanelContainer/VBoxContainer/HBoxContainer/VBoxContainer/AskButton
@onready var full_screen_button: CheckButton = $CanvasLayer/PanelContainer/VBoxContainer/HBoxContainer/VBoxContainer/FullScreenButton
@onready var root_colour: ColorPickerButton = $CanvasLayer/PanelContainer/VBoxContainer/HBoxContainer/VBoxContainer2/HBoxContainer/RootColour
@onready var branch_1_colour: ColorPickerButton = $CanvasLayer/PanelContainer/VBoxContainer/HBoxContainer/VBoxContainer2/HBoxContainer2/Branch1Colour
@onready var branch_2_colour: ColorPickerButton = $CanvasLayer/PanelContainer/VBoxContainer/HBoxContainer/VBoxContainer2/HBoxContainer3/Branch2Colour
@onready var branch_3_colour: ColorPickerButton = $CanvasLayer/PanelContainer/VBoxContainer/HBoxContainer/VBoxContainer2/HBoxContainer4/Branch3Colour
@onready var branch_4_colour: ColorPickerButton = $CanvasLayer/PanelContainer/VBoxContainer/HBoxContainer/VBoxContainer2/HBoxContainer5/Branch4Colour
@onready var branch_5_colour: ColorPickerButton = $CanvasLayer/PanelContainer/VBoxContainer/HBoxContainer/VBoxContainer2/HBoxContainer6/Branch5Colour
@onready var var_colour: ColorPickerButton = $CanvasLayer/PanelContainer/VBoxContainer/HBoxContainer/VBoxContainer2/HBoxContainer7/VarColour

var forge: Node = null

func setup(forge_node: Node) -> void:
	# Set forge
	forge = forge_node
	# Setup buttons
	disable_button.set_pressed_no_signal(Global.tree_button_disable)
	disable_button_overlay.set_pressed_no_signal(Global.tree_button_disable)
	click_button.set_pressed_no_signal(Global.click_sound)
	ask_button.set_pressed_no_signal(Global.ask_close)
	full_screen_button.set_pressed_no_signal(Global.start_full)
	root_colour.set_pick_color(Global.root_colour)
	branch_1_colour.set_pick_color(Global.branch1_colour)
	branch_2_colour.set_pick_color(Global.branch2_colour)
	branch_3_colour.set_pick_color(Global.branch3_colour)
	branch_4_colour.set_pick_color(Global.branch4_colour)
	branch_5_colour.set_pick_color(Global.branch5_colour)
	var_colour.set_pick_color(Global.var_colour)
	# Show
	canvas_layer.show()


func _on_disable_button_toggled(toggled_on: bool) -> void:
	# Set
	Global.tree_button_disable = toggled_on
	disable_button.set_pressed_no_signal(Global.tree_button_disable)


func _on_click_button_toggled(toggled_on: bool) -> void:
	# Set
	Global.click_sound = toggled_on


func _on_ask_button_toggled(toggled_on: bool) -> void:
	# Set
	Global.ask_close = toggled_on


func _on_full_screen_button_toggled(toggled_on: bool) -> void:
	# Set
	Global.start_full = toggled_on


func _on_root_colour_color_changed(color: Color) -> void:
	# Set
	Global.root_colour = color


func _on_branch_1_colour_color_changed(color: Color) -> void:
	# Set
	Global.branch1_colour = color


func _on_branch_2_colour_color_changed(color: Color) -> void:
	# Set
	Global.branch2_colour = color


func _on_branch_3_colour_color_changed(color: Color) -> void:
	# Set
	Global.branch3_colour = color


func _on_branch_4_colour_color_changed(color: Color) -> void:
	# Set
	Global.branch4_colour = color


func _on_branch_5_colour_color_changed(color: Color) -> void:
	# Set
	Global.branch5_colour = color


func _on_var_colour_color_changed(color: Color) -> void:
	# Set
	Global.var_colour = color


func _on_default_button_pressed() -> void:
	# Set colours
	Global.root_colour = Global.DEFAULT_ROOT_COLOUR
	Global.branch1_colour = Global.DEFAULT_BRANCH1_COLOUR
	Global.branch2_colour = Global.DEFAULT_BRANCH2_COLOUR
	Global.branch3_colour = Global.DEFAULT_BRANCH3_COLOUR
	Global.branch4_colour = Global.DEFAULT_BRANCH4_COLOUR
	Global.branch5_colour = Global.DEFAULT_BRANCH5_COLOUR
	Global.var_colour = Global.DEFAULT_VAR_COLOUR
	# Reset
	setup(forge)


func _on_close_button_pressed() -> void:
	# Check if tree exists
	if Global.tree.size() > 0:
		# Reload
		forge.reload()
	# Hide
	canvas_layer.hide()
