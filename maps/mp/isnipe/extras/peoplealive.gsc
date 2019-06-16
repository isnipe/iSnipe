#include maps\mp\gametypes\_hud_util;

/**
 * Initialize the variables used by the peopleAlive module on a level.
 */
init() {
    level.peopleAlive = [];
    level.peopleAlive["allies"] = 0;
    level.peopleAlive["axis"] = 0;
}

/**
 * Initialize the variables used by the peopleAlive module on a player level.
 */
onPlayerConnect() {
    self.peopleAlive = [];
    self.peopleAlive["hud"] = [];
}

/**
 * Log player alive status as well as drawing the HUD for the player.
 */
onPlayerSpawned() {
    team = self.pers["team"];
    level.peopleAlive[team]++;
    self thread _drawHUD();
    self thread _deleteHUD();
    level notify("peopleAlive:UPDATE");

    self waittill("death");
    level.peopleAlive[team]--;
    level notify("peopleAlive:UPDATE");
}

/**
 * Draw and update the player HUD on alive people.
 */
_drawHUD() {
    self endon("death");
    self endon("disconnect");

    label = self createFontString("hudbig", 0.8);
    label setPoint("TOPLEFT", "TOPLEFT", 44, 110);
    label.hideWhenInMenu = true;
    self.peopleAlive["hud"][0] = label;
    for (;;) {
        // Check whether gamemode is FFA.
        if (getDvar("g_gametype") == "dm") {
            // TODO: Does "level.players.size" give all connected players or alive players?
            label setText("^21 ^1" + (level.players.size - 1));
        } else {
            if (self.pers["team"] == "allies") {
                label setText("^2" + level.peopleAlive["allies"] + " ^1" + level.peopleAlive["axis"]);
            } else {
                label setText("^2" + level.peopleAlive["axis"] + " ^1" + level.peopleAlive["allies"]);
            }
        }
        level waittill("peopleAlive:UPDATE");
    }

}

/**
 * Delete the HUD after the player has died.
 */
_deleteHUD() {
    self waittill("death");
    foreach (hudElement in self.peopleAlive["hud"]) {
        hudElement destroy();
    }
    self.peopleAlive["hud"] = [];
}
