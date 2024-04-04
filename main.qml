import QtQuick.Window 2.15

Window {
  width: 800
  height: 800
  maximumWidth: 800
  visible: true
  title: qsTr("Hello World")
  color: "gainsboro"

  Rectangle {
    id: visibilityToggleHour
    width: 60
    height: 30
    color: "red"
    anchors.top: parent.top
    anchors.left: parent.left
  }

  Rectangle {
    id: visibilityToggleMinute
    width: 60
    height: 30
    color: "blue"
    anchors.top: parent.top
    anchors.right: parent.right
  }

  Rectangle {
    id: visibilityToggleControls
    width: 60
    height: 30
    color: "green"
    anchors.bottom: colorSelector.top
    anchors.left: parent.left
  }

  Grid {
    id: colorSelector
    rows: 1
    columns: 4
    width: parent.width / 15
    height: parent.width / 20
    spacing: width / 5
    anchors.bottom: parent.bottom
    anchors.left: parent.left
    Repeater {
      model: 4
      anchors.left: parent.left
      delegate: Rectangle {
        height: colorSelector.height
        width: height
        color: (() => {
                  switch (index) {
                    case 0:
                    return "black"
                    case 1:
                    return "blue"
                    case 2:
                    return "red"
                    case 3:
                    return "green"
                  }
                })()
        MouseArea {
          anchors.fill: parent
          onClicked: {
            clockBase.border.color = color
          }
        }
        radius: 360
      }
    }
  }

  Rectangle {
    id: clockBase
    anchors.centerIn: parent
    width: parent.width - (parent.width * 0.1)
    height: width
    color: "white"
    border.color: "black"
    border.width: parent.width / 25
    radius: 360

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
      let angle = Math.acos(
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
      x: pivotPoint.x
      y: pivotPoint.y - (minuteHand.width)
      z: 1
      width: (parent.width / 10)
      height: width
      color: "transparent"
      border.color: "grey"
      function handleDrag() {
        let newAngle = parent.getHandAngleFromCenter(x + (width / 2),
                                                     y + (height / 2))
        let delta = (newAngle - minuteHand.rotationAngle)
        // hourHand.rotationAngle += delta / 12
        // hourHand.rotationAngle += 1 / 12
        minuteHand.rotationAngle = newAngle
      }
      onXChanged: handleDrag()
      onYChanged: handleDrag()
      // Component.onCompleted: handleDrag()
      radius: 360
      MouseArea {
        id: minuteDragArea
        anchors.fill: parent
        drag.target: parent
        drag.minimumX: pivotPoint.x - (clockBase.width / 2)
        drag.minimumY: pivotPoint.y - (clockBase.width / 2)
        drag.maximumX: pivotPoint.x + (clockBase.width / 2)
        drag.maximumY: pivotPoint.y + (clockBase.width / 2)
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
      x: pivotPoint.x
      y: pivotPoint.y - (hourHand.width)
      z: 1
      width: (parent.width / 10)
      height: width
      color: "transparent"
      border.color: "grey"
      function handleDrag() {
        let newAngle = parent.getHandAngleFromCenter(x + (width / 2),
                                                     y + (height / 2))
        let delta = (newAngle - hourHand.rotationAngle)
        minuteHand.rotationAngle += delta * 12
        hourHand.rotationAngle = newAngle
      }
      onXChanged: handleDrag()
      onYChanged: handleDrag()
      // Component.onCompleted: handleDrag()
      radius: 360
      MouseArea {
        id: hourDragArea
        anchors.fill: parent
        drag.target: parent
        drag.minimumX: pivotPoint.x - (clockBase.width / 2)
        drag.minimumY: pivotPoint.y - (clockBase.width / 2)
        drag.maximumX: pivotPoint.x + (clockBase.width / 2)
        drag.maximumY: pivotPoint.y + (clockBase.width / 2)
      }
    }

    Text {
      id: digitalTime
      color: "black"
      z: 3
      text: (() => {
               var trueValue = Math.floor(hourHand.rotationAngle / 30) + 3
               if (trueValue > 0)
               return trueValue
               else
               return (12 + trueValue)
             })()
      font.pixelSize: 12
      anchors.bottom: pivotPoint.top
      anchors.horizontalCenter: pivotPoint.horizontalCenter
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
        color: clockBase.border.color
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
