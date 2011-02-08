use Test::More;
use Plass;

my $human = plass hello => sub { "Hi. My name is ".shift->name."." };

my $baker = $human->plass( bake => sub { bless {}, 'Bread' } );
my $programmer = $human->plass( code => sub { bless { work => $_[1] }, 'Code' } );
my $hacker = $programmer->plass( code => sub { bless { work => $_[1] }, 'SuperCode' } );

my $john = $human->plass( name => 'john' );
my $bob = $baker->plass( name => 'bob' );
my $mike = $programmer->plass( name => 'mike' );
my $brian = $hacker->plass( name => 'brian' );

is $john->hello, 'Hi. My name is john.';

is $bob->hello, 'Hi. My name is bob.';
isa_ok $bob->bake, 'Bread';

is $mike->hello, 'Hi. My name is mike.';
isa_ok $mike->code, 'Code';

is $brian->hello, 'Hi. My name is brian.';
isa_ok $brian->code, 'SuperCode';

done_testing();
