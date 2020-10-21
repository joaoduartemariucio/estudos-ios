import UIKit

let sock_fd = socket(AF_INET, SOCK_STREAM, 0);
if sock_fd == -1 {
    perror("Failure: creating socket")
    exit(EXIT_FAILURE)
}

var sock_opt_on = Int32(1)
setsockopt(sock_fd, SOL_SOCKET, SO_REUSEADDR, &sock_opt_on, socklen_t(MemoryLayout.size(ofValue: sock_opt_on)))

var server_addr = sockaddr_in()
let server_addr_size = socklen_t(MemoryLayout.size(ofValue: server_addr))
server_addr.sin_len = UInt8(server_addr_size)
server_addr.sin_family = sa_family_t(AF_INET) // chooses IPv4
server_addr.sin_port = UInt16(12321).bigEndian // chooses the port

let bind_server = withUnsafePointer(to: &server_addr) { _ in
    bind(sock_fd, UnsafePointer($0), server_addr_size)
}

if bind_server == -1 {
    perror("Failure: binding port")
    exit(EXIT_FAILURE)
}

if listen(sock_fd, 5) == -1 {
    perror("Failure: listening")
    exit(EXIT_FAILURE)
}

var client_addr = sockaddr_storage()
var client_addr_len = socklen_t(MemoryLayout.size(ofValue: client_addr))
let client_fd = withUnsafeMutablePointer(to: &client_addr) {
    accept(sock_fd, UnsafeMutablePointer($0), &client_addr_len)
}
if client_fd == -1 {
    perror("Failure: accepting connection")
    exit(EXIT_FAILURE);
}

print("connection accepted")
