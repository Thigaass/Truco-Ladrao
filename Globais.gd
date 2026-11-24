extends Node
var baralho: Array[Carta] = []
var maoP: Array[Carta] = []
var maoO: Array[Carta] = []
var poder_esc: int = 0
var poder_us: bool = false
var arg_carta: bool = false
var arg_troca: bool = false
var musica: AudioStreamPlayer
func parar_musica() -> void:
	if is_instance_valid(musica):
		musica.stop()
func poder() -> void:
	if poder_us or arg_carta or arg_troca:
		return
	match poder_esc:
		1:
			arg_carta = true
		2:
			arg_troca = true
		3:
			print("poder3")
		4:
			print("poder4")
func sprite_poder(botao: TextureButton) -> void:
	var caminho := "res://sprites/PlaceHolders/Poder_" + str(poder_esc) + ".png"
	if ResourceLoader.exists(caminho):
		botao.texture_normal = load(caminho)
	else:
		botao.texture_normal = load("res://sprites/PlaceHolders/Butao.png")
	
	match poder_esc:
		1:
			botao.position = Vector2(1025, 1010)
			botao.scale = Vector2(0.08, 0.08)
		2:
			botao.position = Vector2(1025, 1025)
			botao.scale = Vector2(0.3, 0.3)
		_:
			botao.position = Vector2(1025, 1010)
			botao.scale = Vector2(1.0, 1.0)
func distribuir() -> void:
	for carta in baralho:
		carta.valor = carta.valor_base
	baralho.shuffle()
	maoP = baralho.slice(0,3)
	maoO = baralho.slice(3,6)
