class_name PlayerStatsDataResource
extends NodeDataResource

# 🟢 FIX: You MUST declare these here so the script knows they exist!
@export var player_level := 1
@export var current_exp := 0
@export var required_exp := 100
@export var gold := 0

func _save_data(_node: Node) -> void:
    super._save_data(_node)

    # Pull directly from your global Autoload manager
    if PlayerProgressManager:
        player_level = PlayerProgressManager.player_level
        current_exp = PlayerProgressManager.current_exp
        required_exp = PlayerProgressManager.required_exp
        gold = PlayerProgressManager.gold


func _load_data(_source_node: Node) -> void:
    if PlayerProgressManager == null:
        push_error("Load Error: PlayerProgressManager autoload not found.")
        return

    # Inject values straight back into the global manager
    PlayerProgressManager.player_level = player_level
    PlayerProgressManager.current_exp = current_exp
    PlayerProgressManager.required_exp = required_exp
    PlayerProgressManager.gold = gold

    # Force the global manager to tell the HUD to update instantly
    PlayerProgressManager.level_changed.emit(player_level)
    PlayerProgressManager.exp_changed.emit(current_exp, required_exp)
    PlayerProgressManager.gold_changed.emit(gold)
