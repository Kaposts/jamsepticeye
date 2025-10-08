extends Node

signal sig_player_died()

signal sig_player_spawned(level: int)

signal sig_level_finished
signal sig_score_submitted

signal sig_game_paused
signal sig_game_unpaused
signal sig_game_started
signal sig_game_restarted

signal sig_key_remapped(action: StringName)
