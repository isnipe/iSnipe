#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;

/**
 * Initialize the topPlayer array on level.
 * This is used to store data of the current top player.
 *
 * The following variables are stored:
 * - level.topPlayer["playerName"]: this contains the name
 *                                  of the current top player
 * - level.topPlayer["playerGuid"]: this contains the guid
 *                                  of the current top player
 * - level.topPlayer["killDeathRatio"]: this contain the k/d ratio
 *                                      of current top player
 */
init() {
    if (!isDefined(level.topPlayer)) {
        level.topPlayer = [];
    }

    _setSettingIfNotExists("playerName", "");
    _setSettingIfNotExists("playerGuid", "");
    _setSettingIfNotExists("killDeathRatio", 0);

    self thread _updateRatios();
}

/**
 * Set defaultValue in level.topPlayer[property] if it does not exist.
 *
 * @param property: the setting property to act upon
 * @param defaultValue: the default value to set for the property if not set
 */
_setSettingIfNotExists(property, defaultValue) {
    if (!isDefined(level.topPlayer[property])) {
        level.topPlayer[property] = defaultValue;
    }
}

/**
 * Initialize the top player hud for a player.
 */
onPlayerConnect() {
    self.topPlayerHud = [];
}

/**
 * This method is called whenever a player spawns.
 */
onPlayerSpawned() {
    self thread _drawHUD();
    self thread _deleteHUD();
}

/**
 * This method calculates the k/d ratio of each player and
 * checks if it is higher than the current top player. If so
 * the _registerNewTopPlayer method will be called for
 * the current player.
 */
_updateRatios() {
    for(;;){
        foreach (player in level.players){

            //Calculate our k/d ratio
            if(player.deaths == 0){
                player.ratio = player.kills;
            } else {
                player.ratio = player.kills / player.deaths;
            }

            //Check if ratio is higher than top player's ratio
            if(player.ratio > level.topPlayer["killDeathRatio"]){
                player _registerNewTopPlayer();
            }

            //This fixes the ratio not updating when the top player dies
            if((player.ratio < level.topPlayer["killDeathRatio"]) && (player getguid() == level.topPlayer["playerGuid"])){
                player _registerNewTopPlayer();
            }

        }
        wait 0.2;
    }

}

/*
 * Register the player that this method runs for
 * as the new top player.
 */
_registerNewTopPlayer(){
    level.topPlayer["playerName"] = self.name;
    level.topPlayer["killDeathRatio"] = self.ratio;
    level.topPlayer["playerGuid"] = self getguid();
}

/*
 * Draw the top player hud
 */
_drawHUD(){
    self endon("death");
    self endon("disconnect");

    header = _createHUDRow(1.0, -10, 0);
    dataRow = _createHUDRow(0.9, -10, 10);

    self.topPlayerHud[0] = header;
    self.topPlayerHud[1] = dataRow;

    for(;;) {
        //Hide HUD when there is no top player
        if(level.topPlayer["killDeathRatio"] == 0){
            header setText("");
            dataRow setText("");
        } else {
            header setText("^1TOP PLAYER");
            dataRow setText("^3" + level.topPlayer["playerName"] + "^7 K/D: ^3" + level.topPlayer["killDeathRatio"]);
        }
        wait 0.2;
    }
}

/**
 * Create a row in the HUD at the specified position with specified opacity.
 *
 * @param opacity: the opacity of the row
 * @param yPosition: the y-position to put the row on
 */
_createHUDRow(opacity, xPosition, yPosition) {
    row = self createFontString("hud", opacity);
    row setPoint("CENTERRIGHT", "CENTERRIGHT", xPosition, yPosition);
    row.hideWhenInMenu = true;
    return row;
}

/**
 * Delete the hud when the player dies
 */
_deleteHUD() {
    self waittill("death");
    foreach (element in self.topPlayerHud) {
        element destroy();
    }
    self.topPlayerHud = [];
}