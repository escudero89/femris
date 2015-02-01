#include "femrisxmlcontenthandler.h"
#include "configure.h"

#include <iostream>
#include <QDebug>

/**
 * @brief The reader calls this function when it has parsed a start element tag.
 *
 * @param namespaceURI The namespace URI, or an empty string if the element has
 * no namespace URI or if no namespace processing is done
 *
 * @param localName The local name (without prefix), or an empty string if no
 * namespace processing is done
 *
 * @param qName The qualified name (with prefix)
 * @param atts An empty attributes object
 *
 * @return Always true (it would be false if there were an error rendering
 */
bool FemrisXmlContentHandler::startElement(
        const QString & namespaceURI,
        const QString & localName,
        const QString & qName,
        const QXmlAttributes & atts ) {

    if (localName == "item") {
        Configure::write(atts.value("setting"), atts.value("value"));
    }

    return true;
}
