function parsed = jsonParser(key, value, cleanValue)

    parsed = strcat('  "', key, '" : "', value, '",\r\n');

    if ( nargin > 2 )
        parsed = strcat('  "', key, '" : ', value);
    end

