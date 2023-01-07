extends Area2D

func _ready():
	$anim.play("default");

func _physics_process(delta):
	if $tocandoNo_chao.is_colliding():
		self.global_position[1] -= 1


func _on_craniopowerUP_body_entered(body):
	var vida = 200
	if body.name == "player":
		if Global.vida >= 300:
			Global.pontos += vida
			queue_free()
			return 0
		Global.vida += vida;
		$anim.play("default")
		$anim.set_speed_scale(2)
		yield($anim,"frame_changed")
		queue_free()
