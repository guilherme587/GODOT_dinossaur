extends KinematicBody2D

onready var colisao_frente			:Node = $colisao_frente
onready var estaNa_plataforma		:Node = $estaNa_plataforma
onready var anim_sprite					:Node = $AnimatedSprite
var vida			:int		 = 100
var dano			:int		 = 100
var direc			:int 		 = 1
var dir_x			:int		 = 0
var dir_y			:int		 = 0
var forca_pulo		:int		 = 150
var acel			:int		 = 50
var longe			:bool		 = false
var virar			:bool		 = true
var pode_atacar		:bool		 = true
var hited			:bool		 = false
const COOLDOWN		:int		 = 1
enum {
	PARADO, ANDANDO, HITED
}
var state = PARADO

func _ready():
	get_player_posi()

func respaw() -> void:
	if self.global_position[1] > 1000 or vida <= 0:
		self.global_position = Vector2(430, 230)

func get_player_posi( lista :Array =  get_parent().get_parent().get_children() ) -> Vector2:
	for i in lista:
		if i.name == "player":
			return i.global_position
	
	return Vector2.ZERO

func _physics_process(delta) -> void:
	respaw()
	dano()
	
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
	
	var minha_posi		:Vector2	= self.global_position
	var player_posi		:Vector2	= get_player_posi()
	var dist			:Vector2 	= minha_posi - player_posi
	dir_x = 0
	
	# movimentação do pet
	if not is_on_floor():
		dir_y += 9.86
	else:
		dir_y = 0
	if not longe:
		# config orientação do pet
		if colisao_frente.is_colliding() or not estaNa_plataforma.is_colliding():
			colisao_frente.rotation_degrees *= -1
			direc *= -1
		
		dir_x += direc * acel
		
		if dir_x > 0:
			virar = false
		if dir_x < 0:
			virar = true
	
	else:
		if colisao_frente.is_colliding():
			dir_y = 0
			dir_y -= forca_pulo
		if player_posi[0] < minha_posi[0]:
			dir_x -= 1 * acel;
		if player_posi[0] > minha_posi[0]:
			dir_x += 1 * acel;
	
		if dir_x > 0 and abs(dist[0]) > 16:
			virar = false
		if dir_x < 0 and abs(dist[0]) < 16:
			virar = true
	
	anim_sprite.flip_h = virar

	move_and_slide( Vector2(dir_x, dir_y))

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
		vida -= dano
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
# 			dir_y -= 300
# 		elif not $pular_abismo.is_colliding():
# 			dir_y -= 300
# 			acel = 400

func _on_Area2D_body_entered(body):
	if body.name == "player":
		longe = true
		$Area2D/CollisionShape2D.get_shape().set_radius(105)

func _on_Area2D_body_exited(body):
	if body.name == "player":
		longe = false
		$Area2D/CollisionShape2D.get_shape().set_radius(65)
