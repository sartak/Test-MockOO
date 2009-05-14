package Test::MockOO::Calls;
use Moose;
use MooseX::AttributeHelpers;

has calls => (
    metaclass => 'Collection::Array',
    isa       => 'ArrayRef[Test::MockOO::Call]',
    default   => sub { [] },
    provides  => {
        push     => '_add_call',
        clear    => 'clear',
        elements => 'calls',
    },
);

sub called_ok {
    my $self = shift;
    my $name = shift;
    my $desc = shift;

    my $found = 0;
    for my $call ($self->calls) {
        $found = 1, last if $call->name eq $name;
    }

    Test::More::ok($found, $desc || "called the $name method");
}

__PACKAGE__->meta->make_immutable;
no Moose;

1;
