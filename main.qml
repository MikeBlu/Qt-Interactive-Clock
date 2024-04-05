import QtQuick.Window 2.15

Window {
  width: 800
  height: 800
  maximumWidth: 800
  visible: true
  title: qsTr("Hello World")
  color: "gainsboro"

  // Widgets //
  Component {
    id: itemToggle
    Rectangle {
      property string flowDirection: "to-right"
      property var onToggled: {
        return
      }
      property alias annotation: annotation.text
      color: "transparent"
      Rectangle {
        id: statusButton
        width: parent.width / 2
        height: parent.height
        border.color: "black"
        border.width: parent.width / 20
        radius: 15
        anchors.left: (parent.flowDirection === "to-left") ? (annotation.right) : (undefined)
        anchors.leftMargin: (parent.flowDirection === "to-left") ? (10) : (undefined)
        Text {
          id: status
          text: "OFF"
          font.pixelSize: parent.width / 2.5
          font.bold: true
          anchors.centerIn: parent
        }
        MouseArea {
          id: clickArea
          anchors.fill: parent
          onClicked: {
            if (status.text === "OFF") {
              status.text = "ON"
              onToggled(false)
            } else {
              status.text = "OFF"
              onToggled(true)
            }
          }
        }
      }
      Text {
        id: annotation
        text: "text"
        font.pixelSize: parent.width / 15
        anchors.verticalCenter: statusButton.verticalCenter
        anchors.left: (parent.flowDirection === "to-right") ? (statusButton.right) : (undefined)
        anchors.leftMargin: (parent.flowDirection === "to-right") ? (10) : (undefined)
      }
    }
  }

  Loader {
    id: visibilityToggleHour
    sourceComponent: itemToggle
    width: parent.width / 5
    height: parent.height / 10
    anchors.top: parent.top
    anchors.left: parent.left
    onLoaded: {
      item.annotation = "Hour Hand"
      item.onToggled = isOn => {
        if (isOn)
        hourHand.visible = true
        else
        hourHand.visible = false
      }
    }
  }

  Loader {
    id: visibilityToggleMinute
    sourceComponent: itemToggle
    width: visibilityToggleHour.width
    height: visibilityToggleHour.height
    anchors.top: parent.top
    anchors.right: parent.right
    anchors.rightMargin: 5
    onLoaded: {
      item.annotation = "Minute Hand"
      item.flowDirection = "to-left"
      item.onToggled = isOn => {
        if (isOn)
        minuteHand.visible = true
        else
        minuteHand.visible = false
      }
    }
  }

  Loader {
    id: visibilityToggleDigital
    sourceComponent: itemToggle
    width: visibilityToggleHour.width
    height: visibilityToggleHour.height
    anchors.bottom: parent.bottom
    anchors.right: parent.right
    onLoaded: {
      item.annotation = "Digital"
      item.flowDirection = "to-left"
      item.onToggled = isOn => {
        if (isOn)
        digitalTime.visible = true
        else
        digitalTime.visible = false
      }
    }
  }

  Loader {
    id: visibilityToggleControls
    sourceComponent: itemToggle
    width: visibilityToggleHour.width
    height: visibilityToggleHour.height
    anchors.bottom: colorSelector.top
    anchors.left: parent.left
    onLoaded: {
      item.annotation = "Control Lines"
      item.onToggled = isOn => {
        if (isOn) {
          minuteControl.visible = true
          hourControl.visible = true
        } else {
          minuteControl.visible = false
          hourControl.visible = false
        }
      }
    }
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
          onClicked: () => {
                       clockBase.border.color = color
                       minuteHand.color = color
                     }
        }
        radius: 360
      }
    }
  }

  // Everything under here is the clock //
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
      color: "black"
      transform: Rotation {
        id: minuteRotation
        origin.y: minuteHand.height / 2
        angle: 0
      }
    }
    Rectangle {
      id: minuteControl
      property int delay: 0
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
        hourHand.rotationAngle += ((delta >= 0) ? (1) : (-1)) * (1 / 12)
        minuteHand.rotationAngle = newAngle
      }
      onXChanged: handleDrag()
      onYChanged: handleDrag()
      Component.onCompleted: handleDrag()
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
      color: "black"
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
      Component.onCompleted: handleDrag()
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

    Rectangle {
      id: digitalTime
      z: 3
      color: "#99FFFFFF"
      height: parent.width / 10
      width: parent.width / 5
      anchors.bottom: pivotPoint.top
      anchors.bottomMargin: 10
      anchors.horizontalCenter: pivotPoint.horizontalCenter
      Text {
        color: "black"
        text: (() => {
                 let hourValue = Math.floor(
                   hourHand.rotationAngle / 30) + 3, minuteValue = Math.floor(
                   minuteHand.rotationAngle / 6) + 15
                 if (hourValue <= 0)
                 hourValue += 12
                 if (minuteValue <= 0)
                 minuteValue += 60
                 minuteValue = Math.abs(minuteValue % 60)
                 return hourValue + ":" + ((minuteValue < 10) ? ("0" + minuteValue) : (minuteValue))
               })()
        font.pixelSize: parent.width / 3
        anchors.centerIn: parent
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
