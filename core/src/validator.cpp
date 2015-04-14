#include "validator.h"

#include <QDebug>

#include <QString>

/**
 * @brief Constructor of the Class. It needs the name of the field for the messages.
 * @param name Of the field we are validating
 */
Validator::Validator(const QString name) {
    m_name = name;
}

Validator::~Validator() {

}

/**
 * @brief Adds a single rule with a numeric value for comparison into the validator.
 *
 * @param rule Name of the rule we are adding
 * @param comparison Numeric value for the rule to compare with
 */
void Validator::addRule(const QString rule, double comparison) {
    m_validatesDouble.insert(rule, comparison);

    m_validationFields.append(rule);
}

/**
 * @brief Adds a rule that requires that the field must not contain a certain value
 * @param comparison The value that it must not contain
 */
void Validator::addRuleMustNotContain(const QString comparison) {
    QString rule = "mustNotContain";

    m_validatesCustom.insert(rule, comparison);
    m_validationFields.append(rule);
}

/**
 * @brief Loop  through all the rules, checking them all.
 * @param currentValue The value used against our comparison
 * @param failedRule A reference value, filled with the failed rule (if exists)
 * @return True if there wasn't any failed rule, false otherwise
 */
bool Validator::validate(const QString currentValue, QString &failedRule) const {

    for (int kField = 0; kField < m_validationFields.size(); kField++) {
        if ( checkRule(m_validationFields.at(kField), currentValue) == false ) {
            failedRule = m_validationFields.at(kField);
            return false;
        }
    }

    failedRule = "";

    return true;

}

/**
 * @brief Checks a single rule
 * @param rule Rule we are checking
 * @param currentValue The value we are comparing with the one stored in the rule
 *
 * @return True if the rule didn't fail, false otherwise
 */
bool Validator::checkRule(const QString rule, const QString currentValue) const {

    // If it hasn't the rule, returns true
    if (!m_validationFields.contains(rule)) {
        return true;
    }

    bool check = false;

    if (rule == "greaterThan") {
        check = checkGreaterThan(currentValue.toDouble());
    }

    if (rule == "greaterThanOrEqualTo") {
        check = checkGreaterThanOrEqualTo(currentValue.toDouble());
    }

    if (rule == "lessThan") {
        check = checkLessThan(currentValue.toDouble());
    }

    if (rule == "lessThanOrEqualTo") {
        check = checkLessThanOrEqualTo(currentValue.toDouble());
    }

    if (rule == "notEmpty") {
        check = checkNotEmpty(currentValue);
    }

    if (rule == "mustNotContain") {
        check = !currentValue.contains(m_validatesCustom["mustNotContain"]);
    }

    // If some rule was enable, but the value is false, we return false
    if (check && currentValue == "false") {
        check = false;
    }

    return check;
}

/**
 * @brief Gets the message for a single failed rule
 * @param rule The rule that has fail
 * @return The message for the failed rule
 */
QString Validator::getRuleMessage(const QString rule) {

    QString message = QString("regla %1 sin definir").arg(rule);

    if (rule == "greaterThan") {
        message = QString("El valor de %1 debe ser mayor que %2").arg(m_name).arg(QString::number( m_validatesDouble[rule] ) );
    }

    if (rule == "greaterThanOrEqualTo") {
        message = QString("El valor de %1 debe ser mayor o igual que %2").arg(m_name).arg(QString::number( m_validatesDouble[rule] ) );
    }

    if (rule == "lessThan") {
        message = QString("El valor de %1 debe ser menor que %2").arg(m_name).arg(QString::number( m_validatesDouble[rule] ) );
    }

    if (rule == "lessThanOrEqualTo") {
        message = QString("El valor de %1 debe ser menor o igual que %2").arg(m_name).arg(QString::number( m_validatesDouble[rule] ) );
    }

    if (rule == "notEmpty" || rule == "mustNotContain") {
        message = QString("El valor de %1 no puede estar vacío").arg(m_name);
    }

    return message;

}

/**
 * @brief Checks that the current value is > than the stored
 * @param currentValue The value we need to check
 * @return True if it's >, false otherwise
 */
bool Validator::checkGreaterThan(const double currentValue) const {
    return currentValue > m_validatesDouble["greaterThan"];
}

/**
 * @brief Checks that the current value is >= than the stored
 * @param currentValue The value we need to check
 * @return True if it's >=, false otherwise
 */
bool Validator::checkGreaterThanOrEqualTo(const double currentValue) const {
    return currentValue >= m_validatesDouble["greaterThanOrEqualTo"];
}

/**
 * @brief Checks that the current value is < than the stored
 * @param currentValue The value we need to check
 * @return True if it's <, false otherwise
 */
bool Validator::checkLessThan(const double currentValue) const {
    return currentValue < m_validatesDouble["lessThan"];
}

/**
 * @brief Checks that the current value is <= than the stored
 * @param currentValue The value we need to check
 * @return True if it's <=, false otherwise
 */
bool Validator::checkLessThanOrEqualTo(const double currentValue) const {
    return currentValue <= m_validatesDouble["lessThanOrEqualTo"];
}

/**
 * @brief Checks that the current value is not empty
 * @param currentValue The value we need to check
 * @return True if it's empty, false otherwise
 */
bool Validator::checkNotEmpty(const QString currentValue) const {
    return !currentValue.isEmpty();
}
