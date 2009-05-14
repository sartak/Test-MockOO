package Test::MockOO::Call;
use Moose;
use MooseX::AttributeHelpers;

has name => (
    is       => 'ro',
    isa      => 'Str',
    required => 1,
);

has arguments => (
    metaclass => 'Collection::List',
    is        => 'ro',
    isa       => 'ArrayRef',
    required  => 1,
    curries   => {
        get => { invocant => [0] },
    },
);

__PACKAGE__->meta->make_immutable;
no Moose;

1;
