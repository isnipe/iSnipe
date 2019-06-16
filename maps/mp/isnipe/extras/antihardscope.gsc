#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;

/**
 * Initialize the antiHardScope variables on the level.
 *
 * The following settings are available to be set outside this script:
 * - adsTime (default: 3): the time that a player is allowed to aim down sight.
 */
init() {
    if (!isDefined(level.antiHardScope)) {
        level.antiHardScope = [];
    }

    // Set settings to default when they are not set.
    _setSettingIfNotExists("adsTime", 3);
}

/**
 * Set defaultValue in level.antiHardScope[property] if it does not exist.
 *
 * @param property: the setting property to act upon
 * @param defaultValue: the default value to set for the property if not set
 */
_setSettingIfNotExists(property, defaultValue) {
    if (!isDefined(level.antiCamp[property])) {
        level.antiHardScope[property] = defaultValue;
    }
}

/**
 * Define the antiHardScope behaviour each time a player is spawned.
 */
onPlayerSpawned() {
    self endon("disconnect");
    self endon("death");

    adsTime = 0;
    stepTime = 0.05;
    for(;;) {
        if (self playerAds() == 1) {
            adsTime += stepTime;
        } else {
            adsTime = 0;
        }

        if (adsTime >= level.antiHardScope["adsTime"]) {
            adsTime = 0;
            self allowAds(false);
            while(self playerAds() > 0) {
                wait(stepTime);
            }
            self allowAds(true);
        }
        wait(stepTime);
    }
}
