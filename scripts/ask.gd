extends Control

@onready var canvas_layer: CanvasLayer = $CanvasLayer

var response: bool = false

signal respond()

func ask() -> void:
	# Show
	canvas_layer.show()


func _on_yes_button_pressed() -> void:
	# Hide
	canvas_layer.hide()
	# Set response
	response = true
	# Emit signal
	respond.emit()


func _on_no_button_pressed() -> void:
	# Hide
	canvas_layer.hide()
	# Set response
	response = false
	# Emit signal
	respond.emit()
