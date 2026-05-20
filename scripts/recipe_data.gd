extends RefCounted

# 菜谱数据：被动组合加成
static var recipes = [
	{
		"id": "tomato_egg",
		"name": "番茄炒蛋",
		"required_tags": ["番茄", "鸡蛋"],
		"bonus_attraction": 2,
		"bonus_delicious": 2,
	},
	{
		"id": "mapo_tofu",
		"name": "麻婆豆腐",
		"required_tags": ["豆腐", "辣椒"],
		"multiplier_delicious": 1.5,
	}
]
