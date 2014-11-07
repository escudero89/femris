#ifndef FEMRISXMLCONTENTHANDLER_H
#define FEMRISXMLCONTENTHANDLER_H

#include <QXmlDefaultHandler>
#include <QXmlAttributes>

class FemrisXmlContentHandler : public QXmlDefaultHandler {
public:
    FemrisXmlContentHandler():QXmlDefaultHandler() {}
    ~FemrisXmlContentHandler() {}

    bool startElement(const QString &, const QString &, const QString &, const QXmlAttributes &);

};

#endif // FEMRISXMLCONTENTHANDLER_H
