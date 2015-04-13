#include "validator.h"

#include <QDebug>

#include <QString>

Validator::Validator(const QString name) {
    m_name = name;
}

Validator::~Validator() {

}

/**
 * @brief Validator::addRule
 * @param rule
 * @param name
 * @param comparison
 * @param message
 */
void Validator::addRule(const QString rule, double comparison, QString message) {
    m_validatesDouble.insert(rule, comparison);
    m_validatesMessage.insert(rule, message);

    m_validationFields.append(rule);
}

/**
 * @brief Validator::addRuleMustNotContain
 * @param name
 * @param comparison
 */
void Validator::addRuleMustNotContain(const QString comparison) {
    QString rule = "mustNotContain";

    m_validatesCustom.insert(rule, comparison);
    m_validationFields.append(rule);
}

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
 * @brief Validator::checkRule
 * @param rule
 * @param currentValue
 * @return
 */
bool Validator::checkRule(const QString rule, const QString currentValue) const {

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
 * @brief Validator::getRuleMessage
 * @param rule
 * @return
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
 * @brief Validator::checkGreaterThan
 * @return
 */
bool Validator::checkGreaterThan(const QString rule, const double currentValue) const {
    return currentValue > m_validatesDouble[rule];
}

/**
 * @brief Validator::checkGreaterThan
 * @return
 */
bool Validator::checkGreaterThanOrEqualTo(const QString rule, const double currentValue) const {
    return currentValue >= m_validatesDouble[rule];
}

/**
 * @brief Validator::checkGreaterThan
 * @return
 */
bool Validator::checkLessThan(const QString rule, const double currentValue) const {
    return currentValue < m_validatesDouble[rule];
}

/**
 * @brief Validator::checkGreaterThan
 * @return
 */
bool Validator::checkLessThanOrEqualTo(const QString rule, const double currentValue) const {
    return currentValue <= m_validatesDouble[rule];
}

/**
 * @brief Validator::checkGreaterThan
 * @return
 */
bool Validator::checkNotEmpty(const QString currentValue) const {
    return !currentValue.isEmpty();
}
