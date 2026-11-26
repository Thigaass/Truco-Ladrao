extends Node
var baralho: Array[Carta] = []
var maoP: Array[Carta] = []
var maoO: Array[Carta] = []
var poder_esc: int = 0
var poder_us: bool = false
var arg_carta: bool = false
var arg_troca: bool = false
var arg_carta_bot: bool = false
var arg_revelar: bool = false
var musica: AudioStreamPlayer
func parar_musica() -> void:
	if is_instance_valid(musica):
		musica.stop()
func poder() -> void:
	if poder_us or arg_carta or arg_troca or arg_carta_bot or arg_revelar:
		return
	match poder_esc:
		1:
			arg_carta = true
		2:
			arg_troca = true
		3:
			arg_carta_bot = true
		4:
			arg_revelar = true
func sprite_poder(botao: TextureButton) -> void:
	var caminho := "res://sprites/PlaceHolders/Poder_" + str(poder_esc) + ".png"
	if ResourceLoader.exists(caminho):
		botao.texture_normal = load(caminho)
	else:
		botao.texture_normal = load("res://sprites/PlaceHolders/Butao.png")
	
	botao.ignore_texture_size = true
	botao.stretch_mode = TextureButton.STRETCH_KEEP_ASPECT_CENTERED
	botao.custom_minimum_size = Vector2(90, 90)
	botao.size = Vector2(90, 90)
	botao.scale = Vector2.ONE
	botao.position = Vector2(995, 977)
func distribuir() -> void:
	for carta in baralho:
		carta.valor = carta.valor_base
	baralho.shuffle()
	maoP = baralho.slice(0,3)
	maoO = baralho.slice(3,6)
