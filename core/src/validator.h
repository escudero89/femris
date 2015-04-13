#ifndef VALIDATOR_H
#define VALIDATOR_H

#include <QMap>
#include <QString>
#include <QStringList>

class Validator {
public:
    Validator(const QString = "default");
    ~Validator();

    void addRule(const QString, double = 0.0, QString = "default");
    void addRuleMustNotContain(const QString);

    bool validate(const QString, QString&) const;

    bool checkRule(const QString, const QString) const;
    QString getRuleMessage(const QString rule);

    bool checkGreaterThan(const QString, const double) const;
    bool checkGreaterThanOrEqualTo(const QString, const double) const;
    bool checkLessThan(const QString, const double) const;
    bool checkLessThanOrEqualTo(const QString, const double) const;
    bool checkNotEmpty(const QString) const;

protected:

    QString m_name;

    QMap<QString, QString> m_validatesCustom;

    QMap<QString, double> m_validatesDouble;

    QMap<QString, QString> m_validatesMessage;

    QStringList m_validationFields;


};

#endif // VALIDATOR_H
