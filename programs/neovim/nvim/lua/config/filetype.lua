vim.filetype.add({
  filename = {
    ['docker-compose.yaml'] = "yaml.docker-compose",
    ['docker-compose.yml'] = "yaml.docker-compose",
    ['Chart.yaml'] = "helm",
    ['values.yaml'] = "helm"
  },
  pattern = {
    [".*/templates/.*%.ya?ml"] = "helm",
  },
})
