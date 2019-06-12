/**
 * Initialize the antiCamp variables on the level.
 *
 * The following settings are available to be set outside this script:
 * - interfaceTime (default: 5): the time a player has to camp before showing up
 *                               on the HUD
 * - killTime (default: 5): the time a player has to camp before being killed.
 *                          Note that the killTime is after the interfaceTime,
 *                          hence the player needs to be camping
 *                          interfaceTime + killTime seconds to be killed
 * - minDistance (default: 100): the minimum distance a player has to move in
 *                               order to reset the timer
 */
init() {
    if (!isDefined(level.antiCamp)) {
        level.antiCamp = [];
    }

    // Set settings to default when they are not set.
    _setSettingIfNotExists("interfaceTime", 5);
    _setSettingIfNotExists("killTime", 5);
    _setSettingIfNotExists("minDistance", 100);
    level.antiCamp["campers"] = [];
}

/**
 * Set defaultValue in level.antiCamp[property] if it does not exist.
 *
 * @param property: the setting property to act upon
 * @param defaultValue: the default value to set for the property if not set
 */
_setSettingIfNotExists(property, defaultValue) {
    if (!isDefined(level.antiCamp[property])) {
        level.antiCamp[property] = defaultValue;
    }
}

/**
 * Initialize the anti camp for an individual player.
 */
onPlayerConnected() {
    player = self;
    player.antiCamp = [];
    player.antiCamp["hudElements"] = [];
    player.antiCamp["time"] = 0;
    player thread _createHUD();
    player thread _antiCamp();
}

/**
 * Create the anticamp HUD of the player.
 *
 * This function takes care of both drawing while the user is alive and
 * deleting the HUD whenever the user dies.
 */
_createHUD() {
    self endon("disconnect");
    for(;;) {
        player thread _drawHUD();
        self waittill("death");
        player thread _deleteHUD();
        self waittill("spawned_player");
    }
}

/**
 * Draw the anticamp HUD of the player.
 *
 * With the current implementation, the HUD is updated every 0.2 seconds.
 */
_drawHUD() {
    self endon("death");
    self endon("disconnect");

    killTime = level.antiCamp["interfaceTime"] + level.antiCamp["killTime"];
    header = _createHUDRow(1.0, -25);
    self.antiCamp["hudElements"][0] = header;
    while(;;) {
        campers = level.antiCamp["campers"];
        hudElements = self.antiCamp["hudElements"];

        // Hide HUD when no campers are available.
        if (campers.size == 0) {
            header setText("");
        } else {
            header setText("ANTICAMP");
        }

        // Update HUD for all available campers, and add rows if necessary.
        for (i = 0; i < campers; i++) {
            if (!isDefined(hudElements[i + 1])) {
                hudElements[i + 1] = _createHUDRow(0.9, -15 + 10 * i);
            }
            hudElements[i + 1] setText(campers[i].name + " ^3(" + killTime - campers[i].antiCamp["time"] + ")");
        }

        // Remove unnecessary HUD elements because of lack of campers.
        while (hudElements.size > campers.size + 1) {
            // TODO: Check whether destroying elements in array removes them from array.
            hudElements[campers.size + 1] destroy();
        }
        wait 0.2;
    }
}

_deleteHUD() {
    while (self.antiCamp["hudElements"].size > 0) {
        self.antiCamp["hudElements"][0] destroy();
    }
}

/**
 * Create a row in the HUD at the specified position with specified opacity.
 *
 * @param opacity: the opacity of the row
 * @param yPosition: the y-position to put the row on
 */
_createHUDRow(opacity, yPosition) {
    row = self createFontString("hud", opacity);
    row setPoint("CENTERLEFT", "CENTERLEFT", 10, yPosition);
    row.hideWhenInMenu = true;
    return row;
}

/**
 * Stop player from camping.
 *
 * The player will be showing up on the HUD after interfaceTime seconds, after
 * which he will be killed after killTime seconds. This only happens if the
 * player does not move more than minDistance within the given time. Note that
 * this means that the player has to move less than minDistance distance during
 * interfaceTime + killTime seconds to be killed.
 *
 * Assumes that function is being called by a player entity.
 * Function is quit after player dies or disconnects.
 *
 * @param interfaceTime: time before player should show up on the HUD
 * @param killTime: time player has to camp after being warned to be killed
 * @param minDistance: minimum distance player has to walk before resetting the
 *                     timer
 */
_antiCamp(interfaceTime, killTime, minDistance) {
    self endon("death");
    self endon("disconnect");
    lastPosition = self.origin;

    interfaceTime = level.antiCamp["interfaceTime"];
    killTime = level.antiCamp["killTime"];
    minDistance = level.antiCamp["minDistance"];

    for(;;) {
        wait 1;

        currentPosition = self.origin;
        distance = distance2d(lastPosition, currentPosition);
        if (distance < minDistance) {
            self.antiCamp["time"]++;
            if (self.antiCamp["time"] == interfaceTime + killTime) {
                self _removeFromCampers();
                self suicide();
            } else if (self.antiCamp["time"] == interfaceTime) {
                self _addToCampers();
            }
        } else {
            lastPosition = currentPosition;
            self.antiCamp["time"] = 0;
            self _removeFromCampers();
        }
    }
}

/**
 * Remove 'self' from the campers.
 */
_removeFromCampers() {
    tempCampers = [];
    index = -1;
    for(i = 0; i < level.antiCamp["campers"].size; i++) {
        camper = level.antiCamp["campers"][i];
        if (camper != self) {
            tempCampers[tempCampers.size] = camper;
        } else {
            index = i;
        }
    }
    level.campers = tempCampers;
    level notify("antiCamp:REMOVE", self, index);
}

/**
 * Add 'self' to the campers.
 */
_addToCampers() {
    level.antiCamp["campers"][level.antiCamp["campers"].size] = self;
    level notify("antiCamp:ADD", self);
}