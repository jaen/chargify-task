class ApplicationSerializer < ActiveModel::Serializer
  def success?
    not (object.instance_of?(Dry::Monads::Result::Failure) || object.is_a?(StandardError))
  end
end
