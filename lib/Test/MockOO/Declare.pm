package Test::MockOO::Declare;
use Moose ();
use Moose::Exporter;
use Test::MockOO;

Moose::Exporter->setup_import_methods(
    with_caller => [qw(true false)],
    also => 'Moose',
);

sub true {
    my $meta = Class::MOP::class_of(shift);
    $meta->set_true(@_);
}

sub false {
    my $meta = Class::MOP::class_of(shift);
    $meta->set_false(@_);
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

