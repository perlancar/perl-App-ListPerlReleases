package App::ListPerlReleases;

# DATE
# VERSION

use 5.010001;
use strict;
use warnings;

use Perinci::Sub::Gen::AccessTable qw(gen_read_table_func);

use Exporter;
our @ISA = qw(Exporter);
our @EXPORT_OK = qw(
                       list_perl_releases
               );

my $res = gen_read_table_func(
    name => 'list_perl_releases',
    table_data => sub {
        require CPAN::Perl::Releases;

        my @data;
        my @vers = CPAN::Perl::Releases::perl_versions();
        for my $ver (@vers) {
            my $tarballs = CPAN::Perl::Releases::perl_tarballs($ver);
            my $tarball = $tarballs->{ (sort keys %$tarballs)[0] };
            push @data, {
                version => $ver,
                tarball => $tarball,
            };
        }

        {data => \@data};
    },
    table_spec => {
        summary => 'List of Perl releases',
        fields => {
            version => {
                schema => 'str*',
                pos => 0,
                sortable => 1,
            },
            tarball => {
                schema => 'filename*',
                pos => 1,
                sortable => 1,
            },
        },
        pk => 'version',
    },
);
die "BUG: Can't generate list_perl_releases: $res->[0] - $res->[1]"
    unless $res->[0] == 200;

1;
# ABSTRACT: List Perl releases

=head1 SYNOPSIS

See the included script L<list-perl-releases>.


=head1 DESCRIPTION

This distribution offers L<list-perl-releases>, a CLI front-end for L<


=head1 SEE ALSO

L<Debian::Releases>

L<Ubuntu::Releases>

=cut
