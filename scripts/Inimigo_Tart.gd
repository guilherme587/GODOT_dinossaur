extends KinematicBody2D

onready var colisao_frente			:Node = $colisao_frente
onready var estaNa_plataforma		:Node = $estaNa_plataforma
onready var anim_sprite					:Node = $AnimatedSprite
var vida			:int		 = 100
var dano			:int		 = 100
var dir_x			:int		 = 0
var direc			:int 		 = 1
var dir_y			:int		 = 0
var acel			:int		 = 50
const COOLDOWN		:int		 = 2
var longe			:bool		 = false
var virar			:bool		 = true
var pode_atacar		:bool		 = true
var posi_inicial 	:Vector2 	 = Vector2.ZERO
var hited			:bool		 = false
enum {
	PARADO, ANDANDO, HITED
}
var state = PARADO

func _ready():
	posi_inicial = self.global_position;

func respaw() -> void:
	if self.global_position[1] > 1000:
		dir_y					 = 0
		self.global_position	 = posi_inicial

func _physics_process(delta) -> void:
	respaw();
	dano();
	
	if dir_x != 0:
		state = ANDANDO
	else:
		state = PARADO
	if hited:
		state = HITED
	match state:
		PARADO:
			anim_sprite.play("parado")
		ANDANDO:
			anim_sprite.play("andando")
		HITED:
			anim_sprite.play("hited")
			yield(anim_sprite, "animation_finished")
			hited = false
	
	var up				:Vector2 	= Vector2(0, -1)
	var minha_posi		:Vector2	= self.global_position
	# var player_posi		:Vector2	= get_parent().get_children()[0].global_position
	# var dist			:Vector2 	= minha_posi - player_posi
	dir_x = 0
	
	# movimentação do pet
	if not is_on_floor():
		dir_y 	+= 9.86
	else:
		dir_y 	= 0
	
	# config orientação do pet
	if colisao_frente.is_colliding() or not estaNa_plataforma.is_colliding():
		colisao_frente.rotation_degrees *= -1
		direc *= -1
	
	dir_x += direc * acel;
	
	if dir_x > 0:
		virar = false
	if dir_x < 0:
		virar = true
	
	anim_sprite.flip_h = virar

	move_and_slide( Vector2(dir_x, dir_y), up )

func dano():
	var inimigo:Object = colisao_frente.get_collider()
	
	if is_instance_valid(inimigo):
		if inimigo.has_method("hited"):
			if pode_atacar:
				inimigo.hited(dano)
				pode_atacar = false
				yield(get_tree().create_timer(COOLDOWN), "timeout")
				pode_atacar = true

func hited(dano) -> void:
	if vida > 0:
		vida -= dano;
		hited = true
	if vida <= 0:
		Global.pontos += 100
		colisao_frente.enabled = false
		anim_sprite.play("hited")
		yield(anim_sprite, "animation_finished")
		hited = false
		self.queue_free()

# func pular() -> void:
# 	if  is_on_floor():
# 		if $pular_plataforma.is_colliding():
# 			dir_y -= 300;
# 		elif not $pular_abismo.is_colliding():
# 			dir_y -= 300;
# 			acel = 400
