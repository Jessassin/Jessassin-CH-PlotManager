**Jessassin's CommandHelper Plot Manager**

This is a simple plot management snap-in for CommandHelper.

It has the following features:

* ability to generate a custom plot floor pattern
* ability to claim/unclaim plots
* ability to set the default or max number of plots a player is allowed to have

This requires the following:

* WorldEdit (5.3+)
* WorldGuard (5.0+)
* Jessassin-CH-CommonMethods (1.0.0+)

Commands:
* /plot <Action> <Arguments>

	Actions:
	* generate
		Args:
		* <Block1,Block2,Block3,Block4> (array)
	* claim
		Args:
		* <[Name of schematic to load]>
	* unclaim
		Args:
		* <[Name of schematic to save]>
	* info
		No arguments