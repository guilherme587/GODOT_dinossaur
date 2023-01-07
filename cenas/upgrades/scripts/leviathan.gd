extends RigidBody2D

var dir						:Vector2	= Vector2(0, 0)
onready var mira			:Node2D		= $mira
var na_mao 					:bool		= false
var no_chao 				:bool		= false
var reload					:bool		= false
var vel						:int 		= 650
var dano 					:int 		= 1 * Global.pontos
var vel_rot					:float		= 100
var travar_rot_noChao		:float		= 0
var travar_posi_noChao		:Vector2	= Vector2.ZERO
var alvos					:Array		= []

func _physics_process(delta):
	if get_parent().get_player() == null:
		return 0
	if no_chao:
		self.rotation_degrees	= travar_rot_noChao
		self.global_position	= travar_posi_noChao
	if na_mao:
		if Input.is_action_pressed("ui_mouse_mira"):
			olhar_para_o_mouse()
		elif Input.is_action_pressed("ui_mira"):
			if Global.dir_x != 0 or Global.dir_y != 0:
				mira()
			mira()
		else:
			mira.visible = false
		if Input.is_action_just_pressed("ui_attack"):
			ataque()
	if not na_mao and not no_chao:
		self.rotation_degrees += 20
	if Input.is_action_just_pressed("ui_reload") and not na_mao:
		reload = true
		vel = 1050
		self.look_at( Global.mao.global_position )
		dir = Vector2( cos(global_rotation), sin(global_rotation) ).normalized()
		no_chao				 = false
	if na_mao:
		vel = 650
		self.global_position = get_parent().get_player().global_position
		if Global.olhando_dir:
			$Machado.flip_h = true
		if not Global.olhando_dir:
			$Machado.flip_h = false

	self.translate( dir * delta * vel )

func distance_to(par):
	return sqrt( pow( (self.global_position.x - par.global_position.x) , 2) + pow( (self.global_position.y - par.global_position.y) , 2))

func olhar_para_o_mouse():
	mira.global_position = get_global_mouse_position()
	self.look_at( get_global_mouse_position() )

func mira():
	if alvos.empty():
		return 0
		mira.global_position = self.global_position
	var alvo_naMira 		:Object		= alvos[0]
	var maisPerto			:float		= self.distance_to(alvos[0])
	
	mira.visible = true
	
#	print("nimimigos[0]: ", inimigos[0])
	
	for alvo in alvos:
		if self.distance_to(alvo) < maisPerto:
			alvo_naMira = alvo
#	print("alvo: ", alvo)
#	print("alvo.global_position: ", alvo.global_position)
#	print("\n")
	self.look_at(alvo_naMira.global_position)
	mira.global_position = alvo_naMira.global_position

func _on_Area2D_body_entered(body):
	if body.collision_layer == 512 and not reload:
		dir = Vector2(0, 0)
		vel_rot					= 0
		no_chao					= true
		travar_rot_noChao		= self.rotation_degrees
		travar_posi_noChao		= self.global_position
	if body.collision_layer == 1:
		na_mao = true
		reload = false
		Global.dir_y		 = 0
		Global.dir_y		 -= 300
	if not na_mao or not no_chao:
		if is_instance_valid(body):
			if not na_mao and not no_chao:
				if body.has_method("hited"):
					body.hited(dano)

func ataque():
	reload		 = false
	na_mao		 = false
	no_chao		 = false
	mira.visible = false
	dir = Vector2( cos(global_rotation), sin(global_rotation) ).normalized()
	self.position.y -= 20


func _on_Area2D2_body_entered(body):
	alvos.append(body)


func _on_Area2D2_body_exited(body):
	alvos.remove( alvos.find(body) )
