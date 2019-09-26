/*
 * Copyright (C) 2019  Michele Castellazzi
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; version 3.
 *
 * ubuntu-calculator-app is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

#include <QtQml>
#include <QtQml/QQmlContext>

#include "plugin.h"
#include "messwerk.h"

void MesswerkPlugin::registerTypes(const char *uri) {
    //@uri Messwerk
    qmlRegisterSingletonType<Messwerk>(uri, 1, 0, "Messwerk", [](QQmlEngine*, QJSEngine*) -> QObject* { return new Messwerk; });
}
