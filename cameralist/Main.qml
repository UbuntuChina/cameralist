import QtQuick 2.4
import Ubuntu.Components 1.3
import QtMultimedia 5.6

MainView {
    // objectName for functional testing purposes (autopilot-qt5)
    objectName: "mainView"

    // Note! applicationName needs to match the "name" field of the click manifest
    applicationName: "cameralist.liu-xiao-guo"

    width: units.gu(60)
    height: units.gu(85)

    Camera {
        id: camera

        imageProcessing.whiteBalanceMode: CameraImageProcessing.WhiteBalanceFlash

        exposure {
            exposureCompensation: -1.0
            exposureMode: Camera.ExposurePortrait
        }

        flash.mode: Camera.FlashRedEyeReduction

        imageCapture {
            id: capture
            onImageCaptured: {
                console.log("onImageCaptured!")
                // Show the preview in an Image
                photoPreview.source = preview
            }

            onImageSaved: {
                console.log("image has been saved: " + requestId);
                console.log("saved path: " + path);
            }
        }
    }

    Component {
        id: highlight
        Rectangle {
            width: parent.width
            height: delegate.height
            color: "lightsteelblue"; radius: 5
            Behavior on y {
                SpringAnimation {
                    spring: 3
                    damping: 0.2
                }
            }
        }
    }

    Page {
        id: page
        header: PageHeader {
            id: pageHeader
            title: i18n.tr("cameralist")
        }

        Item {
            anchors {
                left: parent.left
                right: parent.right
                bottom: parent.bottom
                top: pageHeader.bottom
            }

            Column {
                anchors.fill: parent

                ListView {
                    id: listview
                    width: page.width
                    height: units.gu(20)

                    model: QtMultimedia.availableCameras
                    highlight:highlight
                    delegate: Item {
                        id: delegate
                        width: listview.width
                        height: layout.childrenRect.height + units.gu(0.5)

                        Column {
                            id: layout
                            width: parent.width

                            Text {
                                text: "deviceId: " + modelData.deviceId
                            }

                            Text {
                                text: "displayName: " + modelData.displayName
                            }

                            Text {
                                text: {
                                    switch(modelData.position) {
                                    case Camera.UnspecifiedPosition:
                                        return "position: UnspecifiedPosition"
                                    case Camera.BackFace:
                                        return "position: BackFace";
                                    case Camera.FrontFace:
                                        return "position: FrontFace"
                                    default:
                                        return "Unknown"
                                    }
                                }
                            }

                            Rectangle {
                                width: parent.width
                                height: units.gu(0.1)
                                color: "green"
                            }

                        }

                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                camera.deviceId = modelData.deviceId
                                listview.currentIndex = index
                            }
                        }
                    }
                }

                VideoOutput {
                    id: output
                    source: camera
                    width: parent.width
                    height: parent.height - listview.height
                    focus : visible

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            console.log("going to capture to: " + path)
                            capture.captureToLocation(path);
                            output.visible = false
                            photoPreview.visible = true
                        }
                    }
                }

                Image {
                    id: photoPreview
                    width: parent.width
                    height: parent.height - listview.height
                    fillMode: Image.PreserveAspectFit

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            photoPreview.visible = false
                            output.visible = true
                        }
                    }

                    Component.onCompleted: {
                        visible = false
                    }
                }
            }
        }
    }
}

