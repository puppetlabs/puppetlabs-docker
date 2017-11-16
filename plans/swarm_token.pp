plan docker::swarm_token(
  String[1] $node_role
) {

  if $node_role !~ /(worker|manager) {
    fail("$node_role is not a valid role in Docker Swarm. Please specify worker or manager")
  }
  run_task('docker', node_role => $node_role)
}