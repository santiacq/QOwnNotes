#ifndef SETTINGSDIALOG_H
#define SETTINGSDIALOG_H

#include <QAbstractButton>
#include <QDialog>
#include <QLabel>
#include "libraries/simplecrypt/simplecrypt.h"

namespace Ui {
class SettingsDialog;
}

class SettingsDialog : public QDialog
{
    Q_OBJECT

public:
    enum OKLabelStatus {
        Unknown,
        Warning,
        OK,
        Failure,
    };

    explicit SettingsDialog(SimpleCrypt *crypto, QWidget *parent = 0);
    ~SettingsDialog();
    void connectTestCallback(bool appIsValid, QString appVersion, QString serverVersion, QString connectionErrorMessage);
    void setOKLabelData(int number, QString text, OKLabelStatus status);
    void refreshTodoCalendarList(QStringList items, bool forceReadCheckedState = false);
private slots:
    void on_connectButton_clicked();
    void on_buttonBox_clicked(QAbstractButton *button);
    void on_localOwnCloudDirectoryButton_clicked();
    void on_ownCloudServerAppPageButton_clicked();
    void on_noteTextEditButton_clicked();
    void on_noteTextViewButton_clicked();
    void on_reloadCalendarListButton_clicked();
    void on_defaultOwnCloudCalendarRadioButton_toggled(bool checked);

private:
    Ui::SettingsDialog *ui;
    SimpleCrypt *crypto;
    QFont noteTextEditFont;
    QFont noteTextViewFont;
    void readSettings();
    void setupCrypto();
    void storeSettings();
    void startConnectionTest();
    void setFontLabel(QLabel *label, QFont font);
};

#endif // SETTINGSDIALOG_H
