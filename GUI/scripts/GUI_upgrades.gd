extends CanvasLayer

var leviathan :Object = preload("res://cenas/upgrades/leviathan.tscn")

func _ready():
	self.visible = false

func _process(delta):
	if Input.is_action_just_pressed("ui_tab"):
		if not get_tree().paused:
			self.visible = true
			get_tree().paused = true
		else:
			get_tree().paused = false
			self.visible = false
	if Input.is_action_just_pressed("ui_esc") and self.visible:
		get_tree().paused = false
		self.visible = false


func _on_up_0_button_pressed():
	Global.pontos += 100
	Global.pontos -= 300000


func _on_up_1_button_button_down():
	Global.pontos += 200
	Global.pontos -= 100000


func _on_up_2_button_button_down():
	Global.dist_dash 	+= 3000
	Global.pontos 		-= 5000


func _on_up_3_button_button_down():
	if Global.mao == null:
		return 0
	var leviathan_intance = leviathan.instance()
	get_parent().add_child(leviathan_intance)
	leviathan_intance.global_position = Global.mao.global_position
	Global.pontos -= 1000000


func _on_up_0_button_mouse_entered():
	$VBoxContainer/HB_up_0/up_0_button.set_modulate( Color(0.7,0.7,0.7,1) )


func _on_up_0_button_mouse_exited():
	$VBoxContainer/HB_up_0/up_0_button.set_modulate( Color(1,1,1,1) )


func _on_up_1_button_mouse_entered():
	$VBoxContainer/HB_up_1/up_1_button.set_modulate( Color(0.7,0.7,0.7,1) )


func _on_up_1_button_mouse_exited():
	$VBoxContainer/HB_up_1/up_1_button.set_modulate( Color(1,1,1,1) )


func _on_up_2_button_mouse_entered():
	$VBoxContainer/HB_up_2/up_2_button.set_modulate( Color(0.7,0.7,0.7,1) )


func _on_up_2_button_mouse_exited():
	$VBoxContainer/HB_up_2/up_2_button.set_modulate( Color(1,1,1,1) )


func _on_up_3_button_mouse_entered():
	$VBoxContainer/HB_up_3/up_3_button.set_modulate( Color(0.7,0.7,0.7,1) )


func _on_up_3_button_mouse_exited():
	$VBoxContainer/HB_up_3/up_3_button.set_modulate( Color(1,1,1,1) )
