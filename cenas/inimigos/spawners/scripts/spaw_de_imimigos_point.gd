extends Node2D

onready var timer			:Timer		= $Timer
export var inimigo_tipo 	:String 	= "tart"
var inimigo 				:Object 	= null
var cooldown				:bool		= true
var pode_ser_atacado		:bool		= true
const COOLDOWN				:int		= 5
const MAX_INIMIGOS			:int		= 20
var vida					:int		= 1000

enum {
	PADRAO,
	HITED
}
var state = PADRAO

func _ready():
	if inimigo_tipo == "sauro":
		inimigo = preload("res://cenas/inimigos/Inimigo_sauro.tscn")
	if inimigo_tipo == "tart":
		inimigo = preload("res://cenas/inimigos/Inimigo_Tart.tscn")


func _physics_process(delta):
	match state:
		PADRAO:
			$AnimatedSprite.play("default")
		HITED:
			$AnimatedSprite.play("hited")
	
	if get_tree().get_nodes_in_group("inimigo").size() > MAX_INIMIGOS:
		return 0
	if cooldown:
		var instancia_inimigo = inimigo.instance()
#		var node = get_parent().get_parent().noh_inimigos()
		var node = get_parent()
		node.add_child(instancia_inimigo)
		instancia_inimigo.global_position = $Position2D.global_position
		cooldown = false
		timer.start(COOLDOWN)

func hited(dano) -> void:
	if vida > 0 and pode_ser_atacado:
		vida -= dano
		state = HITED
		pode_ser_atacado = false
		yield($AnimatedSprite, "animation_finished")
		state = PADRAO
		pode_ser_atacado = true
	if vida <= 0:
		Global.pontos += 5000
		self.queue_free()

func _on_Timer_timeout():
	print("timer")
	cooldown = true
