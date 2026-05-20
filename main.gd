extends Control

@onready var card_scene = preload("res://scenes/card.tscn")
@onready var hand_container = $HBoxContainer
@onready var attr_label = $AttrLabel
@onready var del_label = $DelLabel
@onready var enemy_hp_label = $EnemyHPLabel
@onready var threshold_label = $ThresholdLabel

# 按钮引用（请确保场景里的按钮名字和这里一致）
@onready var restart_button = $RestartButton
@onready var play_button = $PlayButton

# 战斗数据
var enemy_hp = 40
const MAX_ENEMY_HP = 40
const THRESHOLD = 3

# 记录当前选中的卡牌节点
var selected_cards = []

func _ready():
	# 1. 绑定按钮信号
	restart_button.pressed.connect(reset_game)
	if play_button:
		play_button.pressed.connect(_on_play_button_pressed)
	
	update_ui()
	spawn_hand()

func spawn_hand():
	var all_cards = CardData.get_all_cards()
	shuffle_array(all_cards)
	
	# 清空旧牌
	for child in hand_container.get_children():
		child.queue_free()
	selected_cards.clear()
	
	# 发新牌
	for i in range(5):
		var card_data = all_cards[i]
		var card_instance = card_scene.instantiate()
		
		# 必须先加树，再初始化数据（你之前发现的正确顺序）
		hand_container.add_child(card_instance)
		card_instance.init_card(card_data)
		
		# 绑定点击信号
		card_instance.card_clicked.connect(_on_card_clicked)

# 卡牌被点击选中/取消
func _on_card_clicked(card_node):
	if card_node.is_selected:
		selected_cards.append(card_node)
	else:
		selected_cards.erase(card_node)
	
	# 更新顶部临时分数显示
	update_temp_scores()

# 按下打出键
func _on_play_button_pressed():
	if selected_cards.is_empty():
		print("请先选择卡牌！")
		return

	var total_attraction = 0
	var total_delicious = 0

	for card_node in selected_cards:
		var d = card_node.data
		if d.type == CardData.Type.INGREDIENT:
			total_attraction += d.attraction
			total_delicious += d.delicious
		else:
			print("打出厨艺牌：", d.name, "（效果待实现）")

	# 核心：阈值判定
	if total_attraction >= THRESHOLD:
		var damage = total_delicious
		enemy_hp -= damage
		print(">>> 吸引达标(%d>=%d)！造成 %d 点感化伤害！" % [total_attraction, THRESHOLD, damage])
	else:
		print(">>> 吸引分不足 (当前%d / 需要%d)，未造成伤害！" % [total_attraction, THRESHOLD])

	# 弃牌：将打出的牌从手牌区移除（MVP用删掉代替）
	for card_node in selected_cards:
		card_node.queue_free()
	selected_cards.clear()

	update_ui()
	check_game_over()

func update_temp_scores():
	var a = 0; var d = 0
	for c in selected_cards:
		if c.data.type == CardData.Type.INGREDIENT:
			a += c.data.attraction
			d += c.data.delicious
	attr_label.text = "当前吸引：" + str(a)
	del_label.text = "当前美味：" + str(d)

func update_ui():
	enemy_hp_label.text = "恶魔 HP：" + str(enemy_hp)
	threshold_label.text = "吸引阈值：" + str(THRESHOLD)
	update_temp_scores() # 重置分数显示

func check_game_over():
	if enemy_hp <= 0:
		print("====== 胜利！恶魔被感化了！======")
		await get_tree().create_timer(2.0).timeout
		reset_game()

func reset_game():
	enemy_hp = MAX_ENEMY_HP
	update_ui()
	spawn_hand()

func shuffle_array(arr):
	for i in range(arr.size() - 1, 0, -1):
		var j = randi_range(0, i)
		var temp = arr[i]
		arr[i] = arr[j]
		arr[j] = temp
