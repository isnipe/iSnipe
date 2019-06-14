// TODO: How to add settings into the mix.
init() {
    // antiCamp
    self maps\mp\isnipe\extras\anticamp::init();

    // antiHardScope
    self maps\mp\isnipe\extras\antihardscope::init();
}

onPlayerConnect() {
    // antiCamp
    self maps\mp\isnipe\extras\anticamp::onPlayerConnect();
}

onPlayerSpawned() {
    // antiCamp
    self maps\mp\isnipe\extras\anticamp::onPlayerSpawned();

    // antiHardScope
    self maps\mp\isnipe\extras\antihardscope::onPlayerSpawned();
}