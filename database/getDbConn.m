function conn = getDbConn(dbHost,dbName,dbUser,dbPass)
    conn = database(dbName,dbUser,dbPass,'Vendor','MySQL','Server',dbHost);
end