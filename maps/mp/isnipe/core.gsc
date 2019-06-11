#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;

createLabel(modname, locationX, locationY, marginX, marginY, font, fontsize, duration)
{
    label = self createFontString(font, fontsize);
    self thread deleteondeath(Label);
    label setPoint(locationX, locationY, marginX, marginY);
    label setText(modname);
    label.alpha = 1;
    wait duration;

    if(duration != -1)
    {
        while(label.alpha > 0)
            {
                label.alpha -= 0.05;
                wait 0.05;
            }
    }

}

init()
{
    self thread maps\mp\isnipe\settings::apply();
}

deleteondeath(hud)
{
    self waittill("death");
    hud destroy();
}