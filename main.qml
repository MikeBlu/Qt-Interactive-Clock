import QtQuick.Window 2.15

Window {
  width: 800
  height: 800
  maximumWidth: 800
  visible: true
  title: qsTr("Hello World")
  color: "gainsboro"

  Rectangle {
    id: clockBase
    anchors.centerIn: parent
    width: parent.width - (parent.width * 0.1)
    height: width
    color: "white"
    border.color: "black"
    border.width: parent.width / 25
    radius: 360

    Rectangle {
      id: minuteHand
      z: 1
      width: (parent.width / 2.2)
      height: (parent.height / 80)
      x: parent.width / 2
      y: (parent.height / 2) - (minuteHand.height / 2)
      color: "grey"
      transform: Rotation {
        origin.y: minuteHand.height / 2
        angle: 90
      }
      Rectangle {
        id: minuteControl
        z: 1
        width: (parent.parent.height / 10)
        height: width
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.right
        color: "transparent"
        border.color: "grey"
        radius: 360
        MouseArea {
          anchors.fill: parent
          acceptedButtons: Qt.LeftButton | Qt.RightButton
          onClicked: mouse => {
                       console.log("minute control clicked")
                     } // handle Click-and-drag
        }
      }
    }

    Rectangle {
      id: hourHand
      z: 1
      width: (parent.width / 4)
      height: (parent.height / 20)
      x: parent.width / 2
      y: (parent.height / 2) - (hourHand.height / 2)
      color: "grey"
      transform: Rotation {
        origin.y: hourHand.height / 2
        angle: 0
      }
      Rectangle {
        id: hourControl
        z: 1
        width: (parent.parent.height / 10)
        height: width
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.right
        color: "transparent"
        border.color: "grey"
        radius: 360
        MouseArea {
          anchors.fill: parent
          acceptedButtons: Qt.LeftButton | Qt.RightButton
          onClicked: mouse => {
                       console.log("hour control clicked")
                     } // handle Click-and-drag
        }
      }
    }

    Rectangle {
      id: pivotPoint
      z: 2
      width: (parent.width / 10)
      height: (parent.width / 10)
      anchors.centerIn: parent
      color: "black"
      radius: 360
    }

    Repeater {
      id: rep
      model: 60

      delegate: Rectangle {
        height: (index % 5 == 0) ? (parent.width / 10) : (parent.width / 12)
        width: (index % 5 == 0) ? (parent.width / 100) : (parent.width / 130)
        color: "black"
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        transform: Rotation {
          origin.y: parent.height / 2
          origin.x: width / 2
          angle: (360 / rep.model) * index
        }
      }
    }
  }
}
