#!/usr/bin/perl
use strict;
use warnings;
use HTTP::Daemon;
use HTTP::Status;

# Crear un nuevo daemon
my $d = HTTP::Daemon->new(
    LocalAddr => '127.0.0.1',
    LocalPort => 8080,
    Reuse     => 1
) or die "No se pudo crear el daemon: $!";

print "Servidor escuchando en: ", $d->url, "\n";

while (my $c = $d->accept) {
    while (my $r = $c->get_request) {
        if ($r->method eq 'GET') {
            # Responder con "Hola, Mundo!"
            $c->send_response(HTTP::Response->new(RC_OK, 'OK', ['Content-Type' => 'text/plain'], "Hola, Mundo!\n"));
        } else {
            $c->send_error(RC_METHOD_NOT_ALLOWED);
        }
    }
    $c->close;
    undef($c);
}
