#ifndef VALIDATOR_H
#define VALIDATOR_H

#include <QMap>
#include <QString>
#include <QStringList>

class Validator {
public:
    Validator();
    ~Validator();

    void addRule(const QString, double = 0.0, QString = "default");
    void addRuleMustContain(const QString);

    bool validate(const QString, QString&);

    bool checkRule(const QString, const QString);
    QString getRuleMessage(const QString rule);

    bool checkGreaterThan(const QString, const double);
    bool checkGreaterThanOrEqualTo(const QString, const double);
    bool checkLessThan(const QString, const double);
    bool checkLessThanOrEqualTo(const QString, const double);
    bool checkNotEmpty(const QString);

protected:

    QMap<QString, QString> m_validatesCustom;

    QMap<QString, double> m_validatesDouble;

    QMap<QString, QString> m_validatesMessage;

    QStringList m_validationFields;


};

#endif // VALIDATOR_H
