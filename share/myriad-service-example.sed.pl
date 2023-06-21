package a::b::c;
use Myriad::Service;

=head1 NAME

a::b::c - New service from template

=head1 ATTRIBUTES

=head1 METHODS

=head2 startup

Initialize the service

=cut

async method startup () {
}

=head2 diagnostics

Check our object liveness

=cut

async method diagnostics ($level) {
    return "ok";
}

1;


