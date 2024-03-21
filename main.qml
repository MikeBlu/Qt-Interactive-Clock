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

    Repeater {
      id: rep
      model: 60

      delegate: Rectangle {
        height: (parent.width / 12)
        width: 6
        color: "black"
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        transform: Rotation {
          origin.y: parent.height / 2
          origin.x: width / 2
          angle: (360 / rep.model) * index
        }
        Component.onCompleted: {
          console.log(Item.Bottom)
        }
      }
    }
  }
}
