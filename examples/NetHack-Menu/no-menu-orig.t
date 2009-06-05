use strict;
use warnings;
use Test::More tests => 12;
use Test::MockObject;
use Test::Exception;

use NetHack::Menu;

my $vt = Test::MockObject->new;
$vt->set_always(rows => 24);
$vt->set_isa('Term::VT102');

my $menu = NetHack::Menu->new(vt => $vt);

$vt->set_always(row_plaintext => (' ' x 80));
ok(!$menu->has_menu, "has_menu reports no menu");
throws_ok { $menu->at_end } qr/Unable to parse a menu/;

$vt->set_always(row_plaintext => '(end) or is it?');
ok(!$menu->has_menu, "has_menu reports no menu");
throws_ok { $menu->at_end } qr/Unable to parse a menu/;

$vt->set_always(row_plaintext => '(1 of 1) but we make sure to check for \s*$');
ok(!$menu->has_menu, "has_menu reports no menu");
throws_ok { $menu->at_end } qr/Unable to parse a menu/;

$vt->set_always(row_plaintext => '            (-1 of 1)   ');
ok(!$menu->has_menu, "has_menu reports no menu");
throws_ok { $menu->at_end } qr/Unable to parse a menu/;

$vt->set_always(row_plaintext => '            (0 of 1)');
ok(!$menu->has_menu, "has_menu reports no menu");
throws_ok { $menu->at_end } qr/Unable to parse a menu/;

$vt->set_always(row_plaintext => '            (1 of 0)');
ok(!$menu->has_menu, "has_menu reports no menu");
throws_ok { $menu->at_end } qr/Unable to parse a menu/;

