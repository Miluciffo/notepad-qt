from PySide6 import QtCore as qtc, QtWidgets as qtw ,QtGui as qtgui, QtQml as qtqml
import sys

if __name__ == '__main__':
    app = qtw.QApplication()
    eng = qtqml.QQmlApplicationEngine()
    eng.load(qtc.QUrl('./main.qml'))

    sys.exit(app.exec())
