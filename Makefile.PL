require 5.002;
use ExtUtils::MakeMaker;
WriteMakefile(
#   'DISTNAME'		=> 'Array-PrintCols',
    'NAME'		=> 'Array::PrintCols',
    'VERSION'		=> '2.0',

    'clean' => { FILES => 'test.out' },
    'dist'  => { COMPRESS => 'gzip', SUFFIX => '.gz' },

);
