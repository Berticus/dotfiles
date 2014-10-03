#!/usr/bin/env python3
# author: Albert Chang <albert.chang@gmx.com>
# notes: https://tools.ietf.org/html/rfc3507#section-4.4.1
# python_version: 3.3.0
#--

import socket, socketserver
import time
# from http.server import BaseHTTPRequestHandler # for REQMOD requests

# TODO: better logging
# TODO: probably have a config parser to allow certain settings to be changed
#       such as the port and server

__version__ = '0.0.0'
__all__ = ['ICAPServer', 'BaseICAPRequestHandler']

class ICAPServer(socketserver.ThreadingMixIn, socketserver.TCPServer):
    allow_reuse_address = True

    def server_bind(self):
        socketserver.TCPServer.server_bind(self)
        host, port = self.socket.getsockname()[:2]
        self.server_name = socket.getfqdn(host)
        self.server_port = port

class BaseICAPRequestHandler(socketserver.StreamRequestHandler):
    server_version = 'ICAPServer/' + __version__

    responses = {
            100: 'Continue After ICAP Preview',
            101: 'Switching Protocols',
            200: 'OK',
            201: 'Created',
            202: 'Accepted',
            203: 'Non-Authoritative Information',
            204: 'No Modifications Needed',
            205: 'Reset Content',
            206: 'Partial Content',
            300: 'Multiple Choices',
            301: 'Moved Permanently',
            302: 'Found',
            303: 'See Other',
            304: 'Not Modified',
            305: 'Use Proxy',
            307: 'Temporary Redirect',
            400: 'Bad Request',
            401: 'Unauthorized',
            402: 'Payment Required',
            403: 'Forbidden',
            404: 'ICAP Service Not Found',
            405: 'Method Not Allowed for Service',
            406: 'Not Acceptable',
            407: 'Proxy Authentication Required',
            408: 'Request Timeout',
            409: 'Conflict',
            410: 'Gone',
            411: 'Length Required',
            412: 'Precondition Failed',
            413: 'Request Entity Too Large',
            414: 'Request-URI Too Long',
            415: 'Unsupported Media Type',
            416: 'Requested Range Not Satisfiable',
            417: 'Expectation Failed',
            428: 'Precondition Required',
            429: 'Too Many Requests',
            431: 'Request Header Fields Too Large',
            500: 'Internal Server Error',
            501: 'Not Implemented',
            502: 'Bad Gateway',
            503: 'Service Overloaded',
            504: 'Gateway Timeout',
            505: 'ICAP Version Not Supported by Server',
            511: 'Network Authentication Required'
            }

    supported = ['1.0']

    protocol_version = 'ICAP/1.0'

    def iterate_request(self):
        # Get the ICAP request, and find out what the command, URI,
        # and protocol version are.
        request = str(self.rfile.readline(), 'iso-8859-1').split()
        if len(request) != 3:
            self.respond(400)
        self.cmd = request[0]
        self.request_uri = request[1]
        self.protocol = request[2].split('/')
        # Must be:
        # 1. ICAP
        # 2. Protocol version 1.0
        if self.protocol[0] != 'ICAP':
            self.respond(400)
            return
        try: 
            self.supported.index(self.protocol[1])
        except IndexError:
            self.respond(400)   # can't find protocol version
            return
        except ValueError:
            self.respond(505)
            return
        self.path = '/'.join(self.request_uri.split('/')[3:])
        # TODO: add services and get the appropriate service based on path
        if not self.path or self.path == 'echo':
            service = self
        else:
            self.respond(404)

        # Execute command
        cmname = 'do_' + self.cmd
        if not hasattr(service, cmname):
            self.respond(501)

        method = getattr(service, cmname)
        method()

    #def register_service(self, path='', service=BaseICAPService())
    #    if not self.hasattr(service_map):
    #        self.service_map = {}
    #    service_map.update{path, service}

    def handle(self):
        self.iterate_request()
        self.close_connection = False
        while not self.close_connection:
            self.iterate_request()

    def respond(self, code, message = None):
        if not message:
            try:
                message = self.responses[code]
            except IndexError:
                message = '???'
        self._response_buffer = []
        # Write out the response code
        self._response_buffer.append(("%s %s %s:\r\n" %
            (self.protocol_version, code, message)).encode(
                'latin-1', 'strict'))

        # TODO: just call add_header() and get rid of the _headers list
        #       everything is being duplicated when we have a nice method
        #       to do everything for us

        # Write out the date
        self._response_buffer.append(("Date: %s\r\n" %
            time.strftime('%a, %d %b %Y %T %Z', time.gmtime())).encode(
                'latin-1', 'strict'))

        # Write out the server and version
        self._response_buffer.append(("Server: %s\r\n" %
            self.server_version).encode(
                'latin-1', 'strict'))

        # Write out what we allow
        # TODO: introspectively return methods
        #       would need to find do_COMMAND methods which do not
        #       return a 405
        self._response_buffer.append(("Methods: %s, %s\r\n" %
            ("RESPMOD", "REQMOD")).encode(
                'latin-1', 'strict'))

        # TODO: temporary hard coded headers
        # Don't send us anymore content.
        self._response_buffer.append(("Options-TTL: 3600\r\n").encode('latin-1', 'strict'))

        # Adds any custom headers
        if hasattr(self, '_headers'):
            self._response_buffer.extend(self._headers)

        self._response_buffer.append("\r\n".encode('latin-1', 'strict'))
        self.wfile.write(b''.join(self._response_buffer))

        print("Sending response %s %s" % (code, self.responses[code]))

    def do_OPTIONS(self):
        print('OPTIONS request processed')
        self.add_header('Allow: 204')
        self.add_header("Encapsulated: null-body=0")
        self.respond(200)
        pass

    def do_REQMOD(self):
        self.respond(405)

    def do_RESPMOD(self):
        self.respond(405)

    # TODO: remove collissions.
    def add_header(self, obj):
        if not hasattr(self, '_headers'):
            self._headers = []
        self._headers.append((str(obj).strip() + "\r\n").encode('latin-1', 'strict'))


# TODO: add a service that can return a X-Infection-Found on eicar
def serve(server_class=ICAPServer, handler_class=BaseICAPRequestHandler):
    server_address = ('', 1344)
    icapd = server_class(server_address, handler_class)
    icapd.serve_forever()



if __name__ == '__main__':
    serve()
