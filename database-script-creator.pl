#!/usr/bin/perl -w

if ( scalar @ARGV != 4 ) {
    die "usage: $0 sql-dbs sql-roles sql-drops postgisdbs

Read Postgresql database dump from stdin and write a modified version to
stdout. The following modifications will be made:
- all CREATE DATABASE clauses will be removed
- all CREATE ROLE clauses will be removed
- all definitions of Postgis supplied functions will be removed
  (these functions are typically generated by sql scripts from postgis)

While processing the following files will be written named by parameters:
sql-dbs: CREATE DATABASE clauses in SQL format to recreate the databases
sql-roles: CREATE ROLE clauses in SQL format to recreate the roles
sql-drops: SQL script to drop all databases and roles created
postgisdbs: a plain text file of one database name per line of
        all those databases encountered which had postgis functions in them.

The script is used to generate files which may be used to restore a
database regardless of postgis version possibly used. Also, the
created restore file will run whether the databases and roles are there
already.

To use resulting files:
- run sql-dbs and sql-roles
- run postgis installation sqls for all databases named in postgisdbs
- run the output of this command

To remove test data run sql-drops(NOTE: it will remote ALL data in those databases).

WARNING: running this command will overwrite anything already in the
files named by parameters
" ;
	
}

open DATABASES,">".$ARGV[0];
open ROLES,">".$ARGV[1];
open DROPS,">".$ARGV[2];

my $currentdb="";
my $currentfunction="";
my $functionbody="";
my %postgisdbs=();

while (<STDIN>) {
    my $line = $_ ;

    if ($line =~ m/^CREATE ROLE ([a-z_]*)/ ) {
	if ($1 eq "postgres") {
	    # Don't try to recreate postgres
	    next ; # Go to next line
	}
	print DROPS "DROP ROLE IF EXISTS $1;\n";
	print ROLES $line;
	next;
    }
    if ($line =~ m/^CREATE DATABASE ([a-z_]*)/ ) {
	# Create databases in a separate script
	print DATABASES $line ;
	print DROPS "DROP DATABASE IF EXISTS $1;\n";
	next ;
    }
    if ($currentfunction) {
	$functionbody.=$line;
	if ($line =~ /;\s*$/) {
	    $currentfunction="";
	    # Function body ends
	    if ($functionbody =~ m/AS '[^']*postgis/ ) {
		# This is a Postgis function, skipping it completely
		# but recording the database
		$postgisdbs{$currentdb}=1;
		next;
	    } else {
		print $functionbody;
		next;
	    }
	} else {
	    # Function body continues
	    next;
	}
    }
    if ($line =~ m/^CREATE FUNCTION ([a-zA-Z_.]*)/ ) {
	$currentfunction=$1;
	$line =~ s/^CREATE FUNCTION/CREATE OR REPLACE FUNCTION/ ;
	$functionbody=$line;
	next;
    }
    if ($line =~ m/^\\connect ([a-z_]*)/ ) {
	$currentdb=$1;
    }
    
    print $line ;
}

open POSTGIS,">$ARGV[3]" ;
foreach my $db (sort keys %postgisdbs) {
    print POSTGIS "$db\n";
}
