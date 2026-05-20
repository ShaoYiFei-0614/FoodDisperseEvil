extends RefCounted
class_name CardData
# 卡牌类型
enum Type { INGREDIENT, COOKING }

# 5 张食材牌
static var ingredient_cards = [
	{"id": "tomato", "name": "番茄", "type": Type.INGREDIENT, "attraction": 3, "delicious": 1, "cost": 1, "tags": ["蔬菜"]},
	{"id": "beef", "name": "牛肉", "type": Type.INGREDIENT, "attraction": 1, "delicious": 4, "cost": 1, "tags": ["肉类"]},
	{"id": "tofu", "name": "豆腐", "type": Type.INGREDIENT, "attraction": 2, "delicious": 2, "cost": 1, "tags": ["素食"]},
	{"id": "chili", "name": "辣椒", "type": Type.INGREDIENT, "attraction": 1, "delicious": 2, "cost": 1, "tags": ["调料"]},
	{"id": "egg", "name": "鸡蛋", "type": Type.INGREDIENT, "attraction": 2, "delicious": 2, "cost": 1, "tags": ["蛋类"]},
]

# 3 张厨艺牌
static var cooking_cards = [
	{"id": "fry", "name": "煎炸", "type": Type.COOKING, "effect": "double_meat", "cost": 2, "description": "肉类美味×2"},
	{"id": "steam", "name": "清蒸", "type": Type.COOKING, "effect": "add_attraction", "cost": 1, "description": "所有食材吸引+2"},
	{"id": "stir_fry", "name": "快炒", "type": Type.COOKING, "effect": "add_delicious", "cost": 1, "description": "本回合总美味+3"},
]

# 获取所有卡牌
static func get_all_cards():
	return ingredient_cards + cooking_cards
