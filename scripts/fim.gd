extends Control

var reiniciando := false

func _process(_delta: float) -> void:
	if not reiniciando and Input.is_action_just_pressed("ui_accept"):
		reiniciar()

func reiniciar() -> void:
	if reiniciando:
		return
	reiniciando = true
	get_tree().change_scene_to_file.call_deferred("res://scenes/vila.tscn")
