package Test::MockOO::Calls;
use Moose;
use MooseX::AttributeHelpers;

has calls => (
    metaclass => 'Collection::Array',
    is        => 'ro',
    isa       => 'ArrayRef[Test::MockOO::Call]',
    default   => sub { [] },
    provides  => {
        push  => '_add_call',
        clear => 'clear',
    },
);

__PACKAGE__->meta->make_immutable;
no Moose;

1;
