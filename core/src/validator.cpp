#include "validator.h"

#include <QDebug>

#include <QString>

Validator::Validator() {

}

Validator::~Validator() {

}

/**
 * @brief Validator::addRule
 * @param rule
 * @param comparison
 * @param message
 */
void Validator::addRule(const QString rule, double comparison, QString message) {
    m_validatesDouble.insert(rule, comparison);
    m_validatesMessage.insert(rule, message);

    m_validationFields.append(rule);
}

/**
 * @brief Validator::addRuleMustContain
 * @param comparison
 */
void Validator::addRuleMustContain(const QString comparison) {
    m_validatesCustom.insert("mustContain", comparison);
    m_validationFields.append("mustContain");
}

bool Validator::validate(const QString currentValue, QString &failedRule) {

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
 * @brief Validator::checkRule
 * @param rule
 * @param currentValue
 * @return
 */
bool Validator::checkRule(const QString rule, const QString currentValue) {

    // If it hasn't the rule, returns true
    if (!m_validationFields.contains(rule)) {
        return true;
    }

    bool check = false;

    if (rule == "greaterThan") {
        check = checkGreaterThan(rule, currentValue.toDouble());
    }

    if (rule == "greaterThanOrEqualTo") {
        check = checkGreaterThanOrEqualTo(rule, currentValue.toDouble());
    }

    if (rule == "lessThan") {
        check = checkLessThan(rule, currentValue.toDouble());
    }

    if (rule == "lessThanOrEqualTo") {
        check = checkLessThanOrEqualTo(rule, currentValue.toDouble());
    }

    if (rule == "notEmpty") {
        check = checkNotEmpty(currentValue);
    }

    if (rule == "mustContain") {
        check = currentValue.contains(m_validatesCustom["mustContain"]);
    }

    // If some rule was enable, but the value is false, we return false
    if (check && currentValue == "false") {
        check = false;
    }

    return check;
}

/**
 * @brief Validator::getRuleMessage
 * @param rule
 * @return
 */
QString Validator::getRuleMessage(const QString rule) {

    QString message = "regla sin definir";

    if (rule == "greaterThan") {
        message = "El valor debe ser mayor que " + QString::number( m_validatesDouble["greaterThan"] );
    }

    if (rule == "greaterThanOrEqualTo") {
        message = "El valor debe ser mayor o igual que " + QString::number( m_validatesDouble["greaterThanOrEqualTo"] );
    }

    if (rule == "lessThan") {
        message = "El valor debe ser menor que " + QString::number( m_validatesDouble["lessThan"] );
    }

    if (rule == "lessThanOrEqualTo") {
        message = "El valor debe ser menor o igual que " + QString::number( m_validatesDouble["lessThanOrEqualTo"] );
    }

    if (rule == "notEmpty") {
        message = "El valor no puede ser vacío";
    }

    return message;

}

/**
 * @brief Validator::checkGreaterThan
 * @return
 */
bool Validator::checkGreaterThan(const QString rule, const double currentValue) {
    return currentValue > m_validatesDouble[rule];
}

/**
 * @brief Validator::checkGreaterThan
 * @return
 */
bool Validator::checkGreaterThanOrEqualTo(const QString rule, const double currentValue) {
    return currentValue >= m_validatesDouble[rule];
}

/**
 * @brief Validator::checkGreaterThan
 * @return
 */
bool Validator::checkLessThan(const QString rule, const double currentValue) {
    return currentValue < m_validatesDouble[rule];
}

/**
 * @brief Validator::checkGreaterThan
 * @return
 */
bool Validator::checkLessThanOrEqualTo(const QString rule, const double currentValue) {
    return currentValue <= m_validatesDouble[rule];
}

/**
 * @brief Validator::checkGreaterThan
 * @return
 */
bool Validator::checkNotEmpty(const QString currentValue) {
    return !currentValue.isEmpty();
}
