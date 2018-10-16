# docker::configs
class docker::configs($configs) {
  create_resources(docker_configs, $configs)
}
