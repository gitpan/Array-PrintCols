#!/usr/bin/perl
# test program for Array::PrintCols.pm
#
# test.pl [-no-compare]
# 
#    Copyright (C) 1995-1998  Alan K. Stebbens <aks@sgi.com>
#
#    This program is free software; you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation; either version 2 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program; if not, write to the Free Software
#    Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
#
# $Id: test.pl,v 1.2 1998/01/18 06:29:24 aks Exp $

BEGIN { unshift(@INC, '.'); }

use Array::PrintCols;

$ENV{'COLUMNS'} = 80;	# hard code to guarantee consistency

sub frame {
    print "\n";
    print $_[0];
    print "\n";
    for (1..80) { print ($_ % 10); }
    print "\n";
}

sub tests {

    @commands = sort qw( use server get put list set quit exit help );

	frame "Default arguments.\n";

    print_cols \@commands;

	frame "Using 2 columns.\n";

    print_cols \@commands, -2;

	frame "Using column width of 15.\n";

    print_cols \@commands, 15;

	frame "Using total width of 40.\n";

    print_cols \@commands,'', 40;

	frame "Using 2 columns in a total width of 40.\n";

    print_cols \@commands, -2, 40;

	frame "Using 3 columns in a total width of 40.\n";

    print_cols \@commands, -3, 40;

	frame "Using column width of 15 in a total width of 45.\n";

    print_cols \@commands, 15, 45;

	frame "Using defaults with an indent of 1.\n";

    print_cols \@commands,0,0,1;

	frame "Using 2 columns with an indent of 2.\n";

    print_cols \@commands, -2,0,2;

    # Build a big array of words
    @words = split(' ',`cat GNU-LICENSE`);
    foreach ( @words) { s/\W+$//; s/^\W+//; }
    @words{@words} = @words;
    @words = sort keys %words;
    undef %words;

	frame "Printing first 200 words from the dictionary using defaults.\n";

    print_cols \@words, '', '', 1;

	frame "Printing a list of words which failed at version 1.3\n";

	    # From: Wayne Scott <wscott@ichips.intel.com>

    @words = sort split(' ',<<EOF);
	 3D                    NTDesktop_long        memory                
	 FSPEC_complete        NTDesktop_short       photoshop             
	 FSPEC_long            NT_other_complete     sys32_win95_complete  
	 FSPEC_short           NT_other_long         sys32_win95_long      
	 ISPEC_complete        NT_other_short        sys32_win95_short     
	 ISPEC_long            SysNT_complete        ubench                
	 ISPEC_short           SysNT_long            vox                   
	 LargeApps             SysNT_short           wmt_ubench            
	 MMx_complete          Win95Desktop_complete xmark96_complete      
	 MMx_long              Win95Desktop_long     xmark96_long          
	 MMx_short             Win95Desktop_short    xmark96_short         
	 Multimedia_complete   front_end             
	 NTDesktop_complete    games                 
EOF
	
    print_cols \@words, '', '', 5;

}

# Check for -no-compare -- if it's given, don't do a comparison, just run
# the test.

while ($_ = shift @ARGV) {
    /^-n/ && $no_compare++;
}

unless ($no_compare) {

    $testout  = 'test.out';		# where this output goes
    $testref  = "$testout.ref";
    $testdiff = "$testout.diff";

    unlink $testout;

    open(savSTDOUT, ">&STDOUT");
    open(savSTDERR, ">&STDERR");

    open(STDOUT,">test.stdout"); open(STDERR,">test.stderr");
    select(STDOUT);
}

tests;

unless ($no_compare) {

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
	print "Uh-oh! There are differences; see \"$testdiff\".\n";
    } else {
	print "Yea! No differences.\n";
	unlink $testdiff;
    }
}
exit;
