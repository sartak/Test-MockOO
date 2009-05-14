package Test::MockOO::Declare;
use Moose ();
use Moose::Exporter;
use Test::MockOO;

my %delegates = (
    mock   => 'mock',
    true   => 'set_true',
    false  => 'set_false',
    always => 'set_always',
    series => 'set_series',
);

Moose::Exporter->setup_import_methods(
    with_caller => [keys %delegates],
    also => 'Moose',
);

for my $name (keys %delegates) {
    my $method = $delegates{$name};

    no strict 'refs';
    *{__PACKAGE__.'::'.$name} = sub {
        my $meta = Class::MOP::class_of(shift);
        $meta->$method(@_);
    };
}

sub init_meta {
    shift;
    my %options = @_;

    return Moose->init_meta(
        for_class  => $options{for_class},
        metaclass  => 'Test::MockOO::Class',
    );
}

1;

