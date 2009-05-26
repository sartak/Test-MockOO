package Test::MockOO::Class;
use Moose 0.80; # Moose < 0.80 has bugs with anonymous classes

extends 'Moose::Meta::Class';

with (
    'Test::MockOO::Mocks',
    'Test::MockOO::CallTracing',
);

# purify mock class by removing the meta method that
# Class::MOP::Class::create adds
# FIXME: do we want to do this?
sub create {
    my ($self, $package_name, %options) = @_;
    my $meta = $self->SUPER::create($package_name, %options);
    $meta->remove_method('meta') unless $options{methods}{meta};
    return $meta;
}

__PACKAGE__->meta->make_immutable;
no Moose;

1;

