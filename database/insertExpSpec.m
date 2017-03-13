function insertExpSpec(expSpec,conn)
    insert(conn,'ExpSpec',fieldnames(expSpec),expSpec);
end

