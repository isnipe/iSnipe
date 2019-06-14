# iSnipe

## Modules

### antiCamp
This module takes care of recording the anti camp measures for all players. Moreover, it also draws the HUD for each player, where players currently camping are shown. When a player has been moving less than a specified distance for a specified amount of time, the player is shown in the HUD. After the countdown in the HUD has gone to zero, the player camping is killed.

__Available Settings__
- _interfaceTime_ (default: 5): the time in seconds a player has to camp before showing up on the HUD.
- _killTime_ (default: 5): the time in seconds a player has to camp before being killed, after showing up on the HUD.
- _minDistance_ (default: 100): the minimum distance a player has to move in order to reset the timer.

### peopleAlive
This module takes care of recording how many people of each team are alive. Moreover, for each player, a HUD is created where this amount is shown and updated.

