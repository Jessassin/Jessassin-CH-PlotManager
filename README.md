**Jessassin's CommandHelper Plot Manager**

This is a simple plot management snap-in for CommandHelper. I hope that it will become a simple interface for worldguard, and a replacement for more advanced plot management plugins.

It has (or will have) the following features:
* generate a custom plot floor pattern
* allow players to claim/unclaim plots
* set the default number of plots a member can have
* allow members to allow certain players to build on their plot
* allow admins/mods to build on any plot

Dependancies:
* WorldEdit (5.3+)
* WorldGuard (5.0+)
* Jessassin-CH-CommonMethods (1.0.0+)

Commands:
* /plot \<Action\> \<Arguments\>

	Actions:
	* generate \[Block1,Block2,Block3,Block4\]
	* claim \[Name of schematic to load\]
	* unclaim \[Name of schematic to save\]
	* info
	* playerinfo

Permissions:
* ch.all = required to run
* Jessassin.plot.admin
* Jessassin.plot.command
* Jessassin.plot.claim
* Jessassin.plot.unclaim
* Jessassin.plot.generate
* Jessassin.plot.save
* Jessassin.plot.load

Persistance database:
* player_plotcount,"Number of plots owned by player"
* player_maxplotcount,"Number of plots player can still claim"
* player_plotarray,array(plot1addr,plot2addr,plot3addr,etc.)
* plotaddress_owner
* plotaddress_memberarray,array(member1,member2,member3)

To do:
* add worldguard integration
* improve speed of plot floor generation
* allow for more variables, like default number of plots
* add administrative commands
* reduce chat spam
* integrate pre-programmed code, that was removed for rewriting


