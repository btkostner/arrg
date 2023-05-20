[
  import_deps: [:ecto, :ecto_sql, :phoenix],
  inputs: ["*.{heex,ex,exs}", "{config,lib,priv,test}/**/*.{heex,ex,exs}"],
  line_length: 120,
  plugins: [TailwindFormatter.MultiFormatter]
]
