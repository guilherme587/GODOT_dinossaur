extends KinematicBody2D

enum {
	PARADO, PULO, PULO_UP, PULO_DOWN, ATAQUE, HITED, QUICANDO, ANDANDO
}
var state = PARADO
var dino_adulto					:Object				= preload("res://cenas/palyer/Dino_adulto.tscn")
var teste						:Object				= preload("res://cenas/palyer/companheiro_doPalyer/Amigo_sauro.tscn")
onready var anim				:Node				= $anim
onready var anim_sprite			:Node				= $Dino

func _ready() -> void:
	Global.posi_inicial = self.global_position;
	Global.mao = $mao
	Global.pontos = 100

func respaw() -> void:
	if self.global_position[1] > 1000:
		Global.vida -= 100;
		self.global_position = Global.posi_queda;
	if Global.vida <= 0:
		get_tree().change_scene(get_tree().current_scene.filename)
		self.global_position = Global.posi_inicial;
		Global.vida = 300;

func _physics_process(delta):
	if Global.dir_x != 0 and ( $peh_0.is_colliding() or $peh_1.is_colliding() ):
		state = ANDANDO
	else:
		state = PARADO
	if not Global.hited:
		if Global.dir_y < 0:
			state = PULO_UP
	elif Global.dir_y > 0:
		state = PULO_DOWN
	elif Global.hited:
		state = HITED
	if  ($peh_0.is_colliding() and $peh_1.is_colliding() ) and Input.is_action_pressed("ui_up"):
		state = PULO
	match state:
		PARADO:
			anim_sprite.play("parado")
		ANDANDO:
			anim_sprite.play("andando")
		PULO:
			anim_sprite.play("pulo")
		PULO_UP:
			anim_sprite.play("pulo_up")
		PULO_DOWN:
			anim_sprite.play("pulo_down")
		ATAQUE:
			anim_sprite.play("ataque")
		QUICANDO:
			anim_sprite.play("quicando_na_cabeca_dele")
			yield(anim_sprite, "animation_finished")
		HITED:
			anim_sprite.play("hited")
			yield(anim_sprite, "animation_finished")
			Global.hited 					= false
			state 							= PARADO
			$CollisionShape2D.disabled		= false
	
	if Global.montando or Global.hited:
		return 0
	
	respaw()
	dano()
	ainm_vida()
	
	var acel		:int 		= 200
	var vel			:float 		= 1.0
	var forca_pulo	:float 		= 250.0
	Global.dir_x 				= 0.0
	Global.posi_player			= self.global_position
	Global.mao.global_position = $mao.global_position
	
	if Input.is_action_just_pressed("ui_montar"):
		if $colisaoFrente.is_colliding():
			var montaria:Object = $colisaoFrente.get_collider();
			if montaria.is_in_group("companheiro"):
				Global.montando			= true
				montaria.montaria 		= true
	if not $peh_0.is_colliding() or not $peh_1.is_colliding():
		Global.dir_y 			+= 9.86
		acel 					= 100
		$pisao.enabled 			= true
	else:
		Global.dir_y 			= 0
		$pisao.enabled 			= false
		Global.hited			= false
	if $peh_0.is_colliding() or $peh_1.is_colliding():
		Global.posi_queda = self.global_position + (Vector2(32, 0) * (-1 if not Global.olhando_dir else 1) )
	if Input.is_action_pressed("ui_up"):
		if $peh_0.is_colliding() or $peh_1.is_colliding():
			Global.dir_y 	= 0
			Global.dir_y 	-= forca_pulo
	if Input.is_action_pressed("ui_right"):
		Global.dir_x 			+= vel * acel;
		anim_sprite.flip_h 		= false
		Global.olhando_dir		= false
		$peh_0.position[0] = -8
		$colisaoFrente.cast_to = Vector2(0, 14);
	if Input.is_action_pressed("ui_left"):
		Global.dir_x 				-= vel * acel;
		anim_sprite.flip_h 			= true
		Global.olhando_dir			= true
		$peh_0.position[0] = 8
		$colisaoFrente.cast_to = Vector2(0, -14);
	if Input.is_action_just_pressed("ui_dash") and not Global.adulto:
		Global.dir_x += -Global.dist_dash	if Global.olhando_dir else Global.dist_dash
		
	move_and_slide( Vector2(Global.dir_x, Global.dir_y));

func set_olhar() -> void:
	if Global.olhando_dir == true:
		Global.offset -= 1
		# print("esquerda ", $camera.get_offset() );
	if Global.olhando_dir == false:
		Global.offset += 1
		# print("direita ", $camera.get_offset() );
	if Global.offset > 100:
		Global.offset = 100
	
	$camera.set_h_offset(Global.offset);

func dano():
	var inimigo:Object = $pisao.get_collider()
	
	if is_instance_valid(inimigo):
		if inimigo.has_method("hited") and not Global.hited:
			inimigo.hited(Global.dano)
			state = QUICANDO
			Global.dir_y 	= 0
			Global.dir_y 	-= 200
			yield(anim_sprite, "animation_finished")
			state = PARADO
			
func hited(dano):
	if Global.vida > 0:
		$CollisionShape2D.disabled = true
		Global.vida 	-= dano
		Global.dir_x 	+= 350 if Global.olhando_dir else -350
		Global.dir_y 	= 0
		Global.dir_y 	-= 150
		Global.hited 	= true
		state 			= HITED
		move_and_slide( Vector2(Global.dir_x, Global.dir_y))
	else:
		respaw();
		
func ainm_vida():
	anim.play("sem_anim")
#	if Global.vida >= 300:
#		anim.play("vida_cheia")
#	elif Global.vida >= 200:
#		anim.play("vida_meia")
#	else:
#		anim.play("pouca_vida")
