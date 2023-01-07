extends Control

var dir 					:float	 = .45
var sg						:bool	 = false
var og 						:bool	 = false
var eg 						:bool	 = false
onready var butao_start		:Button	 = $MarginContainer/VBoxContainer/start
onready var butao_options	:Button	 = $MarginContainer/VBoxContainer/options
onready var butao_exit		:Button	 = $MarginContainer/VBoxContainer/exit
onready var titulo 			:Label	 = $CenterContainer/VBoxContainer/Label

func _physics_process(delta):
	if Input.is_action_just_pressed("ui_esc"):
		get_tree().change_scene( str(Global.ultima_cena) )
	
	if titulo.rect_position.y <= -18:
		dir *= -1
	if titulo.rect_position.y >= 6:
		dir *= -1
	
	titulo.rect_position.y += dir
	
	if sg:
		var _dir = 1
		if butao_start.rect_position.x == 32:
			_dir *= 0
		butao_start.rect_position.x += _dir
	else:
		var _dir = -1
		if butao_start.rect_position.x == 0:
			_dir *= 0
		butao_start.rect_position.x += _dir
	if og:
		var _dir = 1
		if butao_options.rect_position.x == 32:
			_dir *= 0
		butao_options.rect_position.x += _dir
	else:
		var _dir = -1
		if butao_options.rect_position.x == 0:
			_dir *= 0
		butao_options.rect_position.x += _dir
	if eg:
		var _dir = 1
		if butao_exit.rect_position.x == 32:
			_dir *= 0
		butao_exit.rect_position.x += _dir
	else:
		var _dir = -1
		if butao_exit.rect_position.x == 0:
			_dir *= 0
		butao_exit.rect_position.x += _dir

func _on_start_pressed():
	get_tree().change_scene("res://fases/fase_0/fase_0.tscn")

func _on_options_pressed():
	OS.window_fullscreen = not OS.window_fullscreen

func _on_exit_pressed():
	get_tree().quit()



func _on_start_mouse_entered():
	butao_start.set_modulate( Color(0.7, 0.7, 0.7, 1) )
	sg = true


func _on_start_mouse_exited():
	butao_start.set_modulate( Color(1, 1, 1, 1) )
	sg = false


func _on_options_mouse_entered():
	butao_options.set_modulate( Color(0.7, 0.7, 0.7, 1) )
	og = true


func _on_options_mouse_exited():
	butao_options.set_modulate( Color(1, 1, 1, 1) )
	og = false


func _on_exit_mouse_entered():
	butao_exit.set_modulate( Color(0.7, 0.7, 0.7, 1) )
	eg = true

func _on_exit_mouse_exited():
	butao_exit.set_modulate( Color(1, 1, 1,1) )
	eg = false
