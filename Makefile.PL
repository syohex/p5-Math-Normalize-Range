use inc::Module::Install;
use Module::Install::AuthorTests;
use Module::Install::Repository;

name 'Math-Normalize-Range';
all_from 'lib/Math/Normalize/Range.pm';

requires 'List::MoreUtils';

author_tests('xt');
auto_set_repository();
WriteAll;
