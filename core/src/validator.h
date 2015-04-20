#ifndef VALIDATOR_H
#define VALIDATOR_H

#include <QMap>
#include <QString>
#include <QStringList>

/**
 * @brief The Validator class that handles the validation of inputs
 *
 * The Validator class is a handy class to work with the validations of certain
 * data entered by the user via the interface. Every field needs to have its own
 * Validator.
 *
 */
class Validator {
public:
    Validator(const QString = "default");
    ~Validator();

    void addRule(const QString, double = 0.0);
    void addRuleMustNotContain(const QString);

    bool validate(const QString, QString&) const;

    bool checkRule(const QString, const QString) const;
    QString getRuleMessage(const QString rule);

    bool checkGreaterThan(const double) const;
    bool checkGreaterThanOrEqualTo(const double) const;
    bool checkLessThan(const double) const;
    bool checkLessThanOrEqualTo(const double) const;
    bool checkNotEmpty(const QString) const;

protected:

    QString m_name;

    QMap<QString, QString> m_validatesCustom;

    QMap<QString, double> m_validatesDouble;

    QStringList m_validationFields;


};

#endif // VALIDATOR_H
