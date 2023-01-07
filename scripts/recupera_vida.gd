extends Area2D

func _ready():
	$anim.play("flutuando");
	$anim.set_speed_scale(.25);

func _physics_process(delta):
	if $tocandoNo_chao.is_colliding():
		self.global_position[1] -= 1;

func _on_recupera_vida_body_entered(body):
	var vida = 100;
	if body.name == "player":
		body.vida += vida;
		$anim.play("coletado");
		$anim.set_speed_scale(2);
		yield($anim, "animation_finished");
		queue_free();
