use inc::Module::Install;
name 'Plass';
all_from 'lib/Plass.pm';

requires 'Clone';
requires 'Hash::AsObject';
requires 'Object::Method';

tests 't/*.t';
author_tests 'xt';

test_requires 'Test::More';
auto_include;
WriteAll;
