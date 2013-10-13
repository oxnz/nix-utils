#!/bin/bash

if [ $# -ne 2 ]
then
	cat<<EOF
NAME
	qmove: move Qt to a new directory and setup qmake environments

SYNOPSIS
	qmove src-dir dst-dir

DESCRIPTION

	qmove moves Qt to a new directory and reconfig qmake

	src-dir: orginal directory where Qt exists

	dst-dir: destination directory where will moved to
EOF
	exit
fi

QMAKE="${QT_INSTALL_PREFIX}_64/bin/qmake"
QT_INSTALL_PREFIX="$1"

QT_INSTALL_ARCHDATA="${QT_INSTALL_PREFIX}/"
QT_INSTALL_DATA="${QT_INSTALL_PREFIX}/"
QT_INSTALL_DOCS="${QT_INSTALL_PREFIX}/doc"
QT_INSTALL_HEADERS="${QT_INSTALL_PREFIX}/include"
QT_INSTALL_LIBS="${QT_INSTALL_PREFIX}/lib"
QT_INSTALL_LIBEXECS="${QT_INSTALL_PREFIX}/libexec"
QT_INSTALL_BINS="${QT_INSTALL_PREFIX}/bin"
QT_INSTALL_TESTS="${QT_INSTALL_PREFIX}/tests"
QT_INSTALL_PLUGINS="${QT_INSTALL_PREFIX}/plugins"
QT_INSTALL_IMPORTS="${QT_INSTALL_PREFIX}/imports"
QT_INSTALL_QML="${QT_INSTALL_PREFIX}/qml"
QT_INSTALL_TRANSLATIONS="${QT_INSTALL_PREFIX}/translations"
QT_INSTALL_CONFIGURATION="/Library/Preferences/Qt"
QT_INSTALL_EXAMPLES="${QT_INSTALL_PREFIX}/examples"
QT_INSTALL_DEMOS="${QT_INSTALL_PREFIX}/examples"
QT_HOST_PREFIX="${QT_INSTALL_PREFIX}"
QT_HOST_DATA="${QT_INSTALL_PREFIX}"
QT_HOST_BINS="${QT_INSTALL_PREFIX}/bin"
QMAKE_SPEC="macx-clang"
QMAKE_XSPEC="macx-clang"
QMAKE_VERSION="3.0"
QT_VERSION="5.0.2"
