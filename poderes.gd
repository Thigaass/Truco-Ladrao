extends Control

const DESCRICOES_PODERES := {
	1: "Aumentar Carta: Aumenta em +1 o valor de uma das suas cartas nesta mão",
	2: "Trocar Carta: Escolhe uma carta sua e troca por uma carta virada do bot.",
	3: "Enfraquecer Carta: Diminui em -1 o valor de uma carta do bot nesta mão.",
	4: "Espiar Carta: Revela uma das cartas viradas do bot antes de jogar.",
}

@onready var descricao_box: ColorRect = $DescricaoBox
@onready var descricao_texto: Label = $DescricaoBox/DescricaoTexto


func _ready() -> void:
	for i in range(1, 5):
		var botao := get_node("Panel/Poder" + str(i)) as TextureButton
		botao.texture_click_mask = Globais.criar_mascara_alpha(botao.texture_normal)
		botao.pressed.connect(func(): esc_poder(i))
		botao.mouse_entered.connect(func(): mostrar_descricao(i))
		botao.mouse_exited.connect(esconder_descricao)


func mostrar_descricao(numero: int) -> void:
	descricao_texto.text = DESCRICOES_PODERES.get(numero, "")
	descricao_box.visible = descricao_texto.text != ""


func esconder_descricao() -> void:
	descricao_box.visible = false
	descricao_texto.text = ""


func esc_poder(numero: int) -> void:
	Globais.poder_esc = numero
	get_tree().change_scene_to_file("res://Main.tscn")
