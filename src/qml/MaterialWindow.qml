// Code modified from QML-Material <http://papyros.io>

import QtQuick 2.0
import QtQuick.Controls 1.2 as Controls
import QtQuick.Window 2.0
import Material 0.1
import Material.Extras 0.1
import QtGraphicalEffects 1.0

Controls.ApplicationWindow {
    id: __window
    property bool clientSideDecorations
    flags:   Qt.FramelessWindowHint
    color: "transparent"
    property alias initialPage: __pageStack.initialItem
    property alias pageStack: __pageStack
    property alias theme: __theme

    AppTheme {
        id: __theme
    }

    ResizeArea{
        id:resizeArea
        anchors.fill: parent
        dragHeight: systemBar.height + 50
        anchors.margins:  5
        target: __window
        minSize: Qt.size(100,100)
        enabled: true

        RectangularGlow {
            id: outGlow
            anchors.fill: parent
            anchors.margins:10
            glowRadius: 10
            spread: 0.1
            color: "#A0000000"
            cornerRadius:  glowRadius
        }
    }

    SystemBar {
        id: systemBar
        anchors.margins: 10
    }


    PageStack {
        id: __pageStack
        anchors {
            fill: parent
            margins: 10
        }

        onPushed:{ __toolbar.push(page);  __toolbar.visible = true}
        onPopped: {
             __toolbar.pop(page);
             __toolbar.visible = false
        }
        onReplaced: __toolbar.replace(page)

    }

    Toolbar {
        id: __toolbar
        anchors {
            rightMargin: 10
            topMargin: 10
            leftMargin: 10
        }
        visible: false
        SystemButtons {
            color: "transparent"
            iconsColor: "white"
            anchors {
                right: parent.right
                top: parent.top
                margins: 10
            }
            id: sysbutton
            onShowMinimized: __window.showMinimized();
            onShowMaximized: __window.showMaximized();
            onShowNormal: __window.showNormal();
            onClose: __window.close();
        }
    }

    OverlayLayer {
        id: dialogOverlayLayer
        objectName: "dialogOverlayLayer"
    }

    OverlayLayer {
        id: tooltipOverlayLayer
        objectName: "tooltipOverlayLayer"
    }

    OverlayLayer {
        id: overlayLayer
    }

    width: Units.dp(800)
    height: Units.dp(600)

    Dialog {
        id: errorDialog

        property var promise

        positiveButtonText: "Retry"

        onAccepted: {
            promise.resolve()
            promise = null
        }

        onRejected: {
            promise.reject()
            promise = null
        }
    }

    function showError(title, text, secondaryButtonText, retry) {
        if (errorDialog.promise) {
            errorDialog.promise.reject()
            errorDialog.promise = null
        }

        errorDialog.negativeButtonText = secondaryButtonText ? secondaryButtonText : "Close"
        errorDialog.positiveButton.visible = retry || false

        errorDialog.promise = new Promises.Promise()
        errorDialog.title = title
        errorDialog.text = text
        errorDialog.open()

        return errorDialog.promise
    }

    Component.onCompleted: {

        Units.pixelDensity = Qt.binding(function() {
            return Screen.pixelDensity
        });

        Device.type = Qt.binding(function () {
            var diagonal = Math.sqrt(Math.pow((Screen.width/Screen.pixelDensity), 2) +
                    Math.pow((Screen.height/Screen.pixelDensity), 2)) * 0.039370;

            if (diagonal >= 3.5 && diagonal < 5) { //iPhone 1st generation to phablet
                Units.multiplier = 1;
                return Device.phone;
            } else if (diagonal >= 5 && diagonal < 6.5) {
                Units.multiplier = 1;
                return Device.phablet;
            } else if (diagonal >= 6.5 && diagonal < 10.1) {
                Units.multiplier = 1;
                return Device.tablet;
            } else if (diagonal >= 10.1 && diagonal < 29) {
                return Device.desktop;
            } else if (diagonal >= 29 && diagonal < 92) {
                return Device.tv;
            } else {
                return Device.unknown;
            }
        });

        Units.gridUnit = Qt.binding(function() {
            return Device.type === Device.phone || Device.type === Device.phablet
                    ? Units.dp(48) : Device.type == Device.tablet ? Units.dp(56) : Units.dp(64)
        })
    }

    Item{
        state:__window.visibility
        states: [
            State {
                name: "2"
                PropertyChanges { target: resizeArea; anchors.margins: 5; enabled: true }
                PropertyChanges { target: __pageStack; anchors.margins: 10 }
                PropertyChanges { target: __toolbar; anchors.margins: 0 }
                PropertyChanges { target: systemBar; anchors.margins: 10}
                PropertyChanges { target: outGlow; visible: true }
            },
            State {
                name: "4"
                PropertyChanges { target: resizeArea; anchors.margins: 0; enabled: false }
                PropertyChanges { target: __pageStack; anchors.margins: 0}
                PropertyChanges { target: systemBar; anchors.margins: 0 }
                PropertyChanges { target: __toolbar; anchors.margins: 0 }
                PropertyChanges { target: outGlow; visible: false }
            },
            State {
                name: "5"
                PropertyChanges { target: resizeArea; anchors.margins: 0; enabled: false }
                PropertyChanges { target: __pageStack; anchors.margins: 0}
                PropertyChanges { target: systemBar; anchors.margins: 0 }
                PropertyChanges { target: __toolbar; anchors.margins: 0 }
                PropertyChanges { target: outGlow; visible: false }
            }
        ]
    }

    function colorLuminance(hex, lum) {
    	hex = String(hex).replace(/[^0-9a-f]/gi, '');
    	if (hex.length < 6) {
    	       hex = hex[0]+hex[0]+hex[1]+hex[1]+hex[2]+hex[2];
    	}
    	lum = lum || 0;
    	var rgb = "#", c, i;
    	for (i = 0; i < 3; i++) {
    		c = parseInt(hex.substr(i*2,2), 16);
    		c = Math.round(Math.min(Math.max(0, c + (c * lum)), 255)).toString(16);
    		rgb += ("00"+c).substr(c.length);
    	}

    	return rgb;
    }


}
