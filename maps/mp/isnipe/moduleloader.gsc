// TODO: How to add settings into the mix.
init() {
    // antiCamp
    self maps\mp\isnipe\extras\anticamp::init();

    // peopleAlive
    self maps\mp\isnipe\extras\peoplealive::init();
}

onPlayerConnect() {
    // antiCamp
    self maps\mp\isnipe\extras\anticamp::onPlayerConnect();

    // peopleAlive
    self maps\mp\isnipe\extras\peoplealive::onPlayerConnect();
}

onPlayerSpawned() {
    // antiCamp
    self maps\mp\isnipe\extras\anticamp::onPlayerSpawned();

    // peopleAlive
    self maps\mp\isnipe\extras\peoplealive::onPlayerSpawned();
}