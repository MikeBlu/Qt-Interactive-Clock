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

    function getHandAngleFromCenter(handX, handY) {

      let handVector = {
        "xVec": handX - (pivotPoint.x + (pivotPoint.width / 2)),
        "yVec": -(handY - (pivotPoint.y + (pivotPoint.height / 2)))
      }, baseHandVector = {
        "xVec": (clockBase.width / 2),
        "yVec": 0
      }
      handVector["normalized"] = (Math.sqrt(Math.pow(handVector["xVec"],
                                                     2) + Math.pow(
                                              handVector["yVec"], 2)))
      baseHandVector["normalized"] = (Math.sqrt(Math.pow(
                                                  baseHandVector["xVec"],
                                                  2) + Math.pow(
                                                  baseHandVector["yVec"], 2)))

      let dotProduct = (handVector["xVec"] * baseHandVector["xVec"])
          + (handVector["yVec"] * baseHandVector["yVec"])
      let angle = Math.acos(// -cos is expensive, sheesh
                            dotProduct / (handVector["normalized"] * baseHandVector["normalized"]))
      angle = angle * (180 / Math.PI)
      return (handVector["yVec"] > 0) ? (-angle) : (angle)
    }

    Rectangle {
      id: minuteHand
      property alias rotationAngle: minuteRotation.angle
      z: 1
      width: (parent.width / 2.2)
      height: (parent.height / 80)
      x: parent.width / 2
      y: (parent.height / 2) - (minuteHand.height / 2)
      color: "grey"
      transform: Rotation {
        id: minuteRotation
        origin.y: minuteHand.height / 2
        angle: 0
      }
    }
    Rectangle {
      id: minuteControl
      x: minuteHand.x + minuteHand.width
      y: minuteHand.y - (minuteHand.height / 2)
      z: 1
      width: (parent.parent.height / 10)
      height: width
      color: "transparent"
      border.color: "grey"
      onXChanged: () => {
                    minuteHand.rotationAngle = parent.getHandAngleFromCenter(
                      x + (width / 2), y + (height / 2))
                  }
      radius: 360
      MouseArea {
        anchors.fill: parent
        drag.target: parent
      }
    }

    Rectangle {
      id: hourHand
      property alias rotationAngle: hourRotation.angle
      z: 1
      width: (parent.width / 4)
      height: (parent.height / 20)
      x: parent.width / 2
      y: (parent.height / 2) - (hourHand.height / 2)
      color: "grey"
      transform: Rotation {
        id: hourRotation
        origin.y: hourHand.height / 2
        angle: 0
      }
      radius: 40
    }
    Rectangle {
      id: hourControl
      x: hourHand.x + hourHand.width
      y: hourHand.y - (hourHand.height / 2)
      z: 1
      width: (parent.height / 10)
      height: width
      color: "transparent"
      border.color: "grey"
      onXChanged: () => {
                    hourHand.rotationAngle = parent.getHandAngleFromCenter(
                      x + (width / 2), y + (height / 2))
                  }
      radius: 360
      MouseArea {
        anchors.fill: parent
        drag.target: parent
      }
    }

    Rectangle {
      id: probe
      x: parent.x + (parent.width / 2)
      y: parent.y + (parent.height / 2)
      z: 3
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
