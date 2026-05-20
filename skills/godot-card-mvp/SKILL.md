# Godot 4 卡牌游戏 MVP 开发指南

## 触发条件
Godot卡牌原型、肉鸽卡牌UI、@onready初始化、HBoxContainer排版、阈值结算逻辑、多选交互

---

## 🧱 核心开发流
1. **数据先行**：用 `RefCounted` + 静态字典定义卡牌/敌人/菜谱，解耦 UI 与逻辑
2. **预制件规范**：`Panel` (根) → `Label` ×2 → 脚本绑在 Panel
3. **实例化铁律**：`add_child()` → `connect()` → `init_card()`（顺序不可逆）
4. **容器排版**：`HBoxContainer` 会覆盖手动尺寸，必须设 `Custom Minimum Size`

---

## ⚠️ 高频避坑清单

| 现象 | 原因 | 解法 |
|------|------|------|
| `Invalid assignment ... Nil` | `@onready` 变量未初始化 | 确保 `add_child()` 先于数据赋值调用 |
| Panel 背景色不显示 | Godot 4 改用 StyleBox | `Theme Overrides > Styles > panel > New StyleBoxFlat` |
| 卡牌被容器压扁 | HBoxContainer 自动收缩 | 根节点设 `Layout > Custom Minimum Size` (X:100, Y:140) |
| `$NodeName` 找不到 | 层级过深或名称大小写不匹配 | `$` 仅匹配直接子节点；检查拼写与缩进层级 |

---

## 💡 最佳实践

### 1. 节点实例化标准模板
```gdscript
func spawn_instance():
    var inst = scene.instantiate()
    parent.add_child(inst)          # 1. 先入树，触发 @onready
    inst.ready_signal.connect(...)  # 2. 连信号
    inst.init_data(data)            # 3. 后赋值
```

### 2. 卡牌多选交互结构
```gdscript
# card_ui.gd
signal card_clicked(self_node)
func _gui_input(event):
    if event is InputEventMouseButton and event.pressed:
        is_selected = !is_selected
        rect_position.y = -30 if is_selected else 0  # 上移动画
        card_clicked.emit(self)

# main.gd
func _on_card_clicked(node):
    if node.is_selected: selected.append(node)
    else: selected.erase(node)
```

### 3. 阈值结算核心逻辑
```gdscript
func play_selected():
    var attr = 0; var del = 0
    for c in selected:
        if c.data.type == Type.INGREDIENT:
            attr += c.data.attraction; del += c.data.delicious

    if attr >= THRESHOLD:
        enemy_hp -= del  # 达标造成伤害
    else:
        print("未达标，仅记录分数")

    for c in selected: c.queue_free()  # MVP用销毁代替弃牌堆
    selected.clear()
```

---

## 🛠️ 下一步路线图
- [ ] 回合制：8回合倒计时 + 每回合重置分数/手牌
- [ ] 弃牌堆：`Array` 管理弃牌，回合结束洗牌回抽牌堆
- [ ] 厨艺牌效果：`match card_data.effect` 实现倍率/加成
- [ ] 菜谱检测：出牌后扫描 `required_tags` 触发被动
- [ ] 恶魔AI：预设意图序列（阈值变化/偏好切换）
