extends CanvasLayer

func get_player( lista :Array = get_parent().get_children() ) -> KinematicBody2D:
	for i in lista:
		if i.name == "player":
			return i;
	
	return null;

func _physics_process(delta):
	var player = get_player()
	
	if player != null:
		$player_vida/player_bar.rect_scale.x = float( Global.vida/Global.VIDA_MAX )
		$osso/Label.text = str(Global.pontos)
