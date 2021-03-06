sub MSH_DropDB{
	my $dbh=shift;
	my $db_name=shift;
	#create db
	my $sql=sprintf("DROP DATABASE  %s ;",$db_name);
	$dbh->do($sql);
}
sub MSH_CreateDB{
	my $dbh=shift;
	my $db_name=shift;
	#create db
	my $sql=sprintf("CREATE DATABASE  %s ;",$db_name);
	$dbh->do($sql);
}
sub MSH_OpenDB{
	my $dbname=shift;
	return DBI->connect("DBI:mysql:database=$dbname;host=localhost", "root", "1983410", {'RaiseError' => 1});
}
sub MSH_GetValue{
	my $dbh=shift;
	my $table=shift;
	my $column=shift;
	my $condition=shift;
	#show tables
	if(defined $condition){
		$sql=sprintf("select %s from %s where %s",$column,$table,$condition);		
	}else{
		$sql=sprintf("select %s from %s",$column,$table);		
	}
	my $sth =$dbh->prepare($sql);
	if($sth){
		$sth->execute();
		return _array_value($sth);
	}
	return undef;
}
sub MSH_GetValueFirst{
	my $dh=shift;
	my $table=shift;
	my $column=shift;
	my $condition=shift;
	
	my @result=MSH_GetValue($dh,$table,$column,$condition);
	if(@result){
		return $result[0];
	}
	return undef;
}
sub MSH_GetAllTablesName1{
	my $dbh=shift;
	#show tables
	$sql=("SHOW TABLES;");
	my $sth =$dbh->prepare($sql);
	$sth->execute();
	my @names=();
	while(my $code=$sth->fetchrow_array){
		push @names,$code;
	}
	return @names;
}
sub MSH_GetAllTablesNameArrary{
	my $dbh=shift;
	my $db_name=shift;
	#use database;
	my $sql=sprintf("USE %s ;",$db_name);
	$dbh->do($sql);
	#show tables
	$sql=("SHOW TABLES;");
	my $sth =$dbh->prepare($sql);
	$sth->execute();
	my @names=();
	while(my $code=$sth->fetchrow_array){
		push @names,$code;
	}
	return @names;
}
sub MSH_GetAllTablesName{
	my $dbh=shift;
	my $db_name=shift;
	#use database;
	my $sql=sprintf("USE %s ;",$db_name);
	$dbh->do($sql);
	#show tables
	$sql=("SHOW TABLES;");
	my $sth =$dbh->prepare($sql);
	$sth->execute();
	my @names=();
	while(my $code=$sth->fetchrow_array){
		push @names,$code;
	}
	return join('',@names,'');
}
sub MSH_CreateTable{
	my $dbh=shift;
	my $TableName=shift;
	my $CreateDefinition=shift;
	my $sql=sprintf("CREATE TABLE %s (%s);",$TableName,$CreateDefinition);
	return $dbh->do($sql);
}
sub MSH_DropTable{
	my $dbh=shift;
	my $TableName=shift;
	my $sql=sprintf("DROP TABLE %s ;",$TableName);
	return $dbh->do($sql);
}
sub MSH_DropTableIfExist{
	my $dbh=shift;
	my $TableName=shift;
	my $sql=sprintf("DROP TABLE IF EXISTS %s ;",$TableName);
	return $dbh->do($sql);
}
sub MSH_CreateTableIfNotExist{
	my $dbh=shift;
	my $TableName=shift;
	my $CreateDefinition=shift;
	my $sql=sprintf("CREATE TABLE IF NOT EXISTS %s (%s);",$TableName,$CreateDefinition);
	return $dbh->do($sql);
}
sub _array_value
{
	my ($sth)=@_;
	if($sth){
		my @value=();
		while(my @code=$sth->fetchrow_array){
			push @value,@code;
		}
		return @value;
	}
	return undef;
}
sub MSH_CountRows{
	my $dbh=shift;
	my $TableName=shift;
	my $Key=shift;
	my $sql=sprintf("SELECT COUNT(*) FROM %s;",$TableName);
	my $sth =$dbh->prepare($sql);
	$sth->execute();
	my @value=_array_value($sth);
	if(@value){
		return $value[0];
	}
	return 0;
}
sub MSH_SetUniqueKey{
	my $dbh=shift;
	my $TableName=shift;
	my $Key=shift;
	my $sql=sprintf("ALTER TABLE  %s ADD UNIQUE (%s);",$TableName,$Key);
	$dbh->do($sql);
}
sub MSH_Delete
{
	my ($dbh,$TableName,$Condition)=@_;
	my $sql = sprintf("DELETE FROM %s WHERE %s;",$TableName,$Condition);
	$dbh->do($sql);
}
1;
