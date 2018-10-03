# cf. https://stackoverflow.com/questions/17240106/what-is-the-best-way-to-convert-all-controller-params-from-camelcase-to-snake-ca/30557924
ActionDispatch::Request.parameter_parsers[:json] = -> (raw_post) do
  data = ActiveSupport::JSON.decode(raw_post)

  if data.is_a?(Hash)
    data.deep_transform_keys!(&:underscore)
  else
    data = {:_json => data}
    data.deep_transform_keys!(&:underscore)
    data[:_json]
  end
end
