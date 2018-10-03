class ErrorSerializer < ApplicationSerializer
  def serializable_hash(_adapter_options = nil, _options = {}, _adapter_instance = self.class.serialization_adapter_instance)
    if object.is_a? StandardError
      {:type => object.class.to_s, :message => object.message}
    else
      object
    end
  end

  def success?
    false
  end
end
