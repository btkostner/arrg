%Doctor.Config{
  exception_moduledoc_required: true,
  failed: false,
  ignore_modules: [
    ~r/^Inspect/
  ],
  ignore_paths: [
    ~r/\/controllers\//,
    ~r/\/live\//,
    ~r/\/views\//,
    ~r/test\//
  ],
  min_module_doc_coverage: 75,
  min_module_spec_coverage: 0,
  min_overall_doc_coverage: 70,
  min_overall_moduledoc_coverage: 100,
  min_overall_spec_coverage: 0,
  raise: true,
  reporter: Doctor.Reporters.Full,
  struct_type_spec_required: true,
  umbrella: false
}
