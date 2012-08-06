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

***

### Permissions:
* ch.all = required to run
* Jessassin.plot.admin
* Jessassin.plot.command
* Jessassin.plot.claim
* Jessassin.plot.unclaim
* Jessassin.plot.generate
* Jessassin.plot.save
* Jessassin.plot.load
* Jessassin.plot.member
* Jessassin.plot.guest

***

### Persistance database:
* player_plotcount,"Number of plots owned by player"
* player_maxplotcount,"Number of plots player can still claim"
* player_plotarray,array(plot1addr,plot2addr,plot3addr,etc.)
* plotaddress_owner
* plotaddress_memberarray,array(member1,member2,member3)
* plotaddress_guestarray,array(guest1,guest2,guest3)

***

### To do:
* add worldguard integration
* improve speed of plot floor generation
* allow for more variables, like default number of plots
* add administrative commands
* reduce chat spam
* integrate pre-programmed code, that was removed for rewriting
* Add command /plot lock, that prevents accidental /plot generate
	* add persistance for plotaddress_plotlock
	* (?) allow locking for other things, like building by members, or item interaction
* plot membership
	* plot member <add/remove>
	* Plot guest <add/remove>
* Plot reservations
	* /plot reserve <reason>
	* prevents plot from being claimed
* Map border
	* Prevent plots outside border from being claimed
	* Automatically increase border distance, based on number of available plots
* Plot map
	* shows status of plots, in a logical grid formation that corrosponds to plot locations
	* choose which plot the map is generated on, prevent building on said plot
	* (?) allow members to claim plots by right clicking sign
* Plot administration commands
	* allow admins to override permissions/etc.
* Auto-creation for warps and homes (essentials integration)
* Multiple home management (essentials integration)
* (?) Friends list
	* friends are automatically added to "builder" group of all owned plots