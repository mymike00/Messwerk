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

#ifndef MESSWERK_H
#define MESSWERK_H

#include <QObject>

class Messwerk: public QObject {
    Q_OBJECT

public:
    Messwerk();
    ~Messwerk() = default;

    Q_INVOKABLE void speak();
};

#endif
