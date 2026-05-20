extends Panel

# 点击时发出信号，把自身节点传出去方便主脚本管理
signal card_clicked(self_node)

@onready var name_label = $NameLabel
@onready var value_label = $ValueLabel

var data
var is_selected = false

func init_card(card_data):
	data = card_data
	name_label.text = card_data.name
	if card_data.type == CardData.Type.INGREDIENT:
		value_label.text = "吸引:" + str(card_data.attraction) + " 美味:" + str(card_data.delicious)
	else:
		value_label.text = card_data.description
	update_visual()

func _gui_input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		is_selected = !is_selected
		update_visual()
		card_clicked.emit(self)

func update_visual():
	# 选中时上移，未选中时回位
	position.y = -30 if is_selected else 0
	
	# 附加一个选中高亮（可选）
	if is_selected:
		self_modulate = Color(1, 1, 0.85)
	else:
		self_modulate = Color(1, 1, 1)
