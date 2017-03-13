function insertExpIntoDb(Analyzer,dbHost,dbName,dbUser,dbPass)
    conn = getDbConn(dbHost,dbName,dbUser,dbPass);
	
	expSpec = getExpSpec(Analyzer);
	insertExpSpec(expSpec,conn);
	
	close(conn);
end

