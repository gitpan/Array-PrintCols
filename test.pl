# test program for Array::PrintCols.pm
#
#    Copyright (C) 1995  Alan K. Stebbens <aks@hub.ucsb.edu>
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
# $Id: test.pl,v 1.2 1995/12/18 18:19:36 aks Exp $

use Array::PrintCols;

sub frame {
    print "\n";
    print $_[0];
    print "\n";
    for (1..80) { print ($_ % 10); }
    print "\n";
}

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

exit(0);
