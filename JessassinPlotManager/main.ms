# +----------------------------------------------+
# | Jessassin's Plot Management System           |
# | Main.ms                                      |
# +----------------------------------------------+
bind(
	player_join, null, null, @event,
	assign(@player, player())
	_plotmanager_init(@player)
)