#include "femrisxmlcontenthandler.h"

#include <iostream>

bool FemrisXmlContentHandler::startElement(const QString & namespaceURI, const QString & localName,
                    const QString & qName, const QXmlAttributes & atts )
    {
        std::cout << "Read Start Tag : " << localName.toStdString()<< std::endl;
        std::cout << "Tag Attributes: " << std::endl;


        for(int index = 0 ; index < atts.length();index++)
        {
          std::cout << atts.type(index).toStdString()<< "="
          << atts.value(index).toStdString()<< std::endl;
        }

        std::cout << "------------------------" << std::endl;
        return true;
    };
