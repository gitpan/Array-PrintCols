# Array-PrintCols.pm
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
# Author: Alan K. Stebbens <aks@hub.ucsb.edu>
#
# $Id: PrintCols.pm,v 1.2 1995/12/03 03:46:08 aks Exp $

package Array::PrintCols;

require 5.001;
use Exporter; 
@ISA = (Exporter);
@EXPORT = qw( print_cols );

sub min;
sub max;

$PreSorted = 1;			# if set, do not need to sort

# If users need to, they can set this variable externally:
#
# $Array::PrintCols::PreSorted = 0;
#

# print_cols \@array [, $col_width [, $total_width [, $indent ] ] ]
#
# or
#
# print_cols \@array [, -$columns [, $total_width, [, $indent ] ] ]

# Routine to display an array of values in alphabetically vertically 
# sorted columns. 

sub print_cols {
    my($array)       = shift;
    my($col_width)   = shift;
    my($total_width) = shift || $ENV{'COLUMNS'} || 80;
    my($indent)      = shift || 0;

    my($key,$max_len,$cols,$fmt,$cols,$col,$rows,$row);

    # calculate the maximum item length
    $max_len = max (map length, @$array);

    # Calculate maximum possible # of columns
    $cols = max 1, int(($total_width - $indent) / ($max_len + 1));

    # Now adjust the $cols based on $col_width
    if ($col_width < 0) {		# given as -$columns?
	if (-$col_width <= $cols) {	# is the value possible?
	    $cols = -$col_width;	# yes, set # of columns
	}
	# calculate the new maximum column width
	$col_width = min $max_len, int(($total_width - $indent) / $cols);
    } elsif ($col_width >= 0) {		# $col_width given?
	# get maximum of $max_len, $col_width
	$col_width = max $col_width, $max_len, 1;
	$cols = max 1, int(($total_width - $indent) / $col_width);
    }

    $rows = int(($#$array + $cols) / $cols);
    $fmt = sprintf("%%-%ds ",$col_width - 1);

    $array = [sort @$array] unless $PreSorted;	# sort if necessary
    for ($row = 0; $row < $rows; $row++) {
	print (' ' x $indent) if $indent > 0;
	for ($col = $row; $col <= $#$array; $col += $rows) {
	    printf $fmt,$array->[$col];
	}
	print "\n";
    }
}

sub min { 
    my($min) = shift;
    local($_);
    foreach (@_) { $min = $_ if $min > $_; }
    $min;
}

sub max {
    my($max) = shift;
    local($_);
    foreach (@_) { $max = $_ if $max < $_; }
    $max;
}

1;

__END__

=head1 NAME

print_cols

=head1 SYNOPSIS

C<use Array::PrintCols;>

C<print_cols \@I<array>;>

C<print_cols \@I<array>, $I<colspec>;>

C<print_cols \@I<array>, $I<colspec>, $I<total_width>;>

C<print_cols \@I<array>, $I<colspec>, $I<total_width>, $I<indent>;>

C<$Array::PrintCols::PreSorted = 0;>

=head1 DESCRIPTION

The C<print_cols> subroutine prints the items of C<@I<array>> in multiple,
alphabetically sorted vertical columns.  One, two, or three optional arguments
may be given to C<print_cols> to control the width and number of the columns,
the total width of the output, and indentation.  Reasonable defaults apply 
in the absence of the optional arguments (or when given as the empty string 
or zero).  Generally, the minimum width column is used when possible.

If C<$I<col_width>> is given as a non-negative number, it is treated as
the minimum width of the column; the actual width will be the maximum of
this value and the lengths of all array items.

If C<$I<col_width>> is given as a negative number, its absolute value
value is used to determine the total number of columns.  However, it cannot
exceed the total number of columns possible based on the maximum length
of all the array elements.

If a third argument is supplied, it is used as the total width of the
output.  The default for this value is the value of the environment
variable C<$ENV{'COLUMNS'}>, if defined, or 80.

If the fourth argument is given, it is used as the indent for all lines
printed, which subtracts from the total width of the output.  This
value defaults to zero (ie: no indention of the output).

The variable C<$Array::PrintCols::PreSorted> controls whether or not the
C<print_cols> subroutine will expect its array argument to already 
be sorted.  If this variable is nil or zero, C<print_cols> will
cause print out a sorted I<copy> of the input array.

=head1 EXAMPLE

    use Array::PrintCols;

    @commands = sort qw( use list put get set quit help server );

    # print in three columns with an indention of 1.
    print_cols \@commands, -3, 0, 1;

=head1 AUTHOR

Copyright (C) 1995  Alan K. Stebbens <aks@hub.ucsb.edu>

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.

=head1 BUGS

With Perl, you cannot default intervening arguments by leaving them empty;
you must supply a zero or empty-string ('').
