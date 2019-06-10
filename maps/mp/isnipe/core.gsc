#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;

CreateLabel(modname, locationX, locationY, marginX, marginY, font, fontsize)
{
Label = self createFontString(font, fontsize);
self thread deleteondeath(Label);
Label setPoint(locationX, locationY, marginX, marginY);
Label setText(modname);
Label.alpha = 1;
wait 15;
Label.alpha = 0.95;
wait 0.05;
Label.alpha = 0.9;
wait 0.05;
Label.alpha = 0.85;
wait 0.05;
Label.alpha = 0.8;
wait 0.05;
Label.alpha = 0.75;
wait 0.05;
Label.alpha = 0.7;
wait 0.05;
Label.alpha = 0.65;
wait 0.05;
Label.alpha = 0.6;
wait 0.05;
Label.alpha = 0.55;
wait 0.05;
Label.alpha = 0.5;
wait 0.05;
Label.alpha = 0.45;
wait 0.05;
Label.alpha = 0.4;
wait 0.05;
Label.alpha = 0.35;
wait 0.05;
Label.alpha = 0.3;
wait 0.05;
Label.alpha = 0.25;
wait 0.05;
Label.alpha = 0.2;
wait 0.05;
Label.alpha = 0.15;
wait 0.05;
Label.alpha = 0.1;
wait 0.05;
Label.alpha = 0.05;
wait 0.05;
Label.alpha = 0;
}

initMod()
{
self thread maps\mp\isnipe\settings::ApplySettings();
}

deleteondeath(hud)
{
        self waittill("death");
        hud destroy();
}