import QtQuick 6.6
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Dialogs 6.6

ApplicationWindow {
    visible: true
    width: 800
    height: 600
    title: "Notepad"

    menuBar: MenuBar {
        Menu {
            id: menu_files
            title: "File"
            MenuItem {text: "New"; onTriggered: reset()}
            MenuItem { text: "Open"; onTriggered: openFile() }
            MenuItem { text: "Save"; onTriggered: saveFile() }
            MenuItem { text: "Save As"; onTriggered: saveAsDialog.open() }
            MenuItem { text: "Exit"; onTriggered: exit() }
        }
        Menu {
            title: "Edit"
            MenuItem { text: "Cut"; onTriggered: textArea.cut() }
            MenuItem { text: "Copy"; onTriggered: textArea.copy() }
            MenuItem { text: "Paste"; onTriggered: textArea.paste() }

        }
        Menu {
            title: "Format"
            MenuItem { text: "Word Wrap"; onTriggered: textArea.wrapMode = textArea.wrapMode == TextEdit.Wrap ? TextEdit.NoWrap : TextEdit.Wrap }
            MenuItem { text: "Font"; onTriggered: fontDialog.open() }
        }
        Menu {
            title: "View"
            MenuItem { text: "Zoom In"; onTriggered: textArea.font.pointSize += 1 }
            MenuItem { text: "Zoom Out"; onTriggered: textArea.font.pointSize -= 1 }

        }
        Menu {
            title: "Help"
            MenuItem {
                text: "About"
                onTriggered: {
                    var aboutDialog = Qt.createComponent("AboutDialog.qml")
                    aboutDialog.createObject(parent)
                }
            }
        }
    }

    ScrollView {
        anchors.fill: parent

        TextArea {
            id: textArea
            wrapMode: TextEdit.Wrap
            font.family: "Courier New"
            font.pointSize: 12
            width: parent.width // TextArea expands horizontally
            height: parent.height // and vertically
        }
    }

    // Добавить переменную для хранения текущего имени файла
    property url fileName: null

    // Добавить FileDialog для выбора файла
    FileDialog {
        id: openfileDialog
        fileMode: FileDialog.AnyFile
        defaultSuffix: "txt"
        nameFilters: ["Text files (*.txt)", "All files (*)"]
        onAccepted: {
            if (selectExisting) {
                // Open mode
                openFile(fileUrl)
            } else {
                // Save mode
                saveFile(fileUrl)
            }
        }
    }

    // Добавить FontDialog для выбора шрифта
    FontDialog {
        id: fontDialog
        onAccepted: {
            // Применить выбранный шрифт к текстовой области
            textArea.font = selectedFont
        }
    }

    // Добавить логику для проверки, был ли файл изменен
    function documentChanged(changed) {
        // Установить свойство windowModified в соответствии с изменением
        windowModified = changed
    }

    // Добавить логику для чтения и записи содержимого файла
    function readFile(fileUrl) {
        // Создать XMLHttpRequest для чтения файла
        var request = new XMLHttpRequest()
        request.open("GET", fileUrl, false)
        request.send(null)
        return request.responseText
    }

    function writeFile(fileUrl, text) {
        // Создать XMLHttpRequest для записи файла
        var request = new XMLHttpRequest()
        request.open("PUT", fileUrl, false)
        request.send(text)
        return request.status
    }

    function openFile(fileUrl) {
        // Прочитать содержимое файла и установить его в текстовую область
        var text = readFile(fileUrl)
        textArea.text = text
        // Установить текущее имя файла и заголовок окна
        fileName = fileUrl
        title = fileUrl.toString().split("/").pop() + " - Notepad"
        // Сбросить флаг изменения документа
        textArea.document.reset()
    }

    // function saveFile(fileUrl) {
    //     // Записать содержимое текстовой области в файл
    //     var status = writeFile(fileUrl, textArea.text)
    //     if (status === 200) {
    //         // Установить текущее имя файла и заголовок окна
    //         fileName = fileUrl
    //         title = fileUrl.toString().split("/").pop() + " - Notepad"
    //         // Сбросить флаг изменения документа
    //         textArea.document.reset()
    //     } else {
    //         // Показать сообщение об ошибке
    //         console.log("Error saving file: " + status)
    //     }
    // }
    // function saveFile(fileUrl) {
    //     void TextDocument::saveToFile() {
    //     QString fileName = QFileDialog::getSaveFileName(this,
    //            tr("Save Document"), "",
    //            tr("Document (*.txt);;All Files (*)"));
    //     }
    // }

    function reset() {
        textArea.text = ""
    }

    function exit() {
        // Закрыть приложение
        Qt.quit()
    }
}
