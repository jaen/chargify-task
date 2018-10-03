module Serializers
  class ApiAdapter < ActiveModelSerializers::Adapter::Base
    def serializable_hash(options = nil)
      options = serialization_options(options)

      if serializer.success?
        success_document(options)
      else
        failure_document(options)
      end
    end

    def success_document(options)
      attributes = ActiveModelSerializers::Adapter::Attributes.new(serializer, instance_options).serializable_hash(options)
      serialized_hash = { :data => { root => attributes } }

      self.class.transform_key_casing!(serialized_hash, instance_options)
    end

    def failure_document(options)
      attributes = ActiveModelSerializers::Adapter::Attributes.new(serializer, instance_options).serializable_hash(options)
      serialized_hash = { :errors => attributes }

      self.class.transform_key_casing!(serialized_hash, instance_options)
    end
  end
end
