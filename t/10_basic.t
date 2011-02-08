use Test::More;
use Plass;

my $a = plass;
isa_ok $a, 'Plass';
can_ok $a, 'plass';

done_testing();
