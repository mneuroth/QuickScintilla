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
            infoDialog.open()
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
        }
        onRejected: { console.log("Rejected") }
    }

    MessageDialog {
        id: infoDialog
        visible: false
        title: qsTr("Info")
        standardButtons: StandardButton.Ok
        onAccepted: {
            console.log("Close info dialog")
        }
    }

    ScrollView {
        id: scrollView
        focus: true
        clip: true

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

        ScintillaEditBase {
            id: myScintillaEditor
            anchors.fill: parent
            //implicitWidth: 1000
            //implicitHeight: 3000
            font.family: "Courier New"  //*/ "Hack"
            font.pointSize: 12
            focus: true
            text: "Welcome scintilla in the Qt QML/Quick world !\nLine 2\nLine 3\nLine 4\nLine 5\nLine 6\nLine 7\nLine 8\nLine 9\nLine 10\nLine 11\nLine 12\nLine 13\nLine 14\nLine 15\nLine 16\nLine 17\nlast line is here!"
        }
   }

}
