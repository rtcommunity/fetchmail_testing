use Test::More;
use File::Slurp qw(read_file);
use JSON;
use Data::Dumper;
use Net::IMAP::Simple;
my $filename    = shift;
my $text        = read_file($filename);
my $perl_scalar = decode_json $text;
SERVER: foreach my $server ( @{ $perl_scalar->{servers} } ) {
    die "oops " unless scalar @{ $server->{'users'} } == 1;
    my $user = @{ $server->{'users'} }[0];
    warn $user->{remote};
    test_imap ( $server->{'pollname'}, $user->{remote}, $user->{password} );
}

done_testing;

exit;

sub test_imap {
    my ( $server, $username, $password ) = @_;
    my $imap = Net::IMAP::Simple->new( $server, use_ssl => 1, timeout => 60 )
      || die "Unable to connect to '$server' : $Net::IMAP::Simple::errstr\n";
    ok $imap, "Connect to IMAP";
    if ($imap) {
        if ( !$imap->login( $username, $password ) ) {
            print STDERR "Login failed: " . $imap->errstr . "\n";
            fail "$user could not login";
            return;
        }
        my $nm = $imap->select('INBOX');
        $imap->logout;
        if ( $nm eq "0E0" ) {
            pass "inbox count 0";
        }
        else {
            my $max_inbox = 5;
            cmp_ok( $nm, '<=', $max_inbox,
                "More than messages in INBOX ($nm > $max_inbox)" );
        }
    }

}

