import QtQuick 2.4
import Material 0.1
import Material.ListItems 0.1 as ListItem
import QtQuick.Layouts 1.0
import QtQuick.Controls 1.2 as Controls

Rectangle {
    id:_back
    width:_row.implicitWidth
    height:  _row.implicitHeight
    property color iconsColor
    signal showMinimized;
    signal showMaximized;
    signal showFullScreen;
    signal showNormal;
    signal close;

    RowLayout {
        id: _row
        anchors{
            right: parent.right
            top: parent.top
        }

        spacing: Units.dp(10)

        Rectangle {
            width:1
            color: "transparent"
        }
        IconButton {
            iconName: "navigation/expand_more"
            width: Units.dp(20)
            height: width
            color: _back.iconsColor
            onClicked: _back.showMinimized()
        }

        IconButton {
            iconName: root.visibility == 4 ? "image/crop_7_5" : "image/crop_3_2"
            width: Units.dp(20)
            id: sysbtn_max
            height: width
            color: _back.iconsColor
            onClicked: {
                if(root.visibility == 2)
                    _back.showMaximized();
                else
                    _back.showNormal();
            }
        }

        IconButton {
            iconName: "navigation/close"
            width: Units.dp(20)
            height: width
            color: _back.iconsColor
            onClicked: _back.close()
        }
    }
}
