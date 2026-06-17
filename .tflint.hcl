config {
  format = "compact"
  plugin_dir = "~/.tflint.d/plugins"
  call_module_type = "all"
}

plugin "terraform" {
  enabled = true
  preset  = "all"       # strictest — covers recommended + style + best practices
}

rule "terraform_module_pinned_source" {
  enabled = false
}
