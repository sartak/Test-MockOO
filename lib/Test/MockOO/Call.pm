package Test::MockOO::Call;
use Moose;

has name => (
    is       => 'ro',
    isa      => 'Str',
    required => 1,
);

has arguments => (
    is       => 'ro',
    isa      => 'ArrayRef',
    required => 1,
);

__PACKAGE__->meta->make_immutable;
no Moose;

1;
