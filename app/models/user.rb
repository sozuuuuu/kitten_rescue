class User < ApplicationRecord
  before_create :generate_uid

  def to_param
    uid
  end

  private

  def generate_uid
    self.uid = SecureRandom.uuid
  end
end
