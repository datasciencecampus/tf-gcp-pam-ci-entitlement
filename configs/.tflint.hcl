# TFLint configuration for this repository
# Uses default built-in rules. Add provider rulesets as needed.

plugin "google" {
  enabled = true
  version = "0.38.0"
  source  = "github.com/terraform-linters/tflint-ruleset-google"
}

# You can enable/disable specific rules here, for example:
# rule "terraform_required_version" {
#   enabled = true
# }
config {
  format = "default"
  call_module_type = "none"
  force = false
  disabled_by_default = false
}
