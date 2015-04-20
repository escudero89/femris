#ifndef FEMRISXMLCONTENTHANDLER_H
#define FEMRISXMLCONTENTHANDLER_H

#include <QXmlDefaultHandler>
#include <QXmlAttributes>

/**
 * @brief This class helps to handle the proccessing of the configuration files in XML
 */
class FemrisXmlContentHandler : public QXmlDefaultHandler {

public:
    FemrisXmlContentHandler():QXmlDefaultHandler() {}
    ~FemrisXmlContentHandler() {}

    bool startElement(const QString &, const QString &, const QString &, const QXmlAttributes &);

};

#endif // FEMRISXMLCONTENTHANDLER_H
