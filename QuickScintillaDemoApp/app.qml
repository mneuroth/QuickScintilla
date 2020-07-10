import Scintilla 1.0
import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Dialogs 1.2
//import Qt.labs.platform 1.1

ApplicationWindow {
    id: myRoot
    width: 600
    height: 400
    visible: true

    property string urlPrefix: "file://"

    function buildValidUrl(path) {
        // ignore call, if we already have a file:// url
        path = path.toString()
        if( path.startsWith(urlPrefix) )
        {
            return path;
        }
        // ignore call, if we already have a content:// url (android storage framework)
        if( path.startsWith("content://") )
        {
            return path;
        }

        var sAdd = path.startsWith("/") ? "" : "/"
        var sUrl = urlPrefix + sAdd + path
        return sUrl
    }

    function readCurrentDoc(url) {
        // then read new document
        var urlFileName = buildValidUrl(url)
        lblFileName.text = urlFileName
        myScintillaEditor.text = applicationData.readFileContent(urlFileName)
    }

    Button {
        id: btnLoadFile
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.topMargin: 5
        anchors.leftMargin: 5
        text: "Load file"
        onClicked: {
            //fileDialog.fileMode = FileDialog.OpenFile
            fileDialog.title = "Choose a file"
            fileDialog.selectExisting = true
            fileDialog.openMode = true
            fileDialog.open()
        }
    }

    Button {
        id: btnSaveFile
        //enabled: lblFileName.text.startsWith(urlPrefix)
        anchors.top: parent.top
        anchors.left: btnLoadFile.right
        anchors.topMargin: 5
        anchors.leftMargin: 5
        text: "Save file as"
        onClicked: {
            //fileDialog.fileMode = FileDialog.SaveFile
            fileDialog.title = "Save a file"
            fileDialog.selectExisting = false
            fileDialog.openMode = false
            fileDialog.open()
        }
    }

    Button {
        id: btnClearText
        anchors.top: parent.top
        anchors.left: btnSaveFile.right
        anchors.topMargin: 5
        anchors.leftMargin: 5
        text: "Clear"
        onClicked: {
            myScintillaEditor.text = ""
            lblFileName.text = "unknown.txt"
            //for Tests only: Qt.inputMethod.show()
            scrollView.focus = true
            //myScintillaEditor.focus = true
        }
    }

    Button {
        id: btnShowText
        anchors.top: parent.top
        anchors.left: btnClearText.right
        anchors.topMargin: 5
        anchors.leftMargin: 5
        text: "Show text"
        onClicked: {
            infoDialog.text = myScintillaEditor.text
            //for Tests only: infoDialog.text = " "+scrollView.contentItem
            infoDialog.open()
            //for Tests only: readCurrentDoc("/sdcard/Texte/mgv_quick_qdebug.log")
            /*for Tests only: */myScintillaEditor.text = applicationData.readLog()
        }
    }

    Text {
        id: lblFileName
        anchors.top: btnLoadFile.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        //anchors.verticalCenter: btnShowText.verticalCenter
        anchors.leftMargin: 5
        anchors.rightMargin: 5
        anchors.topMargin: 5
        anchors.bottomMargin: 5
        text: "?"
    }

    FileDialog {
        id: fileDialog
        visible: false
        modality: Qt.WindowModal
        title: "Choose a file"
        folder: "."

        property bool openMode: true

        selectExisting: true
        selectMultiple: false
        selectFolder: false

        onAccepted: {
            console.log("Accepted: " + /*currentFile*/fileUrl+" "+fileDialog.openMode)
            /*if(fileDialog.fileMode === FileDialog.SaveFile)*/if(!fileDialog.openMode) {
                var ok = applicationData.writeFileContent(/*currentFile*/fileUrl, myScintillaEditor.text)
            }
            else {
                readCurrentDoc(/*currentFile*/fileUrl)
            }
            scrollView.focus = true
        }
        onRejected: {
            console.log("Rejected")
            scrollView.focus = true
        }
    }

    MessageDialog {
        id: infoDialog
        visible: false
        title: qsTr("Info")
        standardButtons: StandardButton.Ok
        onAccepted: {
            console.log("Close info dialog")
            scrollView.focus = true
            //myScintillaEditor.focus = true
        }
    }

    function max(v1, v2) {
        return v1 < v2 ? v2 : v1;
    }

    // Use Scrollview to handle ScrollBars for QuickScintilla control.
    // Scrollbar uses Rectangle as flickable item which has the implicitSize of the QuickScintilla control
    // (implicitSize is the maximun size needed to show the full content of the QuickScintilla control).
    // The QuickScintilla controll will be placed at the currently visible viewport of the ScrollView.
    ScrollView {
        id: scrollView
        focus: true
        clip: true
        //focusPolicy: Qt.StrongFocus

        property alias myScintillaEditor: myScintillaEditor
        //property Flickable flickableItem: flickableItem

        //anchors.fill: parent
        //anchors.centerIn: parent
        anchors.top: lblFileName.bottom
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.rightMargin: 5
        anchors.leftMargin: 5
        anchors.topMargin: 5
        anchors.bottomMargin: 5

        ScrollBar.horizontal.policy: ScrollBar.AlwaysOn
        ScrollBar.vertical.policy: ScrollBar.AlwaysOn

        // box needed to support ScrollView and simulate current maximum size of scintilla text control
        // editor control will be placed in visible part of this rectangle
        Rectangle {
            id: editorFrame

            anchors.fill: parent

            implicitWidth: myScintillaEditor.logicalWidth
            implicitHeight: myScintillaEditor.logicalHeight

            // the QuickScintilla control
            ScintillaEditBase {
                id: myScintillaEditor

                width: scrollView.availableWidth //+ 2*myScintillaEditor.charHeight
                height: scrollView.availableHeight //+ 2*myScintillaEditor.charWidth

                // position of the QuickScintilla controll will be changed in response of signals from the ScrollView
                x : 0
                y : 0

                Accessible.role: Accessible.EditableText

                //implicitWidth: 1600//1000
                //implicitHeight: 1800//3000
                font.family: "Courier New"  //*/ "Hack"
                font.pointSize: 18
                focus: true
                text: "Welcome scintilla in the Qt QML/Quick world !\nLine 2\nLine 3\nLine 4\nLine 5\nLine 6\nLine 7\nLine 8\nLine 9\nLine 10\nLine 11\nLine 12\nLine 13\nLine 14\nLine 15\nLine 16\nLine 17\nlast line is here!\n"+parent.x+ " "+parent.y+" "+x+" "+y
            }
        }

        Connections {
            // https://stackoverflow.com/questions/30359262/how-to-scroll-qml-scrollview-to-center
            target: scrollView.contentItem //.flickableItem //.ScrollBar.vertial

            onContentXChanged: {
                var delta = scrollView.contentItem.contentX - myScintillaEditor.x
                var deltaInColumns = parseInt(delta / myScintillaEditor.charWidth,10)
                if(delta > myScintillaEditor.charWidth) {
                    // disable repaint: https://stackoverflow.com/questions/46095768/how-to-disable-update-on-a-qquickitem
                    myScintillaEditor.enableUpdate(false);
                    myScintillaEditor.x = myScintillaEditor.x + deltaInColumns*myScintillaEditor.charWidth    // TODO --> bewirkt geometry changed !!!
                    myScintillaEditor.scrollColumn(deltaInColumns)
                    myScintillaEditor.enableUpdate(true)
                }
                else if(-deltaInColumns > myScintillaEditor.charWidth) {
                    myScintillaEditor.enableUpdate(false);
                    myScintillaEditor.x = myScintillaEditor.x + deltaInColumns*myScintillaEditor.charWidth      // deltaInColumns is < 0
                    if(myScintillaEditor.x < 0)
                    {
                        myScintillaEditor.x = 0
                    }
                    myScintillaEditor.scrollColumn(deltaInColumns)   // deltaInColumns is < 0
                    myScintillaEditor.enableUpdate(true)
                }
            }
            onContentYChanged: {
                var delta = scrollView.contentItem.contentY - myScintillaEditor.y
                var deltaInLines = parseInt(delta / myScintillaEditor.charHeight,10)
                if(delta > myScintillaEditor.charHeight) {
                    // disable repaint: https://stackoverflow.com/questions/46095768/how-to-disable-update-on-a-qquickitem
                    myScintillaEditor.enableUpdate(false);
                    myScintillaEditor.y = myScintillaEditor.y + deltaInLines*myScintillaEditor.charHeight    // TODO --> bewirkt geometry changed !!!
                    myScintillaEditor.scrollRow(deltaInLines)
                    myScintillaEditor.enableUpdate(true)
                }
                else if(-delta > myScintillaEditor.charHeight) {
                    myScintillaEditor.enableUpdate(false);
                    myScintillaEditor.y = myScintillaEditor.y + deltaInLines*myScintillaEditor.charHeight
                    if(myScintillaEditor.y < 0)
                    {
                        myScintillaEditor.y = 0
                    }
                    myScintillaEditor.scrollRow(deltaInLines) // -1 * -1
                    myScintillaEditor.enableUpdate(true)
                }
            }
        }

        /* For tests with Flickable:

        SimpleScrollBar {
            id: verticalScrollBar
            width: 12
            visible: true
            height: scrollView.height-12
            anchors.right: parent.right
            opacity: 1
            orientation: Qt.Vertical
            position: myScintillaEditor.firstVisibleLine/myScintillaEditor.totalLines
            pageSize: myScintillaEditor.height/max(myScintillaEditor.logicalHeight,myScintillaEditor.height) // 0.5 //view.visibleArea.heightRatio
        }

        SimpleScrollBar {
            id: horizontalScrollBar
            width: scrollView.width-12
            height: 12//+50
            //scrollView.height
            visible: true
            //anchors.bottom: parent.bottom+50
            y: scrollView.height-12 //-50
            opacity: 1
            orientation: Qt.Horizontal
            position: myScintillaEditor.firstVisibleColumn/myScintillaEditor.totalColumns
            pageSize: myScintillaEditor.width/max(myScintillaEditor.logicalWidth,myScintillaEditor.width) //0.25 //myScintillaEditor.widthRatio
        }
        */
   }

}
