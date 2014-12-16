#include "femrisxmlcontenthandler.h"
#include "configure.h"

#include <iostream>
#include <QDebug>

bool FemrisXmlContentHandler::startElement(const QString & namespaceURI, const QString & localName,
                    const QString & qName, const QXmlAttributes & atts ) {

        if (localName == "item") {
            //qDebug() << atts.value("setting") << "|" << atts.value("value");
            Configure::write(atts.value("setting"), atts.value("value"));
        }

        return true;
}
