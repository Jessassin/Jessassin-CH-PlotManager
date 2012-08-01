**Jessassin's CommandHelper Plot Manager**

This is a simple plot management snap-in for CommandHelper.

It has the following features:

* ability to generate a custom plot floor pattern
* ability to claim/unclaim plots
* ability to set the default or max number of plots a player is allowed to have

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
	
Permissions:
* ch.all = required to run
* Jessassin.plot.admin
* Jessassin.plot.claim
* Jessassin.plot.unclaim
* Jessassin.plot.generate
* Jessassin.plot.save
* Jessassin.plot.load

Persistance database:
* jessassin_plot_count_(PlayerName),"Number of plots owned by player"
* jessassin_plot_maxcount_(PlayerName),"Number of plots player can still claim"
* jessassin_plot_coords_(PlayerName),array(plot1addr,plot2addr,plot3addr,etc.)
* jessassin_plot_info_(plotaddress),array(owner,array(member1,member2),array(interact1,interact2))


