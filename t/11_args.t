use Test::More;
use Plass;

my $human = plass
    walk => sub {
        my ( $self, $dir ) = @_;
        return $self->name. " walks to $dir.";
    };

my $ytnobody = $human->plass( name => 'ytnobody' );

is $ytnobody->walk( 'east' ), 'ytnobody walks to east.';

done_testing();
