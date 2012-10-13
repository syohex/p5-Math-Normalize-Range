package Math::Normalize::Range;
use strict;
use warnings;
use 5.008_001;

our $VERSION = '0.01';

use Carp ();

sub new {
    my ($class, $num, $args) = @_;

    unless (defined $num) {
        Carp::croak("Undefined number");
    }

    my $target_min = $args->{target_min} || 0;
    my $target_max = $args->{target_max} || 1;

    _validate_min_max($target_min, $target_max);

    bless {
        num => $num,
        target_min => $target_min,
        target_max => $target_max,
    }, $class;
}

sub normalize {
    my ($self, %args) = @_;

    for my $key (qw/min max/) {
        unless (exists $args{$key}) {
            Carp::croak("missing mandatory parameter '$key'");
        }
    }

    my $num = $self->{num};
    my ($min, $max) = @args{'min', 'max'};
    _validate_min_max($min, $max);

    unless ($num > $min && $num < $max) {
        Carp::croak("Number should be min($min) < $num < max($max)");
    }

    my $unit = ($num - $min) / ($max - $min);
    return $unit * ($self->{target_max} - $self->{target_min}) + $self->{target_min};
}

sub _validate_min_max {
    my ($min, $max) = @_;
    unless ($min < $max) {
        Carp::croak("'min'($min) greater than 'max'($max)");
    }
}

1;
__END__

=encoding utf-8

=for stopwords

=head1 NAME

Math::Normalize::Range - Normalize within specified range

=head1 SYNOPSIS

  use Math::Normalize::Range;

  my $num = Math::Normalize::Range->new(10.0, {
      target_min => 1000, target_max => 10000
  });

  $num->normalize(min => 5, max => 20);

=head1 DESCRIPTION

Math::Normalize::Range normalizes number to specified range
Default range is 0.0 .. 1.0. You can normalize any range.

=head1 METHOD

=head2 Class Method

=head3 C<< Math::Normalize::Range->new($num, $option) >>

I<$options> may be:

=over

=item target_min

Target minimum number. Default is 0.

=item target_max

Target maximum number. Default is 1.

=back

=head2 Instance Method

=head3 C<< $number->normalize(min => $min, max => $max) >>

Normalize number in range(C<$min>..C<$max>) to target range.

=head1 AUTHOR

Syohei YOSHIDA E<lt>syohex@gmail.comE<gt>

=head1 COPYRIGHT

Copyright 2012- Syohei YOSHIDA

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 SEE ALSO

=cut
