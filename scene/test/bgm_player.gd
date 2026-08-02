extends AudioStreamPlayer

@export var morning_bgm: AudioStream

@export var day_bgm: AudioStream

@export var night_bgm: AudioStream

var current_period := ""

func _ready() -> void:


 DayAndNightCycleManager.time_tick.connect(_on_time_tick)

 finished.connect(_on_music_finished)

 var total_minutes: int = int((DayAndNightCycleManager.time / DayAndNightCycleManager.Game_MINUTES_DURATION) + 0.001)
 var hour: int = (total_minutes % DayAndNightCycleManager.MINUTES_PER_DAY) / DayAndNightCycleManager.MINUTES_PER_HOUR
 _change_bgm(hour)

func _on_time_tick(day: int, hour: int, minute: int) -> void:

 _change_bgm(hour)

func _change_bgm(hour: int) -> void:

 var new_period := ""
 if hour >= 6 and hour < 12:
  new_period = "morning"
 elif hour >= 12 and hour < 18:
  new_period = "day"
 else:
  new_period = "night"

 if new_period == current_period:
  return
 current_period = new_period
 match current_period:
  "morning":
   stream = morning_bgm
  "day":
   stream = day_bgm
  "night":
   stream = night_bgm
 play()

func _on_music_finished() -> void:

 play()
