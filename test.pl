#!/usr/bin/perl

# test.pl
# Script to run tester.pl and compare the output against previous runs

$testout  = 'test.out';		# where this output goes
$testref  = "$testout.ref";
$testdiff = "$testout.diff";

unlink $testout;

open(savSTDOUT, ">&STDOUT");
open(savSTDERR, ">&STDERR");

open(STDOUT,">test.stdout"); open(STDERR,">test.stderr");
select(STDOUT);
do 'tester.pl';
close STDOUT; close STDERR;

# Copy stdout & stderr to the test.out file
open(TESTOUT,">$testout");
select(TESTOUT);
print "*** STDOUT ***\n";
open(OUT,"<test.stdout"); while (<OUT>) { print; } close OUT;
print "*** STDERR ***\n";
open(ERR,"<test.stderr"); while (<ERR>) { print; } close ERR;
close TESTOUT;
unlink ('test.stdout', 'test.stderr');

open(STDOUT, ">&savSTDOUT");
open(STDERR, ">&savSTDERR");
select(STDOUT);

if (! -f $testref) {			# any existing reference?
    system("cp $testout $testref");	# no, copy
}

system("diff $testref $testout >$testdiff");

if ($?>>8) {
    print "There are differences; see \"$testdiff\".\n";
} else {
    print "No differences.\n";
    unlink $testdiff;
}
