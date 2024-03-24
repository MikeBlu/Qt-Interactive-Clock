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
    clip: true

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
        angle: -90
      }
      Rectangle {
        id: minuteControl
        x: parent.width / 1.2
        y: 0
        z: 1
        width: (parent.parent.height / 10)
        height: width
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
        angle: -90
      }
      radius: 40
      Rectangle {
        id: hourControl
        x: parent.width / 1.5
        y: 0
        z: 1
        width: (parent.parent.height / 10)
        height: width
        color: "transparent"
        border.color: "grey"
        radius: 360
        MouseArea {
          anchors.fill: parent
          drag.target: parent
        }
      }
    }

    Rectangle {
      id: probe
      x: clockBase.x
      y: clockBase.y
      z: 2
      width: 5
      height: 5
      color: "red"
      radius: 360
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
      id: pins
      model: 60

      delegate: Rectangle {
        Text {
          color: "black"
          anchors.top: parent.bottom
          anchors.horizontalCenter: parent.horizontalCenter
          font.pixelSize: parent.width * 5
          Component.onCompleted: () => {
                                   if (index % 5 == 0) {
                                     text = (index == 0) ? ("12") : (index / 5)
                                   }
                                 }
        }
        height: (index % 5 == 0) ? (parent.width / 10) : (parent.width / 12)
        width: (index % 5 == 0) ? (parent.width / 100) : (parent.width / 130)
        color: "black"
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        transform: Rotation {
          origin.y: parent.height / 2
          origin.x: width / 2
          angle: (360 / pins.model) * index
        }
      }
    }
  }
}
