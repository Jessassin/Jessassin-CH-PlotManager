# **Jessassin's CommandHelper Plot Manager**

This is a simple plot management snap-in for CommandHelper. I hope that it will become a simple interface for worldguard, and a replacement for more advanced plot management plugins.

***

### It has (or will have) the following features:
* generate a custom plot floor pattern
* allow players to claim/unclaim plots
* set the default number of plots a member can have
* allow members to allow certain players to build on their plot
* allow admins/mods to build on any plot

***

### Dependancies:
* [WorldEdit](http://dev.bukkit.org/server-mods/worldedit/)(5.3+)
* [WorldGuard](http://dev.bukkit.org/server-mods/worldguard/)(5.0+)
* [Jessassin-CH-CommonMethods](https://github.com/Jessassin/Jessassin-CH-CommonMethods) (1.0.0+)
* Worldborder (looking at alternatives)

***

### Commands:
* /plot \<Action\> \<Arguments\>
	### Actions:
	* generate \<Block1,Block2,Block3,Block4\>
	* claim \<Name of schematic to load\>
	* unclaim \<Name of schematic to save\>
	* info
	* playerinfo
	* Member \<add/remove\> \<player\>
	* Guest \<add/remove\> \<player\>
	* Lock \<on/off\> Plot lock prevents accidental /plot unclaim or /plot generate
	* Mode \<Member/Guest/None\> Plot mode sets all players access lebel to plot
	* Reserve \<user\> \<reason\> reserves plot for user, specify reason (32 char limit)
	* Map \<plot\> Teleports you to the plot map, if plot is specified, teleports you to plot on map
	* Warp \<plot\> Teleports you to center of plot specified
	* Load \<Schematic Name\> Loads schematic onto current plot, replacing existing content
	* Save \<Schematic Name\> Saves current plot to schematic

***

### Permissions:
* ch.all OR commandhelper.all = Required for all commands
* Jessassin.plot.admin
* Jessassin.plot.command
* Jessassin.plot.claim
* Jessassin.plot.unclaim
* Jessassin.plot.generate
* Jessassin.plot.member
* Jessassin.plot.guest
* Jessassin.plot.lock
* Jessassin.plot.mode
* Jessassin.plot.reserve
* Jessassin.plot.map
* Jessassin.plot.warp
* Jessassin.plot.load
* Jessassin.plot.save

***

### Persistance database:
* player_plotcount,"Number of plots owned by player"
* player_maxplotcount,"Number of plots player can still claim"
* player_plotarray,array(plot1addr,plot2addr,plot3addr,etc.)
* player_mapmotto
* plotaddress_owner
* plotaddress_memberarray,array(member1,member2,member3)
* plotaddress_guestarray,array(guest1,guest2,guest3)
* plotaddress_plotmode
* plotaddress_plotlock (bool)
* plotaddress_plotreservedfor array(player,reason)

***

### To do:
* Remove redundant persistance value "player_plotcount" can use length(player_plotarray)
* Implement plot unclaiming
* implement member add/remove
* implement guest add/remove
* implement plot lock
* implement plot mode
* finish implementation of plot map
* Implement plot saving
* Implement plot loading
* add worldguard integration
* worldborder integration / replacement with other system
* improve speed of plot floor generation
* allow for more variables, like default number of plots
* add administrative commands
* reduce chat spam
* integrate pre-programmed code, that was removed for rewriting
* integrate "override everything" model
	* Allow all perameters to be overridden, including player,plot,location,etc.
	* for example /plot claim 10101 someplayer (with plot.admin) claims 10101 as someplayer