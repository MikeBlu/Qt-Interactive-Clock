import QtQuick.Window 2.15

Window {
  width: 800
  height: 800
  visible: true
  title: qsTr("Hello World")
  color: "gainsboro"

  Rectangle {
    id: clock
    anchors.centerIn: parent
    width: parent.width - 100
    height: width
    color: "white"
    border.color: "black"
    border.width: parent.width / 25
    radius: 360

    Rectangle {
      id: hourHand
      width: (parent.width / 2) - 40
      height: (parent.height / 80)
      x: parent.width / 2
      y: (parent.height / 2) - (hourHand.height / 2)
      color: "black"
      transform: Rotation {
        origin.y: hourHand.height / 2
        angle: 180
      }
    }
    Rectangle {
      id: minuteHand
      width: (parent.width / 2) - 150
      height: (parent.height / 20)
      x: parent.width / 2
      y: (parent.height / 2) - (minuteHand.height / 2)
      color: "black"
      transform: Rotation {
        origin.y: minuteHand.height / 2
        angle: 180
      }
    }

    Rectangle {
      id: pivotPoint
      width: (parent.width / 10)
      height: (parent.width / 10)
      anchors.centerIn: parent
      color: "black"
      radius: 360
    }
  }
}
