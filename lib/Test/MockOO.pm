package Test::MockOO;
use strict;
use warnings;
use Scalar::Util 'blessed';

use Test::MockOO::Class;

our $VERSION = '0.01';

sub create {
    my $self    = shift;
    my $genitor = shift;

    my $class;

    if (blessed($genitor)) {
        # ->new(Mock->meta)
        if ($genitor->isa('Test::MockOO::Class')) {
            $class = $genitor;
        }
        # ->new(Foreign->new)
        else {
            $class = Test::MockOO::Class->create_anon_class(
                superclasses => [Scalar::Util::blessed($genitor)],
            );
        }
    }
    elsif ($genitor) {
        my $metaclass = Class::MOP::class_of($genitor);
        # ->new('Mock')
        if ($metaclass && $metaclass->isa('Test::MockOO::Class')) {
            $class = Class::MOP::class_of($genitor);
        }
        # ->new('Foreign')
        else {
            $class = Test::MockOO::Class->create_anon_class(
                superclasses => [$genitor],
            );
        }
    }
    else {
        $class = Test::MockOO::Class->create_anon_class;
    }

    my $instance = $class->new_object;

    return $instance if !wantarray;
    return ($class, $instance);
}

1;

__END__

=pod

=head1 NAME

Test::MockOO - An OO mocking framework built on Moose

=head1 SYNOPSIS

    use Test::MockOO;
    my ($meta_mock, $mock) = Test::MockOO->create();
    $meta_mock->set_true( 'somemethod' );
    ok( $mock->somemethod() );

=head1 DESCRIPTION

Test::MockOO provides a modern framework for mocking dependencies as you test
modules.

Test::MockOO can be used to create a new, empty mock object, as shown in the
synopsis. It can also be used to extend an existing class or object. See the
L<create method|/Test::MockOO->create()> for details.

L<Test::MockOO::Declare> can be used to write Moose mock packages. This allows
you to create a set of mock classes, using both Moose and Test::MockOO syntax.

Test::MockOO mock objects provide an interface similar to chromatic's
L<Test::MockObject>. However, Test::MockOO's mocks differ from
L<Test::MockObject> in some important ways:

=over 4

=item * Test::MockOO extends L<Moose> (and, by extension, L<Class::MOP>) to
manipulate Perl classes and objects

=item * Test::MockOO expects you to use the class meta object to create mock
methods. The actual mock object instance only provides methods you declare;
this differs from L<Test::MockObject>, where the mock object provides both the
mocking interface as well as the mocked interface.

=back

Keep in mind that Test::MockOO is still a work in progress and does not yet
implement some useful features:

=over 4

=item * Test::MockOO does not yet have the ability to directly modify an
existing package. L<Test::MockObject> does have this ability.

However, if you're thinking of doing this, consider using a less invasive
method of doing dependency injection, if possible. For example, if you're
writing the module you're testing, consider using the factory method pattern.

=item * Test::MockOO does not provide "scoped" mocks. L<Sub::Override> does
provide this ability.

=back

=head1 METHODS

=over 4

=item B<< Test::MockOO->create() >>
=item B<< Test::MockOO->create($mock) >>
=item B<< Test::MockOO->create($obj) >>
=item B<< Test::MockOO->create('class') >>

Uses L<Test::MockOO::Class> to create a new anonymous class (if necessary) and
returns the L<Test::MockOO::Class> meta class object and a new instance of the
anonyous class. In scalar context, returns just the new instance.

If no object or class name is given, an empty anonymous class is created:

    my ($meta_mock, $mock) = Test::MockOO->create();
    # $mock is an instance of an empty anonymous class. $meta_mock is the meta
    # class object for this new anonymous class.

If an existing mock object or its meta class object is given, the existing
meta class is re-used (a new meta class is not created):

    ($meta_mock, $new_mock) = Test::MockOO->create($mock);
    # $new_mock is a new instance of the same class as $mock. $meta_mock is the
    # existing meta class object.

Otherwise, a new anonymous class that inherits from the given class is
created. In the case of an object, the anonymous class will inherit from the
class the object is blessed into:

    ($meta_mock, $mock) = Test::MockOO->create('MyClass');
    # $mock is a new instance of a new anonymous class that inherits from
    # MyClass. $meta_mock is the meta class object for this new anonymous class.

The meta class object is a L<Test::MockOO::Class> object. To add mock methods
to your mock object, use the L<Test::MockOO::Class> meta object's mock
creation methods. See L<Test::MockOO::Class> for details.

If you've lost your meta class object, you can recover it thusly:

    $meta_mock = Class::MOP::class_of($mock);

=back

=head1 SEE ALSO

=over 4

=item L<Test::MockOO::Class>

=item L<Test::MockOO::Declare>

=item L<Moose>

=item L<Test::MockObject>

=item L<Sub::Override>

=item Wikipedia entry on mock objects: L<http://en.wikipedia.org/wiki/Mock_object>

=item Wikipedia entry on dependency injection: L<http://en.wikipedia.org/wiki/Dependency_injection>

=item Wikipedia entry on the factory method pattern: L<http://en.wikipedia.org/wiki/Factory_method_pattern>

=back

=head1 BUGS

Quite possibly, please report them.

=head1 AUTHOR and CONTRIBUTORs

Shawn (sartak) Moore

Daniel (eqhmcow) Sterling

=head1 COPYRIGHT AND LICENSE

Copyright 2009 by Shawn Moore.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
