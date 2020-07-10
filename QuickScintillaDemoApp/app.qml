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
        quickScintillaEditor.text = applicationData.readFileContent(urlFileName)
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
            quickScintillaEditor.text = ""
            lblFileName.text = "unknown.txt"
            //for Tests only: Qt.inputMethod.show()
            scrollView.focus = true
            //quickScintillaEditor.focus = true
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
            infoDialog.text = quickScintillaEditor.text
            //for Tests only: infoDialog.text = " "+scrollView.contentItem
            infoDialog.open()
            //for Tests only: readCurrentDoc("/sdcard/Texte/mgv_quick_qdebug.log")
            /*for Tests only: */quickScintillaEditor.text = applicationData.readLog()
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
                var ok = applicationData.writeFileContent(/*currentFile*/fileUrl, quickScintillaEditor.text)
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
            //quickScintillaEditor.focus = true
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

        property alias quickScintillaEditor: quickScintillaEditor
        //property Flickable flickableItem: flickableItem
        //property alias vScrollBar: ScrollBar.vertical
        property bool actionFromKeyboard: false

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

            implicitWidth: quickScintillaEditor.logicalWidth
            implicitHeight: quickScintillaEditor.logicalHeight

            // the QuickScintilla control
            ScintillaEditBase {
                id: quickScintillaEditor

                width: scrollView.availableWidth //+ 2*quickScintillaEditor.charHeight
                height: scrollView.availableHeight //+ 2*quickScintillaEditor.charWidth

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
                console.log("xchanged")
                var delta = scrollView.contentItem.contentX - quickScintillaEditor.x
                var deltaInColumns = parseInt(delta / quickScintillaEditor.charWidth,10)
                if(delta > quickScintillaEditor.charWidth) {
                    console.log("p1")
                    // disable repaint: https://stackoverflow.com/questions/46095768/how-to-disable-update-on-a-qquickitem
                    quickScintillaEditor.enableUpdate(false);
                    quickScintillaEditor.x = quickScintillaEditor.x + deltaInColumns*quickScintillaEditor.charWidth    // TODO --> bewirkt geometry changed !!!
                    quickScintillaEditor.scrollColumn(deltaInColumns)
                    quickScintillaEditor.enableUpdate(true)
                }
                else if(-deltaInColumns > quickScintillaEditor.charWidth) {
                    console.log("p2")
                    quickScintillaEditor.enableUpdate(false);
                    quickScintillaEditor.x = quickScintillaEditor.x + deltaInColumns*quickScintillaEditor.charWidth      // deltaInColumns is < 0
                    if(quickScintillaEditor.x < 0)
                    {
                        quickScintillaEditor.x = 0
                    }
                    quickScintillaEditor.scrollColumn(deltaInColumns)   // deltaInColumns is < 0
                    quickScintillaEditor.enableUpdate(true)
                }
            }
            onContentYChanged: {
                console.log("YCHANGED")
                var delta = scrollView.contentItem.contentY - quickScintillaEditor.y
                var deltaInLines = parseInt(delta / quickScintillaEditor.charHeight,10)
                if(delta > quickScintillaEditor.charHeight) {
                    console.log("P1")
                    // disable repaint: https://stackoverflow.com/questions/46095768/how-to-disable-update-on-a-qquickitem
                    quickScintillaEditor.enableUpdate(false);
                    quickScintillaEditor.y = quickScintillaEditor.y + deltaInLines*quickScintillaEditor.charHeight    // TODO --> bewirkt geometry changed !!!
                    quickScintillaEditor.scrollRow(deltaInLines)
                    quickScintillaEditor.enableUpdate(true)
                }
                else if(-delta > quickScintillaEditor.charHeight) {
                    console.log("P2")
                    quickScintillaEditor.enableUpdate(false);
                    quickScintillaEditor.y = quickScintillaEditor.y + deltaInLines*quickScintillaEditor.charHeight
                    if(quickScintillaEditor.y < 0)
                    {
                        quickScintillaEditor.y = 0
                    }
                    quickScintillaEditor.scrollRow(deltaInLines) // -1 * -1
                    quickScintillaEditor.enableUpdate(true)
                }
            }
        }

        Connections {
            target: quickScintillaEditor

            onHorizontalScrolled: {
                var v = value/quickScintillaEditor.charWidth/quickScintillaEditor.totalColumns
                console.log("HSCROLL "+value+" new="+v)
                //scrollView.ScrollBar.horizontal.position = v      // TODO: recursive call crash !
            }
            onVerticalScrolled: {
                var v = value/quickScintillaEditor.totalLines
                console.log("VSCROLL "+value+" "+v)
                scrollView.ScrollBar.vertical.position = v
            }
            onHorizontalRangeChanged: {
                console.log("HRANGE "+max+" "+page+" "+quickScintillaEditor.totalColumns+" "+quickScintillaEditor.visibleColumns)
                scrollView.ScrollBar.horizontal.size = page/quickScintillaEditor.totalColumns
            }
            onVerticalRangeChanged: {
                console.log("VRANGE "+max+" "+page+" "+quickScintillaEditor.totalLines+" "+quickScintillaEditor.visibleLines)
                scrollView.ScrollBar.vertical.size = page/quickScintillaEditor.totalLines
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
            position: quickScintillaEditor.firstVisibleLine/quickScintillaEditor.totalLines
            pageSize: quickScintillaEditor.height/max(quickScintillaEditor.logicalHeight,quickScintillaEditor.height) // 0.5 //view.visibleArea.heightRatio
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
            position: quickScintillaEditor.firstVisibleColumn/quickScintillaEditor.totalColumns
            pageSize: quickScintillaEditor.width/max(quickScintillaEditor.logicalWidth,quickScintillaEditor.width) //0.25 //quickScintillaEditor.widthRatio
        }
        */
   }

}
